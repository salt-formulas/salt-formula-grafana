grafana:
  client:
    enabled: true
    server:
      protocol: https
      host: grafana.host
      port: 3000
      user: admin
      password: password
    datasource:
      elasticsearch:
        type: elasticsearch
        host: log01.domain.com
        port: 80
        index: grafana-dash
    dashboard:
      system_metrics:
        title: "Generic system metrics"
        style: dark
        editable: false
        row:
          top:
            title: "First row"