name             'mint-dev-environment'
maintainer       'Vincent Theron'
maintainer_email 'vptheron@gmail.com'
license          'Apache 2.0'
description      'Set up a Linux Mint 16 machine for a developer'
long_description 'Please refer to README.md'
version          '0.1.0'

recipe 'mint-dev-environment', 'Configure a developer environment on a vanilla Linux Mint 16 system.'

depends "java"
depends "idea"
depends "rbenv"
depends "ruby_build"
