# Adds the Grafana repo
grafana_repo:
  pkgrepo.managed:
    - name: deb https://packages.grafana.com/oss/deb stable main
    - key_url: https://packages.grafana.com/gpg.key
    - require_in:
      - pkg: grafana_packages
