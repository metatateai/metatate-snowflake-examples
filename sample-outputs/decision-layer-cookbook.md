# Decision Layer Cookbook Output

The AcmeCloud offline fixture demonstrates the expected decision flow.

## Discover

Metatate returns five governed AcmeCloud tables. `CUSTOMERS`, `SUPPORT_TICKETS`, and `CUSTOMER_EXPORTS` contain PII or privacy-sensitive context.

## Inspect

`EMAIL` is classified as an email address with high sensitivity and partial masking. `CUSTOMER_NAME` is person-name PII and should be redacted or minimized for broad analytics.

## Authorize

Analytics on `CUSTOMERS` returns `CONDITIONAL`: the use is allowed only with minimization and masking.

Direct marketing on `CUSTOMERS` returns `DENY`.

## Validate SQL

A query selecting `EMAIL` for analytics returns a warning and asks the agent to revise the query unless direct contact is required.

