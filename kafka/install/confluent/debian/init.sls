{% from "kafka/settings.sls" import kafka with context -%}

kafka_repo:
  pkgrepo.managed:
    - name: deb [arch={{ grains.osarch }}] http://packages.confluent.io/deb/{{ kafka.version }} stable main
    - file: /etc/apt/sources.list.d/kafka.list
    - key_url: http://packages.confluent.io/deb/{{ kafka.version }}/archive.key
