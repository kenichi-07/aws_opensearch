Opensearch Changes

aws es update-elasticsearch-domain-config --domain-name pvai-prod-logs-v6 --elasticsearch-cluster-config file://es1.json --profile gsk --no-verify-ssl --region us-east-1
#es1.json (Instance Changes)
{
        “InstanceType”: “r5.large.elasticsearch”
}


#changes: instance count, instance type
aws es update-elasticsearch-domain-config --domain-name pvai-sit-logs-v6 --elasticsearch-cluster-config file://es1.json --profile gsk --no-verify-ssl --region us-east-1


#es1.json (Instance Changes)
{
        “InstanceType”: “r5.large.elasticsearch”
}


aws es update-elasticsearch-domain-config --domain-name pvai-val-logs-v6 --elasticsearch-cluster-config file://es1.json --profile gsk --no-verify-ssl --region us-east-1
#es1.json (Instance Changes)
{
        “InstanceType”: “r5x.large.elasticsearch”,
        "InstanceCount": 2
}


#es2.json (Subnet)
{
        “SubnetIds”: [
                “subnet-00d200c0589022e92”
        ],
        “SecurityGroupIds”: [
                “sg-061d7bed20d2cf7d3”
        ]
}


########################################################################################################

Bayer:

#Increase the max_shards_per_node

All Settings:-
GET _cluster/settings?flat_settings&include_defaults

#Allocations:
GET _cat/allocation?v

#Just confirmed with the team, and tested the same on my test domain. 
#You can run the following API call in Dev Tools in OpenSearch dashboard to increase the shard limit per node.
PUT /_cluster/settings
{
  "persistent": {
    "cluster.max_shards_per_node": <shard_count>
  }
}

#Replica to 0: Permanently in Templatte
PUT /_template/everything_template
{
  "template": "*",
  "settings": {
    "number_of_replicas": 0
  }
}


#To change the number of primary and replica shard count for an index:
PUT «index-name»
{
  "settings": {
    "number_of_shards": «primary-shard-count», 
    "number_of_replicas": «replica-shard-count»
  }
}

#Reducing the existing Primary shards by Reindexing:-

[STEP-1] 
Create a new index say “index-A-001”
PUT index-A-001
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 0»
  }
}

[STEP-2] 
Reindex data from “index-A” to “index-A-001”
POST _reindex
{
  "source": {
    "index": "index-A"
  },
  "dest": {
    "index": "index-A-001"
  }
}

[STEP-3] 
Check if the new index is created
GET _cat/indices?s=index

[STEP-4] 
Once confirmed, delete the older the index -- “index-A”
DELETE index-A


And to review these settings are successful, you can run the below API call.
GET _cluster/settings


pvai-dev-log-v6:-

#Version Upgrade: 
aws es upgrade-elasticsearch-domain --domain-name pvai-dev-logs-v6 --target-version 7.10 --profile bayer --region eu-west-1 --no-verify-ssl --vpc-options file://bayer_dev2.json

#changes: instance count, instance type
aws es update-elasticsearch-domain-config --domain-name pvai-dev-logs-v6 --elasticsearch-cluster-config file://bayer_dev1.json --vpc-options file://bayer_dev2.json --profile gsk --no-verify-ssl --region eu-west-1

#bayer_dev1.json (Instance Changes)
{
        “InstanceType”: “r6g.large.elasticsearch”,
        "InstanceCount": 1,
        “DedicatedMasterEnabled”: "false",
        “ZoneAwarenessEnabled”: "false"
}

#bayer_dev2.json (Subnet)
{
        “SubnetIds”: [
                “subnet-0363d5241f65b5257”
        ],
        “SecurityGroupIds”: [
                “sg-0dce6577dd87b4229”
        ]
}


pvai-sit-log-v6:-

#Version Upgrade: 
aws es upgrade-elasticsearch-domain --domain-name pvai-sit-log-v6 --target-version 7.10 --profile bayer --region eu-west-1 --no-verify-ssl

