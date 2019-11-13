object @item
attributes :id,
           :title,
           :status,
           :description,
           :tags,
           :due_at,
           :started_at,
           :completed_at,
           :created_at,
           :updated_at

node(:id) { |o| o.id.to_s }
node(:due_at) { |o| o.due_at.try(:strftime, "%B %d, %Y %I:%M %p")}
node(:started_at) { |o| o.started_at.try(:strftime, "%B %d, %Y %I:%M %p")}
node(:completed_at) { |o| o.completed_at.try(:strftime, "%B %d, %Y %I:%M %p")}
node(:created_at) { |o| o.created_at.strftime("%B %d, %Y %I:%M %p") }
node(:updated_at) { |o| o.updated_at.strftime("%B %d, %Y %I:%M %p") }

child :tags, object_root: false do
    attributes :name, :slug
end
