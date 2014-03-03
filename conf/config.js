/** @scratch /configuration/config.js/1
 * == Configuration
 * config.js is where you will find the core Grafana configuration. This file contains parameter that
 * must be set before kibana is run for the first time.
 */
define(['settings'],
function (Settings) {
  "use strict";

  return new Settings({

    /**
     * elasticsearch url:
     * For Basic authentication use: http://username:password@domain.com:9200
     */
    elasticsearch: "http://{{ salt['pillar.get']('grafana:server:elasticsearch:host', "") }}:{{ salt['pillar.get']('grafana:server:elasticsearch:port', 9200) }}",

    /**
     * graphite-web url:
     * For Basic authentication use: http://username:password@domain.com
     * Basic authentication requires special HTTP headers to be configured
     * in nginx or apache for cross origin domain sharing to work (CORS).
     * Check install documentation on github
     */
    {% if (pillar.grafana.server.data|length) == 1 %}

    {% for data in pillar.grafana.server.data %}
    {%- if data.type == "graphite" %}
    graphiteUrl: "http://{{ data.host }}:{{ data.port }}",
    {%- endif %}
    {% endfor %}

    {%- else %}
    /*graphiteUrl: "http://"+{{ salt['pillar.get']('grafana:server:data:host', "")}}+":{{ salt['pillar.get']('grafana:server:data:port', 80)}}",
    */

    /**
     * Multiple graphite servers? Comment out graphiteUrl and replace with
     *
     *  datasources: {

     *    data_center_us: { type: 'graphite',  url: 'http://<graphite_url>',  default: true },
     *    data_center_eu: { type: 'graphite',  url: 'http://<graphite_url>' }
     *  }
     */
    {%- endif %}

    default_route: '/dashboard/file/default.json',

    /**
     * If your graphite server has another timezone than you & users browsers specify the offset here
     * Example: "-0500" (for UTC - 5 hours)
     */
    timezoneOffset: null,

    grafana_index: "grafana-dash",

    panel_names: [
      'text',
      'graphite'
    ]
  });
});
