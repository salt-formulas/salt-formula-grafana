{%- from "grafana/map.jinja" import server with context %}
{%- if server.enabled %}

grafana_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

/etc/grafana/grafana.ini:
  file.managed:
  - source: salt://grafana/files/grafana.ini
  - template: jinja
  - user: root
  - group: root
  - require:
    - pkg: grafana_packages

{%- endif %}