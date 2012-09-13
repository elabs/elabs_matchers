require "rspec"

module ElabsMatchers
  require "active_support/core_ext/hash/indifferent_access"
  require "active_support/inflector"

  Dir[File.join(File.expand_path(File.dirname(__FILE__)), "elabs_matchers/**/*.rb")].each do |file|
    require file unless file.split("/").last == "version.rb"
  end

  RSpec.configure do |config|
    config.include ElabsMatchers::Matchers::Rspec::Allow
    config.include ElabsMatchers::Matchers::Rspec::Common
    config.include ElabsMatchers::Matchers::Rspec::Orm

    Dir[File.join(File.expand_path(File.dirname(__FILE__)), "elabs_matchers/helpers/*.rb")].each do |file|
      file = file.split("/").last.split(".").first
      file = file[0].chr.upcase + file[1..-1]
      module_to_include = eval("ElabsMatchers::Helpers::#{file}")

      config.include(module_to_include)
      World(module_to_include) if defined?(World)
    end
  end
end
