
# Grafana

A beautiful, easy to use and feature rich Graphite dashboard replacement and graph editor.

## Sample pillar

    grafana:
      server:
        enabled: true
        source:
          type: 'git'
          address: https://github.com/torkelo/grafana.git
          rev: master
        elasticsearch:
          host: localhost
          port: 9200
        data:
        - name: metrics1
          type: graphite
          host: metrics1.domain.com
          ssl: true
          port: 443
          user: test

## Sample pillar with source from stable package

    grafana:
      server:
        enabled: true
        source:
          type: 'pkg'
          rev: 1.4.0
        elasticsearch:
          host: localhost
          port: 9200
        data:
        - name: metrics1
          type: graphite
          host: metrics1.domain.com
          ssl: true
          port: 443
          user: test

## Read more

* http://grafana.org/
* https://github.com/torkelo/grafana/wiki