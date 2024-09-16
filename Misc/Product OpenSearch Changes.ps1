Product OpenSearch Changes

###Instance: pvai-pt-test-logs6###

#InstanceType: r6g.large.elasticsearch
aws es update-elasticsearch-domain-config --domain-name pvai-pt-test-logs --elasticsearch-cluster-config file://prod_test.json --profile product --no-verify-ssl --region us-east-1

#prod_test.json (Instance Changes)
{
        "InstanceType": "r6g.xlarge.elasticsearch"
}

#Cluster Status: Yellow Due to Unassigned shards.
#Next Step: Delete Unassigned shards and make the replica indexing 0 to permanently fix that no unassigned shards persist.

##Check Unassigned Shards: Kibana
GET /_cluster/health/

##Unassigned Replicas to 0:  Kibana
PUT */_settings { "index.number_of_replicas": 0 }

#InstanceType: r6g.xlarge.elasticsearch
aws es update-elasticsearch-domain-config --domain-name pvai-pt-test-logs --elasticsearch-cluster-config file://prod_test.json --profile product --no-verify-ssl --region us-east-1

#prod_test.json (Instance Changes)
{
        "InstanceType": "r6g.xlarge.elasticsearch"
}

#InstanceType: r6g.large.elasticsearch
aws es update-elasticsearch-domain-config --domain-name pvai-pt-test-logs --elasticsearch-cluster-config file://prod_test1.json --profile product --no-verify-ssl --region us-east-1

#prod_test1.json (Instance Changes)
{
        "InstanceType": "r6g.large.elasticsearch"
}

###Instance: pvai-pt-test-logs6###

##demo1-v6
aws es update-elasticsearch-domain-config --domain-name pvai-demo1-logs-v6 --elasticsearch-cluster-config { "InstanceType": "c6g.large.search"} --profile product --no-verify-ssl --region us-east-1


opensearch_identifier = 'pvai-demo1-logs-v6'
aws opensearch describe-domain-config --domain-name $opensearch_identifier 

SHUTDOWN:
ECS
elasticsearch

UP:
elasticsearch
ECS

"DomainConfig"
x=`aws opensearch describe-domain-config --domain-name pvai-demo1-logs-v6 --query 'DomainConfig.EngineVersion.Status.State' --region us-east-1 --profile product --profile product --no-verify-ssl`
y=`aws opensearch describe-domain-config --domain-name pvai-demo1-logs-v6 --query 'DomainConfig.ClusterConfig.Status.State' --region us-east-1 --profile product --profile product --no-verify-ssl`
z=`aws opensearch describe-domain-config --domain-name pvai-demo1-logs-v6 --query 'DomainConfig.EBSOptions.Status.State' --region us-east-1 --profile product --profile product --no-verify-ssl`

if [x==active]

if [ $((x%2)) == 0 ]; then
  echo "Number is Even"
fi

if [ $x == 'Active' ] &&  [ $y == 'Active' ] && [ $z == 'Active' ]; then
      echo "continue"
else
    echo "Opensearch Cluster is not active."
fi
