
=======
Grafana
=======

A beautiful, easy to use and feature rich Graphite dashboard replacement and graph editor.

Sample pillars
==============

Server deployments
------------------

Server installed from system package

.. code-block:: yaml

    grafana:
      server:
        enabled: true
        admin:
          user: admin
          password: passwd
        database:
          engine: sqlite

Server installed with PostgreSQL database

.. code-block:: yaml

    grafana:
      server:
        enabled: true
        admin:
          user: admin
          password: passwd
        database:
          engine: postgresql
          host: localhost
          port: 5432
          name: grafana
          user: grafana
          password: passwd

Client setups
-------------

Client enforced data sources

.. code-block:: yaml

    grafana:
      client:
        enabled: true
        server:
          protocol: https
          host: grafana.host
          port: 3000
          token: token
        datasource:
          graphite:
            type: graphite
            host: mtr01.domain.com
            protocol: https
            port: 443
          elasticsearch:
            type: elasticsearch
            host: log01.domain.com
            port: 80
            user: admin
            password: password
            index: grafana-dash

Client enforced dashboards

.. code-block:: yaml

    grafana:
      client:
        enabled: true
        server:
          host: grafana.host
          port: 3000
          token: token
        dashboard:
          system_metrics:
            title: "Generic system metrics"
            style: dark
            editable: false
            row:
              top:
                title: "First row"

Client enforced dashboards defined in salt-mine

.. code-block:: yaml

    grafana:
      client:
        enabled: true
        collect_mine: true
        server:
          host: grafana.host
          port: 3000
          token: token


Read more
=========

* http://grafana.org/
* http://docs.grafana.org/reference/export_import/
