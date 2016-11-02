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
  grafana3_datasource.present:
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

{%- set raw_dict = {} %}
{%- set final_dict = {} %}

{%- if client.remote_data.engine == 'salt_mine' %}
{%- for node_name, node_grains in salt['mine.get']('*', 'grains.items').iteritems() %}
{%- if node_grains.grafana is defined %}
{%- set raw_dict = salt['grains.filter_by']({'default': raw_dict}, merge=node_grains.grafana.get('dashboard', {})) %}
{%- endif %}
{%- endfor %}
{%- endif %}

{%- if client.dashboard is defined %}
{%- set raw_dict = salt['grains.filter_by']({'default': raw_dict}, merge=client.dashboard) %}
{%- endif %}

{%- for dashboard_name, dashboard in raw_dict.iteritems() %}
{%- set rows = [] %}
{%- for row_name, row in dashboard.get('row', {}).iteritems() %}
{%- set panels = [] %}
{%- for panel_name, panel in row.get('panel', {}).iteritems() %}
{%- set targets = [] %}
{%- for target_name, target in panel.get('target', {}).iteritems() %}
{%- do targets.extend([target]) %}
{%- endfor %}
{%- do panel.update({'targets': targets}) %}
{%- do panels.extend([panel]) %}
{%- endfor %}
{%- do row.update({'panels': panels}) %}
{%- do rows.extend([row]) %}
{%- endfor %}
{%- do dashboard.update({'rows': rows}) %}
{%- do final_dict.update({dashboard_name: dashboard}) %}
{%- endfor %}

{%- for dashboard_name, dashboard in final_dict.iteritems() %}

{%- if dashboard.get('enabled', True) %}

grafana_client_dashboard_{{ dashboard_name }}:
  grafana3_dashboard.present:
  - name: {{ dashboard_name }}
  - dashboard: {{ dashboard }}

{%- else %}

grafana_client_dashboard_{{ dashboard_name }}:
  grafana3_dashboard.absent:
  - name: {{ dashboard_name }}

{%- endif %}

{%- endfor %}

{%- endif %}
