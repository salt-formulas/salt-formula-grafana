{%- from "grafana/map.jinja" import server with context %}
{%- if server.enabled %}

grafana package repository:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/grafana/stable/debian/ {{ grains["oscodename"] }} main
    - keyid: 418A7F2FB0E1E6E7EABF6FE8C2E73424D59097AB
    - keyserver: hkp://p80.pool.sks-keyservers.net:80
    - file: /etc/apt/sources.list.d/grafana.list
    - refresh_db: True

grafana_packages:
  pkg.installed:
  - names: {{ server.pkgs }}
  - pkgrepo: grafana package repository

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
