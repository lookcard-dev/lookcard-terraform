{
  "Comment": "A simple AWS Step Function example",
  "StartAt": "InvokeLambda",
  "States": {
    "InvokeLambda": {
      "Type": "Task",
      "Resource": "${lambda_arn}",
      "End": true
    }
  }
}
