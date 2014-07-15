module Tincanz
  class Engine < ::Rails::Engine
    isolate_namespace Tincanz

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false, :helper_specs => false
    end
  end
end
