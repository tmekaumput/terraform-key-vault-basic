## Terraform Key Vault Basic Profile

- Very bare minimum of Azure Key Vault configuration
- Adding Log Analytics for Monitoring

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.64.0, < 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.87.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_resource_group.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_permitted_object_ids"></a> [admin\_permitted\_object\_ids](#input\_admin\_permitted\_object\_ids) | List of additional Object Ids to be granted with all permissions, the object Id of the current configuration is always added. | `list(string)` | n/a | yes |
| <a name="input_friendly_prefix"></a> [friendly\_prefix](#input\_friendly\_prefix) | Friendly prefix prepending to the resource names | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure resources location | `string` | n/a | yes |
| <a name="input_read_permitted_object_ids"></a> [read\_permitted\_object\_ids](#input\_read\_permitted\_object\_ids) | List of additional Object Ids to be granted with read-only permissions. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key-vault-id"></a> [key-vault-id](#output\_key-vault-id) | n/a |
<!-- END_TF_DOCS -->