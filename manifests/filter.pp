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
# = Class: logstash::filter
#
# Class to install logstash filter configs
#
# == Parameters
#
# [*level*]
#   String. Conf level prefix for stitching files together in order.
# [*target*]
#   String. Path to actual config location will be symlinked to.
define logstash::filter (
  $level,
  $target,
) {
  include ::logstash

  file { "/etc/logstash/conf.d/${level}-${name}.conf":
    ensure  => link,
    target  => $target,
    require => Class['logstash'],
  }
}
