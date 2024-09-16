#### Opensearch Instance Scale-Down ####
opensearch_identifier = pvai-product-demo1
status_check (){
    x=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.EngineVersion.Status.State'`
    y=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.ClusterConfig.Status.State'`
    z=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.EBSOptions.Status.State'`
    InstanceType=`aws es describe-elasticsearch-domain-config --domain-name ansaf-testing-domain --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.ElasticsearchClusterConfig.Options.InstanceType'`
            }

status_check
if [ $x == '"Active"' ] &&  [ $y == '"Active"' ] && [ $z == '"Active"' ] && [ $InstanceType == '"r6g.large.elasticsearch"']; then
    echo "continue"
    aws es update-elasticsearch-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --elasticsearch-cluster-config InstanceType=c6g.large.search --no-verify-ssl

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


#### Opensearch Instance Scale-Up ####
status_check () {
    x=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.EngineVersion.Status.State'`
    y=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.ClusterConfig.Status.State'`
    z=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.EBSOptions.Status.State'`
}

status_check
if [ $x == '"Active"' ] &&  [ $y == '"Active"' ] && [ $z == '"Active"' ]; then
    echo "continue"
    aws es update-elasticsearch-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1  --elasticsearch-cluster-config InstanceType=r6g.large.search

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



1. Manual Snapshot in S3.
2. Check the status of the cluster delete then kibana logs older than 30 days.
3. Automated Snapshot: 
4. 

aws opensearch describe-domain-config --domain-name pvai-pt2-logs-v6 --region us-east-1 --query 'DomainConfig.EngineVersion.Status.State


#### Opensearch Instance Scale-Down ####
opensearch_identifier='pvai-product-demo1'
status_check (){
    x=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.EngineVersion.Status.State'`
    y=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.ClusterConfig.Status.State'`
    z=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.EBSOptions.Status.State'`
}

status_check
if [ $x == '"Active"' ] &&  [ $y == '"Active"' ] && [ $z == '"Active"' ]; then
    echo "continue"
    aws es update-elasticsearch-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --elasticsearch-cluster-config { "InstanceType": "c6g.large.search"} --no-verify-ssl

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


opensearch_identifier='pvai-product-demo1'
status_check()
{
        x=`aws opensearch describe-domain-config --domain-name $opensearch_identifier --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.EngineVersion.Status.State'`
}

status_check
