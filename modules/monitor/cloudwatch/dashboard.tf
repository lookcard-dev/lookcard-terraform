resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "LookCard-Service-Dashboard-${upper(var.runtime_environment)}"

  dashboard_body = jsonencode({
    widgets = concat(
      [
        {
          type   = "text"
          x      = 0
          y      = 0
          width  = 24
          height = 1
          properties = {
            markdown = "# LookCard Service Dashboard - ${upper(var.runtime_environment)}"
          }
        },
        {
          type   = "metric"
          x      = 0
          y      = 1
          width  = 12
          height = 6
          properties = {
            view    = "timeSeries"
            stacked = false
            metrics = [
              ["AWS/ApiGateway", "Count", "ApiName", "lookcard_api", { "stat" = "Sum" }],
              ["AWS/ApiGateway", "Count", "ApiName", "webhook", { "stat" = "Sum" }],
              ["AWS/ApiGateway", "Count", "ApiName", "reseller_api", { "stat" = "Sum" }]
            ],
            region = var.aws_provider.region,
            title  = "API Gateway Request Count",
            period = 300
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 1
          width  = 12
          height = 6
          properties = {
            view    = "timeSeries"
            stacked = false
            metrics = [
              ["AWS/ApiGateway", "Latency", "ApiName", "lookcard_api", { "stat" = "Average" }],
              ["AWS/ApiGateway", "Latency", "ApiName", "webhook", { "stat" = "Average" }],
              ["AWS/ApiGateway", "Latency", "ApiName", "reseller_api", { "stat" = "Average" }]
            ],
            region = var.aws_provider.region,
            title  = "API Gateway Latency",
            period = 300
          }
        },
        {
          type   = "metric"
          x      = 0
          y      = 7
          width  = 12
          height = 6
          properties = {
            view    = "timeSeries"
            stacked = false
            metrics = [
              ["AWS/ApiGateway", "4XXError", "ApiName", "lookcard_api", { "stat" = "Sum" }],
              ["AWS/ApiGateway", "4XXError", "ApiName", "webhook", { "stat" = "Sum" }],
              ["AWS/ApiGateway", "4XXError", "ApiName", "reseller_api", { "stat" = "Sum" }]
            ],
            region = var.aws_provider.region,
            title  = "API Gateway 4XX Errors",
            period = 300
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 7
          width  = 12
          height = 6
          properties = {
            view    = "timeSeries"
            stacked = false
            metrics = [
              ["AWS/ApiGateway", "5XXError", "ApiName", "lookcard_api", { "stat" = "Sum" }],
              ["AWS/ApiGateway", "5XXError", "ApiName", "webhook", { "stat" = "Sum" }],
              ["AWS/ApiGateway", "5XXError", "ApiName", "reseller_api", { "stat" = "Sum" }]
            ],
            region = var.aws_provider.region,
            title  = "API Gateway 5XX Errors",
            period = 300
          }
        },
        {
          type   = "metric"
          x      = 0
          y      = 13
          width  = 12
          height = 6
          properties = {
            view    = "timeSeries"
            stacked = false
            metrics = [
              ["AWS/ECS", "CPUUtilization", "ClusterName", "core-application", { "stat" = "Average" }],
              ["AWS/ECS", "CPUUtilization", "ClusterName", "composite-application", { "stat" = "Average" }],
              ["AWS/ECS", "CPUUtilization", "ClusterName", "listener", { "stat" = "Average" }],
              ["AWS/ECS", "CPUUtilization", "ClusterName", "cronjob", { "stat" = "Average" }],
              ["AWS/ECS", "CPUUtilization", "ClusterName", "webhook", { "stat" = "Average" }],
              ["AWS/ECS", "CPUUtilization", "ClusterName", "administrative", { "stat" = "Average" }]
            ],
            region = var.aws_provider.region,
            title  = "ECS Cluster CPU Utilization",
            period = 300
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 13
          width  = 12
          height = 6
          properties = {
            view    = "timeSeries"
            stacked = false
            metrics = [
              ["AWS/ECS", "MemoryUtilization", "ClusterName", "core-application", { "stat" = "Average" }],
              ["AWS/ECS", "MemoryUtilization", "ClusterName", "composite-application", { "stat" = "Average" }],
              ["AWS/ECS", "MemoryUtilization", "ClusterName", "listener", { "stat" = "Average" }],
              ["AWS/ECS", "MemoryUtilization", "ClusterName", "cronjob", { "stat" = "Average" }],
              ["AWS/ECS", "MemoryUtilization", "ClusterName", "webhook", { "stat" = "Average" }],
              ["AWS/ECS", "MemoryUtilization", "ClusterName", "administrative", { "stat" = "Average" }]
            ],
            region = var.aws_provider.region,
            title  = "ECS Cluster Memory Utilization",
            period = 300
          }
        }
      ],
      [
        for i, service in var.services : {
          type   = "log"
          x      = i % 2 == 0 ? 0 : 12
          y      = 19 + (i / 2 * 8)
          width  = 12
          height = 8
          properties = {
            query  = "SOURCE '/lookcard/${service}' | fields @timestamp, @message | sort @timestamp desc | limit 20"
            region = var.aws_provider.region
            title  = "${service} Application Logs"
            view   = "table"
          }
        }
      ],
      [
        {
          type   = "metric"
          x      = 0
          y      = 19 + (length(var.services) / 2 * 8) + (length(var.services) % 2 == 0 ? 0 : 8)
          width  = 24
          height = 6
          properties = {
            view    = "timeSeries"
            stacked = false
            metrics = [
              ["CloudWatchSynthetics", "SuccessPercent", "CanaryName", "lookcard-tron", { "stat" = "Average" }]
            ],
            region = var.aws_provider.region,
            title  = "Canary Success Rate",
            period = 300,
            annotations = {
              horizontal = [
                {
                  value = 100,
                  label = "100% Success",
                  color = "#2ca02c"
                },
                {
                  value = 99,
                  label = "99% Success",
                  color = "#ffbb78"
                }
              ]
            }
          }
        }
      ]
    )
  })
}

resource "aws_cloudwatch_dashboard" "services_dashboard" {
  dashboard_name = "LookCard-Services-Detail-Dashboard-${upper(var.runtime_environment)}"

  dashboard_body = jsonencode({
    widgets = concat(
      [
        {
          type   = "text"
          x      = 0
          y      = 0
          width  = 24
          height = 1
          properties = {
            markdown = "# LookCard Services Detail Dashboard - ${upper(var.runtime_environment)}"
          }
        }
      ],
      flatten([
        for i, service in var.services : [
          {
            type   = "metric"
            x      = 0
            y      = 1 + (i * 9)
            width  = 12
            height = 9
            properties = {
              view    = "timeSeries"
              stacked = false
              metrics = [
                ["AWS/ECS", "CPUUtilization", "ServiceName", service, "ClusterName", "core-application", { "stat" = "Average" }]
              ]
              region = var.aws_provider.region
              title  = "${service} - CPU Utilization"
              period = 300
            }
          },
          {
            type   = "metric"
            x      = 12
            y      = 1 + (i * 9)
            width  = 12
            height = 9
            properties = {
              view    = "timeSeries"
              stacked = false
              metrics = [
                ["AWS/ECS", "MemoryUtilization", "ServiceName", service, "ClusterName", "core-application", { "stat" = "Average" }]
              ]
              region = var.aws_provider.region
              title  = "${service} - Memory Utilization"
              period = 300
            }
          }
        ]
      ])
    )
  })
}

resource "aws_cloudwatch_dashboard" "crypto_listener_dashboard" {
  dashboard_name = "LookCard-Crypto-Listener-Dashboard-${upper(var.runtime_environment)}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 1
        properties = {
          markdown = "# LookCard Crypto Listener Dashboard - ${upper(var.runtime_environment)}"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 1
        width  = 12
        height = 6
        properties = {
          view    = "timeSeries"
          stacked = false
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", "crypto-listener-tron-mainnet-trongrid", "ClusterName", "listener", { "stat" = "Average" }],
            ["AWS/ECS", "CPUUtilization", "ServiceName", "crypto-listener-tron-mainnet-getblock", "ClusterName", "listener", { "stat" = "Average" }],
          ]
          region = var.aws_provider.region
          title  = "Tron Listener CPU Utilization"
          period = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 1
        width  = 12
        height = 6
        properties = {
          view    = "timeSeries"
          stacked = false
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ServiceName", "crypto-listener-tron-mainnet-trongrid", "ClusterName", "listener", { "stat" = "Average" }],
            ["AWS/ECS", "MemoryUtilization", "ServiceName", "crypto-listener-tron-mainnet-getblock", "ClusterName", "listener", { "stat" = "Average" }],
          ]
          region = var.aws_provider.region
          title  = "Tron Listener Memory Utilization"
          period = 300
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 7
        width  = 24
        height = 8
        properties = {
          query  = "SOURCE '/lookcard/crypto-listener/tron/mainnet/trongrid' | fields @timestamp, @message | filter @message like 'ERROR' | sort @timestamp desc | limit 20"
          region = var.aws_provider.region
          title  = "Tron Trongrid Listener Error Logs"
          view   = "table"
        }
      }
    ]
  })
}

# Outputs
output "main_dashboard_name" {
  description = "Name of the main CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "services_dashboard_name" {
  description = "Name of the services detail dashboard"
  value       = aws_cloudwatch_dashboard.services_dashboard.dashboard_name
}

output "crypto_listener_dashboard_name" {
  description = "Name of the crypto listener dashboard"
  value       = aws_cloudwatch_dashboard.crypto_listener_dashboard.dashboard_name
}
