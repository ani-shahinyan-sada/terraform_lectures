# Google Cloud Storage Scripts Bucket Module

This Terraform module creates a Google Cloud Storage bucket designed for storing scripts and related files.

## Features

- Creates a GCS bucket with uniform bucket-level access enabled
- Configurable bucket name, location, and project
- IAM-only access control (ACLs disabled)
- Destroy protection enabled by default

## Usage

```terraform
module "scripts_bucket" {
  source = "./path/to/module"

  bucket_name     = "my-scripts-bucket"
  bucket_location = "US"
  project_id      = "my-gcp-project"
}
```

## Variables

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `bucket_name` | Name of the GCS bucket | `string` | Yes |
| `bucket_location` | Geographic location for the bucket (e.g., US, EU, asia-east1) | `string` | Yes |
| `project_id` | GCP project ID where the bucket will be created | `string` | Yes |

## Resources Created

- `google_storage_bucket.scripts` - A GCS bucket with the following configuration:
  - **Uniform bucket-level access**: Enabled (ACLs disabled, IAM-only access control)
  - **Force destroy**: Disabled (prevents accidental deletion of bucket with contents)

## Security Considerations

This module uses uniform bucket-level access, which:
- Disables Access Control Lists (ACLs)
- Uses only Identity and Access Management (IAM) policies
- Provides consistent, centralized access control across all bucket objects
- Simplifies permission management and improves security posture


## Example

```terraform
module "scripts_bucket" {
  source = "./modules/gcs-scripts-bucket"

  bucket_name     = "company-automation-scripts"
  bucket_location = "us-central1"
  project_id      = "production-project-123"
}
```

## Requirements

- Terraform >= 0.13
- Google Cloud Provider
- Appropriate GCP permissions to create storage buckets