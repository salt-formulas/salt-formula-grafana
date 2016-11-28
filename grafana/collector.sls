{%- from "grafana/map.jinja" import collector with context %}
{%- if collector.get('enabled', False) %}

grafana_grains_dir:
  file.directory:
  - name: /etc/salt/grains.d
  - mode: 700
  - makedirs: true
  - user: root

{%- set service_grains = {} %}

{# Loading the other service support metadata for localhost #}

{%- for service_name, service in pillar.iteritems() %}
{%- if service.get('_support', {}).get('grafana', {}).get('enabled', False) %}

{%- macro load_grains_file(grains_fragment_file) %}{% include grains_fragment_file ignore missing %}{% endmacro %}

{%- set grains_fragment_file = service_name+'/meta/grafana.yml' %}
{%- set grains_yaml = load_grains_file(grains_fragment_file)|load_yaml %}
{%- set service_grains = salt['grains.filter_by']({'default': service_grains}, merge=grains_yaml) %}

{%- endif %}
{%- endfor %}

grafana_grain:
  file.managed:
  - name: /etc/salt/grains.d/grafana
  - source: salt://grafana/files/grafana.grain
  - template: jinja
  - user: root
  - mode: 600
  - defaults:
    service_grains:
      grafana: {{ service_grains|yaml }}
  - require:
    - file: grafana_grains_dir

grafana_grains_file:
  cmd.wait:
  - name: cat /etc/salt/grains.d/* > /etc/salt/grains
  - watch:
    - file: grafana_grain

grafana_grains_publish:
  module.run:
  - name: mine.update
  - watch:
    - cmd: grafana_grains_file

{%- endif %}
