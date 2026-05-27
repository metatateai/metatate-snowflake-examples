# Troubleshooting

## The notebooks show offline responses after I configured Snowflake

Set live mode in the same shell where Jupyter starts:

```bash
export METATATE_EXAMPLES_MODE=live
```

Restart the notebook kernel after changing environment variables.

## The MCP endpoint does not exist

Check `METATATE_MCP_URL`. The endpoint should look like:

```text
https://<account-url>/api/v2/databases/METATATE_APP/schemas/CORE/mcp-servers/METATATE_MCP
```

If your app, schema, or MCP server uses a different name, either set `METATATE_MCP_URL` directly or configure:

```text
METATATE_MCP_ACCOUNT_URL
METATATE_APP_NAME
METATATE_MCP_SCHEMA
METATATE_MCP_SERVER_NAME
```

## The PAT is invalid

Confirm:

- `METATATE_MCP_PAT_ENV` names the environment variable that contains the PAT
- the PAT is exported in the same shell where Jupyter starts
- `SNOWFLAKE_ROLE` matches the PAT `ROLE_RESTRICTION`
- the PAT belongs to the same Snowflake account as the MCP endpoint
- the PAT has not expired or been removed

Do not put the PAT secret in `.env`.

## Live notebook execution fails with a transient MCP connection error

The live client retries temporary disconnects and retryable HTTP responses. If failures continue, confirm the MCP endpoint is healthy and rerun with a longer timeout:

```bash
export METATATE_MCP_TIMEOUT_SECONDS=180
scripts/run_notebook_pack.sh
```

## Snowflake says network policy is required or the IP/token is not allowed

The request reached Snowflake, but the PAT user is blocked by network policy.

Use the dedicated service-user flow:

```bash
SNOW_CONNECTION=<profile> scripts/create_mcp_pat_user.sh
```

That script creates a user-level `/32` allowlist for the current public IP. Do not attach this policy to a human/admin user.

## The setup SQL cannot insert into `app_data.*`

The fixture script requires a role that can use the application and write demo fixture rows. For demos, run it with an administrative Snowflake profile or adjust the variables at the top of `sql/setup_acmecloud_demo.sql`.

Production policies should be deployed through Metatate, not direct fixture inserts.

## The examples return no governed tables

In live mode, either seed the AcmeCloud fixture or update the notebooks to use governed tables already deployed in your account.

```bash
snow sql -f sql/setup_acmecloud_demo.sql -c <profile>
snow sql -f sql/smoke_acmecloud_demo.sql -c <profile>
```

## The transfer example returns UNKNOWN

Transfer authorization requires destination context:

```json
{
  "destination": {
    "system": "SALESFORCE",
    "jurisdiction": "US"
  },
  "consumer_jurisdiction": "EU"
}
```

If destination or consumer jurisdiction is missing, Metatate may ask for more context instead of returning a final transfer decision.
