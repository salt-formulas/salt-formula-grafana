{%- from "grafana/map.jinja" import collector with context %}
{%- if collector.get('enabled', False) %}

# This state is only used to map grains.collector pillar. Grains are now
# managed from salt.minion.grains so we will just include it in case it's
# executed explicitly

include:
  - salt.minion.grains

{%- endif %}
