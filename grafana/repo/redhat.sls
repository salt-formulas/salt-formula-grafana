grafana:
  pkgrepo.managed:
    - humanname: 'grafana'
    - name: 'grafana'
    - baseurl: 'https://packagecloud.io/grafana/stable/el/7/$basearch'
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
