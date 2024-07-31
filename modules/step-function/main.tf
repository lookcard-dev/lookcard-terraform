# # Step Function
# data "template_file" "step_function_definition" {
#   template = file("${path.module}/opt/step_function_definition.json.tpl")
#   vars = {
#     lambda_arn = aws_lambda_function.stepfunction_testing_candel.arn
#   }
# }

# Step Function
locals {
  step_function_definition = templatefile("${path.module}/opt/step_function_definition.json.tpl", {
    lambda_arn = aws_lambda_function.stepfunction_testing_candel.arn
  })
}

resource "aws_sfn_state_machine" "sfn-testing-candel" {
  name     = "Testing-Candel-StateMachine"
  role_arn = aws_iam_role.step_function_role.arn
  definition = local.step_function_definition
}

