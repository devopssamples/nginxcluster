#execute 'gitclone' do
#  command "sudo git clone https://github.com/testcomcast/comcastsamples.git /home/ubuntu/comcastsamples"
#end
execute 'deployapp' do
  #command "cp /home/ubuntu/comcastapp/nginxapp/index.html /var/www/html/index.html"
  command "sudo chmod 755 /home/ubuntu/comcastsamples/deploy/deploy.sh; /home/ubuntu/comcastsamples/deploy/deploy.sh"
end