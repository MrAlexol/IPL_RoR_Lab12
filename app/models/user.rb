class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, length: { minimum: 3, message: 'не может быть короче 3-х символов' }

  def admin?
    admin
  end
end
