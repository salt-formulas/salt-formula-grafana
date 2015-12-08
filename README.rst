
=======
Grafana
=======

A beautiful, easy to use and feature rich Graphite dashboard replacement and graph editor.

Sample pillar
=============

Sample pillar with source from system package

    grafana:
      server:
        enabled: true
        source:
          type: 'pkg'
          version: 2.5.0
        database:
          engine: postgresql
          host: localhost
          port: 5432
        data_source:
          metrics1:
            engine: graphite
            host: metrics1.domain.com
            ssl: true
            port: 443
            user: test

Read more
=========

* http://grafana.org/
* https://github.com/torkelo/grafana/wiki
