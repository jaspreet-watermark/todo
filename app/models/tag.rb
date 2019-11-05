class Tag
  include Mongoid::Document

  # Defining our fields with their types
  field :name, type: String
  field :slug, type: String

  # index
  index({ slug: 1 }, { unique: true, name: "slug_index" })

  # This model should be saved in the item document
  embedded_in :item

  # validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  # callbacks
  before_validation do
    self.slug = name.parameterize
  end
end
