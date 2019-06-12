resource google_compute_region_instance_group_manager manager {
  count = length(var.regions)
  name = replace(var.name, "{region}", var.regions[count.index])
  base_instance_name = replace(var.name, "{region}", var.regions[count.index])
  region = var.regions[count.index]
  instance_template = var.instance_template_link
}
