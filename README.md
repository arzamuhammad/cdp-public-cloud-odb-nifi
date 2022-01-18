# cdp-public-cloud-odb-nifi

## Introduction
 
Data Lifecycle - collecting data. This workshop will show you how to use Apache NiFi to pull data from a cloud storage solution, format it to send it into a messaging queue (Kafka), and finally consume from that queue to ingest it into an operational database (HBase).

## Prerequisites
 
Have access to Cloudera Data Platform (CDP) Public Cloud
Have created a CDP workload User
Basic AWS CLI skills
 
## Assets

Clone our GitHub repository --> https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi.git or git@github.com:arzamuhammad/cdp-public-cloud-odb-nifi.git
It provides assets used in this and other tutorials


Using AWS CLI, copy file transaction.txt, customer.txt, product_ref.txt, store.txt to S3 bucket, defined by your environment’s storage.location.base attribute.

Note: You may need to ask your environment's administrator to get property value for storage.location.base.

 
For example, property storage.location.base has value s3://mardiyan-aws-2201-bucket/data/; therefore copy the files using the command:

#### aws s3 cp transaction.txt s3://mardiyan-aws-2201-bucket/data/tmp/
#### aws s3 cp customer.txt s3://mardiyan-aws-2201-bucket/data/tmp/
#### aws s3 cp product_ref.txt s3://mardiyan-aws-2201-bucket/data/tmp/
#### aws s3 cp store.txt s3://mardiyan-aws-2201-bucket/data/tmp/

## Provision Data Hub Clusters
 
This tutorial requires that we provision 2 data hub clusters named:

flow-management, using cluster definition 7.x - Flow Management Light Duty for AWS
 

provision-flow-management
 

streams-messaging, using cluster definition 7.x - Streams Messaging Light Duty for AWS
 

provision-streams-messaging
