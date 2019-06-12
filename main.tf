resource google_compute_region_instance_group_manager manager {
  count = length(var.regions)
  name = replace(var.name, "{region}", var.regions[count.index])
  base_instance_name = replace(var.name, "{region}", var.regions[count.index])
  region = var.regions[count.index]
  instance_template = coalesce(var.instance_template_link, google_compute_instance_template.default_template.self_link)

  lifecycle {
    ignore_changes = var.instance_template_link == null ? ["instance_template"] : []
  }
}

resource google_compute_instance_template default_template {
  count = var.instance_template_link == null ? 1 : 0
  name = format("%s-default", var.name)
  description = format("Default template used to initialize the `%s` instance groups. Designed to be overridden on deployments.", var.name)
  machine_type = "f1-micro"

  disk {
    boot = true
    disk_size_gb = 10
    disk_type = "pd-standard"
    source_image = data.google_compute_image.default_image.self_link
  }

  network_interface {
    network = "default"
  }
}

data google_compute_image default_image {
  count = var.instance_template_link == null ? 1 : 0
  family = "cos-stable"
  project = "gce-uefi-images"
}
