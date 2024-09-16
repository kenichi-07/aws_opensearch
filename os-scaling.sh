#!/bin/bash

opensearch_identifier_1='test_domain'

#### Opensearch Instance Scale-Down ####
status_check (){
    x=`aws opensearch describe-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --query 'DomainConfig.EngineVersion.Status.State'`
    y=`aws opensearch describe-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --query 'DomainConfig.ClusterConfig.Status.State'`
    z=`aws opensearch describe-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --query 'DomainConfig.EBSOptions.Status.State'`
    i=`aws es describe-elasticsearch-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --query 'DomainConfig.ElasticsearchClusterConfig.Options.InstanceType'`
            }

status_check
if [ $x == '"Active"' ] && [ $y == '"Active"' ] && [ $z == '"Active"' ] && [ $i == '"r5.xlarge.elasticsearch"' ]; then
    echo "continue"
    aws es update-elasticsearch-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --elasticsearch-cluster-config InstanceType=c6g.large.elasticsearch

    status_check    
    while [ $x == '"Active"' ] && [ $y == '"Active"' ] && [ $z == '"Active"' ]
    do
        status_check
        echo 'opensearch cluster did not come up yet.'
        sleep 5
    done
else
    echo "Opensearch Cluster is not active."
fi


#### Opensearch Instance Scale-Up ####
status_check () {
    x=`aws opensearch describe-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --query 'DomainConfig.EngineVersion.Status.State'`
    y=`aws opensearch describe-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --query 'DomainConfig.ClusterConfig.Status.State'`
    z=`aws opensearch describe-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --query 'DomainConfig.EBSOptions.Status.State'`
    i=`aws es describe-elasticsearch-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --query 'DomainConfig.ElasticsearchClusterConfig.Options.InstanceType'`
}

status_check
if [ $x == '"Active"' ] &&  [ $y == '"Active"' ] && [ $z == '"Active"' ] && [ $i == '"c6g.large.elasticsearch"' ]; then
    echo "continue"
    aws es update-elasticsearch-domain-config --domain-name $opensearch_identifier_1 --region us-east-1 --elasticsearch-cluster-config InstanceType=r5.xlarge.elasticsearch

    status_check    
    while [ $x == '"Active"' ] &&  [ $y == '"Active"' ] && [ $z == '"Active"' ]
    do
        status_check
        echo 'opensearch cluster did not come up yet.'
        sleep 5
    done
else
    echo "Opensearch Cluster is not active."
fi


