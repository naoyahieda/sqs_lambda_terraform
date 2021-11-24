resource "aws_sqs_queue" "default" {
  name                        = "${var.service_name}.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds = 901
}

resource "aws_lambda_event_source_mapping" "default" {
  batch_size = 1 # 一番見やすそうだから1にしてみたがやりながらになるかな
  event_source_arn = aws_sqs_queue.default.arn
  function_name    = aws_lambda_function.default.arn
  enabled = true
}

output "sqs_endpoint_for_django" {
  value = aws_sqs_queue.default.url
}