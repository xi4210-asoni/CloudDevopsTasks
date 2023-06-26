output "KeyValuesDetails" {
    value = {
        custom = aws_kms_external_key.customer_managed.id
    }
}