# IAM Module

## Overview
Grants the service account permission to read objects from the Cloud Storage bucket. This allows VMs to download and execute their startup scripts.

## Resources Created
- `google_storage_bucket_iam_member` - IAM binding granting service account access to bucket

## Usage

```hcl
module "iam" {
  source = "./modules/iam"
  
  role                  = "roles/storage.objectViewer"
  service_account_email = "${var.service_account_id}@${var.project_id}.iam.gserviceaccount.com"
  bucket_name           = var.bucket_name
}
```

## Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `bucket_name` | string | yes | name of the gcs bucket to grant access to, passed from root variable, must match the bucket created by bucket module where startup scripts are stored |
| `role` | string | yes | iam role to grant on the bucket (e.g., 'roles/storage.objectViewer'), passed from root variable, determines what service account can do with bucket objects (read/write/admin) |
| `service_account_email` | string | yes | full email of service account to grant permissions to, constructed in main.tf as 'service_account_id@project_id.iam.gserviceaccount.com', this allows vms using this service account to read startup scripts |

## Outputs

| Output | Type | Description | Used By |
|--------|------|-------------|---------|
| `member` | string | full member identifier granted access (format: serviceAccount:email), useful for verification of iam binding | Not currently used |
| `role` | string | iam role that was granted, useful for auditing permissions | Not currently used |

## Configuration Details

### IAM Role: roles/storage.objectViewer
This role provides:
- Permission to list objects in the bucket
- Permission to read object data and metadata
- **Does NOT** allow writing, deleting, or modifying objects

This is the minimum permission needed for VMs to download startup scripts.

### Member Format
The IAM member is specified in the format:
```
serviceAccount:{email}
```

Example:
```
serviceAccount:sirelidevserviceaccount@my-project-123.iam.gserviceaccount.com
```

### Permission Flow
1. Service account is created by service_account module
2. IAM module grants `roles/storage.objectViewer` to service account on bucket
3. VMs are configured with this service account
4. VMs can now read startup scripts from the bucket

## Dependencies
- **Service Account Module** (via depends_on) - service account must exist before granting it permissions
- **Bucket Module** - bucket must exist to grant permissions on it

## Notes
- This is a single IAM binding shared by all VMs (they all use the same service account)
- Without this permission, VMs cannot download their startup scripts and will fail to configure properly
- The binding applies to the entire bucket, not individual objects
- Service account email is currently constructed in main.tf but should ideally come from service_account module output