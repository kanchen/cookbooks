#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2008-2014, kchen
# from: https://www.howtoforge.com/apache_php_mysql_on_centos_6.5_lamp
#

pkgs = %w{
  mysql 
  mysql-server
  httpd
  php
  php-mysql
  php-gd 
  php-imap 
  php-ldap 
  php-odbc 
  php-pear 
  php-xml 
  php-xmlrpc 
  php-mbstring 
  php-mcrypt 
  php-mssql 
  php-snmp 
  php-soap 
  php-tidy 
  curl 
  curl-devel 
  php-pecl-apc
}

#install packages 
pkgs.flatten.each do |pkg|
  r = package pkg do
    action(:install )
  end
  r.run_action(:install)
end

# start mysqld service
service "mysqld" do
  action [:enable,:start]
end

#secure mysql
user      = node['lamp']['mysql']['admin_user']
scope     = node['lamp']['mysql']['admin_scope']
password  = node['lamp']['mysql']['admin_password']
template "#{node['lamp']['mysql']['init_file']}" do
  source "mysql.init.erb"
  mode '0644'
  owner 'mysql'
  group 'mysql'
  variables({
    :dbuser => "'#{user}'@'#{scope}'",
    :dbpassword => "'#{password}'"
  })
  action :create
end

execute 'install-init' do
  command "mysql -u root < #{node['lamp']['mysql']['init_file']} > /var/log/mysql-init.log 2>&1"
  notifies :delete, "file[#{node['lamp']['mysql']['init_file']}]"
end

file node['lamp']['mysql']['init_file'] do
  action :nothing
end

#PHP info page
cookbook_file "/var/www/html/info.php" do
  owner "apache"
  group "apache"
  mode 0644
  source "info.php"
  action :create
end

#install wordpress
directory "#{node['lamp']['wp']['install_dir']}" do
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end

remote_file "#{node['lamp']['wp']['install_dir']}/#{node['lamp']['wp']['tar_file']}" do
  source "#{node['lamp']['wp']['src_url']}"
end

execute "extract_tar" do
  command "tar xzvf #{node['lamp']['wp']['tar_file']}"
  cwd "#{node['lamp']['wp']['install_dir']}"
end

template "#{node['lamp']['wp']['install_dir']}/wordpress/wp-config.php" do
  source "wp-config.php.erb"
  mode '0755'
  owner 'root'
  group 'root'
  action :create
end

execute "/var/www/html/wordpress" do
  command "(cd #{node['lamp']['wp']['install_dir']}/wordpress; tar cf - *) | (cd /var/www/html; tar xf -)"
end

# start web service
service "httpd" do
  action [:enable,:start]
end
