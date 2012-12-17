require "scrypt"
require "encryptor"

class Passtache::Profile
  DATA_DIR = "#{Dir.home}/.passtache"

  attr_accessor :name
  attr_reader :master_hash

  # Constructs a new instance of Passtache::Profile. The master password,
  # +master+, will not be stored- it is hashed first. Saves the new profile.
  #
  # @param [String] name the name of the profile
  # @param [String] master the master password
  def initialize(name, master)
    @name = name
    @master_hash = SCrypt::Password.create(master).to_s
    @accounts = {}

    save
  end

  # Modifies the accounts hash with +account+. If it doesn't exist already,
  # a new one will be created. Saves the profile when finished.
  #
  # @example Creates a new account for an example profile
  #   profile.new_account "masterpass", "IRC", "AzureDiamond", "hunter2"
  #
  # @example Change the password when you realise that you leaked it
  #   profile.set_account "masterpass", "IRC", "AzureDiamond", "oops"
  #
  # @param [String] master the master password
  # @param [String] account the account to create or modify
  # @param [String] username the username to the account
  # @param [String] password the password of the account
  def set_account(master, account, username, password)
    @accounts[account] = {
      username: username,
      password: Encryptor.encrypt(password, key: master)
    }

    save
  end
  alias new_account set_account
  alias add_account set_account

  # Retrieves the username and unencrypted password for +account+. The format
  # of the returned hash is as follows:
  #
  #   {username: "username here", password: "password here"}
  #
  # @example Retrieve the account data for IRC
  #   profile.get_account "masterpass", "IRC"
  #     # => {username: "AzureDiamond", password: "hunter2"}
  #
  # @param [String] master the master password
  # @param [String] account the account to get information for
  def get_account(master, account)
    {
      username: @accounts[account][:username],
      password: Encryptor.decrypt(@accounts[account][:password], key: master)
    }
  end

  # Deletes +account+ from the accounts hash. Saves the profile when finished.
  #
  # @example Delete the IRC account
  #   profile.delete "IRC"
  #
  # @param [String] account the account to delete.
  def delete(account)
    @accounts.delete account
    save
  end

  # Sees if an account with the name +account+ exists in the profile.
  #
  # @param [String] account the account to check for
  # @return [Boolean] whether or not the account is in the profile
  def has_account?(account)
    @accounts.has_key? account
  end

  private

  # Saves the account to a YAML file.
  def save
    Dir.mkdir DATA_DIR unless Dir.exists?(DATA_DIR)
    File.write "#{DATA_DIR}/#{@name}.stache", self.to_yaml
  end
end
