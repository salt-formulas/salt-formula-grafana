
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

Collector setup
---------------

Used to aggregate dashboards

.. code-block:: yaml

    grafana:
      collector:
        enabled: true


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
        remote_data:
          engine: salt_mine
        server:
          host: grafana.host
          port: 3000
          token: token

Usage
=====

There's a difference between JSON dashboard representation and models we us. Lists are replaced by dictionaries to support mergings and interpolations.

Client enforced dashboards defined in salt-mine

.. code-block:: yaml

    system_metrics:
      title: graph
      editable: true
      hideControls: false
      rows:
      - title: Usage
        height: 250px
        panels:
        - title: Panel Title
          span: 6
          editable: false
          type: graph
          targets: 
          - refId: A
            target: "support_prd.cfg01_iot_tcpcloud_eu.cpu.0.idle"
          datasource: graphite01
          renderer: flot
        showTitle: true


.. code-block:: yaml

    system_metrics:
      title: graph
      editable: true
      hideControls: false
      rows:
      - title: Usage
        height: 250px
        panels:
        - title: Panel Title
          span: 6
          editable: false
          type: graph
          targets: 
          - refId: A
            target: "support_prd.cfg01_iot_tcpcloud_eu.cpu.0.idle"
          datasource: graphite01
          renderer: flot
        showTitle: true




Read more
=========

* http://grafana.org/
* http://docs.grafana.org/reference/export_import/