#changes: instance count, instance type
aws es update-elasticsearch-domain-config --domain-name pvai-sit-logs-v6 --elasticsearch-cluster-config file://bayer_sit1.json --vpc-options file://bayer_sit2.json --profile bayer --no-verify-ssl --region eu-west-1

#bayer_sit1.json (Instance Changes)
{
        “InstanceType”: “m6g.large.elasticsearch”,
        "InstanceCount": 1
        “DedicatedMasterEnabled”: false,
        “ZoneAwarenessEnabled”: false
}
#bayer_sit2.json (Subnet)
{
        “SubnetIds”: [
                “subnet-0f77a0dd5819a7a572”
        ],
        “SecurityGroupIds”: [
                “sg-0dce6577dd87b4229”
        ]
}


########################################################################################################

Bayer sit2-logs-v6

#Version Upgrade: 6.8
aws es upgrade-elasticsearch-domain --domain-name pvai-sit2-logs-v6 --target-version 6.8 --profile bayer --region eu-west-1 --no-verify-ssl

Deleted Old Kibana Logs:-
DELETE filebeat-6.2.1-2022.01*
DELETE filebeat-6.2.1-2022.02*
DELETE filebeat-6.2.1-2022.03*
DELETE filebeat-6.2.1-2022.04*
DELETE filebeat-6.2.1-2022.05*
DELETE filebeat-6.2.1-2022.06*
DELETE filebeat-6.2.1-2022.07*

DELETE traces:span-2022.01*
DELETE traces:span-2022.02*
DELETE traces:span-2022.03*
DELETE traces:span-2022.04*
DELETE traces:span-2022.05*
DELETE traces:span-2022-06*
DELETE traces:span-2022-07*

DELETE metrics-2022.01*
DELETE metrics-2022.02*
DELETE metrics-2022.03*
DELETE metrics-2022.04*
DELETE metrics-2022.05*
DELETE metrics-2022.06*
DELETE metrics-2022.07*

DELETE logs-2022.01*
DELETE logs-2022.02*
DELETE logs-2022.03*
DELETE logs-2022.04*
DELETE logs-2022.05*
DELETE logs-2022.06*
DELETE logs-2022.07*

#Version Upgrade: 7.10
aws es upgrade-elasticsearch-domain --domain-name pvai-sit2-logs-v6 --target-version 6.8 --profile bayer --region eu-west-1 --no-verify-ssl

#changes: instance count, instance type
aws es update-elasticsearch-domain-config --domain-name pvai-sit2-logs-v6 --elasticsearch-cluster-config file://bayer_sit2-v6-1.json --ebs-options file://bayer_sit2-v6-ebs.json --vpc-options file://bayer_sit2-v7-2.json --profile bayer --no-verify-ssl --region eu-west-1

#bayer_sit2-v6-1.json (Instance Changes)
{
        "InstanceCount": 1,
        “DedicatedMasterEnabled”: false,
        “ZoneAwarenessEnabled”: false
}

#bayer_sit2-v6-ebs.json (Volume Size)
{
    "VolumeSize": 250
}

#bayer_sit2-v7-2.json (Subnet)
{
        "SubnetIds": [
                "subnet-0f77a0dd5819a7a57"
        ],
        "SecurityGroupIds": [
                "sg-0dce6577dd87b4229"
        ]
}



########################################################################################################

Bayer sit2-logs-v7

#Version Upgrade: 
aws es upgrade-elasticsearch-domain --domain-name pvai-sit2-logs-v7 --target-version 7.10 --profile bayer --region eu-west-1 --no-verify-ssl

#changes: instance count, storage size
aws es update-elasticsearch-domain-config --domain-name pvai-sit2-logs-v7 --elasticsearch-cluster-config file://bayer_sit2-v7.json --ebs-options file://bayer_sit2-v7-ebs.json --vpc-options file://bayer_sit2-v7-1.json --profile bayer --no-verify-ssl --region eu-west-1

#bayer_sit2-v7.json (Instance Changes)
{
        "InstanceCount": 1,
        "DedicatedMasterEnabled": false,
        "ZoneAwarenessEnabled": false
}

