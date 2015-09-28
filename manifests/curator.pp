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
  $keep_for_days  = '14',
  $pin_for_old_es = false,
  $cron_hour      = '2',
  $cron_minute    = '0',
) {

  if ($pin_for_old_es) {
    package { 'elasticsearch-curator':
      ensure   => '0.6.2',
      provider => 'pip',
    }
  } else {
    package { 'elasticsearch-curator':
      ensure   => 'latest',
      provider => 'pip',
    }
  }

  cron { 'cleanup_old_es_indices':
    user        => 'root',
    hour        => $cron_hour,
    minute      => $cron_minute,
    command     => "/usr/bin/curator --logfile /var/log/curator.log delete indices --older-than ${keep_for_days} --time-unit days --timestring %Y.%m.%d"
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
