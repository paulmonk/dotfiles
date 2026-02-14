# Terraform

Infrastructure as Code using Terraform/OpenTofu, orchestrated
with Terragrunt.

## Repository Structure

Separate modules from live (deployment) repos. Choose between
traditional or stacks-based organisation.

### Traditional Structure

Individual `terragrunt.hcl` files per resource, organised by
account/project and region:

```text
infrastructure-live/
├── terragrunt.hcl              # Root config (providers, state)
├── _common/                    # Shared templates
├── _modules/                   # Local modules (or use external)
├── <account>/                  # AWS: account, GCP: project
│   ├── account.hcl             # Account/project-level vars
│   ├── _global/                # Account-wide resources
│   └── <region>/
│       ├── region.hcl
│       └── <resource>/
│           └── terragrunt.hcl  # Hand-written config
```

### Stacks Structure

`terragrunt.stack.hcl` files that reference a units catalogue and
generate configs:

```text
infrastructure-live/
├── terragrunt.hcl              # Root config (providers, state)
├── catalog/                    # Units catalog (or external git repo)
│   └── units/
│       ├── vpc/
│       │   └── terragrunt.hcl
│       └── rds/
│           └── terragrunt.hcl
├── <account>/
│   └── <region>/
│       └── terragrunt.stack.hcl   # Defines which units to deploy
```

Run `terragrunt stack generate` to create the actual
`terragrunt.hcl` files (by default in `.terragrunt-stack/`, or
in-place with `no_dot_terragrunt_stack = true`).

### Conventions

- Prefix non-deployable folders with `_`
- Right-size modules: group resources that deploy together and
  share ownership
- State paths mirror folder structure
- Use three-part naming for module repositories:
  `terraform-<PROVIDER>-<NAME>`

## Variable Hierarchy

Load variables at appropriate levels using
`find_in_parent_folders()`:

```hcl
locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}
```

## Include Patterns

Use double-include for DRY resource configs:

```hcl
include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path   = "${dirname(find_in_parent_folders())}/_common/vpc.hcl"
  expose = true
}

terraform {
  source = "${include.common.locals.source_base_url}"
}

inputs = { name = "my-vpc" }
```

## Provider and State Generation

Define once in root using `generate` blocks:

```hcl
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region_vars.locals.aws_region}"
}
EOF
}

remote_state {
  backend = "s3"  # or "gcs" for GCP
  config = {
    bucket = "${local.account_vars.locals.account_name}-tfstate"
    key    = "${path_relative_to_include()}/terraform.tfstate"
  }
}
```

## Dependencies

```hcl
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = { vpc_id = "vpc-mock" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = { vpc_id = dependency.vpc.outputs.vpc_id }
```

## Stacks

**When to use:**

- `unit` blocks: Single infrastructure components (VPC, database)
- `stack` blocks: Reusable patterns of components to provision together

```hcl
# terragrunt.stack.hcl
locals {
  units_path = find_in_parent_folders("catalog/units")
}

unit "vpc" {
  source = "git::git@github.com:acme/infra-catalog.git//units/vpc?ref=v1.0.0"
  path   = "vpc"
  values = {
    name = "prod-vpc"
    cidr = "10.0.0.0/16"
  }
}

unit "database" {
  source = "${local.units_path}/rds"
  path   = "database"
  values = { vpc_name = "prod-vpc" }
}
```

Commands:

- `terragrunt stack generate` to generate stack structure
- `terragrunt stack generate --filter 'prod/**'` to filter by path
- `terragrunt run --all plan` to plan all generated units

## Terraform HCL Style

The following applies to all `.tf` files, whether hand-written or
in modules.

### Code Formatting

- Place arguments at the top of blocks, followed by nested blocks
  with one blank line separation
- Put meta-arguments (count, for_each) first, followed by other
  arguments, then nested blocks
- Place lifecycle blocks last, separated by blank lines
- Separate top-level blocks with one blank line

### Resource Organisation

- Define data sources before the resources that reference them
- Group related resources together (networking, compute, storage)
- Order resource parameters: meta-arguments, resource-specific
  parameters, nested blocks, lifecycle, depends_on

### Resource Naming

- Use descriptive nouns separated by underscores
- Do not include the resource type in the resource name
- Example: `resource "aws_instance" "web_server" {}` not
  `resource "aws_instance" "webserver_instance" {}`

### Variables and Outputs

- Define `type` and `description` for every variable
- Include reasonable `default` values for optional variables
- Set `sensitive = true` for passwords and private keys
- Order variable parameters: type, description, default,
  sensitive, validation blocks
- Order output parameters: description, value, sensitive
- Use descriptive names with underscores

### Comments

- Use `#` for comments (not `//` or `/* */`)
- Write self-documenting code; use comments only to clarify
  complexity
- Add comments above resource blocks to explain non-obvious
  business logic

### Local Values

- Use local values sparingly to avoid making code harder to
  understand
- Define in `locals.tf` if referenced across multiple files
- Define at the top of a file if specific to that file only

### Dynamic Resource Management

- Use `count` for nearly identical resources
- Use `for_each` when resources need distinct values that cannot
  be derived from integers
- Use `count` with conditional expressions:
  `count = var.enable_feature ? 1 : 0`

### Provider Configuration

- Always include a default provider configuration
- Define all providers in the same file (`providers.tf`)
- Define the default provider first, then aliased providers
- Use `alias` as the first parameter in non-default provider
  blocks

### Version Management

- Pin Terraform version using `required_version` in terraform
  block
- Pin provider versions using exact versions in
  `required_providers`
- Pin module versions when sourcing from registries
- Prefer the pessimistic constraint operator (`~>`) for modules
  and providers
- Avoid open-ended constraints (`>`, `>=` without upper bound) in
  production

### Security and Secrets

- Never commit `terraform.tfstate` files or `.terraform`
  directories
- Use dynamic provider credentials when possible
- Access secrets from external secret management systems
- Use environment variables for provider credentials

### Testing and Validation

- Write Terraform tests for modules using the test
  framework
- Use variable validation blocks for restrictive requirements
- Include input validation with meaningful error messages

## Terraform Modules

When creating reusable Terraform modules (not Terragrunt
units):

### Module Structure

```text
terraform-<provider>-<name>/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── locals.tf
└── modules/
    └── <nested>/
```

### Required Files

- `main.tf`: Primary resource and data source definitions
- `variables.tf`: Input variable definitions (alphabetical order)
- `outputs.tf`: Output value definitions (alphabetical order)
- `README.md`: Module purpose, usage, and examples

### Guidance

- Keep modules focused on single infrastructure concerns
- Split large configurations into logical files
  (e.g., `network.tf`, `compute.tf`)
- Include `README.md` for external-facing nested modules; omit
  for internal-only
