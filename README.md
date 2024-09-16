# OpenSearch Cluster Management and Scaling

This repository contains several scripts and configuration files for managing, scaling, and interacting with Amazon OpenSearch clusters. The scripts use AWS CLI and `opensearch-py` to automate various tasks such as scaling instances, managing indices, and domain creation.

## Table of Contents

- [Files Overview](#files-overview)
  - [`kibana_logs_deletion.py`](#kibana_logs_deletionpy)
  - [`os-scaling.sh`](#os-scalingsh)
  - [`describe-domain-fetch-indices.py`](#describe-domain-fetch-indicespy)
  - [`manage-indices.py`](#manage-indicespy)
  - [`Opensearch Clusters Deletion.dockerfile`](#opensearch-clusters-deletiondockerfile)
  - [`create-domain.sh`](#create-domainsh)
  - [`es1.json`](#es1json)
  - [`es2.json`](#es2json)
  - [`instance_type_check.sh`](#instance_type_checksh)

## Files Overview

### `kibana_logs_deletion.py`

This script is designed to automate the deletion of old Kibana logs in an OpenSearch cluster. It uses the `opensearch-py` library to connect to the cluster and deletes indices based on predefined age criteria.

- **Usage:**
  - Run this script to periodically clean up logs and avoid storage issues.
  
### `os-scaling.sh`

This Bash script provides an automated method to **scale up** and **scale down** an OpenSearch domain instance in AWS. It uses the AWS CLI to query the status of the OpenSearch domain and adjusts the instance type accordingly.

- **Functionality:**
  - **Scale-Down:** Checks the domain’s current status and scales down the instance type if certain conditions are met.
  - **Scale-Up:** Similarly, scales up the instance when needed.
  
- **Key Commands:**
  - `aws opensearch describe-domain-config`: Retrieves current configuration details of the domain.
  - `aws es update-elasticsearch-domain-config`: Updates the instance type for scaling.

- **Example Usage:**
  ```bash
  ./os-scaling.sh
  ```

### `describe-domain-fetch-indices.py`

This script connects to an OpenSearch domain and retrieves domain configuration information. It also lists the indices available in the domain using the `opensearch-py` library.

- **Key Functions:**
  - Describes the OpenSearch domain using `opensearch.describe_domain()`.
  - Fetches and lists the indices present in the OpenSearch domain.

### `manage-indices.py`

This script helps manage indices in OpenSearch, allowing for operations like deleting or closing old indices. It uses the `opensearch-py` library to interact with the cluster.

- **Usage:**
  - Automate the management of indices in OpenSearch for tasks like optimizing storage or managing log retention.
  
- **Key Functionality:**
  - Fetches all indices.
  - Allows filtering and deleting indices based on criteria such as index age.

### `Opensearch Clusters Deletion.dockerfile`

This Dockerfile is used to create a container environment for managing and deleting OpenSearch clusters. It sets up a Docker environment with the necessary dependencies for interacting with OpenSearch and AWS.

- **Key Instructions:**
  - Installs necessary packages such as Python and AWS CLI.
  - Configures the environment for working with OpenSearch clusters.

### `create-domain.sh`

This Bash script automates the creation of an OpenSearch domain in AWS using the AWS CLI. It takes input from configuration files (`es1.json` and `es2.json`) to set up the domain’s instance type and EBS storage configuration.

- **Key Commands:**
  - `aws es create-elasticsearch-domain`: Creates an OpenSearch domain with the specified configuration.
  
- **Dependencies:**
  - **es1.json:** Contains the configuration for instance type and count.
  - **es2.json:** Contains the EBS configuration.

- **Example Usage:**
  ```bash
  ./create-domain.sh
  ```

### `es1.json`

This JSON file contains the configuration for the OpenSearch cluster’s instance type, instance count, and other related settings.

- **Fields:**
  - `InstanceType`: `r6g.large.elasticsearch`
  - `InstanceCount`: 1
  - `DedicatedMasterEnabled`: false
  - `ZoneAwarenessEnabled`: false

### `es2.json`

This JSON file specifies the Elastic Block Store (EBS) options for the OpenSearch cluster.

- **Fields:**
  - `EBSEnabled`: true
  - `VolumeType`: `gp2`
  - `VolumeSize`: 10 GB

### `instance_type_check.sh`

This script checks the current instance type of a specified OpenSearch domain using the AWS CLI.

- **Key Command:**
  ```bash
  aws es describe-elasticsearch-domain-config --domain-name ansaf-testing-domain --profile product --region us-east-1 --no-verify-ssl --query 'DomainConfig.ElasticsearchClusterConfig.Options.InstanceType'
  ```

- **Usage:**
  - Run the script to verify the instance type of an OpenSearch domain.

---

### Notes:
- Ensure that you have the necessary AWS credentials configured (`~/.aws/credentials`) for running these scripts.
- Install the required libraries (`opensearch-py`, `boto3`) and tools (`AWS CLI`) before using the scripts.

--- 

This `README.md` should serve as a guide for setting up, scaling, and managing your OpenSearch clusters with the provided scripts and configuration files.
