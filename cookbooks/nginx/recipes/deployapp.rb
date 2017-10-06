
execute 'deployapp' do
  command "sudo chmod 755 /home/ubuntu/devopssamples/nginxcluster/deploy/deploy.sh; /home/ubuntu/nginxcluster/deploy/deploy.sh"
end
