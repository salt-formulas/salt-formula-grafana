{%- from "grafana/map.jinja" import client with context %}

grafana_admin_user_{{ client.server.user }}_present:
  grafana4_user.present:
    - name: {{ client.server.user }}
    - password: {{ client.server.password }}
    - email: "{{ client.server.user }}@localhost"
    - fullname: {{ client.server.user }}
    - is_admin: true

grafana_admin_user_{{ client.server.user }}_update_password:
  module.run:
  - name: grafana4.update_user_password
  - userid: {{ client.server.user_id }}
  - kwargs:
      password: {{ client.server.password }}
  - require:
    - grafana4_user: grafana_admin_user_{{ client.server.user }}_present