#bayer_sit2-v7-ebs.json
{
    "VolumeSize": 400
}

#bayer_sit2-v7-1.json (Subnet)
{
        "SubnetIds": [
                “subnet-0f77a0dd5819a7a57”
        ],
        "SecurityGroupIds": [
                “sg-0dce6577dd87b4229”
        ]
}

Deleted Unassigned Shards on the Node with Kibana:

GET _cat/allocation?v

##Unassigned Replicas to 0:  Kibana
PUT /*/_settings
{
 "index" : {
  "number_of_replicas":0
 }
}

Bayer: pvai-dev-logs-v6


#changes: instance count, storage size
aws es update-elasticsearch-domain-config --domain-name pvai-dev-logs-v6 --elasticsearch-cluster-config file://bayer-dev-1.json --ebs-options file://bayer-dev-ebs.json --profile bayer --no-verify-ssl --region eu-west-1

--vpc-options file://bayer_dev-2.json

#bayer_dev-1.json (Instance Changes)
{
        "InstanceCount": 1,
        "InstanceType": "r6g.large.elastisearch",
        "ZoneAwarenessEnabled": false
}

#bayer-dev-ebs.json
{
    "VolumeSize": 480
}

#bayer_dev-2.json (Subnet)
{
        "SubnetIds": [
                “subnet-0363d5241f65b5257”
        ],
        "SecurityGroupIds": [
                “sg-0dce6577dd87b4229”
        ]
}



Cluster: pvai-sit-logs-v6

aws es update-elasticsearch-domain-config --domain-name pvai-sit-logs-v6 --elasticsearch-cluster-config file://bayer-sit-1.json --ebs-options file://bayer-sit-ebs.json --profile bayer --no-verify-ssl --region eu-west-1

--vpc-options file://bayer_dev-2.json

#bayer_dev-1.json (Instance Changes)
{
        "InstanceCount": 1,
        "InstanceType": "r6g.large.elastisearch",
        "ZoneAwarenessEnabled": false
}

#bayer-dev-ebs.json
{
    "VolumeSize": 480
}

#bayer_dev-2.json (Subnet)
{
        "SubnetIds": [
                “subnet-0363d5241f65b5257”
        ],
        "SecurityGroupIds": [
                “sg-0dce6577dd87b4229”
        ]
}

bayer-val

#changes: instance count, instance type
aws es update-elasticsearch-domain-config --domain-name pvai-val-logs-v6 --elasticsearch-cluster-config file://bayer_val1.json --vpc-options file://bayer_val2.json --profile bayer --no-verify-ssl --region eu-west-1

#bayer_val1.json (Instance Changes)
{
        "InstanceType": "r6g.large.elasticsearch",
        "InstanceCount": 1,
        "DedicatedMasterEnabled": false,
        "ZoneAwarenessEnabled": false
}

#bayer_val2.json (Subnet)
{
        "SubnetIds": [
                "subnet-0f77a0dd5819a7a57"
        ],
        "SecurityGroupIds": [
                “sg-0dce6577dd87b4229"
        ]
}

aws es update-elasticsearch-domain-config --domain-name pvai-prod-logs-v --elasticsearch-cluster-config file://bayer_sit2-v7.json --ebs-options file://bayer_sit2-v7-ebs.json --vpc-options file://bayer_sit2-v7-1.json --profile bayer --no-verify-ssl --region eu-west-1

aws es update-elasticsearch-domain-config --domain-name pvai-xyz --ebs-options file://x.json --profile Product

#bayer_sit2-v7.json (Instance Changes)
{
        "InstanceCount": 1,
        "DedicatedMasterEnabled": false,
        "ZoneAwarenessEnabled": false
}

#bayer_sit2-v7-ebs.json
{
    "VolumeSize": 400
}

#bayer_sit2-v7-1.json (Subnet)
{
        "SubnetIds": [
                “subnet-0f77a0dd5819a7a57”
        ],
        "SecurityGroupIds": [
                “sg-0dce6577dd87b4229”
        ]
}



