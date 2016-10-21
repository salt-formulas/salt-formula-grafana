{%- from "grafana/map.jinja" import client with context %}
{%- if client.enabled %}

/etc/salt/minion.d/_grafana.conf:
  file.managed:
  - source: salt://grafana/files/_grafana.conf
  - template: jinja
  - user: root
  - group: root

{%- for datasource_name, datasource in client.datasource.iteritems() %}

grafana_client_datasource_{{ datasource_name }}:
  grafana_datasource.present:
  - name: {{ datasource_name }}
  - type: {{ datasource.type }}
  - url: http://{{ datasource.host }}:{{ datasource.get('port', 80) }}
  {%- if datasource.access is defined %}
  - access: proxy
  {%- endif %}
  {%- if datasource.user is defined %}
  - basic_auth: true
  - basic_auth_user: {{ datasource.user }}
  - basic_auth_password: {{ datasource.password }}
  {%- endif %}

{%- endfor %}

{%- for dashboard_name, dashboard in client.dashboard.iteritems() %}

grafana_client_dashboard_{{ dashboard_name }}:
  grafana_dashboard.present:
  - name: {{ dashboard_name }}
  - dashboard: {{ dashboard }}

{%- endfor %}

{%- endif %}
