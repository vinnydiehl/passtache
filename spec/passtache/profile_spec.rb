require "spec_helper"
require "passtache/profile"

describe Profile do
  let!(:profile) { new_temp_profile }
  after(:each) { cleanup_temp_profiles }

  subject { profile }

  describe "constructor" do
    it "creates the .stache file" do
      File.exists?("#{Profile::DATA_DIR}/#{TEMP_NAME}.stache").
        should be_true
    end

    its(:name) { should == TEMP_NAME }

    # Make sure it doesn't save the password in plain text.
    its(:master_hash) { should_not == TEMP_MASTER }
  end

  describe "#set_account" do
    before(:each) { profile.add_dummy_account }

    it "creates the account" do
      profile.accounts.has_key?(ACCOUNT).should be_true
    end

    it "sets the username" do
      profile.accounts[ACCOUNT][:username].should == USERNAME
    end

    it "sets the password, but not in plain text" do
      profile.accounts[ACCOUNT][:password].should_not == PASSWORD
    end

    it "can change an existing account" do
      profile.set_account TEMP_MASTER, ACCOUNT, (new = "new_name"), PASSWORD
      profile.accounts[ACCOUNT][:username].should == new
    end

    it "can add additional accounts" do
      profile.add_account TEMP_MASTER, "new_account_test", "name", "pass"
      profile.should have(2).accounts
    end
  end

  describe "#get_account" do
    before(:each) { profile.add_dummy_account }
    let(:data) { profile.get_account TEMP_MASTER, ACCOUNT }

    it "gets the correct username" do
      data[:username].should == USERNAME
    end

    it "gets the correct password, unecrypted" do
      data[:password].should == PASSWORD
    end

    context "with the wrong master password" do
      it "raises a CipherError" do
        # Putting characters around TEMP_MASTER to ensure that this
        # password is always incorrect.
        expect { profile.get_account "x#{TEMP_MASTER}x", ACCOUNT }.
          to raise_error(OpenSSL::Cipher::CipherError)
      end
    end
  end

  describe "#delete" do
    before(:each) { profile.add_dummy_account }

    it "deletes the account from the profile" do
      profile.delete ACCOUNT
      profile.accounts.has_key?(ACCOUNT).should be_false
    end
  end

  describe "#has_account?" do
    before(:each) { profile.add_dummy_account }

    context "when the account exists" do
      it "returns true" do
        profile.has_account?(ACCOUNT).should be_true
      end
    end

    context "when the account doesn't exist" do
      it "returns false" do
        profile.has_account?("x#{ACCOUNT}x").should be_false
      end
    end
  end
end
