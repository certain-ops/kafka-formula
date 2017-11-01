{%- import_yaml 'kafka/defaults.yaml' as kafka_defaults -%}
{%- set kafka_pillar = salt.pillar.get('kafka', {}) %}
{%- set kafka_grains = salt.grains.get('kafka', {}) %}

{%- set kafka = kafka_defaults.kafka %}
{%- do salt.slsutil.update(kafka, kafka_pillar) %}
{%- do salt.slsutil.update(kafka, kafka_grains) %}
