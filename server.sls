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

/srv/grafana/site/src/config.js:
  file:
  - managed
  - source: salt://grafana/conf/config.js
  - template: jinja
  - require:
    - git: grafana_repository

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
    - file: /srv/grafana/site/src/config.js

{% elif pillar.grafana.server.source.type == 'pkg' %}

{% set version = pillar.grafana.server.source.rev %}

/srv/grafana/site/dist:
  file:
  - directory
  - mode: 755
  - makedirs: true

/srv/grafana/site/dist/config.js:
  file:
  - managed
  - source: salt://grafana/conf/config.js
  - template: jinja
  - require:
    - file: /srv/grafana/site/dist

download_grafana:
  cmd.run:
    - names:
      - wget https://github.com/torkelo/grafana/releases/download/v{{ version }}/grafana-{{ version }}.tar.gz
    - user: root
    - cwd: /root
    - unless: test -e /root/grafana-{{ version }}.tar.gz

untar_grafana:
  cmd.run:
    - names: 
      - tar zxvf /root/grafana-{{ version }}.tar.gz -C /srv/grafana/site/dist
    - user: root
    - cwd: /root
    - unless: test -e /srv/grafana/dist/app
    - require:
      - file: /srv/grafana/site/dist/config.js
      - file: /srv/grafana/site/dist

{% endif %}

{%- endif %}
