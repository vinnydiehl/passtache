# Helpers for handling temporary testing accounts.

TEMP_NAME, TEMP_MASTER = "_spec_profile", "masterpass"

def new_temp_profile
  Profile.new TEMP_NAME, TEMP_MASTER
end

def cleanup_temp_profiles
  Dir["#{Profile::DATA_DIR}/_spec*"].each { |f| File.delete f }
  Dir.delete Profile::DATA_DIR if Dir["#{Profile::DATA_DIR}/*"].empty?
end

ACCOUNT, USERNAME, PASSWORD = "test_account", "test_name", "test_password"

class Passtache::Profile
  def add_dummy_account
    set_account TEMP_MASTER, ACCOUNT, USERNAME, PASSWORD
  end
end
