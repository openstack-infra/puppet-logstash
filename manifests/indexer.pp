# Copyright 2013 Hewlett-Packard Development Company, L.P.
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
# = Class: logstash::indexer
#
# Class to install logstash indexer
#
# == Parameters
#
# [*conf_template*]
#   String. (deprecated) Path to indexer config template.
#   Default: undef
# [*input_template*]
#   String. Path to indexer input config template.
#   Default: 'logstash/input.conf.erb'
# [*output_template*]
#   String. Path to indexer output config template.
#   Default: 'logstash/output.conf.erb'
class logstash::indexer (
  $conf_template   = undef,
  $input_template  = 'logstash/input.conf.erb',
  $output_template = 'logstash/output.conf.erb',
) {
  include ::logstash

  if $conf_template != undef {
    notify { 'Using $conf_template is deprecated, please switch to $input_template, $output_template and ::logstash::filter defines.': }

    file { '/etc/logstash/conf.d/indexer.conf':
      ensure  => present,
      content => template($conf_template),
      replace => true,
      owner   => 'logstash',
      group   => 'logstash',
      mode    => '0644',
      require => Class['logstash'],
      notify  => Service['logstash'],
    }
  } else {
    file { '/etc/logstash/conf.d/00-input.conf':
      ensure  => present,
      content => template($input_template),
      replace => true,
      owner   => 'logstash',
      group   => 'logstash',
      mode    => '0644',
      require => Class['logstash'],
      notify  => Service['logstash'],
    }

    file { '/etc/logstash/conf.d/99-output.conf':
      ensure  => present,
      content => template($output_template),
      replace => true,
      owner   => 'logstash',
      group   => 'logstash',
      mode    => '0644',
      require => Class['logstash'],
      notify  => Service['logstash'],
    }
  }

  file { '/etc/default/logstash':
    ensure  => present,
    source  => 'puppet:///modules/logstash/logstash.default',
    replace => true,
    owner   => 'logstash',
    group   => 'logstash',
    mode    => '0644',
    require => Class['logstash'],
  }

  service { 'logstash':
    ensure    => running,
    enable    => true,
    subscribe => [
      File['/etc/default/logstash'],
    ],
    require   => Class['logstash'],
  }
}
