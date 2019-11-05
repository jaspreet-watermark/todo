class Item
  include Mongoid::Document
  include Mongoid::Enum
  include Mongoid::Timestamps

  # Defining our fields with their types
  field :title, type: String
  field :description, type: String

  enum :status, [:submit, :start, :finish], default: :submit

  # tags will be stored inside the
  embeds_many :tags

  # Validations
  validates :title, presence: true
  validates :status, presence: true
end
