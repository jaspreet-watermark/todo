class Item
  include Mongoid::Document
  include Mongoid::Enum
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  # Fields
  field :title, type: String
  field :description, type: String

  enum :status, [:submit, :start, :finish], default: :submit

  # Associations
  embeds_many :tags

  # Validations
  validates :title, presence: true
  validates :status, presence: true

  # class methods
  class << self
    def statuses
      STATUS.map(&:to_s)
    end
  end
end

