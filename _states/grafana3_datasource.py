# -*- coding: utf-8 -*-
'''
Manage Grafana v3.0 data sources

.. versionadded:: 2016.3.0

Token auth setup

.. code-block:: yaml

    grafana_version: 3
    grafana:
      grafana_timeout: 5
      grafana_token: qwertyuiop
      grafana_url: 'https://url.com'

Basic auth setup

.. code-block:: yaml

    grafana_version: 3
    grafana:
      grafana_timeout: 5
      grafana_user: grafana
      grafana_password: qwertyuiop
      grafana_url: 'https://url.com'

.. code-block:: yaml

    Ensure influxdb data source is present:
      grafana_datasource.present:
        - name: influxdb
        - type: influxdb
        - url: http://localhost:8086
        - access: proxy
        - basic_auth: true
        - basic_auth_user: myuser
        - basic_auth_password: mypass
        - is_default: true
'''
from __future__ import absolute_import

import json
import requests

from salt.ext.six import string_types


def __virtual__():
    '''Only load if grafana v3.0 is configured.'''
    return __salt__['config.get']('grafana_version', 1) == 3


def present(name,
            type,
            url,
            access='proxy',
            user='',
            password='',
            database='',
            basic_auth=False,
            basic_auth_user='',
            basic_auth_password='',
            is_default=False,
            profile='grafana'):
    '''
    Ensure that a data source is present.

    name
        Name of the data source.

    type
        Which type of data source it is ('graphite', 'influxdb' etc.).

    access
        Use proxy or direct. Default: proxy

    url
        The URL to the data source API.

    user
        Optional - user to authenticate with the data source

    password
        Optional - password to authenticate with the data source

    database
        Optional - database to use with the data source

    basic_auth
        Optional - set to True to use HTTP basic auth to authenticate with the
        data source.

    basic_auth_user
        Optional - HTTP basic auth username.

    basic_auth_password
        Optional - HTTP basic auth password.

    is_default
        Optional - Set data source as default. Default: False
    '''
    if isinstance(profile, string_types):
        profile = __salt__['config.option'](profile)

    ret = {'name': name, 'result': None, 'comment': None, 'changes': None}
    datasource = _get_datasource(profile, name)
    data = _get_json_data(name, type, url,
                          access=access,
                          user=user,
                          password=password,
                          database=database,
                          basic_auth=basic_auth,
                          basic_auth_user=basic_auth_user,
                          basic_auth_password=basic_auth_password,
                          is_default=is_default)

    if datasource:
        requests.put(
            _get_url(profile, datasource['id']),
            data=json.dumps(data),
            auth=_get_auth(profile),
            headers=_get_headers(profile),
            timeout=profile.get('grafana_timeout', 3),
        )
        ret['result'] = True
        ret['changes'] = _diff(datasource, data)
        if ret['changes']['new'] or ret['changes']['old']:
            ret['comment'] = 'Data source {0} updated'.format(name)
        else:
            ret['changes'] = None
            ret['comment'] = 'Data source {0} already up-to-date'.format(name)
    else:
        requests.post(
            '{0}/api/datasources'.format(profile['grafana_url']),
            data=json.dumps(data),
            auth=_get_auth(profile),
            headers=_get_headers(profile),
            timeout=profile.get('grafana_timeout', 3),
        )
        ret['result'] = True
        ret['comment'] = 'New data source {0} added'.format(name)
        ret['changes'] = data

    return ret


def absent(name, profile='grafana'):
    '''
    Ensure that a data source is present.

    name
        Name of the data source to remove.
    '''
    if isinstance(profile, string_types):
        profile = __salt__['config.option'](profile)

    ret = {'result': None, 'comment': None, 'changes': None}
    datasource = _get_datasource(profile, name)

    if not datasource:
        ret['result'] = True
        ret['comment'] = 'Data source {0} already absent'.format(name)
        return ret

    requests.delete(
        _get_url(profile, datasource['id']),
        auth=_get_auth(profile),
        headers=_get_headers(profile),
        timeout=profile.get('grafana_timeout', 3),
    )

    ret['result'] = True
    ret['comment'] = 'Data source {0} was deleted'.format(name)

    return ret


def _get_url(profile, datasource_id):
    return '{0}/api/datasources/{1}'.format(
        profile['grafana_url'],
        datasource_id
    )


def _get_datasource(profile, name):
    response = requests.get(
        '{0}/api/datasources'.format(profile['grafana_url']),
        auth=_get_auth(profile),
        headers=_get_headers(profile),
        timeout=profile.get('grafana_timeout', 3),
    )
    data = response.json()
    for datasource in data:
        if datasource['name'] == name:
            return datasource
    return None


def _get_headers(profile):

    headers = {'Content-type': 'application/json'}

    if profile.get('grafana_token', False):
        headers['Authorization'] = 'Bearer {0}'.format(profile['grafana_token'])

    return headers


def _get_auth(profile):
    if profile.get('grafana_token', False):
        return None

    return requests.auth.HTTPBasicAuth(
        profile['grafana_user'],
        profile['grafana_password']
    )


def _get_json_data(name,
                   type,
                   url,
                   access='proxy',
                   user='',
                   password='',
                   database='',
                   basic_auth=False,
                   basic_auth_user='',
                   basic_auth_password='',
                   is_default=False,
                   type_logo_url='public/app/plugins/datasource/influxdb/img/influxdb_logo.svg',
                   with_credentials=False):
    return {
        'name': name,
        'type': type,
        'url': url,
        'access': access,
        'user': user,
        'password': password,
        'database': database,
        'basicAuth': basic_auth,
        'basicAuthUser': basic_auth_user,
        'basicAuthPassword': basic_auth_password,
        'isDefault': is_default,
        'typeLogoUrl': type_logo_url,
        'withCredentials': with_credentials,
    }


def _diff(old, new):
    old_keys = old.keys()
    old = old.copy()
    new = new.copy()
    for key in old_keys:
        if key == 'id' or key == 'orgId':
            del old[key]
        # New versions of Grafana can introduce new keys that are not present
        # in _get_json_data.
        elif key in new and old[key] == new[key]:
            del old[key]
            del new[key]
    return {'old': old, 'new': new}
