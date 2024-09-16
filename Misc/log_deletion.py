from datetime import datetime
import os
from elasticsearch import Elasticsearch
es = Elasticsearch()

host = 'https://vpc-product-demo1-7c2kvm4yejbzkrefckkqx5pckq.us-east-1.es.amazonaws.com'
region = 'us-east-1'
service = 'es'
credentials = {
    'access_key': os.environ.get('ACCESS_KEY'),
    'secret_key': os.environ.get('SECRET_KEY')
}
awsauth = AWS4Auth(credentials['access_key'], credentials['secret_key'], region, service)
es = Elasticsearch(
    hosts=[host,9200],
    https_auth=awsauth,
    use_ssl=True,
    verify_certs=True
)
print(es.info())