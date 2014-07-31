require "batman_rails_flo/version"

module BatmanRailsFlo
  require "batman_rails_flo/railtie" if defined?(Rails)
  require "batman_rails_flo/engine" if defined?(Rails)
end
