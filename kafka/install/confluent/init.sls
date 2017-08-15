{% from "kafka/settings.sls" import kafka with context -%}

include:
  - .{{ grains['os_family'] | lower }}

kafka-pkg-setup:
  pkg.installed:
    - name: confluent-kafka-2.11
    - refresh: True
  user.present:
    - name: kafka
    - shell: /bin/false
    - gid_from_name: True
    - createhome: False
    - system: True
