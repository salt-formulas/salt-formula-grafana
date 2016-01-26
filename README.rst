
=======
Grafana
=======

A beautiful, easy to use and feature rich Graphite dashboard replacement and graph editor.

Sample pillars
==============

Sample pillar installed from system package

    grafana:
      server:
        enabled: true
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
          metrics2:
            engine: elasticsearch
            host: metrics2.domain.com
            port: 80
            user: test
            index: grafana-dash
Read more
=========

* http://grafana.org/
* http://docs.grafana.org/reference/export_import/
