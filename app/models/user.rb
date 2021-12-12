class User < ApplicationRecord
  has_secure_password

  def admin?
    admin
  end
end
