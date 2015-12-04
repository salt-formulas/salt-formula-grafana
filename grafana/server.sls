{%- from "grafana/map.jinja" import server with context %}
{%- if server.enabled %}

grafana_packages:
  pkg.installed:
  - names:
    - python-memcache
    - python-psycopg2
    - python-imaging

/etc/grafana/local_settings.py:
  file.managed:
  - source: salt://grafana/files/local_settings.py
  - template: jinja
  - user: root
  - group: root
  - require:
    - pkg: grafana_packages

{%- endif %}