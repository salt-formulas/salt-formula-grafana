{%- from "grafana/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

/etc/salt/minion.d/_grafana.conf:
  file.managed:
  - source: salt://grafana/files/_grafana.conf
  - template: jinja
  - user: root
  - group: root

{%- endif %}
