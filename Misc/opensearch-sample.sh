#!/bin/bash
opensearch_identifier='pt-logs'
status_check () {
    x=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --query 'DomainConfig.EngineVersion.Status.State' --region us-east-1 --profile product --profile product --no-verify-ssl`
    y=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --query 'DomainConfig.ClusterConfig.Status.State' --region us-east-1 --profile product --profile product --no-verify-ssl`
    z=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --query 'DomainConfig.EBSOptions.Status.State' --region us-east-1 --profile product --profile product --no-verify-ssl`
}

status_check
if [ $x == '"Active"' ] &&  [ $y == '"Active"' ] && [ $z == '"Active"' ]; then
    echo "continue"
    #aws es update-elasticsearch-domain-config --domain-name $opensearch_identifier --elasticsearch-cluster-config { "InstanceType": "c6g.large.search"} --profile product --no-verify-ssl --region us-east-1

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


