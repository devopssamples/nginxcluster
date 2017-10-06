# nginxcluster
To create a scalable and secure static web application in AWS. 

- Create and deploy a running instance of nginx web server using a configuration management tool chef. The web server will serve one page with the "hello world"

- This application and host will be secured such that only appropriate ports are publicly exposed and all http requests are redirected to https. This is automated using a configuration management tool (chef) a self-signed certificate will be used for the web server
  

## Software used for the purpose

- WebServer- nginx
- AWS EC2 - ubuntu xenial
- Packer 1.0.2 - for creating AMIs
- Terraform 0.10.7 - for spinning up AWS resources
- git hub - hosting the scripts and application
- openssl to generate selfsigned certs 
- ssh-keygen to generate sshkeys to set on instances

## Getting started
- Install aws cli on your box and run aws configure. this will prompt you for entering AWS credentials
- Install packer and terraform on your box
- Install cygwin and then install ssh packages from cygwin on your box. This will allow you to create ssh-keygen
- Install git on your box


### How?

- git clone https://github.com/devopssamples/nginxcluster.git.
- cd to nginxcluster/packer folder
- edit the setenv.cmd. Set the VPC and subnet. I am using the same VPC and subnet in terraform
- run setenv.cmd
- run packer build chefclient.json. This will create an ubuntu xenial based AMI with chef client installed. We will be using chef client local mode for all our provisioning
- next edit njinx.json with the newly created ami name and run packer build njinx.json. This will create another AMI which will have nginx and git installed. We use chef to configure SSL certs on nginx. You can see that in the cookbooks.
- next go to nginxcluster/terraform folder. edit variables.tf. Set the ami to the AMI you created in the prev step. I already checked in the certs and sshkeys required to run this stack. If you need your own please create them and then modify the variables.tf and nginx.tf accordingly. Then run terraform apply. This will create the network stack and autoscaling groups. Now the index.html is in github. I used this as a way to show how apps can be deployed using chef on autoscaling groups. Note the userdata.sh. It will download the nginx application and then deploy it using chef. I am using github itself as application repo. Ideally I would use artifactory or something and would pull the deployables from there
