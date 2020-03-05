{%- from "grafana/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

{%- set datasources = [] %}
{%- for datasource_name, datasource in client.datasource.items() %}

{%- do datasources.append(datasource.type) %}
grafana_client_datasource_{{ datasource_name }}:
  grafana3_datasource.present:
  - name: {{ datasource.name|default(datasource_name) }}
  - type: {{ datasource.type }}
  - url: http://{{ datasource.host }}:{{ datasource.get('port', 80) }}
  {%- if datasource.access is defined %}
  - access: proxy
  {%- endif %}
  {%- if datasource.user is defined %}
  - user: {{ datasource.user }}
  - password: {{ datasource.password }}
  {%- endif %}
  {%- if datasource.get('is_default', False) %}
  - is_default: {{ datasource.is_default|lower }}
  {%- endif %}
  {%- if datasource.database is defined %}
  - database: {{ datasource.database }}
  {%- endif %}

{%- endfor %}

{%- set raw_dict = {} %}
{%- set final_dict = {} %}

{%- if client.remote_data.engine == 'salt_mine' %}
{%- for node_name, node_grains in salt['mine.get']('*', 'grains.items').items() %}
  {%- if node_grains.grafana is defined %}
  {%- set raw_dict = salt['grains.filter_by']({'default': raw_dict}, merge=node_grains.grafana.get('dashboard', {})) %}
  {%- endif %}
{%- endfor %}
{%- endif %}

{%- if client.dashboard is defined %}
  {%- set raw_dict = salt['grains.filter_by']({'default': raw_dict}, merge=client.dashboard) %}
{%- endif %}

{%- for dashboard_name, dashboard in raw_dict.items() %}
  {%- if dashboard.get('format', 'yaml')|lower == 'yaml' %}
  # Dashboards in JSON format are considered as blob
  {%- set rows = [] %}
  {%- for row_name, row in dashboard.get('row', {}).items() %}
    {%- set panels = [] %}
    {%- for panel_name, panel in row.get('panel', {}).items() %}
      {%- set targets = [] %}
      {%- for target_name, target in panel.get('target', {}).items() %}
        {%- do targets.extend([target]) %}
      {%- endfor %}
      {%- do panel.update({'targets': targets}) %}
      {%- do panels.extend([panel]) %}
    {%- endfor %}
    {%- do row.update({'panels': panels}) %}
    {%- do rows.extend([row]) %}
  {%- endfor %}
  {%- do dashboard.update({'rows': rows}) %}
  {%- endif %}

  {%- do final_dict.update({dashboard_name: dashboard}) %}
{%- endfor %}

{%- for dashboard_name, dashboard in final_dict.items() %}
{%- if dashboard.datasource is not defined or dashboard.datasource in datasources %}
  {%- if dashboard.get('enabled', True) %}
grafana_client_dashboard_{{ dashboard_name }}:
  grafana3_dashboard.present:
  - name: {{ dashboard_name }}
    {%- if dashboard.get('format', 'yaml')|lower == 'json' %}
    {%- import_json dashboard.template as dash %}
  - dashboard: {{ dash|json }}
  - dashboard_format: json
    {%- else %}
  - dashboard: {{ dashboard }}
      {%- if dashboard.base_dashboards is defined %}
  - base_dashboards_from_pillar: {{ dashboard.base_dashboards|yaml }}
      {%- endif %}
      {%- if dashboard.base_rows is defined %}
  - base_rows_from_pillar: {{ dashboard.base_rows|yaml }}
      {%- endif %}
      {%- if dashboard.base_panels is defined %}
  - base_panels_from_pillar: {{ dashboard.base_panels|yaml }}
      {%- endif %}
    {%- endif %}
  {%- else %}
grafana_client_dashboard_{{ dashboard_name }}:
  grafana3_dashboard.absent:
  - name: {{ dashboard_name }}
  {%- endif %}
{%- endif %}
{%- endfor %}

{%- endif %}
