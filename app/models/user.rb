# frozen_string_literal: true

# Модель пользователя
class User < ApplicationRecord
  has_secure_password validations: false

  validate :password_presence
  validates :password, confirmation: { message: 'Пароли не совпадают' },
                       length: { minimum: 6, maximum: 15, message: 'слишком короткий,
                                                                   минимальная длина - 6 символов.' }

  validates :username, length: { minimum: 3, message: 'не может быть короче 3-х символов' },
                       uniqueness: { message: 'уже занято' }

  validates :email, allow_blank: true,
                    uniqueness: { message: 'занята другим пользователем' },
                    format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: 'не может быть использована' }

  def password_presence
    errors.add(:password, 'не может быть пустым') unless password_digest.present?
  end

  def admin?
    admin
  end
end
