
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

Server installed with default StackLight JSON dashboards

.. code-block:: yaml

    grafana:
      server:
        enabled: true
        admin:
          user: admin
          password: passwd
        dashboards:
          enabled: true
          path: /var/lib/grafana/dashboards


Collector setup
---------------

Used to aggregate dashboards from monitoring node.

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
            index: grafana-dash

Client defined and enforced dashboard

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

There's a difference between JSON dashboard representation and models we us.
The lists used in JSON format [for rows, panels and target] were replaced by
dictionaries. This form of serialization allows better merging and overrides
of hierarchical data structures that dashboard models are.

The default format of Grafana dashboards with lists for rows, panels and targets.

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

The modified version of Grafana dashboard format with dictionary declarations.
Please note that dictionary keys are only for logical separation and are not
displayed in generated dashboards.

.. code-block:: yaml

    system_metrics:
        system_metrics2:
          title: graph
          editable: true
          hideControls: false
          row:
            usage:
              title: Usage
              height: 250px
              panel:
                usage-panel:
                  title: Panel Title
                  span: 6
                  editable: false
                  type: graph
                  target:
                    A:
                      refId: A
                      target: "support_prd.cfg01_iot_tcpcloud_eu.cpu.0.idle"
                  datasource: graphite01
                  renderer: flot
              showTitle: true


Read more
=========

* http://grafana.org/
* http://docs.grafana.org/reference/export_import/
