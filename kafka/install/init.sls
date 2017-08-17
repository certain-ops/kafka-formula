{% from "kafka/settings.sls" import kafka with context -%}

include:
  - .{{ kafka.source }}

/var/log/kafka:
  file.directory:
    - user: kafka
    - group: kafka
