output "bucket_id" {
  value = aws_s3_bucket.terraform_state.id
}
output "dynamo_table_id" {
  value = aws_dynamodb_table.tf-state-lock.id
}
