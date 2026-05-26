# Troubleshooting

## The notebooks show offline responses even after I configured Snowflake

Set:

```bash
export METATATE_EXAMPLES_MODE=live
```

Restart the notebook kernel after changing environment variables.

## Snowflake says the app object does not exist

Check `METATATE_APP_NAME`. The default is:

```text
METATATE_APP
```

If your Native App is installed with a different name, set the environment variable before starting Jupyter.

## Snowflake authentication opens a browser every time

The examples default to:

```text
SNOWFLAKE_AUTHENTICATOR=externalbrowser
```

You can use any Snowflake connector-supported authenticator appropriate for your environment. Do not commit credentials.

## The setup SQL cannot insert into `app_data.*`

The fixture script requires a role that can use the application and write the demo fixture rows. In normal production use, policies should be deployed through Metatate instead of direct fixture inserts.

For demos, run the script with the same type of role used for internal MCP SQL validation.

## The examples return no governed tables

In live mode, either:

- seed the AcmeCloud fixture with `sql/setup_acmecloud_demo.sql`, or
- edit notebook table names to match governed tables already deployed in your account.

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

If destination or consumer jurisdiction is missing, Metatate may ask for more context rather than returning a final transfer decision.

