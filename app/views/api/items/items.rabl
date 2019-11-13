object false

node(:total) {|m| @items.total_count }

child(@items, object_root: false) do
  extends('items/item')
end