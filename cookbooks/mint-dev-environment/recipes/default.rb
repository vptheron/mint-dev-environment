## System wide changes
######################

# Install JDK
node.set['java']['install_flavor'] = 'openjdk'
node.set['java']['jdk_version'] = '7' 
include_recipe 'java::default'

# Install sbt-extras
remote_file '/usr/local/bin/sbt' do
  action :create_if_missing
  source 'https://raw.github.com/paulp/sbt-extras/master/sbt'
  backup false
  mode '0755'
  owner 'root'
  group 'root'
end

# Install leiningen
remote_file '/usr/local/bin/lein' do
  action :create_if_missing
  source 'https://raw.github.com/technomancy/leiningen/stable/bin/lein'
  backup false
  mode '0755'
  owner 'root'
  group 'root'
end

# Delete packages
['firefox', 'firefox-locale-en',
 'mint-flashplugin-11', 'mint-flashplugin-steam',
 'tomboy',
 'gthumb', 'gthumb-data',
 'gimp', 'gimp-data', 'libgimp2.0',
 'pidgin', 'pidgin-data',
 'thunderbird',
 'xchat', 'xchat-common',
 'hexchat', 'hexchat-common',
 'banshee',
 'totem', 'totem-common',
 'gir1.2-totem-1.0', 'gir1.2-totem-plparser-1.0'
].each do |pkg|
  package pkg do
    action :purge
  end
end

directory '/opt/firefox' do  
  action :delete
  recursive true
end

# Install new packages
['vim',
 'tree',
 'chromium-browser',    
 'adobe-flashplugin',
 'skype',
 'haskell-platform',
 'calibre',
 'clementine',
 'brasero',
 'meld'
].each do |pkg|
  package pkg do
    action :upgrade
  end
end

## User specific changes
#######################

username = node['mint-dev-environment']['username']
home_dir = "/home/#{username}"

# Clean up home folder
['.mozilla', 'Public', 'Templates'].each do |dir|
  directory File.join(home_dir, dir) do
    action :delete
    recursive true
  end
end

# Create dev folders
['Devel', 'Devel/tools'].each do |dir|
  directory File.join(home_dir, dir) do
    action :create
    owner username
    group username
    mode 00755
  end
end

# Install IDEA IntelliJ
node.set['idea']['setup_dir'] = File.join(home_dir, 'Devel/tools')
node.set['idea']['user'] = username
node.set['idea']['group'] = username
include_recipe 'idea::default'

# Configure git
template File.join(home_dir, '.gitconfig') do
  action :create_if_missing
  source 'gitconfig.erb'
  variables(
    :full_name => node['mint-dev-environment']['full_name'],
    :email_address => node['mint-dev-environment']['email_address']
  )
  owner username
  group username
  mode 0664
end

# Install rbenv, ruby and bundler
ruby_version = '1.9.3-p484'
node.set['rbenv']['git_url'] = 'https://github.com/sstephenson/rbenv.git'
node.set['rbenv']['install_pkgs'] = %w{git grep autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev}
node.set['rbenv']['user_home_root'] = '/home'
node.set['rbenv']['user_installs'] = [
  {
    'user' => username,
    'rubies' => [ruby_version],
    'global' => ruby_version,
    'gems' => { ruby_version => [{'name' => 'bundler'}] }
  }
]

include_recipe 'ruby_build'
include_recipe 'rbenv::user'



# Customized CINNAMON desktop environment
execute 'update desktop icons' do
  action :run
  command 'gsettings set org.nemo.desktop trash-icon-visible true; gsettings set org.nemo.desktop computer-icon-visible false; gsettings set org.nemo.desktop home-icon-visible false'
  user username
end
    
wallpaper_path = File.join(home_dir, 'Pictures/wallpaper.jpg')
cookbook_file 'linux_cheat_sheet.jpg' do
  action :create
  path wallpaper_path 
  owner username
  group username
  mode 0644
end

execute 'update clock format' do
  action :run
  command 'gsettings set org.cinnamon.desktop.interface clock-use-24h false; gsettings set org.cinnamon.desktop.interface clock-show-date true'
  user username
end
    
execute 'set desktop background' do
  action :run 
  command "gsettings set org.cinnamon.desktop.background picture-uri 'file://#{wallpaper_path}'"
  user username
end

execute 'remove applets from panel' do
  action :run
  command "gsettings set org.cinnamon enabled-applets \"['panel1:left:0:menu@cinnamon.org:0', 'panel1:left:2:panel-launchers@cinnamon.org:2', 'panel1:left:3:window-list@cinnamon.org:3', 'panel1:right:0:notifications@cinnamon.org:4', 'panel1:right:2:removable-drives@cinnamon.org:6', 'panel1:right:4:bluetooth@cinnamon.org:8', 'panel1:right:5:network@cinnamon.org:9', 'panel1:right:6:sound@cinnamon.org:10', 'panel1:right:7:power@cinnamon.org:11', 'panel1:right:8:systray@cinnamon.org:12', 'panel1:right:9:calendar@cinnamon.org:13']\""
  user username
end

execute 'configure launcher applet' do
  action :run
  command "gsettings set org.cinnamon panel-launchers \"['nemo.desktop', 'gnome-terminal.desktop', 'chromium-browser.desktop']\""
  user username
end

execute 'configure window list' do
  action :run
  command "gsettings set org.cinnamon window-list-applet-scroll true"
  user username
end

execute 'configure favorite apps' do
  action :run
  command "gsettings set org.cinnamon favorite-apps \"[]\""
  user username
end

execute 'configure power manager' do
  action :run
  command "gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-battery-timeout 600; gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-ac-timeout 600; gsettings set org.cinnamon.settings-daemon.plugins.power critical-battery-action 'hibernate'; gsettings set org.cinnamon.settings-daemon.plugins.power lid-close-battery-action 'hibernate'; gsettings set org.cinnamon.settings-daemon.plugins.power lid-close-ac-action 'hibernate';"
  user username
end
end
