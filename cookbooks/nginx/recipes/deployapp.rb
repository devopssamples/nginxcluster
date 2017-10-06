
execute 'deployapp' do
  command "sudo chmod 755 /home/ubuntu/comcastsamples/deploy/deploy.sh; /home/ubuntu/comcastsamples/deploy/deploy.sh"
end
