# Terraform Honeycomb Scenarios

## Using these configs
1. Make sure you have the latest version of Terraform [installed](https://developer.hashicorp.com/terraform/downloads). You can do this however you like. I use [asdf](https://asdf-vm.com/) to manage multiple Terraform versions. 
1. Make sure Terraform is working by running `terraform -version`. You can see other commands avaialble with `terraform -help`
1. Create a new team in Honeycomb and generate a new API token for your team that has all of the permissions checked.
1. Clone this repository and navigate into the directory for the scenario you'd like to run. You should see 2 files in this directory: main.tf and variables.tf.
1. The variables you need to set to run the scenario are defined in variables.tf. There are lots of different [ways to set variables in Terraform](https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables). These instructions use environment variables but you can use whatever way you prefer.
1. Export the API key you generated in Honeycomb to the environment variable TF_VAR_honeycomb_api_key
    ```
    export TF_VAR_honeycomb_api_key=YOUR_API_KEY_HERE
    ```
1. Export the API URL for Honeycomb to the environment variable TF_VAR_honeycomb_api_url
    ```
    export TF_VAR_honeycomb_api_url=YOUR_HONEYCOMB_API_URL_HERE
    ```
1. Any other variables (like dataset_count, column_count, derived_column_count) can be left unset. Terraform will prompt you for them in the command line later.
1. Run `terraform init` to download any necessary providers needed to work with your configuration.
1. Run `terraform validate` to check whether your current configuration is valid.
1. Run `terraform plan`. This will show a preview of everything that will be created if your run `terraform apply` with your current configuration. 
1. Run `terraform apply`. This will generate another plan and ask for your approval before creating anything. Type 'yes' and then look in the Honeycomb UI to see your applied changes.
1. Run `terraform destroy`. This will generate another plan and ask for your approval before destroying anything. Type 'yes' and then look in the Honeycomb UI to see that everything was destroyed. Some resources (like datasets) cannot be deleted with the provider. You'll have to delete these by deleting your team if your want to clean up. 

## Learning Resources
1. [Intro to Terraform documentation](https://www.terraform.io/intro)
1. [Intro to Terraform CLI tutorial](https://learn.hashicorp.com/tutorials/terraform/init?in=terraform/cli)
1. [HashiCorp Learn](https://learn.hashicorp.com/terraform)
1. [Terraform CLI documentation](https://www.terraform.io/cli)
1. [Terraform Language documentation](https://www.terraform.io/language)
1. [Honeycomb Terraform provider documentation](https://registry.terraform.io/providers/honeycombio/honeycombio/latest/docs)
1. [Honeycomb Terraform provider repository](https://github.com/honeycombio/terraform-provider-honeycombio)
