{%- if pillar.grafana.server.enabled %}

include:
  - git
  - nodejs

/srv/grafana:
  file:
  - directory
  - mode: 755
  - makedirs: true

{% if pillar.grafana.server.source.type == 'git' %}

grafana_repository:
  git.latest:
  - name: {{ pillar.grafana.server.source.address }}
  - rev: {{ pillar.grafana.server.source.rev }}
  - target: /srv/grafana/site
  - require:
    - file: /srv/grafana
    - pkg: git_packages

grafana_install:
  cmd.run:
  - names: 
    - npm install
    - npm install -g grunt-cli
  - cwd: /srv/grafana/site
  - unless: test -e /srv/grafana/site/node_modules
  - require:
    - git: grafana_repository


grafana_grun_build:
  cmd.run:
  - names: 
    - grunt build --force
  - cwd: /srv/grafana/site
  - unless: test -e /srv/grafana/site/dist
  - require:
    - git: grafana_repository


{% endif %}

/srv/grafana/site/src/config.js:
  file:
  - managed
  - source: salt://grafana/conf/config.js
  - template: jinja
  - require:
    - cmd: grafana_install

{%- endif %}
