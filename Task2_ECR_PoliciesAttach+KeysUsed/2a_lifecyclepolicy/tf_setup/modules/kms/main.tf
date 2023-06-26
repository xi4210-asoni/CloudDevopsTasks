#AWS Managed
resource "aws_kms_key" "custom_aws_key_creation" {
  description             = "KMS Key Creation"
  deletion_window_in_days = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation = true
  multi_region = true
  is_enabled = true
}

# Customer Managed
resource "aws_kms_external_key" "customer_managed" {
  description = "KMS EXTERNAL for AMI encryption"
  multi_region = true
  key_material_base64 = "tQd/2vHAR+ptl1sSQdYF10C8+VHS1NaPFRt29ctrp54="
  deletion_window_in_days = 7
}