# Contributing to Azure Hybrid IaaS FinOps Framework

We welcome contributions from cloud architects, platform engineers, and FinOps practitioners!

## Guidelines
1. **Mathematical Accuracy**: All cost calculation models must be accompanied by unit tests in `automation/python/test_finops_calculator.py`.
2. **IaC Standards**: Terraform code must pass `terraform fmt` and `terraform validate` against AzureRM v4+. Bicep templates must compile via `az bicep build`.
3. **Decisions as Code**: Major architectural choices must be documented as an Architecture Decision Record in `docs/adr/`.
4. **Pre-commit Validation**: Run `./scripts/validate-all.sh` before submitting pull requests.
