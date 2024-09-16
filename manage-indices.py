import boto3
from elasticsearch import Elasticsearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth
import curator

session = boto3.Session(profile_name='cloudops-product', region_name='us-east-1')
credentials = session.get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, session.region_name, 'es', session_token=credentials.token)


def connect_to_es():
    es = Elasticsearch(timeout=120, max_retries=10, 
        hosts = [{'host': 'vpc-xyz-product-demo1-7c2kvm4yejbzkrefckkqx5pckq.us-east-1.es.amazonaws.com', 'port': 9200}],
        http_auth = awsauth,
        use_ssl = True,
        verify_certs = True,
        connection_class = RequestsHttpConnection)
    print("Es connected successfully")
    print(es.ping)
    index_list = curator.IndexList(es)
    index_list.filter_by_age(source='name', direction='older', timestring='%Y.%m.%d', unit='days', unit_count=30)
    print(len(index_list.indices))
    # result = es.search(index="filebeat-7.6.1-2022.11.11", body={"query":{"match_all":{}}})
    # print(result)
    
    return es

connect_to_es()