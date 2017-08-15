{% from "kafka/settings.sls" import kafka with context -%}

kafka_dist_repo_installed:
  pkgrepo.managed:
    - name: Confluent.dist
    - humanname: Confluent repository (dist)
    - baseurl: http://packages.confluent.io/rpm/{{ kafka.version }}/{{ grains.osmajorrelease }}
    - key_url: http://packages.confluent.io/rpm/{{ kafka.version }}/archive.key

kafka_repo_installed:
  pkgrepo.managed:
    - name: Confluent
    - humanname: Confluent repository
    - baseurl: http://packages.confluent.io/rpm/{{ kafka.version }}
    - key_url: http://packages.confluent.io/rpm/{{ kafka.version }}/archive.key
