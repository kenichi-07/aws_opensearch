Kibana Old Logs Deletion

DELETE filebeat-6.2.1-2022.01*
DELETE filebeat-6.2.1-2022.02*
DELETE filebeat-6.2.1-2022.03*
DELETE filebeat-6.2.1-2022.04*
DELETE filebeat-6.2.1-2022.05*
DELETE filebeat-6.2.1-2022.06*
DELETE filebeat-6.2.1-2022.07*
DELETE filebeat-6.2.1-2022.08*

DELETE traces:span-2022.01.22*
DELETE traces:span-2022.02*
DELETE traces:span-2022.03*
DELETE traces:span-2022.04*
DELETE traces:span-2022.05*
DELETE traces:span-2022-06*
DELETE traces:span-2022-07*
DELETE traces:span-2022-08*

DELETE metrics-2022.01*
DELETE metrics-2022.02*
DELETE metrics-2022.03*
DELETE metrics-2022.04*
DELETE metrics-2022.05*
DELETE metrics-2022.06*
DELETE metrics-2022.07*
DELETE metrics-2022.08*

DELETE logs-2022.01*
DELETE logs-2022.02*
DELETE logs-2022.03*
DELETE logs-2022.04*
DELETE logs-2022.05*
DELETE logs-2022.06*
DELETE logs-2022.08*


curl -XGET 'https://vpc-pvai-product-demo1-7c2kvm4yejbzkrefckkqx5pckq.us-east-1.es.amazonaws.com/filebeat-7.6.1*/_search' 

