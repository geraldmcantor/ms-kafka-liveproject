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

# Verify that KAFKA_HOME dir exists
check_kafka_dir $KAFKA_HOME "Kafka installation not found at $KAFKA_HOME"

# Verify that the KAFKA_BIN dir exists
check_kafka_dir $KAFKA_BIN "Kafka bin commands not found at $KAFKA_BIN"

# Verify that the KAFKA_CONFIG exists
check_kafka_dir $KAFKA_CONFIG "Kafka configs not found at $KAFKA_CONFIG"

# Fire up Kafka
$KAFKA_BIN/kafka-server-start.sh $KAFKA_CONFIG/server.properties
