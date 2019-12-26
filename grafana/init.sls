
{%- if pillar.grafana is defined %}
include:
{%- if pillar.grafana.server is defined %}
  {%- if pillar.grafana.server.manage_repo and grains['os_family'] == 'RedHat' %}
- grafana.repo.redhat
  {%- endif %}
- grafana.server
{%- endif %}
{%- if pillar.grafana.client is defined %}
- grafana.client
{%- endif %}
{%- if pillar.grafana.collector is defined %}
- grafana.collector
{%- endif %}
{%- endif %}
