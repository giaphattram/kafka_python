FROM quay.io/debezium/kafka:1.9

USER root

WORKDIR /kafka

COPY ./bashscripts/create_topic_and_push_data.sh /kafka/bashscripts/create_topic_and_push_data.sh
COPY ./bashscripts/data.json /kafka/bashscripts/data.json

RUN chmod +x /kafka/bashscripts/create_topic_and_push_data.sh