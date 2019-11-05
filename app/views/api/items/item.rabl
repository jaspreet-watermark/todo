object @item
attributes :id, :title, :status, :description, :tags, :created_at, :updated_at

node(:id) { |o| o.id.to_s }

child :tags, object_root: false do
    attributes :name, :slug
end
