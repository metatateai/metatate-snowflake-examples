# CI Gate For Data And AI Changes Output

The CI gate evaluates three proposed changes:

- an aggregate revenue dashboard passes
- a marketing activation SQL model fails
- a Salesforce export requires controls

The notebook prints denied changes without failing by default so readers can run it end to end. Set `METATATE_EXAMPLES_STRICT_CI_GATE=1` to make denied changes raise the same way a CI job would fail.
