# Transfer Governance Output

The transfer example sends the same customer data to two destinations.

## Salesforce

Exporting customer data to `SALESFORCE` in the `US` for an `EU` consumer returns `CONDITIONAL`.

Required controls:

- approval
- anonymization
- audit logging with the returned `decision_id`

## Advertising Platform

Exporting customer PII to `ADS_PLATFORM` returns `DENY`.

The agent should block the export and suggest either an approved destination or an aggregated output that does not contain direct identifiers.

