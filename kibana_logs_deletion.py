from opensearchpy import OpenSearch, RequestsHttpConnection, AWSV4SignerAuth
import boto3
from requests.exceptions import RequestException

# Define the OpenSearch domain details
host = 'vpc-product-demo1-7c2kvm4yejbzkrefckkqx5pckq.us-east-1.es.amazonaws.com'
region = 'us-east-1'
index = 'filebeat-7.6.1-2022.02.02'  # The index you want to query

# Set up AWS credentials for authentication
credentials = boto3.Session().get_credentials()
auth = AWSV4SignerAuth(credentials, region)

# Initialize the OpenSearch client
client = OpenSearch(
    hosts=[{'host': host}],
    http_auth=auth,
    use_ssl=True,
    verify_certs=True,
    connection_class=RequestsHttpConnection
)

# Function to search the OpenSearch index with error handling
def search_opensearch():
    try:
        # Perform a search query on the OpenSearch index
        # This example searches for logs where "message" contains the word "ERROR"
        query = {
            "query": {
                "match": {
                    "message": "ERROR"
                }
            }
        }
        res = client.search(index=index, body=query)
        
        # Print the total number of hits and the first few results
        print(f"Total hits: {res['hits']['total']['value']}")
        for hit in res['hits']['hits']:
            print(f"Document ID: {hit['_id']}, Message: {hit['_source']['message']}")
    
    except RequestException as e:
        print(f"Request failed: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Test the connection to the OpenSearch domain
def test_connection():
    try:
        if client.ping():
            print("Connected to OpenSearch cluster successfully!")
        else:
            print("Failed to connect to OpenSearch cluster.")
    except Exception as e:
        print(f"Error while pinging OpenSearch cluster: {e}")

# Main execution
if __name__ == "__main__":
    # Test connection
    test_connection()

    # Perform the search
    search_opensearch()
