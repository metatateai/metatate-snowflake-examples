# Live Mode

Offline mode uses committed JSON response fixtures. Live mode calls a Metatate Native App installed in your Snowflake account.

## Prerequisites

- Metatate installed as a Snowflake Native App
- the app initialized and granted required references
- the MCP/tool layer registered
- a Snowflake role that can use the app objects
- Python dependencies from `requirements-live.txt`

## Configure

```bash
cp .env.example .env
```

Set:

```text
METATATE_EXAMPLES_MODE=live
SNOWFLAKE_ACCOUNT=<org-account>
SNOWFLAKE_USER=<user>
SNOWFLAKE_ROLE=<role-with-metatate-access>
SNOWFLAKE_WAREHOUSE=<warehouse>
SNOWFLAKE_AUTHENTICATOR=externalbrowser
METATATE_APP_NAME=METATATE_APP
```

The Python helper calls:

- `METATATE_APP.CORE.DISCOVER_CONTEXT`
- `METATATE_APP.CORE.GET_DECISION_CONTEXT`
- `METATATE_APP.CORE.INSPECT_DATA_MEANING`
- `METATATE_APP.CORE.INSPECT_GOVERNANCE_RULES`
- `METATATE_APP.CORE.AUTHORIZE_USE`
- `METATATE_APP.CORE.VALIDATE_QUERY_CONTEXT`
- `METATATE_APP.CORE.EXPLAIN_WHY`

If your app is named differently, set `METATATE_APP_NAME`.

## Seed Demo Data

Live mode does not require AcmeCloud if your account already has governed tables. To run the notebooks exactly as written, seed the AcmeCloud fixture:

```bash
snow sql -f sql/setup_acmecloud_demo.sql -c <profile>
```

Review the placeholders at the top of the SQL file before running it.

## Security Notes

- Do not commit `.env`.
- Do not commit Snowflake passwords, PATs, or OAuth tokens.
- Use role-scoped credentials for examples.
- The fixture SQL is for demo/development accounts, not production policy deployment.

