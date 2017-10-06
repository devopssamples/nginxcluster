execute 'chmodapp' do
  command "sudo chmod 755 /home/ubuntu/comcastsamples/deploy/deploy.sh"
end
execute 'deployapp' do
  command "sudo /home/ubuntu/comcastsamples/deploy/deploy.sh"
end