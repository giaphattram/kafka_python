# Create topic input_topic
/kafka/bin/kafka-topics.sh --bootstrap-server kafka:9092 --create --topic input_topic --replication-factor 1

# Create topic output_topic
/kafka/bin/kafka-topics.sh --bootstrap-server kafka:9092 --create --topic output_topic --replication-factor 1

# Push data in data.json into input_topic
echo '{"myKey": 1, "myTimestamp": "2022-03-01T09:11:04+01:00"}' | /kafka/bin/kafka-console-producer.sh --bootstrap-server kafka:9092 --topic input_topic $1
echo 'Record successfully added to input_topic: {"myKey": 1, "myTimestamp": "2022-03-01T09:11:04+01:00"}'
echo '{"myKey": 2, "myTimestamp": "2022-03-01T09:12:08+01:00"}' | /kafka/bin/kafka-console-producer.sh --bootstrap-server kafka:9092 --topic input_topic $1
echo 'Record successfully added to input_topic: {"myKey": 2, "myTimestamp": "2022-03-01T09:12:08+01:00"}'
echo '{"myKey": 3, "myTimestamp": "2022-03-01T09:13:12+01:00"}' | /kafka/bin/kafka-console-producer.sh --bootstrap-server kafka:9092 --topic input_topic $1
echo 'Record successfully added to input_topic: {"myKey": 3, "myTimestamp": "2022-03-01T09:13:12+01:00"}'
echo '{"myKey": 4, "myTimestamp": ""}' | /kafka/bin/kafka-console-producer.sh --bootstrap-server kafka:9092 --topic input_topic $1
echo 'Record successfully added to input_topic: {"myKey": 4, "myTimestamp": ""}'
echo '{"myKey": 5, "myTimestamp": "2022-03-01T09:14:05+01:00"}' | /kafka/bin/kafka-console-producer.sh --bootstrap-server kafka:9092 --topic input_topic $1
echo 'Record successfully added to input_topic: {"myKey": 5, "myTimestamp": "2022-03-01T09:14:05+01:00"}'


# Note: The code below reads from file, but this approach has unstable performance, so I use echo like above for simplicity.
# input='/kafka/bashscripts/data.json'
# while read -r line
# do 
#   echo $line | /kafka/bin/kafka-console-producer.sh --bootstrap-server kafka:9092 --topic input_topic $1
#   echo "Record successfully added to input_topic: $line"
# done < "$input"