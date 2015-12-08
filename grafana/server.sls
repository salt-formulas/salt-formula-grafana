{%- from "grafana/map.jinja" import server with context %}
{%- if server.enabled %}

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

grafana_service:
  service.running:
  - name: {{ server.service }}
  - enable: true
  - reload: true
  - watch:
    - file: /etc/grafana/grafana.ini

{%- endif %}