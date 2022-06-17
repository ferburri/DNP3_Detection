# Machine Learning Based Security Analysis of DNP3 

This repository contains the code about the creation of a Machine Learning model in order to detect the anomalies of the DNP3 protocol. In addition, it contains a Kibana visualisation dashboard that represent the statistics of the DNP3 dataset used.

<p align="center">
  <img src="https://user-images.githubusercontent.com/79408013/174275007-bcc31805-1a26-48e1-b496-da4d8205c302.png" width="1000" />
 </p>

## Table of Contents


## Abstract



## Requirements

To execute successfully the proposed system of this thesis, it is employed Ubuntu 20.04.4 LTS. You have to install the following requirements

### Python
  - Python v2.7: This version is necessary to run the program ```DNP3AttackCrafter.py ```
  - Python v3+: These versions are configured to run the rest of scripts.

### Zeek version 5.0.0

To install zeek on your virtual machine, you need to follow a serie of steps stated in these website:

[Zeek Installation][Zeek]

[Zeek]: https://kifarunix.com/install-zeek-on-ubuntu/

### Elasticsearch & Kibana v7.17+

To install the Elasticsearch and Kibana dependencies in your local machine, you have to follow the installation procedure from this website:

[Elasticsearch & Kibana Installation][es]

[es]: https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-ubuntu-20-04

### Jupyter Notebook

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

## Scripts

This section explains the scripts employed in this thesis. Each script has a role in the process of processing the data to Elasticsearch.


## Kibana Dashboard

