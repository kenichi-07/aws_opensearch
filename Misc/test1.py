status_check()
{
x=`aws opensearch describe-domain-config --domain-name pvai-product-demo1 --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.EngineVersion.Status.State'`
}

status_check