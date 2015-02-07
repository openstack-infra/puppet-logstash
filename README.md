# OpenStack Logstash Module

## Overview

Installs and configures Logstash.

## Quick Start

```puppet
  class { 'logstash::web':
    frontend            => 'kibana',
    discover_nodes      => ['es1.example.com:9200', 'es2.example.com:9200'],
    proxy_elasticsearch => true,
  }
```

## Usage Considerations

You will want to add security with certs and firewalls when using this
module.

This module is recently split out of the monolithic OpenStack Infra system-config
repo.  It is gaining flexibility but for now may be more opinionated than
what you really want.

Example to bring up logstash web interface or kibana

Example usage:

```puppet
  class { 'logstash::web':
    frontend            => 'kibana',
    discover_nodes      => ['es1.example.com:9200', 'es2.example.com:9200'],
    proxy_elasticsearch => true,
  }
```

Example to install a logstash indexer

Example usage:

```puppet

  class { 'logstash::indexer':
    conf_template => 'my_org_module/indexer.conf.erb',
  }
```

Where index.conf.erb looks like:

http://git.openstack.org/cgit/openstack-infra/system-config/tree/modules/openstack_project/templates/logstash/indexer.conf.erb

# License

Apache 2.0

# Project website

Though this project is mirrored to github, that is just a mirror. This
is a sub project under the OpenStack umbrella, and so has more process
associated with it than your typical Puppet module.

This module is under the direction of the openstack-infra team.
Website: http://ci.openstack.org/

The official git repository is at:
https://git.openstack.org/cgit/openstack-infra/puppet-logstash

Bugs can be submitted against this module at:
https://storyboard.openstack.org/#!/search?q=puppet-logstash

And contributions should be submitted through review.openstack.org
by following http://docs.openstack.org/infra/manual/developers.html

# Contact

You can reach the maintainers of this module on freenode in #openstack-infra
and on the openstack-infra mailing list:

openstack-infra@lists.openstack.org.

Unsubscribed users' messages will be held for a short time until they are
manually released.
