default['lamp']['wp']['tar_file']    = "latest.tar.gz"
default['lamp']['wp']['src_url']    = "http://wordpress.org/#{node['lamp']['wp']['tar_file']}"
default['lamp']['wp']['install_dir']    = "/opt/wordpress"

default['lamp']['mysql']['init_file'] = "/tmp/mysql_init.sql"
default['lamp']['mysql']['admin_user'] = "masteruser"
default['lamp']['mysql']['admin_password'] = "password1234"
default['lamp']['mysql']['admin_scope'] = "%"

default['lamp']['wp']['db_name'] = "wordpress"
default['lamp']['wp']['db_user'] = "wordpressuser"
default['lamp']['wp']['db_password'] = "password"
