class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, :description, :contact_name, :contact_phone, presence: true
  validates :contact_phone, length: { minimum: 10, maximum: 15 }, format: { with: /\A\d+\z/, message: 'must be between 10 and 15 digits' }

  scope :credit_accepted, -> { where(credit_accepted: true) }
end