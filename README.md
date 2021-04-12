# Mongodb BI Connector

this docker image for mongodb-bi-connector.


## docker-compose example

```
version: "3"
services:
  mongodb:
    image: mongo:bionic
  
  mongodb-bi-connector:
    image: ryanhs/mongodb-bi-connector:latest
    environment:
      MONGO_URL: mongodb://mongodb:27017/?connect=direct
    
```
