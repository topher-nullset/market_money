class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, :contact_name, :contact_phone, presence: true

  scope :credit_accepted, -> { where(credit_accepted: true) }
end