resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  name                              = "cloudfront_oac_${var.frontend_bucket_name}"
  description                       = "CloudFront S3 OAC For Bucket ${var.frontend_bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # Frontend Origin
  origin {
    domain_name              = "${var.frontend_bucket_name}.s3.sa-east-1.amazonaws.com"
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
    origin_id                = var.frontend_bucket_name
    origin_path              = var.frontend_bucket_name_origin_path
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.frontend_bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  


  # Lambda URL Origins
  # dynamic "origin" {
  #   for_each = var.lambda_origin_configs

  #   content {
  #     domain_name = origin.value["domain_url"]
  #     origin_id = origin.value["lambda_name"]

  #     custom_origin_config {
  #       https_port = 443
  #       http_port = 80
  #       origin_protocol_policy = "https-only"
  #       origin_ssl_protocols = ["TLSv1.2"]
  #     }
  #   }
  # }


  # Lambda URL Behaviors
  # dynamic "ordered_cache_behavior" {
  #   for_each = var.lambda_origin_configs

  #   content {
  #     path_pattern = "/api/${ordered_cache_behavior.value["api_path"]}/*"
      
  #     allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
  #     cached_methods = ["HEAD", "GET", "OPTIONS"]
  #     target_origin_id = ordered_cache_behavior.value["lambda_name"]

  #     forwarded_values {
  #       query_string = true

  #       cookies {
  #         forward = "whitelist"
  #         whitelisted_names = [
  #           "sessionId"
  #         ]
  #       }
  #     }

  #     viewer_protocol_policy = "redirect-to-https"

  #     #disabled cache
  #     min_ttl                = 0
  #     default_ttl            = 0
  #     max_ttl                = 0
  #   }
  # }

  origin {
    domain_name = "${var.api_gateway_id}.execute-api.${var.api_gateway_region}.amazonaws.com"
    origin_id = "api-gateway-${var.api_gateway_id}"
    # origin_path = "/dev"

    custom_origin_config {
      https_port = 443
      http_port = 80
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  ordered_cache_behavior {
    path_pattern = "/api/*"
    
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = "api-gateway-${var.api_gateway_id}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "whitelist"
        whitelisted_names = [
          "sessionId"
        ]
      }
    }

    viewer_protocol_policy = "allow-all"

    #disabled cache
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
  
  custom_error_response {
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }
  

  price_class = "PriceClass_100" # PriceClass_100 (Mais barata, entrega rápida apenas para NA e EUROPA)

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  # SSL config
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Environment = "production"
  }
}