# Start from fresh debian stretch & add some tools
# note: rsyslog & curl (openssl,etc) needed as dependencies too
FROM debian:stretch
RUN apt update
RUN apt install -y rsyslog nano curl openssl

# Download BI Connector to /mongosqld
WORKDIR /tmp
RUN curl https://info-mongodb-com.s3.amazonaws.com/mongodb-bi/v2/mongodb-bi-linux-x86_64-debian92-v2.12.0.tgz -o bi-connector.tgz && \
    tar -xvzf bi-connector.tgz && rm bi-connector.tgz && \
    mv /tmp/mongodb-bi-linux-x86_64-debian92-v2.12.0 /mongosqld
    
COPY mongo.pem /tmp/mongo.pem

# Setup default environment variables
ENV MONGO_URL mongodb://mongodb:27017/?connect=direct
ENV LISTEN_PORT 3307
ENV MONGO_USER admin
ENV MONGO_PASSWD secret
ENV MONGO_SCHEMA sampleDb
ENV MONGO_SCHEMAMODE auto

# Start Everything
# note: we need to use sh -c "command" to make rsyslog running as deamon too
RUN service rsyslog start

CMD sh -c "/mongosqld/bin/mongosqld --logPath /var/log/mongosqld.log --sslMode requireSSL --sslPEMKeyFile /tmp/mongo.pem --mongo-uri '$MONGO_URL' --auth -u $MONGO_USER -p $MONGO_PASSWD --schemaSource $MONGO_SCHEMA --schemaMode $MONGO_SCHEMAMODE --addr 0.0.0.0:$LISTEN_PORT"
