# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# define your locate WhatWeb path
WHATWEB_PATH="/home/qingxp9/Developer/github/WhatWeb"
WHATWEB_SAVE_PATH="device_logs/whatweb_logs"
WHATWEB_PLUGES="#{WHATWEB_PATH}/my-plugins"

#define targets split by blank,line "127.0.0.1-100 192.168.1.1 192.168.0.0/24"
TARGET_RANGE="127.0.0.1"
