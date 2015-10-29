module Cpanel
  class ApplicationController < ::ApplicationController
    layout 'cpanel'
    before_action :authenticate_user!
  end
end
