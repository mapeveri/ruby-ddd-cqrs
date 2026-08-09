FROM confluentinc/cp-kafka-connect:7.7.1

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.4

RUN cd /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/lib \
    && curl -sL -o postgresql-42.7.3.jar https://jdbc.postgresql.org/download/postgresql-42.7.3.jar
