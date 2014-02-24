
include:
{% if pillar.grafana.server is defined %}
- grafana.server
{% endif %}
