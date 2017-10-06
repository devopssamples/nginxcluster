#!/bin/bash
cd /home/ubuntu
sudo git clone https://github.com/devopssamples/nginxcluster.git 
sudo chef-client --local-mode -c /home/ubuntu/nginxcluster/nginxsamples/chefconfig/client.rb --override-runlist nginx::deployapp
