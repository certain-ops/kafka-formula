{% from "kafka/settings.sls" import kafka with context -%}

{#- Salt doesn't recognize the MD5 format supplied by apache, so we do some 
    formatting here
#}
{%- set source_hash = salt['cmd.run']("curl -s https://dist.apache.org/repos/dist/release/kafka/{kv}/kafka_{sv}-{kv}.tgz.md5 | cut -d ' ' -f 2- | tr -d ' ' | tr '[:upper:]' '[:lower:]'".format(kv=kafka.version, sv=kafka.scala_version)) -%}

kafka-pkg-setup:
  user.present:
    - name: kafka
    - shell: /bin/false
    - gid_from_name: True
    - createhome: False
    - system: True
  archive.extracted:
    - name: {{ kafka.prefix }}
    - source: 
{%- for source in kafka.apache_sources %}
      - {{ source }}/{{ kafka.version }}/kafka_{{ kafka.scala_version }}-{{ kafka.version }}.tgz
{%- endfor %}
    - source_hash: {{ source_hash }}
    - user: kafka
    - group: kafka
    - skip_verify: True
  file.symlink:
    - name: {{ kafka.prefix }}/kafka
    - target: {{ kafka.prefix }}/kafka_{{ kafka.scala_version }}-{{ kafka.version }}
