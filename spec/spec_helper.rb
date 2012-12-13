# Include all files in spec/support
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

# Include the Passtache module so that stuff doesn't need to constantly be
# prefixed with "Passtache::".
include Passtache
