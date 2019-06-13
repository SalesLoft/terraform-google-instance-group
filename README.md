# Google Managed Instance Group Terraform Module

Terraform module which creates managed instance groups on Google's Cloud Platform. Configuration of autoscaling can also
be implemented through this module.


## Usage

```hcl
module my_instance_group {
  source = "garbetjie/instance-group/google"
  
  // Required parameters.
  name = "my-instance-group"  // Or name = "my-instance-group-{region}" if you want to include the region in the name.
  regions = ["europe-west4"]
  instance_template_link = google_compute_instance_template.my_instance_template.self_link
  
  // Optional parameters.
  target_size = 1
  min_replicas = 1
  max_replicas = 3
  cooldown_period = 60
  autoscaling = []
}

resource google_compute_instance_template my_instance_template {
  // ...
}
```

### With autoscaling enabled.

It is also possible to enable autoscaling with this module:

```hcl
module my_instance_group {
  source = "garbetjie/instance-group/google"
  name = "my-instance-group"  // Or name = "my-instance-group-{region}" if you want to include the region in the name.
  regions = ["europe-west4"]
  instance_template_link = google_compute_instance_template.my_instance_template.self_link
  autoscaling = [
    { cpu = 0.6 },
    { metric = "custom.googleapis.com/my_metric", value = 1, type = "GAUGE" }
  ]
}

resource google_compute_instance_template my_instance_template {
  // ...
}
```


## Inputs

| Name                   | Description                                                                                                                                               | Type         | Default | Required |
|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|--------------|---------|----------|
| name                   | Name format to use when creating groups. Any values of `{region}` are replaced with the instance group's region.                                          | string       | n/a     | Yes      |
| regions                | Regions in which to create managed instance groups.                                                                                                       | list(string) | n/a     | Yes      |
| instance_template_link | Link to the instance template to assign to the instance group.                                                                                            | string       | n/a     | Yes      |
| cooldown_period        | Length of time (in seconds) each new instance is allowed to boot before beginning to fetch information from it.                                           | number       | `60`    | No       |
| target_size            | Number of instances in the instance group, when autoscaling is not in effect.                                                                             | number       | `1`     | No       |
| min_replicas           | Minimum number of instances to scale down to when autoscaling is enabled.                                                                                 | number       | `1`     | No       |
| max_replicas           | Maximum number of instances to scale up to when autoscaling is enabled.                                                                                   | number       | `3`     | No       |
| autoscaling            | A list of objects that define the autoscaling to use on the instance group. Leave empty to disable autoscaling. See documentation below on the structure. | list(object) | `[]`    | No       |


### Autoscaling configuration

When enabling autoscaling, there are two "kinds" of autoscaling to use - either CPU-based, or based on the value of a
Stackdriver metric. Each object in the `autoscaling` input parameter determines the kind of autoscaling to enable.


#### CPU autoscaling.

This can only be specified once in the list.

| Name | Description                                                  | Type   | Default | Required |
|------|--------------------------------------------------------------|--------|---------|----------|
| cpu  | The average CPU usage to maintain across the instance group. | number | n/a     | Yes      |


#### Stackdriver metric autoscaling.

| Name   | Description                                                                                          | Type   | Default | Required |
|--------|------------------------------------------------------------------------------------------------------|--------|---------|----------|
| metric | The name of the metric to autoscale on.                                                              | string | n/a     | Yes      |
| value  | The value of the metric to maintain.                                                                 | number | n/a     | Yes      |
| type   | The type of metric being monitored. Can be one of `GAUGE`, `DELTA_PER_SECOND`, or `DELTA_PER_MINUTE` | string | `GAUGE` | No       |


## Outputs

| Name                 | Type         | Description                                                                         |
|----------------------|--------------|-------------------------------------------------------------------------------------|
| manager_links        | list(string) | Full URLs to all the instance group managers managed by this module.                |
| instance_group_links | list(string) | Full URLs to all the instance groups managed this module's instance group managers. |
