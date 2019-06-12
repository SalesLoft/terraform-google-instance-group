output "manager_links" {
  value = google_compute_region_instance_group_manager.manager.*.self_link
  description = "Full URLs to all the instance group managers managed by this module."
}

output "instance_group_links" {
  value = split(",", join(",", google_compute_region_instance_group_manager.manager.*.instance_group))
  description = "Full URLs to all the instance groups managed this module's instance group managers."
}
