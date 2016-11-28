{%- from "grafana/map.jinja" import server with context %}
{%- if server.get('enabled', False) %}

grafana_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

/etc/grafana/grafana.ini:
  file.managed:
  - source: salt://grafana/files/grafana.ini
  - template: jinja
  - user: grafana
  - group: grafana
  - require:
    - pkg: grafana_packages

{%- if server.dashboards.enabled %}
grafana_copy_default_dashboards:
  file.recurse:
  - name: {{ server.dashboards.path }}
  - source: salt://grafana/files/dashboards
  - user: grafana
  - group: grafana
  - require:
    - pkg: grafana_packages
{%- endif %}

grafana_service:
  service.running:
  - name: {{ server.service }}
  - enable: true
  - watch:
    - file: /etc/grafana/grafana.ini
{%- if server.dashboards.enabled %}
  - require:
    - file: grafana_copy_default_dashboards
{%- endif %}

{%- endif %}
