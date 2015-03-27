#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2008-2014, kchen
#

pkgs = %w{
  epel-release
  nginx
}
 
pkgs.flatten.each do |pkg|
  r = package pkg do
    action(:install )
  end
  r.run_action(:install)
end

service "nginx" do
    action [:enable,:start]
end
