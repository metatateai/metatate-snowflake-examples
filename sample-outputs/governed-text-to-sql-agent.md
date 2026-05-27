# Governed Text-to-SQL Agent Output

The text-to-SQL example starts from a business question about active ARR by region.

The first draft selects `CUSTOMER_NAME` and `EMAIL`, so Metatate returns a conditional decision and flags direct identifiers.

The agent revises the query to aggregate by `REGION` and `ACCOUNT_STATUS`, then validates the revised SQL. The final decision is `ALLOW` in offline mode.

The key point is that the agent does not rely on prompt instructions alone. It checks governed context before returning executable SQL.
