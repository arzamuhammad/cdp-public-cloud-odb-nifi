# cdp-public-cloud-odb-nifi

# Introduction
 
Data Lifecycle - collecting data. This workshop will show you how to use Apache NiFi to pull data from a cloud storage solution, format it to send it into a messaging queue (Kafka), and finally consume from that queue to ingest it into an operational database (HBase).

# Prerequisites
 
Have access to Cloudera Data Platform (CDP) Public Cloud
Have created a CDP workload User
Basic AWS CLI skills
 
# Assets

Clone our GitHub repository --> https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi.git or git@github.com:arzamuhammad/cdp-public-cloud-odb-nifi.git
It provides assets used in this and other tutorials


Using AWS CLI, copy file transaction.txt, customer.txt, product_ref.txt, store.txt to S3 bucket, defined by your environment’s storage.location.base attribute.

Note: You may need to ask your environment's administrator to get property value for storage.location.base.

 
For example, property storage.location.base has value s3://mardiyan-aws-2201-bucket/data/; therefore copy the files using the command:

#### aws s3 cp transaction.txt s3://mardiyan-aws-2201-bucket/data/tmp/
#### aws s3 cp customer.txt s3://mardiyan-aws-2201-bucket/data/tmp/
#### aws s3 cp product_ref.txt s3://mardiyan-aws-2201-bucket/data/tmp/
#### aws s3 cp store.txt s3://mardiyan-aws-2201-bucket/data/tmp/


# Provision Data Hub Clusters
 
This workshop requires that we provision 2 data hub clusters named:

flow-management, using cluster definition 7.x - Flow Management Light Duty for AWS

provision-flow-management
 
 ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/datahub_cfm.png)

streams-messaging, using cluster definition 7.x - Streams Messaging Light Duty for AWS

provision-streams-messaging

![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/datahub_sm.png)

# Create Operational Database

This workshop requires that we provision operational database cluster

Operational Database --> Create Database

![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/create_odb.png)

# Operational Database
 
We need to create an HBase table using phoenix

Open Hue

operational-database > choose your database name > hue

![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/hue_operational_database.png)

#### run this below query

CREATE TABLE IF NOT EXISTS TRANSACTION
(
transaction_id integer PRIMARY key,
customer_id integer,
store_id integer,
product_id integer,
price integer,
total_trx integer,
total_amount bigint,
transaction_date date,
process_date timestamp
);

CREATE TABLE IF NOT EXISTS STORE
(
store_id integer PRIMARY key,
store_name varchar,
city varchar,
status varchar,
created_date date
);

CREATE TABLE IF NOT EXISTS CUSTOMER
(
customer_id integer primary key,
customer_firstname varchar,
customer_lastname varchar,
email varchar,
phonenumber bigint,
status varchar,
created_date date
);

CREATE TABLE IF NOT EXISTS PRODUCT_REF
(
product_id integer PRIMARY key,
product_name varchar,
product_category varchar,
normal_price integer,
create_date date
);


# Streams Messaging
 
Let's create five (5) new Topics:

Begin from Streams Messaging Data Hub:

streams-messaging > Streams Messaging Manager

![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/stream_messaging.png)

Select Topics
Select Add New
TOPIC NAME: Transaction-1
PARTITIONS: 5
Availability: Maximum
Cleanup Policy: delete
Save
Repeat the same steps to create the following named topics:

Transaction-2

Transaction-3

Transaction-4

Transaction-5

![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/create_topic.png)


# Build and Configure NiFi Data Flow
 
Instead of building the data flow from scratch, we will use the template provided in download assets.

You can see the templates on the xml-and-json directory


# Upload NiFi Template
 
NiFi data flow template, l, was provided in xml-and-json directory. Follow these easy  steps to upload.

1. Click on ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/icon-nifi-template-upload.webp)  to upload collect-dataflow-template.xml template
2. Click and drag ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/icon-nifi-template.webp)  into the canvas and select collect-dataflow-template

