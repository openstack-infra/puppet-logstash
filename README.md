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


Elasticsearch and redis are both daemons that fall down somewhat in the
security dept. You will want to add security with certs and firewalls at
a different layer.


This module is reecently split out of the monolithic openstackci repo.
It is gainig flexibility but for now may be more opinionated than
what you really want.


## Classes


### logstash


Main class to install common logstash items


### logstash::web


Class to bring up logstash web interface or kibana


Example usage:

```puppet
  class { 'logstash::web':
    frontend            => 'kibana',
    discover_nodes      => ['es1.example.com:9200', 'es2.example.com:9200'],
    proxy_elasticsearch => true,
  }
```


### logstash::agent


Class to install logstash agent (log shipper)


### logstash::elasticsearch


Class to set up elasticsearch logstash settings


### logstash::indexer


Class to install a logstash indexer


Example usage:

```puppet

  class { 'logstash::indexer':
    conf_template => 'my_org_module/indexer.conf.erb',
  }
```

Where index.conf.erb looks like:


```shell
# Increase the max heap size to twice the default.
# Default is 25% of memory or 1g whichever is less.
JAVA_ARGS='-Xmx2g'
```

### logstash::redis


Class to install redis


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
and on the openstack-infra mailing list.


