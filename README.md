# Machine Learning Based Security Analysis of DNP3 

This repository contains the code about the creation of a Machine Learning model in order to detect the anomalies of the DNP3 protocol. In addition, it contains a Kibana visualisation dashboard that represent the statistics of the DNP3 dataset used.

<p align="center">
  <img src="https://user-images.githubusercontent.com/79408013/174275007-bcc31805-1a26-48e1-b496-da4d8205c302.png" width="1000" />
 </p>

## Table of Contents

1. [Requirements](#Requirements)
  
      1.1. [Python](#Python)
  
      1.2. [Zeek](#Zeek)
  
      1.3. [Elasticsearch & Kibana](#es)
  
      1.4 [Jupyter Notebook](#colab)
  
2. [Data](#Data)
3. [Scripts](#Scripts)
4. [Kibana Dashboard](#KibanaDashboard)

## Requirements <a name="Requirements"></a>

To execute successfully the proposed system of this thesis, it is employed Ubuntu 20.04.4 LTS. You have to install the following requirements

### Python <a name="Python"></a>
  - Python v2.7: This version is necessary to run the program ```DNP3AttackCrafter.py ```
  - Python v3+: These versions are configured to run the rest of scripts.

### Zeek version 5.0.0 <a name="Zeek"></a>

To install zeek on your virtual machine, you need to follow a serie of steps stated in these website:

[Zeek Installation][Zeek]

[Zeek]: https://kifarunix.com/install-zeek-on-ubuntu/

### Elasticsearch & Kibana v7.17+ <a name="es"></a>

To install the Elasticsearch and Kibana dependencies in your local machine, you have to follow the installation procedure from this website:

[Elasticsearch & Kibana Installation][es]

[es]: https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-ubuntu-20-04

### Jupyter Notebook <a name="colab"></a>

In order to run the different Machine Learning algorithms, you should import different Python libraries:

```
pandas == 1.3.5       seaborn == 0.11.2        setuptools == 57.4.0         scikit-learn == 1.0.2
numpy == 1.21.6       sklearn-pandas == 1.8.0  matplotlib == 3.2.2          xgboost == 0.90
```
Finally, you need to install the Elasticsearch Python API to extract the documents of the stored index:

```bash
$ pip install elasticsearch7==7.17.3
```
Function to extract the documents from a given index:

```python
# Connect to my ElasticSearch Service
es = Elasticsearch("http://localhost:9200")
es.ping()

# Extract the documents that each index has to convert into a Dataframe
def get_data_from_elastic(index_name):

    # Scan function to get all the data. 
    rel = scan(client=es,                                     
               scroll='1m',
               index=index_name,
               raise_on_error=True,
               preserve_order=False,
               clear_scroll=True)

    # Keep response in a list.
    result = list(rel)

    temp = []

    # We need only '_source', which has all the fields required.
    # This elimantes the elasticsearch metdata like _id, _type, _index.
    for hit in result:
        temp.append(hit['_source'])

    # Create a dataframe.
    df = pd.DataFrame(temp)

    return df
 
# Example
conn_index = 'zeek_conn_2022-05-06'
```

## Data <a name="Data"></a>

This folder contains some PCAP examples that were used in the proposed system. The timestamps of the packets were changed by using a Python program ```changeTimestamps.py``` which modifies that field on each packet. 

The folder is structured in 3 folders: 

- **attacks_Data.zip**: this zip contains some attacks employed in this project with the zeek logs generated in the processing of data.
- **dataframes.zip**: it represents the dataframes employed in the implementation of the Machine Learning models.
- **test_Data.zip**: it includes PCAP files that simulates a normal traffic behaviour. Also, it contains the Zeek logs.

To unzip the content, there's a script named ```unzip.sh``` that will extract the content of the data folder. To execute this script:
```bash
$ ./unzip.sh
```

## Scripts <a name="Scripts"></a>

This section explains the scripts employed in this thesis. Each script has a role in the process of processing the data to Elasticsearch.

- **pcaptolog.sh**: this script extracts the information regarding the PCAP files and executes the Zeek tool to generate the logs. Finally the script ingests each log to the Elasticsearch engine in three different indeces.
- **dnp3_anomaly.zeek**: it is a script of Zeek that generates the field 'anomaly' to be used in the ML analysis. 
- **DNP3Crafter**: this folder contains three Python programs that are used to modify the timestamps of given PCAPs and a DNP3AttackCrafter to generate DNP3 attacks.
- **zeekes**: it contains a Python program used in pcpaptolog.sh in order to ingest the Zeek logs into Elasticsearch. 
- **unzip.sh**: script to extract the zips stored in data folder.
- **zip.sh**: script to compress the files from the data folder.
  
## Kibana Dashboard <a name="KibanaDashboard"></a>

The first approach of this model corresponds to the Kibana dashboard in order to visualise the behaviour of DNP3 within the communication channel. This dashboard represents different information regarding this protocol and the weird logs captured by Zeek. The dashboard is the following one.

<p align="center">
  <img width="442" alt="Dashboard_DNP3" src="https://user-images.githubusercontent.com/79408013/174283553-386d4fd7-1a9f-429d-b551-3825689f3af6.png">
</p>

