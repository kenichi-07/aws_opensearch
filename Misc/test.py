import boto3
import requests
from requests_aws4auth import AWS4Auth
from pprint import pprint
import sys
import time



region = 'us-east-1'
service = 'es'
session = boto3.Session(profile_name='cloudops-product', region_name='us-east-1')
credentials = session.get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

opensearch_client = session.client('opensearch')
domanin_name_response = opensearch_client.list_domain_names(
    EngineType='Elasticsearch'
)

def cluster_status(domain_name):
    cluster_status_response = opensearch_client.describe_domain_config(DomainName=domain_name)
    if cluster_status_response['DomainConfig']['ClusterConfig']['Status']['State'] == 'Active' and cluster_status_response['DomainConfig']['EngineVersion']['Status']['State'] == 'Active' and cluster_status_response['DomainConfig']['EBSOptions']['Status']['State'] == 'Active':
        # print(cluster_status_response['DomainConfig']['EBSOptions']['Options']['VolumeSize'])
        print('cluster is active')
    else:
        print('move on to next cluster as current one is not in active state')
        pass
    return cluster_status_response

def modify_storage_size(domain_name, desired_volume_size):
    storage_modification_response = opensearch_client.update_domain_config(
    DomainName=domain_name,
    EBSOptions={
        'VolumeSize': desired_volume_size,
    })
    pprint(storage_modification_response)
    cluster_status_response = opensearch_client.describe_domain_config(DomainName=domain_name)
    while cluster_status_response['DomainConfig']['EBSOptions']['Status']['State'] != 'Active':
        cluster_status_response = opensearch_client.describe_domain_config(DomainName=domain_name)
        time.sleep(5)
    print(cluster_status_response['DomainConfig']['EBSOptions']['Status']['State'])
    print(cluster_status_response['DomainConfig']['EBSOptions']['Options']['VolumeSize'])
    


def health_status_function(domain_endpoint):
    host = domain_endpoint

    # path = 'filebeat-7.6.1-2022.11.22/_search' # the Elasticsearch API endpoint
    path = '_cluster/health'
    url = host + path

    # payload = {"query": {"match_all": {}}}

    headers = {"Content-Type": "application/json"}

    # r = requests.get(url, auth=awsauth, json=payload, headers=headers)
    r = requests.get(url, auth=awsauth, headers=headers)

    print(r.status_code)
    if r.json()['status'] == 'yellow':
        print('status is yellow')
    if r.json()['status'] == 'red':
        print('status is red')
    if r.json()['status'] == 'green':
        print('status is green')

def available_storage_function(domain_endpoint):
    host = domain_endpoint
    path = '_cluster/stats?human&pretty'
    url = host + path
    headers = {"Content-Type": "application/json"}
    r = requests.get(url, auth=awsauth, headers=headers)

    if r.json()['nodes']['fs']['free_in_bytes'] < 50000000000:
        free_space = r.json()['nodes']['fs']['free']
        print(f'total free space is: {free_space}')
        print('storage needs to be extended')
    else:
        free_space = r.json()['nodes']['fs']['free']
        print(f'total free space is: {free_space}')

def unassigned_shards_existence_function(domain_endpoint):
    host = domain_endpoint
    path = '_cluster/health'
    url = host + path
    headers = {"Content-Type": "application/json"}
    r = requests.get(url, auth=awsauth, headers=headers)
    if r.json()['unassigned_shards'] > 0:
        print('unassigned shards are present')
    else:
        print('no unassigned shards found')

def list_indices_function(domain_endpoint):
    host = domain_endpoint
    path = '_all'
    url = host + path
    headers = {"Content-Type": "application/json"}
    r = requests.get(url, auth=awsauth, headers=headers)
    pprint(r.json())


# i = 1
# for each_dictionary in domanin_name_response['DomainNames']:
#     if each_dictionary['EngineType'] == 'Elasticsearch':
#         # print(i, each_dictionary['DomainName'])
#         # print(i, domain_describe_response['DomainStatus']['Endpoints']['vpc'])
        
        
        
#         domain_describe_response = opensearch_client.describe_domain(DomainName=each_dictionary['DomainName'])
#         pprint(domain_describe_response)
#         domain_endpoint = 'https://'+domain_describe_response['DomainStatus']['Endpoints']['vpc']+'/'
#         print(i, domain_endpoint)
#         cluster_status(each_dictionary['DomainName'])
#         i += 1

# health_status_function('https://vpc-pvai-product-val2x-exjd4rumxruepudck24m5ismdq.us-east-1.es.amazonaws.com/')
# available_storage_function('https://vpc-pvai-product-val2x-exjd4rumxruepudck24m5ismdq.us-east-1.es.amazonaws.com/')
# unassigned_shards_existence_function('https://vpc-pvai-product-val2x-exjd4rumxruepudck24m5ismdq.us-east-1.es.amazonaws.com/')
# modify_storage_size('pvai-dev21-logs-v7', '<provide desired size')
list_indices_function('https://vpc-pvai-product-val2x-exjd4rumxruepudck24m5ismdq.us-east-1.es.amazonaws.com/')




s-east-1:281688746363:cluster/pvai-gsk-test-eks-cluster


