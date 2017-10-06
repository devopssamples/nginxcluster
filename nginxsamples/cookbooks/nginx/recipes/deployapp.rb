execute 'chmodapp' do
  command "sudo chmod 755 /home/ubuntu/nginxcluster/nginxsamples/deploy/deploy.sh"
end
execute 'deployapp' do
  command "sudo /home/ubuntu/nginxcluster/nginxsamples/deploy/deploy.sh"
end
