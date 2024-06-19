data "archive_file" "lambda" {
  type             = "zip"
  source_dir       = "${path.module}/test"
  output_file_mode = "0666"
  output_path      = "${path.module}/tmp/lambda.zip"

}
