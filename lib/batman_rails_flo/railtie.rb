require 'batman-rails-flo'
require 'rails'
module BatmanRailsFlo
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'*.rake')].each { |f| load f }
    end
  end
end