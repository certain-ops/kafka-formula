{% from "kafka/settings.sls" import kafka with context -%}

{% set version = kafka.get('version', kafka.apache.version) %}

{#- Salt doesn't recognize the MD5 format supplied by apache, so we do some 
    formatting here
#}
{%- set source_hash = salt['cmd.run']("curl -s https://archive.apache.org/dist/kafka/{kv}/kafka_{sv}-{kv}.tgz.md5 | cut -d ' ' -f 2- | tr -d ' ' | tr '[:upper:]' '[:lower:]'".format(kv=version, sv=kafka.scala_version)) -%}

kafka-pkg-setup:
  group.present:
    - name: kafka
  user.present:
    - name: kafka
    - shell: /bin/false
    - gid_from_name: True
    - createhome: False
    - system: True
  archive.extracted:
    - name: {{ kafka.apache.prefix }}
    - source: 
{%- for source in kafka.apache.sources %}
      - '{{ source }}/{{ version }}/kafka_{{ kafka.scala_version }}-{{ version }}.tgz'
{%- endfor %}
    - source_hash: {{ source_hash }}
    - user: kafka
    - group: kafka
    - skip_verify: True
  file.symlink:
    - name: {{ kafka.apache.prefix }}/kafka
    - target: {{ kafka.apache.prefix }}/kafka_{{ kafka.scala_version }}-{{ version }}
