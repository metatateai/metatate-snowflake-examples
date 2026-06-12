"""Reusable LangGraph governed SQL agent example.

The graph is deterministic on purpose: it proves where Metatate sits in the
agent workflow without relying on model output.
"""

from __future__ import annotations

from typing import Any, TypedDict

from framework_runtime.scenarios import MARKETING_SQL, SAFE_ANALYTICS_SQL, UNSAFE_ANALYTICS_SQL


class GovernedSqlAgentState(TypedDict, total=False):
    question: str
    intended_use: str
    draft_sql: str
    validation: dict[str, Any]
    decision: str
    route: str
    final_sql: str | None
    answer: str
    notes: list[str]
    validation_id: str | None


def build_governed_sql_agent(client: Any) -> Any:
    """Build a LangGraph SQL agent that validates every draft with Metatate."""

    try:
        from langgraph.graph import END, StateGraph
    except ImportError as exc:  # pragma: no cover - dependency guard.
        raise RuntimeError("Install requirements-framework.txt to run the LangGraph runtime example") from exc

    def plan_sql(state: GovernedSqlAgentState) -> GovernedSqlAgentState:
        sql_text, intended_use = plan_question(state["question"])
        return {**state, "draft_sql": sql_text, "intended_use": intended_use, "notes": []}

    def validate_with_metatate(state: GovernedSqlAgentState) -> GovernedSqlAgentState:
        validation = client.validate_query_context(
            state["draft_sql"],
            operation="read",
            intended_use=state["intended_use"],
            actor_role="DATA_ANALYST",
        )
        decision = decision_label(validation)
        route = route_for_decision(decision)
        return {
            **state,
            "validation": validation,
            "decision": decision,
            "route": route,
            "validation_id": validation_id(validation),
        }

    def approve_sql(state: GovernedSqlAgentState) -> GovernedSqlAgentState:
        return {
            **state,
            "final_sql": state["draft_sql"],
            "answer": "Metatate approved the SQL for analytics. The agent may return the query.",
            "notes": [*state.get("notes", []), "approved_by_metatate"],
        }

    def revise_sql(state: GovernedSqlAgentState) -> GovernedSqlAgentState:
        return {
            **state,
            "final_sql": SAFE_ANALYTICS_SQL,
            "answer": "Metatate required minimization. The agent revised the SQL before returning it.",
            "notes": [*state.get("notes", []), "revised_after_metatate_decision"],
        }

    def block_sql(state: GovernedSqlAgentState) -> GovernedSqlAgentState:
        return {
            **state,
            "final_sql": None,
            "answer": "Metatate blocked this use. The agent must not return executable SQL.",
            "notes": [*state.get("notes", []), "blocked_by_metatate"],
        }

    graph = StateGraph(GovernedSqlAgentState)
    graph.add_node("plan_sql", plan_sql)
    graph.add_node("validate_with_metatate", validate_with_metatate)
    graph.add_node("approve_sql", approve_sql)
    graph.add_node("revise_sql", revise_sql)
    graph.add_node("block_sql", block_sql)
    graph.set_entry_point("plan_sql")
    graph.add_edge("plan_sql", "validate_with_metatate")
    graph.add_conditional_edges(
        "validate_with_metatate",
        lambda state: state["route"],
        {
            "approve": "approve_sql",
            "revise": "revise_sql",
            "block": "block_sql",
        },
    )
    graph.add_edge("approve_sql", END)
    graph.add_edge("revise_sql", END)
    graph.add_edge("block_sql", END)
    return graph.compile()


def plan_question(question: str) -> tuple[str, str]:
    """Map a user question to a deterministic SQL draft and intended use."""

    normalized = question.lower()
    if "marketing" in normalized or "email campaign" in normalized:
        return MARKETING_SQL, "marketing"
    if "email" in normalized or "identify" in normalized:
        return UNSAFE_ANALYTICS_SQL, "analytics"
    return SAFE_ANALYTICS_SQL, "analytics"


def route_for_decision(decision: str) -> str:
    if decision == "DENY":
        return "block"
    if decision == "ALLOW":
        return "approve"
    return "revise"


def summarize_state(state: GovernedSqlAgentState) -> dict[str, Any]:
    return {
        "question": state["question"],
        "route": state.get("route"),
        "decision": state.get("decision"),
        "intended_use": state.get("intended_use"),
        "validation_id": state.get("validation_id"),
        "draft_sql": state.get("draft_sql"),
        "final_sql": state.get("final_sql"),
        "answer": state.get("answer"),
        "notes": state.get("notes", []),
    }


def acceptance_result(state: GovernedSqlAgentState) -> dict[str, Any]:
    route = state["route"]
    status = {"approve": "approved", "revise": "revised", "block": "blocked"}[route]
    return {
        "decision": state["decision"],
        "status": status,
        "original_sql": state["draft_sql"],
        "final_sql": state.get("final_sql"),
        "validation_id": state.get("validation_id"),
        "route": route,
        "answer": state.get("answer"),
    }


def decision_label(response: dict[str, Any]) -> str:
    data = response.get("data", {})
    decision = data.get("decision")
    if isinstance(decision, dict):
        return str(decision.get("decision") or decision.get("overall_decision") or "UNKNOWN").upper()
    return str(decision or data.get("overall_decision") or "UNKNOWN").upper()


def validation_id(response: dict[str, Any]) -> str | None:
    data = response.get("data", {})
    action = data.get("agent_action")
    if data.get("validation_id"):
        return str(data["validation_id"])
    if isinstance(action, dict) and action.get("validation_id"):
        return str(action["validation_id"])
    return None
