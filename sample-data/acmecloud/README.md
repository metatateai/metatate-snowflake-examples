# AcmeCloud Sample Data

AcmeCloud is a synthetic B2B SaaS dataset used across the Metatate examples.

## Contents

```text
tables/               CSV source tables for offline inspection
policies/             Example Metatate policy YAML
metatate-responses/   Offline response fixtures for the notebooks
```

The CSV data is intentionally small. The Metatate response fixtures represent the decision-layer output that would be produced after equivalent policies are deployed and materialized by the Native App.

Use `sql/setup_acmecloud_demo.sql` to create the live Snowflake version.

