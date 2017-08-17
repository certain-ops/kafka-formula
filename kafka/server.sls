{%- from 'zookeeper/settings.sls' import zk with context %}
{%- from 'kafka/settings.sls' import kafka with context %}

include:
  - kafka

kafka-systemd-unit:
  file.managed:
    - name: /lib/systemd/system/kafka.service
    - source: salt://kafka/files/kafka.service.systemd
    - template: jinja

kafka-config:
  file.managed:
    - name: /etc/kafka/server.properties
    - source: salt://kafka/files/server.properties
    - template: jinja
    - context:
      zookeepers: {{ zk.connection_string }}
    - makedirs: True
    - require:
      - sls: kafka.install

kafka-environment:
  file.managed:
    - name: /etc/default/kafka
    - source: salt://kafka/files/kafka.default
    - template: jinja

kafka-service:
  service.running:
    - name: kafka
    - enable: True
    - require:
      - sls: kafka.install
      - file: kafka-environment
      - file: kafka-systemd-unit
    {%- if kafka.restart_on_config_change == True %}
    - watch:
      - file: kafka-config
    {%- endif %}
