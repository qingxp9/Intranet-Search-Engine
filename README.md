#Intranet Search Engine

Its goal is to help people to find all webservice in intranet.We make this Web application based on Ruby On Rails.  

##Installation
First, you should install Ruby and Rails,I use ruby 2.2.0 and rails 4.2.0 when I develop it.
You can use rvm to fast install them:

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    
    curl -sSL https://get.rvm.io | bash -s stable --rails 

Second,You should install mongodb and elasticsearch on your device.
###Mongodb
    sudo apt-get install mongodb  

###ElasticSearch
Download and install the Public Signing Key 

    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

Add the repository definition to your /etc/apt/sources.list file:

    echo "deb http://packages.elastic.co/elasticsearch/1.5/debian stable main" | sudo tee -a /etc/apt/sources.list
    
Finally,enter into the application root,run

    bundle install
    rails server

if you don't see any errors,everything is ok. 
