# Monkey patch classes to add accessors to attributes that aren't normally
# public, making testing nicer.

class Passtache::Profile
  attr_accessor :accounts
end
