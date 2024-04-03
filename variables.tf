variable frontend_bucket_name {
  type        = string
  description = "frontend bucket name to be used as origin in cloudfront"
}

variable frontend_bucket_name_origin_path {
  type        = string
  description = "frontend bucket name to be used as origin in cloudfront"
}

variable api_gateway_id {
  type        = string
  description = "API Gateway ID"
}

variable api_gateway_region {
  type        = string
  description = "Region where API Gateway was deployed"
  default = "sa-east-1"
}

# variable lambda_origin_configs {
#     type = set(
#         object({
#             domain_url = string
#             lambda_name = string
#             api_path = string
#         })
#     )

#     description = "list of lambda urls that will be added to cloudfront"

#     default = []
# }