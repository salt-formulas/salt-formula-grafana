
=======
Grafana
=======

A beautiful, easy to use and feature rich Graphite dashboard replacement and graph editor.


Sample pillars
==============


Server deployments
------------------

Server installed from system package and listening on 1.2.3.4:3000 (the default
is 0.0.0.0:3000)

.. code-block:: yaml

    grafana:
      server:
        enabled: true
        bind:
          address: 1.2.3.4
          port: 3000
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

Server installed with LDAP authentication and all authenticated users are
administrators

.. code-block:: yaml

    grafana:
      server:
        enabled: true
        admin:
          user: admin
          password: passwd
        auth:
          ldap:
            enabled: true
            host: '127.0.0.1'
            port: 389
            use_ssl: false
            bind_dn: "cn=admin,dc=grafana,dc=org"
            bind_password: "grafana"
            user_search_filter: "(cn=%s)"
            user_search_base_dns:
            - "dc=grafana,dc=org"

Server installed with LDAP and basic authentication

.. code-block:: yaml

    grafana:
      server:
        enabled: true
        admin:
          user: admin
          password: passwd
        auth:
          basic:
            enabled: true
          ldap:
            enabled: true
            host: '127.0.0.1'
            port: 389
            use_ssl: false
            bind_dn: "cn=admin,dc=grafana,dc=org"
            bind_password: "grafana"
            user_search_filter: "(cn=%s)"
            user_search_base_dns:
            - "dc=grafana,dc=org"

Server installed with LDAP for authentication and authorization

.. code-block:: yaml

    grafana:
      server:
        enabled: true
        admin:
          user: admin
          password: passwd
        auth:
          ldap:
            enabled: true
            host: '127.0.0.1'
            port: 389
            use_ssl: false
            bind_dn: "cn=admin,dc=grafana,dc=org"
            bind_password: "grafana"
            user_search_filter: "(cn=%s)"
            user_search_base_dns:
            - "dc=grafana,dc=org"
            group_search_filter: "(&(objectClass=posixGroup)(memberUid=%s))"
            group_search_base_dns:
            - "ou=groups,dc=grafana,dc=org"
            authorization:
              enabled: true
              admin_group: "admins"
              editor_group: "editors"
              viewer_group: "viewers"

Server installed with default StackLight JSON dashboards. This will
be replaced by the possibility for a service to provide its own dashboard
using salt-mine.

.. code-block:: yaml

    grafana:
      server:
        enabled: true
        dashboards:
          enabled: true
          path: /var/lib/grafana/dashboards

Server with theme overrides

.. code-block:: yaml

    grafana:
      server:
        enabled: true
        theme:
          light:
            css_override:
              source: http://path.to.theme
              source_hash: sha256=xyz
              build: xyz
          dark:
            css_override:
              source: salt://path.to.theme


Collector setup
---------------

Used to aggregate dashboards from monitoring node.

.. code-block:: yaml

    grafana:
      collector:
        enabled: true


Client setups
-------------

Client with token based auth

.. code-block:: yaml

    grafana:
      client:
        enabled: true
        server:
          protocol: https
          host: grafana.host
          port: 3000
          token: token

Client with base auth

.. code-block:: yaml

    grafana:
      client:
        enabled: true
        server:
          protocol: https
          host: grafana.host
          port: 3000
          user: admin
          password: password

Client enforcing graphite data source

.. code-block:: yaml

    grafana:
      client:
        enabled: true
        datasource:
          graphite:
            type: graphite
            host: mtr01.domain.com
            protocol: https
            port: 443

Client enforcing elasticsearch data source

.. code-block:: yaml

    grafana:
      client:
        enabled: true
        datasource:
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

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-grafana/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-grafana

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
