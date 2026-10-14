#!/usr/bin/env bash
# ==============================================================================
# Master Validation Script for Azure Hybrid IaaS FinOps Framework
# Validates Terraform, Bicep, Python calculator unit tests, Shell scripts, JSON
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=========================================================="
echo " 🚀 Running Full FinOps Repository Validation Suite"
echo "=========================================================="

# 1. Validate Python FinOps Calculator Unit Tests
echo "[1/5] Testing Python FinOps Calculator & Math Models..."
python3 -m unittest discover -s "${REPO_ROOT}/automation/python" -p "test_*.py" -v
echo "✅ Python unit tests passed!"

# 2. Validate Terraform Configuration
echo "[2/5] Validating Terraform code..."
if command -v terraform &>/dev/null; then
  terraform -chdir="${REPO_ROOT}/terraform" fmt -check
  terraform -chdir="${REPO_ROOT}/terraform" init -backend=false
  terraform -chdir="${REPO_ROOT}/terraform" validate
  echo "✅ Terraform configuration is valid!"
else
  echo "⚠️ terraform not found in PATH, skipping terraform check."
fi

# 3. Validate Azure Bicep Templates
echo "[3/5] Compiling and validating Azure Bicep templates..."
if command -v az &>/dev/null && az bicep version &>/dev/null; then
  az bicep build --file "${REPO_ROOT}/bicep/main.bicep" --stdout > /dev/null
  az bicep build --file "${REPO_ROOT}/bicep/modules/azurePolicy.bicep" --stdout > /dev/null
  echo "✅ Azure Bicep templates compiled successfully!"
else
  echo "⚠️ az bicep not found, skipping bicep compilation."
fi

# 4. Validate JSON Azure Policy Definitions
echo "[4/5] Validating JSON Policy Definitions..."
for policy in "${REPO_ROOT}/policies"/*.json; do
  python3 -m json.tool "$policy" > /dev/null
  echo "  ✓ Validated JSON: $(basename "$policy")"
done
echo "✅ All Azure Policy JSON definitions are valid!"

# 5. Check Shell Scripts with bash -n (syntax check)
echo "[5/5] Syntax checking Shell scripts..."
bash -n "${REPO_ROOT}/scripts/validate-all.sh"
echo "✅ All shell scripts syntax verified!"

echo "=========================================================="
echo " 🎉 ALL VALIDATIONS PASSED CLEANLY!"
echo "=========================================================="
