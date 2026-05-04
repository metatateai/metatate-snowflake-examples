# Snowflake Intelligence Prompts

Use these prompts once the Metatate wrappers are attached to a Snowflake Intelligence agent.

## Decision context

```text
What decision context applies to METATATE_DEMO.PUBLIC.CUSTOMERS?
Summarize sensitivity, PII exposure, policy coverage, retention guidance, and safest next action.
```

## Column meaning

```text
What does the EMAIL column mean in METATATE_DEMO.PUBLIC.CUSTOMERS?
Tell me whether it is PII, how sensitive it is, and what handling guidance applies.
```

## Query review

```text
Review this SQL before execution:

SELECT customer_id, email, account_status
FROM METATATE_DEMO.PUBLIC.CUSTOMERS
WHERE region = 'US';

Can this be used for reporting?
```

## Transfer governance

```text
Can I export CUSTOMER_ID, NAME, EMAIL, and ACCOUNT_STATUS from
METATATE_DEMO.PUBLIC.CUSTOMERS to Salesforce for external sharing?
If the answer is conditional or denied, explain why and suggest a safer path.
```

## Explanation

```text
Explain the last Metatate authorization decision.
Include the decision, reason codes, decisive factors, required actions, and whether the decision was based on active governance state.
```

