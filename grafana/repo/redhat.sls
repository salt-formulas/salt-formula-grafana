grafana:
  pkgrepo.managed:
    - humanname: 'grafana'
    - name: 'grafana'
    - baseurl: 'https://packages.grafana.com/oss/rpm'
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: https://packages.grafana.com/gpg.key
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
