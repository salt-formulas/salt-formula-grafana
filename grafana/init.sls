
{%- if pillar.grafana is defined %}
include:
{%- if pillar.grafana.server is defined %}
- grafana.server
{%- endif %}
{%- endif %}
