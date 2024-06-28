locals {
  entity = {for entity_name in var.allow_entities: entity_name => var.entities[entity_name] if contains(keys(var.entities), entity_name)}
}