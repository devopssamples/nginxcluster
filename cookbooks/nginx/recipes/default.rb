#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved. 
execute 'apt-get update' do
  command "sudo apt-get update"
end
execute 'install-nginx' do
  command "sudo apt-get install -y nginx"
end
execute 'install-git' do
  command "sudo apt-get install -y git"
end
cookbook_file '/etc/ssl/certs/dhparam.pem' do
  source 'ssl/dhparam.pem'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
cookbook_file '/etc/ssl/certs/nginx-selfsigned.crt' do
  source 'ssl/nginx-selfsigned.crt'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
cookbook_file '/etc/ssl/private/nginx-selfsigned.key' do
  source 'ssl/nginx-selfsigned.key'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
cookbook_file '/etc/nginx/snippets/self-signed.conf' do
  source 'ssl/self-signed.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
cookbook_file '/etc/nginx/snippets/ssl-params.conf' do
  source 'ssl/ssl-params.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
execute 'takebackup' do
  command "cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak"
end
cookbook_file '/etc/nginx/sites-available/default' do
  source 'ssl/default'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end


