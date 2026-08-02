    # Vulnerable S3 Bucket - Public ACL, Missing Block Public Access
    # This fixture intentionally contains security anti-patterns for testing purposes.

    # FINDING: S3 bucket with a public-read ACL (CIS AWS 2.1.5)
    resource "aws_s3_bucket" "insecure_data_lake" {
      bucket = "acme-corp-data-lake-prod"

      # ANTI-PATTERN: Public ACL grants read access to everyone on the internet.
      acl = "public-read"

      tags = {
        Environment = "production"
        Owner       = "data-team"
      }
    }

    # FINDING: S3 bucket versioning is NOT enabled, risking data loss on overwrites.
    resource "aws_s3_bucket_versioning" "insecure_data_lake_versioning" {
      bucket = aws_s3_bucket.insecure_data_lake.id

      versioning_configuration {
        # ANTI-PATTERN: Versioning is suspended (disabled).
        status = "Suspended"
      }
    }

    # MISSING RESOURCE: aws_s3_bucket_public_access_block is absent.
    # A secure configuration requires this resource to be present and all four
    # 'block_public_*' arguments to be set to 'true'.

    # FINDING: Server-side encryption is NOT configured.
    # A secure bucket should have an aws_s3_bucket_server_side_encryption_configuration block.

    # FINDING: Logging is NOT enabled on this bucket.

    # --- Dynamic Value Example (should be flagged as "unable to statically verify") ---
    resource "aws_s3_bucket" "dynamic_acl_bucket" {
      bucket = "acme-corp-dynamic-${var.environment}"

      # DYNAMIC VALUE: ACL is set from a variable; static analysis cannot verify safety.
      acl = var.bucket_acl

      tags = {
        Environment = var.environment
      }
    }
