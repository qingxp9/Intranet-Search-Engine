#Intranet Search Engine

Its goal is to help people to find all webservice in intranet.It likes Shodanhq or Zoomeye but aim at intranet.
![about_root][1]

![about_search][2]

----
##Installation
We make it based on Ruby On Rails.  
### 1.Rails and Ruby
Using **rvm** to install them:

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    
    curl -sSL https://get.rvm.io | bash -s stable --rails 


###2.Mongodb
    sudo apt-get install mongodb  

###3.ElasticSearch
Download and install the Public Signing Key 

    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

Add the repository definition to your */etc/apt/sources.list file*:

    echo "deb http://packages.elastic.co/elasticsearch/1.5/debian stable main" | sudo tee -a /etc/apt/sources.list
    sudo apt-get update && sudo apt-get install elasticsearch

Start it

    sudo service elasticsearch start

Configure Elasticsearch to automatically start during bootup:

    sudo update-rc.d elasticsearch defaults 95 10

execute:

    rake environment elasticsearch:import:all

    
###4.Redis

    sudo apt-get install redis-server   

###5.[WhatWeb][3]

    $ cd ~ && git clone https://github.com/urbanadventurer/WhatWeb

> you should copy your wanted plugins into WhatWeb/my-plugins,I have add these from plugins-disabled: *http-headers meta-description meta-keywords title*

Then set your Whatweb_path in *config/environment*.rb

    WHATWEB_PATH = "/home/xxxxx/WhatWeb"

and set your target intranet ip

    #Separated by Spaces,such as "127.0.0.1-100 192.168.1.1 192.168.0.0/24"
    TARGET_RANGE = "127.0.0.1"
    

## Run Server
    
at the root directory,run:

    bundle install
    rails server

if you don't see any errors,you can view the website at http://127.0.0.1:3000 

###Scheduled scans
at root directory

    $ whenever -iscan
    [write] crontab file updated

> You can change **scan time** in *config/schedule.rb* ,and redo whenever.


  [1]: https://raw.githubusercontent.com/qingxp9/Intranet-Search-Engine/master/public/about_root.png
  [2]: https://raw.githubusercontent.com/qingxp9/Intranet-Search-Engine/master/public/about_search.png
  [3]: https://github.com/urbanadventurer/WhatWeb
