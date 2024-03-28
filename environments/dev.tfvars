# DEV VARIABLES
# terraform apply -var-file='environments/dev.tfvars'

frontend_bucket_name = "finances-app-frontend-bucket"
frontend_bucket_name_origin_path = "/finances-app/browser"

lambda_origin_configs = [
    {
        domain_url = "mxrnknfylcww3y2ogrz4kkoywe0iifob.lambda-url.sa-east-1.on.aws"
        lambda_name = "lambda_auth"
        api_path = "auth"
    },
    {
        domain_url = "x7dzbbuyiz7gl5h2kmlv5zijeu0zvnme.lambda-url.sa-east-1.on.aws"
        lambda_name = "lambda_api_handler"
        api_path = "api_handler"
    },
    {
        domain_url = "6z3wq2mkrx7zu6psjmp7v2isve0zkaue.lambda-url.sa-east-1.on.aws"
        lambda_name = "lambda_dashboard_despesa"
        api_path = "dashboard_despesa"
    }
]