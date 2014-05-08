class Movement < ActiveRecord::Base
  # name:string founded:date founder:string short_description:text
  # long_description:text mission:text phone:string email:string website:string
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  validates :name, presence: true
  validates :short_description, presence: true, length: { maximum: 150,
                                                          minimum: 5 }
  validates :privacy, presence: true, inclusion: { in: %w(open closed secret) }
  validates_format_of :website, with: URI.regexp
  validates_format_of :email,
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end
