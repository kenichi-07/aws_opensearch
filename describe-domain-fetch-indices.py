import boto3
from pprint import pprint
from elasticsearch import Elasticsearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth

# Initialize a boto3 session
session = boto3.session.Session(profile_name='product', region_name='us-east-1')

# Create a boto3 client for Elasticsearch (AWS ES service)
client = session.client('es', region_name='us-east-1')

# Describe the Elasticsearch domain using the boto3 client
response = client.describe_elasticsearch_domain(
    DomainName='xyz-product-demo1'
)

# Pretty print the domain description details
pprint(response)

# Extract the endpoint from the domain description
domain_endpoint = response['DomainStatus']['Endpoint']
print(f"Elasticsearch Domain Endpoint: {domain_endpoint}")

# Set up AWS authentication for connecting to the Elasticsearch cluster
credentials = session.get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, session.region_name, 'es', session_token=credentials.token)

# Connect to the Elasticsearch cluster using the elasticsearch-py library
es = Elasticsearch(
    hosts=[{'host': domain_endpoint, 'port': 443}],
    http_auth=awsauth,
    use_ssl=True,
    verify_certs=True,
    connection_class=RequestsHttpConnection
)

# Test the connection by pinging the Elasticsearch cluster
if es.ping():
    print("Connected to Elasticsearch cluster successfully!")
else:
    print("Failed to connect to Elasticsearch cluster.")

# Fetch all indices and their aliases from the Elasticsearch cluster
indices = es.indices.get_alias("*")
pprint(indices)

