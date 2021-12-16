# Export all Environment Variables
set -o allexport; source ../../.env; set +o allexport

# Terraform Init
terraform init -var-file=ENV_${ENV}.tfvars

# Terraform Plan
terraform plan -var-file=ENV_${ENV}.tfvars