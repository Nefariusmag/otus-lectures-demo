#!/usr/bin/env bash

number_group=007

group=cube-activity-${number_group}-dev-rg

# Deploy

terraform init

terraform apply -auto-approve=true -var "group=${group}" -var "number_group=${number_group}" -target azurerm_resource_group.bi_group

terraform apply -auto-approve=true -var "group=${group}" -var "number_group=${number_group}" -target module.event_hub.azurerm_eventhub_authorization_rule.eventhub_authorization_rule_send

terraform apply -auto-approve=true -var "group=${group}" -var "number_group=${number_group}" -target module.azure_sql.null_resource.initial_monitoring

terraform apply -auto-approve=true -var "group=${group}" -var "number_group=${number_group}" -target module.cube_activity.null_resource.azure_functions_deploy

# Destory

terraform destroy -var "group=${group}" yes-var "number_group=${number_group}"
