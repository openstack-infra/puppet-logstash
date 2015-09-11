# Copyright 2015 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# ELK curator
#
class logstash::curator (
  $virtualenv_path = '/opt/curator/venv',
  $source_path     = '/opt/curator/src',
  $keep_for_days   = '14',
  $git_revision    = 'master',
) {

  vcsrepo { $source_path:
    ensure   => latest,
    provider => 'git',
    source   => 'https://github.com/elastic/curator.git',
    revision => $git_revision,
  }

  exec { 'create-curator-virtualenv':
    command => "/usr/local/bin/virtualenv ${virtualenv_path}",
    creates => $virtualenv_path,
  }

  exec { 'install-curator':
    command     => "${virtualenv_path}/bin/pip install ${source_path}",
    refreshonly => true,
    subscribe   => Vcsrepo[$source_path],
    require     => [
      Vcsrepo[$source_path],
      Exec['create-curator-virtualenv'],
    ],
  }

  cron { 'cleanup_old_es_indices':
    user        => 'root',
    hour        => '2',
    minute      => '0',
    environment => "PATH=${virtualenv_path}/bin:/usr/bin:/bin:/usr/sbin:/sbin",
    command     => "${virtualenv_path}/bin/curator --logfile /var/log/curator.log delete indices --older-than ${keep_for_days} --time-unit days --timestring %Y.%m.%d"
  }

  include ::logrotate
  logrotate::file { 'curator.log':
    log     => '/var/log/curator.log',
    options => [
      'compress',
      'missingok',
      'rotate 31',
      'daily',
      'notifempty',
    ],
  }
}
