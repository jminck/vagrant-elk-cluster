# Requirements

Get a Twitter API key http://stackoverflow.com/questions/1808855/getting-new-twitter-api-consumer-and-secret-keys

### Logstash setup
Update logstash configuration in the logstash VM with the sample data in logstash.conf
```sh
    vagrant ssh logstash
    vi /vagrant/conf/logstash-vm251.conf
 ```
 - <copy sample data into .conf file>
 - exit ssh connection
 - restart logstash machine 
```sh
    vagrant reload logstash
```

### Kibana setup
 - Create a twitter-* index pattern in kibana
 - go to Settings -> Indices and create a pattern called twitter-*, then hit create
 - if this fails, there is an issue with your logstash configuration and data is not yet flowing intto twitter-* indexes

