# Human-in-the-Loop Exception Workflow Output

The workflow evaluates three requests:

- a safe aggregate analytics query that proceeds without an exception
- a conditional Salesforce export that becomes a reviewer-ready exception packet
- a support-ticket training job that remains blocked by policy

The conditional packet includes the Metatate decision, evidence ID, source, destination, required controls, obligations, rationale, reviewer note, and required attestations.

The approved Salesforce request resumes only after `approval_recorded` and `anonymization_before_transfer` are attested. Denied requests do not resume.

Command-line version:

```bash
scripts/run_human_exception_workflow.sh
```
