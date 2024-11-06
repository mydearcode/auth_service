class User < ApplicationRecord
  # Constants
  ROLES = { admin: 0, user: 1 }.freeze
  STATUSES = { pending: 0, active: 1, suspended: 2 }.freeze

  # Attributes
  has_secure_password

  # Enums
  enum :role, ROLES, default: :user
  enum :status, STATUSES, default: :pending

  # Validations
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
            
  validates :password,
            presence: true,
            length: { minimum: 8 },
            format: { 
              with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/,
              message: 'must include at least one lowercase letter, one uppercase letter, one number, and one special character'
            },
            if: -> { new_record? || !password.nil? }
            
  validates :first_name, :last_name, presence: true

  # Callbacks
  before_save :downcase_email

  # Instance Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def active?
    status == 'active'
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end 