{% set p = salt['pillar.get']('kafka', {}) %}
{% set pc = p.get('config', {}) %}
{% set g = salt['grains.get']('kafka', {}) %}
{% set gc = g.get('config', {}) %}

{%- set java_home = salt['grains.get']('java_home', salt['pillar.get']('java_home', g.get('java_home', p.get('java_home', '/usr/lib/java')))) %}

# Global config options - pillar only
{% set restart_on_config_change  = pc.get('restart_on_config_change', False) %}
{% set uid = p.get('uid', '') %}
{% set userhome = p.get('userhome', '/home/kafka') %}
{% set prefix = p.get('prefix', '/usr/lib') %}
{% set tmp_dir = p.get('tmp_dir', '/tmp') %}
{% set source = p.get('source', 'confluent') %}

# Options for Apache Kafka
{%- set default_apache_sources = [
  'http://download.nextag.com/apache/kafka',
  'http://apache.claz.org/kafka',
  'http://apache.cs.utah.edu/kafka',
  'http://apache.ip-guide.com/kafka', 
  'http://apache.mirrors.hoobly.com/kafka',
  'http://apache.mirrors.ionfish.org/kafka',
  'http://apache.mirrors.lucidnetworks.net/kafka',
  'http://apache.mirrors.pair.com/kafka',
  'http://apache.mirrors.tds.net/kafka',
  'http://apache.spinellicreations.com/kafka'
  ]
%}
{%- set apache_sources = p.get('apache_sources', default_apache_sources) %}

{%- set source_map = {
    'confluent': {
      'pwd': '', 
      'bin': '/usr/bin/kafka-server-start',
      'default_version': '3.3'
    },
    'apache': {
      'pwd': '{}/kafka'.format(prefix),
      'bin': '{}/kafka/bin/kafka-server-start.sh'.format(prefix),
      'default_version': '0.11.0.0'
    }
  }
%}

{%- set scala_version = p.get('scala_version', '2.11') %}
{%- set source_config = source_map.get(source) %}
{%- set version = p.get('version',  source_config.get('default_version')) %}
{%- set pwd     = p.get('pwd',      source_config.get('pwd')) %}
{%- set bin     = p.get('bin',      source_config.get('bin')) %}

# Instance config options
{%- set heap_initial_size = gc.get('heap_initial_size', pc.get('heap_initial_size', '1G')) %}
{%- set heap_max_size     = gc.get('heap_max_size', pc.get('heap_max_size',         '1G')) %}
{%- set chroot_path       = gc.get('chroot_path', pc.get('chroot_path',          'kafka')) %}
{%- set config_properties = gc.get('properties', pc.get('properties',                 {})) %}
{%- set jvm_opts          = gc.get('jvm_opts', pc.get('jvm_opts',                     {})) %}

{%- set hosts_function    = g.get('hosts_function', p.get('hosts_function', 'network.get_hostname')) %}
{%- set hosts_target      = g.get('hosts_target', p.get('hosts_target',          'roles:zookeeper')) %}
{%- set targeting_method  = g.get('targeting_method', p.get('targeting_method',            'grain')) %}

# Does this work? How can I do different clusters?
{%- set cluster_id = g.get('cluster_id', p.get('cluster_id', None)) %}

{%- set kafka = {} %}
{%- do kafka.update({
  'java_home'                : java_home,
  'heap_initial_size'        : heap_initial_size,
  'heap_max_size'            : heap_max_size,
  'chroot_path'              : chroot_path,
  'restart_on_config_change' : restart_on_config_change,
  'config_properties'        : config_properties,
  'prefix'                   : prefix,
  'pwd'                      : pwd,
  'bin'                      : bin,
  'tmp_dir'                  : tmp_dir,
  'source'                   : source,
  'apache_sources'           : apache_sources,
  'version'                  : version,
  'scala_version'            : scala_version
}) %}
