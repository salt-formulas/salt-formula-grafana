grafana:
  server:
    enabled: true
    bind:
      address: 1.2.3.4
      port: 3000
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
    database:
      engine: postgresql
      host: localhost
      port: 5432
      name: grafana
      user: grafana
      password: passwd