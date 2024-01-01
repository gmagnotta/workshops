#!/bin/sh

podman volume create postgres
podman run -d --name postgresql_database -e POSTGRESQL_USER=user -e POSTGRESQL_PASSWORD=pass -e POSTGRESQL_DATABASE=db -p 5432:5432 -v postgres:/var/lib/pgsql/data rhel8/postgresql-10
podman exec -ti postgresql_database /bin/bash -c 'psql db -c "ALTER user \"user\" REPLICATION;"'
podman exec -ti postgresql_database /bin/bash -c 'psql db -c "CREATE PUBLICATION dbz_publication FOR ALL TABLES;"'
podman exec -ti postgresql_database /bin/bash -c "sed -i 's/\#wal_level \= replica/wal_level \= logical/g' /var/lib/pgsql/data/userdata/postgresql.conf"

podman pod create --name=dbz -p 9092:9092 -p 3306:3306 -p 8083:8083 #--publish "9092,3306,8083"
sudo podman run -d --rm --name zookeeper --pod dbz quay.io/debezium/zookeeper:1.9 && \
sudo podman run -d --rm --name kafka --pod dbz quay.io/debezium/kafka:1.9 && \
sudo podman run -d --rm --name connect --pod dbz -e GROUP_ID=1 -e CONFIG_STORAGE_TOPIC=my_connect_configs -e OFFSET_STORAGE_TOPIC=my_connect_offsets -e STATUS_STORAGE_TOPIC=my_connect_statuses quay.io/debezium/connect:1.9

# https://stackoverflow.com/questions/61061369/kafka-connect-bootstrap-broker-disconnected
podman run --rm --name connect \
 -e GROUP_ID=1 \
 -e BOOTSTRAP_SERVERS=peppe-ccpv-nvqh-qbgdv-hjvg.bf2.kafka.rhcloud.com:443 \
 -e CONNECT_SECURITY_PROTOCOL=SASL_SSL \
 -e CONNECT_SASL_JAAS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"08478f79-d42e-42dc-919e-899517b933d5\" password=\"yehd88pSmPd83tLuWwIvoMtNpXn9vYIE\";" \
 -e CONNECT_SASL_MECHANISM=PLAIN \
 -e CONFIG_STORAGE_TOPIC=my_connect_configs \
 -e OFFSET_STORAGE_TOPIC=my_connect_offsets \
 -e STATUS_STORAGE_TOPIC=my_connect_statuses \
 -e CONNECT_CONSUMER_SECURITY_PROTOCOL=SASL_SSL \
 -e CONNECT_CONSUMER_SASL_JAAS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"08478f79-d42e-42dc-919e-899517b933d5\" password=\"yehd88pSmPd83tLuWwIvoMtNpXn9vYIE\";" \
 -e CONNECT_CONSUMER_SASL_MECHANISM=PLAIN \
 -e CONNECT_PRODUCER_SECURITY_PROTOCOL=SASL_SSL \
 -e CONNECT_PRODUCER_SASL_JAAS_CONFIG="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"08478f79-d42e-42dc-919e-899517b933d5\" password=\"yehd88pSmPd83tLuWwIvoMtNpXn9vYIE\";" \
 -e CONNECT_PRODUCER_SASL_MECHANISM=PLAIN \
 -p 8083:8083 \
 quay.io/debezium/connect:1.9

curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{ "name": "outbox-connector", "config": { "connector.class" : "io.debezium.connector.postgresql.PostgresConnector", "tasks.max" : "1", "database.hostname" : "192.168.1.6", "database.port" : "5432", "database.user" : "user", "database.password" : "pass", "database.dbname" : "db", "database.server.name" : "dbserver1", "schema.whitelist" : "public", "table.whitelist" : "public.outboxevent", "tombstones.on.delete" : "false", "transforms" : "router", "transforms.router.type" : "io.debezium.transforms.outbox.EventRouter", "value.converter" : "io.debezium.converters.ByteBufferConverter", "transforms.router.table.fields.additional.placement":"type_value:header:type","plugin.name" : "pgoutput", "transforms.router.route.by.field":"type_value"} }'

# OCP
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{ "name": "outbox-connector", "config": { "connector.class" : "io.debezium.connector.postgresql.PostgresConnector", "tasks.max" : "1", "database.hostname" : "postgresql", "database.port" : "5432", "database.user" : "jboss", "database.password" : "jboss", "database.dbname" : "jboss", "database.server.name" : "dbserver1", "schema.whitelist" : "public", "table.whitelist" : "public.outboxevent", "tombstones.on.delete" : "false", "transforms" : "router", "transforms.router.type" : "io.debezium.transforms.outbox.EventRouter", "value.converter" : "io.debezium.converters.ByteBufferConverter", "transforms.router.table.fields.additional.placement":"type_value:header:type","plugin.name" : "pgoutput", "transforms.router.route.by.field":"type_value"} }'

# SMT
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{ "name": "cdc", "config": { "connector.class" : "io.debezium.connector.postgresql.PostgresConnector", "tasks.max" : "1", "database.hostname" : "192.168.1.6", "database.port" : "5432", "database.user" : "user", "database.password" : "pass", "database.dbname" : "db", "database.server.name" : "dbserver1", "schema.whitelist" : "public", "table.whitelist" : "public.orders, public.line_items, public.items", "tombstones.on.delete" : "false",  "plugin.name" : "pgoutput", "transforms":"unwrap", "transforms.unwrap.type":"io.debezium.transforms.ExtractNewRecordState", "transforms.unwrap.drop.tombstones":"false", "key.converter": "org.apache.kafka.connect.json.JsonConverter", "key.converter.schemas.enable": "false", "value.converter": "org.apache.kafka.connect.json.JsonConverter", "value.converter.schemas.enable": "false"} }'
