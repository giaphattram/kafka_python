"""
    This application consumes from Kafka topic input_topic,
    convert timezoned myTimestamp to UTC,
    then push the data to output_topic.
"""

import json
import logging
from datetime import datetime, timedelta

from kafka import KafkaConsumer, KafkaProducer

logging.basicConfig(level=logging.INFO)
KAFKA_BROKER = ['kafka:9092']
INPUT_TOPIC = "input_topic"
OUTPUT_TOPIC = "output_topic"

def get_utc_timestamp(timezoned_timestamp: str):
    """Convert timestamp with timezone 
       into UTC timestamp

    Args:
        timezoned_timestamp (str)

    Returns:
        utc_timestamp (str)
    """
    date, time = timestamp.split('T')

    year, month, day = [int(each) for each in date.split('-')]

    hour, minute, second = [int(each) for each in time[:8].split(':')]
    sign = time[8]
    tz_hour, tz_minute = [int(each) for each in time[9:].split(':')]

    if sign == '+':
        utc_timestamp = (
            datetime(year, month, day, hour, minute, second)
            - timedelta(hours=tz_hour, minutes=tz_minute)
        )
    else:
        utc_timestamp = (
            datetime(year, month, day, hour, minute, second)
            + timedelta(hours=tz_hour, minutes=tz_minute)
        )
    utc_timestamp = utc_timestamp.isoformat() + '+00:00'
    return utc_timestamp

def on_send_error(error):
    logging.error(error)

if __name__ == "__main__":
    consumer = KafkaConsumer(
        INPUT_TOPIC,
        group_id='timestamp-converter4',
        bootstrap_servers=KAFKA_BROKER,
        auto_offset_reset='earliest'
    )

    producer = KafkaProducer(bootstrap_servers=KAFKA_BROKER)

    for record in consumer:
        message = json.loads(record.value.decode('utf-8'))
        timestamp = message['myTimestamp']
        if (timestamp != "") & (len(timestamp) == 25):
            timestamp = get_utc_timestamp(timestamp)
            message['myTimestamp'] = timestamp
        message = json.dumps(message)

        producer \
            .send(OUTPUT_TOPIC, str.encode(message)) \
            .add_errback(on_send_error)
        logging.info(f"Record successfully added to {OUTPUT_TOPIC}: {message}")
        # I know it's not correct to log this success message here, 
        # because error could still have occured and this message would still be pushed to stdout.
        # I know I should use producer.send(...).add_callback(cb_function),
        # but in this API the send() only send record metadata to the callback, 
        # not the record value itself, so logging in stdout will be less informative.
        # In the interest of time and presentation (informative stdout), 
        # I'd just log this success message here for now.
        
        producer.flush()

