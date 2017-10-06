#!/bin/bash
sudo git clone https://github.com/testcomcast/comcastsamples.git /home/ubuntu/comcastsamples
sudo chef-client --local-mode -c /home/ubuntu/comcastsamples/chefconfig/client.rb --override-runlist nginx::deployapp