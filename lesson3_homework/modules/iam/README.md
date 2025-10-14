# IAM Module

This module manages Google Cloud Service Accounts and their IAM bindings for GCS buckets.

## Usage

Basic usage of this module is as follows:

```hcl
module "iam" {
  source = "./modules/iam"

  project_id   = "my-project-id"
  account_id   = "my-service-account"
  display_name = "My Service Account"
  description  = "Service account for VM instances"

  bucket_iam_bindings = {
    scripts_viewer = {
      bucket = "my-scripts-bucket"
      role   = "roles/storage.objectViewer"
    }
  }
}
```

### Multiple Bucket Bindings

You can grant access to multiple buckets:

```hcl
module "iam" {
  source = "./modules/iam"

  project_id   = "my-project-id"
  account_id   = "multi-bucket-sa"
  display_name = "Multi-Bucket Service Account"

  bucket_iam_bindings = {
    scripts_viewer = {
      bucket = "scripts-bucket"
      role   = "roles/storage.objectViewer"
    }
    data_admin = {
      bucket = "data-bucket"
      role   = "roles/storage.objectAdmin"
    }
    logs_viewer = {
      bucket = "logs-bucket"
      role   = "roles/storage.objectViewer"
    }
  }
}
```

### Using in VM Configuration

```hcl
module "iam" {
  source = "./modules/iam"

  project_id   = "my-project-id"
  account_id   = "vm-service-account"
  display_name = "VM Service Account"

  bucket_iam_bindings = {
    scripts = {
      bucket = google_storage_bucket.scripts.name
      role   = "roles/storage.objectViewer"
    }
  }
}

resource "google_compute_instance" "vm" {
  name         = "my-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  # ... other configuration ...

  service_account {
    email  = module.iam.service_account_email
    scopes = ["cloud-platform"]
  }
}
```

## Features

- Creates a Google Cloud Service Account
- Manages IAM bindings for GCS buckets
- Supports multiple bucket bindings through a map
- Validates service account naming conventions
- Outputs service account details for use in other resources

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The GCP project ID where the service account will be created | `string` | n/a | yes |
| account_id | The account ID for the service account (must be 6-30 characters) | `string` | n/a | yes |
| display_name | The display name for the service account | `string` | `""` | no |
| description | Description of the service account | `string` | `"Service account managed by Terraform"` | no |
| bucket_iam_bindings | Map of IAM bindings for GCS buckets. Key is binding name, value contains bucket and role. | `map(object({bucket = string, role = string}))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| service_account_email | The email address of the created service account |
| service_account_id | The fully-qualified ID of the service account |
| service_account_name | The fully-qualified name of the service account |
| service_account_unique_id | The unique ID of the service account |
| bucket_iam_members | Map of bucket IAM member bindings |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| google | >= 5.0, < 8.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 5.0, < 8.0 |

## Resources

| Name | Type |
|------|------|
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket_iam_member.bucket_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |

## Examples

- [Simple Example](./examples/simple) - Basic service account with bucket access

## IAM Roles

This module can assign any valid GCS IAM role. Common roles include:

- `roles/storage.objectViewer` - Read access to bucket objects
- `roles/storage.objectAdmin` - Full access to bucket objects
- `roles/storage.admin` - Full control of buckets and objects
- `roles/storage.objectCreator` - Create objects in buckets
- `roles/storage.legacyBucketReader` - List bucket contents and read bucket metadata

For a complete list of available roles, see the [GCS IAM roles documentation](https://cloud.google.com/storage/docs/access-control/iam-roles).

## Service Account Naming

The `account_id` variable must follow these rules:

- Must be 6-30 characters long
- Must start with a lowercase letter
- Can only contain lowercase letters, numbers, and hyphens
- Cannot end with a hyphen

**Valid examples:**
- `my-service-account`
- `vm-access-sa`
- `object-viewer-123`

**Invalid examples:**
- `MyServiceAccount` (uppercase)
- `sa` (too short)
- `-service-account` (starts with hyphen)
- `service-account-` (ends with hyphen)

## Best Practices

1. **Least Privilege**: Grant only the minimum permissions required. Use `objectViewer` for read-only access instead of `admin`.

2. **Descriptive Names**: Use clear, descriptive account IDs that indicate the service account's purpose:
   ```hcl
   account_id = "vm-startup-scripts-reader"
   ```

3. **Multiple Bindings**: If a service account needs access to multiple buckets, use the `bucket_iam_bindings` map:
   ```hcl
   bucket_iam_bindings = {
     scripts = { bucket = "scripts-bucket", role = "roles/storage.objectViewer" }
     data    = { bucket = "data-bucket", role = "roles/storage.objectViewer" }
   }
   ```

4. **Documentation**: Always set the `description` variable to document the service account's purpose:
   ```hcl
   description = "Service account for VM instances to read startup scripts from GCS"
   ```

## Troubleshooting

### Error: Account ID format validation failed

**Problem**: The account_id doesn't meet GCP's naming requirements.

**Solution**: Ensure your account_id:
- Is 6-30 characters
- Starts with a letter
- Contains only lowercase letters, numbers, and hyphens

### Error: Permission denied on bucket

**Problem**: The service account can't access the bucket even after IAM binding.

**Solution**: 
1. Verify the bucket has uniform bucket-level access enabled
2. Wait a few minutes for IAM propagation
3. Check that the role granted has the required permissions

### Error: Service account already exists

**Problem**: A service account with this ID already exists.

**Solution**: Either:
1. Import the existing service account: `terraform import module.iam.google_service_account.service_account projects/PROJECT_ID/serviceAccounts/ACCOUNT_ID@PROJECT_ID.iam.gserviceaccount.com`
2. Use a different account_id
