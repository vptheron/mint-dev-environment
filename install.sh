#!/bin/bash

echo "---- Updating package cache ----"
apt-get update -o Acquire::http::No-Cache=True

if hash chef-solo 2>/dev/null; then
  echo "---- Chef-solo is already installed ----"
else
  echo "---- Installing Chef via curl ----"
  apt-get install -y curl
  curl -L https://www.opscode.com/chef/install.sh | bash
fi

echo "---- Applying cookbook ----"
chef-solo -c solo.rb -j mint.json

echo "Cookbook applied. Reboot recommended."
