# DEV VARIABLES
# terraform apply -var-file='environments/dev.tfvars'

frontend_bucket_name = "finances-app-frontend-bucket"
frontend_bucket_name_origin_path = "/finances-app/browser"

api_gateway_id = "43bm9vnw7g"

# lambda_origin_configs = [
#     {
#         domain_url = ""
#         lambda_name = "lambda_auth"
#         api_path = "auth"
#     },
#     {
#         domain_url = ""
#         lambda_name = "lambda_api_handler"
#         api_path = "api_handler"
#     },
#     {
#         domain_url = ""
#         lambda_name = "lambda_dashboard_despesa"
#         api_path = "dashboard_despesa"
#     }
# ]