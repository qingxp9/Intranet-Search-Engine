# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!


ZMAP_LOG_PATH="log/zmap_logs"

#define targets split by blank,line "127.0.0.1-100 192.168.1.1 192.168.0.0/24"
TARGET_RANGE="10.18.25.0/24"
