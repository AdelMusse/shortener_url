class User < ActiveRecord::Base
  has_many :items
  validates_presence_of :name, :email
  # validates :email, uniqueness: {case_sensitive: false}
  include BCrypt

def password
  @password ||= Password.new(password_hash)
end

def password=(new_password)
  @password = Password.create(new_password)
  self.password_hash = @password
end

end