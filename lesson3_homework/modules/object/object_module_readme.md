# Object Module

## Overview
Uploads VM startup scripts from local filesystem to Cloud Storage bucket. Each VM gets its own script object that it downloads and executes on boot.

## Resources Created
- `google_storage_bucket_object` - Object (file) in the GCS bucket

## Usage

```hcl
module "object" {
  source   = "./modules/object"
  for_each = var.vm_attributes
  
  object_name        = each.value.vm_name
  script_source_path = "./scripts/${each.value.startup_script}"
  bucket_name        = var.bucket_name
}
```

## Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `object_name` | string | yes | name for the object in gcs bucket, set to vm_name from vm_attributes map in root via for_each (e.g., 'node-exporter-vm'), used as identifier in bucket |
| `script_source_path` | string | yes | local filesystem path to startup script file, constructed in main.tf as './scripts/${startup_script}' where startup_script comes from vm_attributes (e.g., './scripts/node-script.sh') |
| `bucket_name` | string | yes | name of gcs bucket to upload script to, passed from root variable, must match bucket created by bucket module |

## Outputs

| Output | Type | Description | Used By |
|--------|------|-------------|---------|
| `script_url` | string | publicly accessible url to the uploaded script in gcs, passed to gce module as startup_script_url via for_each, vm fetches and executes this script on boot | GCE module (matched by for_each key) |

## Configuration Details

### Script Naming Convention
- **Object name in bucket:** Set to VM name (e.g., `node-exporter-vm`)
- **Local script file:** From vm_attributes (e.g., `node-script.sh`)
- **Full local path:** Constructed as `./scripts/node-script.sh`

Example mapping:
```
node-exporter-vm → ./scripts/node-script.sh
prometheus-vm    → ./scripts/prom-script.sh
grafana-vm       → ./scripts/graf-script.sh
loki-vm          → ./scripts/loki-script.sh
promtail-vm      → ./scripts/promtail-script.sh
```

### Script URL Format
The output URL follows this format:
```
https://storage.cloud.google.com/{bucket_name}/{object_name}
```

Example:
```
https://storage.cloud.google.com/startupscripts-monitoring-modules-for-ani-dev/node-exporter-vm
```

### How VMs Use the Script
1. Object module uploads script to GCS
2. GCE module receives `script_url` output
3. VM metadata includes `startup-script-url` pointing to this URL
4. On boot, VM downloads and executes the script
5. Service account must have `roles/storage.objectViewer` to read the script

## Dependencies
- **Bucket Module** (via depends_on) - bucket must exist before uploading objects
- **Service Account Module** (via depends_on) - ensures service account exists

## Notes
- Created via `for_each` loop - one script object per VM
- Each VM has a different startup script for its specific monitoring service
- Scripts must exist in `./scripts/` directory before running terraform
- The object name is set to VM name, not the script filename
- VMs need the service account with proper IAM permissions to download scripts