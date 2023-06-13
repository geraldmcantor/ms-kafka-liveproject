#!/bin/sh
KAFKA_HOME=${KAFKA_HOME:=/opt/kafka}
KAFKA_BIN="$KAFKA_HOME/bin"
KAFKA_CONFIG="$KAFKA_HOME/config"

# Utility function that verifies the existence of a Kafka install directory
check_kafka_dir()
{
    KAFKA_DIR=$1
    ERROR_MSG=$2
    shift; shift;

    if [ ! -d $KAFKA_DIR ] ; then
        echo $ERROR_MSG 
        exit 1;
    fi
}

# Utility function that creates a Kafka topic based on the supplied topic name
create_topic()
{
    TOPIC_NAME=$1
    shift;

    $KAFKA_BIN/kafka-topics.sh --create --bootstrap-server localhost:9092 --create --topic $TOPIC_NAME
    if [ $? -ne 0 ] ; then
        echo "Warning: Failed to create topic $TOPIC_NAME"
    fi
}

# Utility function that modifies a supplied topic's retention time 
mod_topic_retention()
{
    TOPIC_NAME=$1
    RETENTION_TIME=$2
    shift; shift;

    $KAFKA_BIN/kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name $TOPIC_NAME --alter --add-config retention.ms=$RETENTION_TIME
    if [ $? -ne 0 ] ; then
        echo "Warning: Failed to update topic $TOPIC_NAME retention time"
    fi
}

# Verify that KAFKA_HOME dir exists
check_kafka_dir $KAFKA_HOME "Kafka installation not found at $KAFKA_HOME"

# Verify that the KAFKA_BIN dir exists
check_kafka_dir $KAFKA_BIN "Kafka bin commands not found at $KAFKA_BIN"

# Verify that the KAFKA_CONFIG exists
check_kafka_dir $KAFKA_CONFIG "Kafka configs not found at $KAFKA_CONFIG"

# Create the following topics
# order-received-events
# order-confirmed-events
# order-pp-events
# notification-events
# error-events 
TOPICS="order-received-events order-confirmed-events order-pp-events notification-events error-events"
for TOPIC in $TOPICS
do
    create_topic $TOPIC 
done

# Modify the previously created topics to have a 3 day retention policy
# 3 * 24 * 60 * 60 * 1000 = 259200000
RETENTION_MILLIS=259200000
echo "Modifying topics to adjust retention time to $RETENTION_MILLIS" 
for TOPIC in $TOPICS
do
    mod_topic_retention $TOPIC $RETENTION_MILLIS
done
