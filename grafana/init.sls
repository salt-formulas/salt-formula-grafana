
{%- if pillar.grafana is defined %}
include:
{%- if grains['os_family'] == 'RedHat' %}
- grafana.repo.redhat
{%- endif %}
{%- if pillar.grafana.server is defined %}
- grafana.server
{%- endif %}
{%- if pillar.grafana.client is defined %}
- grafana.client
{%- endif %}
{%- if pillar.grafana.collector is defined %}
- grafana.collector
{%- endif %}
{%- endif %}
