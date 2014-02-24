{%- if pillar.grafana.server.enabled %}

include:
  - git
  - nodejs

/srv/grafana:
  file:
  - directory
  - mode: 755
  - makedirs: true

grafana_repository:
  git.latest:
  - name: https://github.com/torkelo/grafana.git
  - rev: master
  - target: /srv/grafana/site
  - require:
    - file: /srv/grafana
    - pkg: git_packages

{#
/srv/grafana/sites/{{ app.name }}/config/configuration.yml:
  file:
  - managed
  - source: salt://grafana/conf/configuration.yml
  - template: jinja
  - defaults:
    app_name: "{{ app.name }}"
  - require:
    - hg: repo-{{ app.name }}
#}

{%- endif %}
