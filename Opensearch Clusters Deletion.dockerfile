## Opensearch Clusters Deletion

aws opensearch delete-domain --domain-name pvai-pt2-logs-v7 --profile product --region us-east-1 --no-verify-ssl
aws opensearch delete-domain --domain-name pvai-sit-logs --profile product --region us-east-1 --no-verify-ssl
aws opensearch delete-domain --domain-name pvai-sit-logs-v7 --profile product --region us-east-1 --no-verify-ssl
aws opensearch delete-domain --domain-name pvai-qa-logs-v6 --profile product --region us-east-1 --no-verify-ssl