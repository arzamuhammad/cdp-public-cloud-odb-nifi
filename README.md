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
 
NiFi data flow template, l, was provided in xml-and-json directory ( Transaction_to_Hbase.xml ). Follow these easy  steps to upload.

1. Click on ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/icon-nifi-template-upload.webp)  to upload collect-dataflow-template.xml template
2. Click and drag ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/icon-nifi-template.webp)  into the canvas and select collect-dataflow-template

Or we can just 

1. click and drag process group
   ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/process_group.png)
3. upload the json file ( Transaction_to_Hbase.json ) into process group 
   ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/add_process_group.png)
   
# Modify Variables used in Data Flow
 
Right-click  on the Transaction to Hbase Group, choose Variable

Click on value column to modify the variable:

Name: username, Value: <use your CDP workload username>
Name: file_location, Value: <environment’s storage.location.base attribute>
Name: kafkabrokers, Value: <list of all Kafka broker addresses, separated by commas>
Kafka broker addresses are found in Streams Messaging Data Hub.

streams-messaging > Streams Messaging Manager
 
![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/stream_messaging.png)
 
Select Brokers

The broker address is located underneath its name. 
 
![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/kafka_broker.png)
 
The variables defined should look something like:
 
![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/nifi_variables.png)
 
# Configure Controller Services
 
Right-click on processor group Push to Kafka
Select Configure
Enable CSVReader, CSVRecordSetWriter, JsonRecordSetWriter, JsonTreeReader by clicking on enable icon 
Note1: You should see two (2) services named Default NiFi SSL Context Service. Delete the one marked with .

Right-click on processor group Kafka Ingest
Select Configure
Enable CSVReader, CSVRecordSetWriter, JsonRecordSetWriter, JsonTreeReader by clicking on enable icon 

![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/controller_services.png)
 
 There are three steps in enabling Phoenix Client controller:
 
 1. fill the Database Connection Url by the information that you get from operational database 
  
 ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/phoenix_thin.png)
 ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/phoenix_client_controller.png)
 
 dont forget to change the password value by your workload user password\
 
 2. set Database Driver Class name value : org.apache.phoenix.queryserver.client.Driver
 3. set Database Driver Location(s) : /opt/cloudera/parcels/CDH/lib/phoenix_queryserver/phoenix-queryserver-client-6.0.0.7.2.12.2-5.jar
 

# Configure Processors
 
Several processors, in each group, require passwords. We will update them using your CDP workload password.

 

 
Push to Kafka processor group
 
Expand processor group and update properties for the following processors:

Pull-From-S3: update Kerberos Password
Transaction 1 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
Transaction 2 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
Transaction 3 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
Transaction 4 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
Transaction 5 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
 

Kafka Ingest processor group
 
Expand processor group and update properties for the following processors:

Transaction 1 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
Transaction 2 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
Transaction 3 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
Transaction 4 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
Transaction 5 Kafka Stream: update Password and SSL Context Service with Default NiFi SSL Context Service
 
![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/kafka_stream_processor.png) 
 
 
 # Run Data Flow
 
Let's run the data flow you have just created. You have the option to run all processor groups, a processor group at a time or single processor at a time. For general debugging and diagnostics, it is recommended to run one processor at a time. This will allow you to validate data in the list queues.

We will run one processor group at a time.

### Expand processor group Push to Kafka and run all processors at once by clicking play in the Operate menu.

After a few seconds, you will see the data flow through all the processors. Click on  from the Operate menu to stop all processors at once.

 
### Expand processor group Kafka Ingest and  run all processors at once by clicking play in the Operate menu.

After a few seconds, you will see the data flow through all the processors. Click on  from the Operate menu to stop all processors at once.
 
 
# View HBase Data
 
 Open hue
 
 Run this below Query
 
 ### Select * from Transaction
 ### Select count(*) from Transaction
 

 #  Upload NiFi Template - Part 2
 
NiFi data flow template, l, was provided in xml-and-json directory ( Reference_CDPODB.xml ). Follow these easy  steps to upload.

1. Click on ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/icon-nifi-template-upload.webp)  to upload collect-dataflow-template.xml template
2. Click and drag ![alt text](https://github.com/arzamuhammad/cdp-public-cloud-odb-nifi/blob/main/images/icon-nifi-template.webp)  into the canvas and select collect-dataflow-template

Or we can just 

1. click and drag process group
2. upload the json file into process group ( Reference.json )
 
# Modify Variables used in Data Flow - Part 2
 
Right-click  on the Reference Group, choose Variable

Click on value column to modify the variable:

Name: username, Value: <use your CDP workload username>
Name: file_location, Value: <environment’s storage.location.base attribute>
 
 
  # Run Data Flow
 
Let's run the data flow you have just created. You have the option to run all processor groups, a processor group at a time or single processor at a time. For general debugging and diagnostics, it is recommended to run one processor at a time. This will allow you to validate data in the list queues.

We will run one processor group at a time.

### Expand processor group Customer  and run all processors at once by clicking play in the Operate menu.
 
### Expand processor group Product_Ref  and run all processors at once by clicking play in the Operate menu.'
 
### Expand processor group Store  and run all processors at once by clicking play in the Operate menu.
 
 
 # Create Index on Phoenix Hbase
 
 
