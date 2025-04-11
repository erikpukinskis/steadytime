class GoogleAccount < ApplicationRecord
  self.primary_key = "id"

  # Associations
  belongs_to :user

  # Validations
  validates :id, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :user, presence: true
end
