resource google_compute_region_instance_group_manager manager {
  count = length(var.regions)
  name = replace(var.name, "{region}", var.regions[count.index])
  base_instance_name = replace(var.name, "{region}", var.regions[count.index])
  region = var.regions[count.index]
  instance_template = var.instance_template_link
  target_size = length(var.autoscaling) > 0 ? null : var.target_size
}

resource google_compute_region_autoscaler autoscaler {
  count = length(var.autoscaling) > 0 ? length(var.regions) : 0
  name = format("%s-%s", var.name, var.regions[count.index])
  region = var.regions[count.index]
  target = google_compute_region_instance_group_manager.manager[count.index].self_link

  autoscaling_policy {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
    cooldown_period = var.cooldown_period

    dynamic "cpu_utilization" {
      for_each = local.autoscaling_cpu

      content {
        target = cpu_utilization.value.cpu
      }
    }

    dynamic "metric" {
      for_each = local.autoscaling_metrics

      content {
        name = metric.value.metric
        target = metric.value.value
        type = lookup(metric.value, "type", "GAUGE")
      }
    }
  }
}
