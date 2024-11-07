output "lookcard_websocket_arn" {
  value = module.lookcard-websocket.lookcard_websocket_arn
}

output "lookcard_websocket_name" {
  value = module.lookcard-websocket.lookcard_websocket_name
}

output "websocket_connect_arn" {
  value = module.websocket-connect.websocket_connect_arn
}

output "websocket_connect_name" {
  value = module.websocket-connect.websocket_connect_name
}

output "websocket_disconnect_arn" {
  value = module.websocket-disconnect.websocket_disconnect_arn
}

output "websocket_disconnect_name" {
  value = module.websocket-disconnect.websocket_disconnect_name
}

output "lambda_aggregator_tron_sg_id" {
  value = module.aggregator-tron.lambda_aggregator_tron_sg_id
}

output "crypto_fund_withdrawal_sg_id" {
  value = module.crypto-fundwithdrawal.crypto_fund_withdrawal_sg_id
}

output "lambda_firebase_authorizer_sg_id" {
  value = module.firebase-authorizer.lambda_firebase_authorizer_sg_id
}

output "firebase_authorizer_invoke_url" {
  value = module.firebase-authorizer.firebase_authorizer_invoke_url
}