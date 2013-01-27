#
# Cookbook Name:: http_server
# Recipe:: default
#
# Copyright 2013, HiganWorks LLC
#
# LICENCE: MIT
#

package "nginx" do
  action :install
end

service "nginx" do
  action [:enable, :start]
end


# vhosts
directory node['nginx']['vhost_dir'] do
  action :create
  owner "www-data"
  group "www-data"
  mode  "0750"
  recursive true
end

["www.example.com"].each do |site|

  directory ::File.join(node['nginx']['vhost_dir'], site) do
    action :create
    owner "www-data"
    group "www-data"
    mode  "0750"
  end

  file ::File.join(node['nginx']['vhost_dir'], site, "index.html") do
    action :create
    content site
    owner "www-data"
    group "www-data"
    mode  "0640"
  end


  template ::File.join(node['nginx']['site_avail_dir'], "#{site}.conf") do
    source "vhost.conf.erb"
    variables({
      :server_name => site,
      :vhost_root => ::File.join(node['nginx']['vhost_dir'], site)
    })
    owner "root"
    group "root"
    mode  "0640"
    notifies :restart, "service[nginx]"
  end

  link ::File.join(node['nginx']['site_enable_dir'], "#{site}.conf") do
    action :create
    to ::File.join(node['nginx']['site_avail_dir'], "#{site}.conf") 
  end
end


