module V1
  class Item < Grape::API

    resources :items do
      # GET /api/v1/items
      desc 'Returns all items'
      params do
        optional :tag, type: String, desc: 'Tags'
        optional :limit, type: Integer, default: 2, desc: "Limit the number of returned orders, default to 100."
        optional :page,  type: Integer, default: 1, desc: "Specify the page of paginated results."
      end
      get rabl: 'items/items' do
        @items = ::Item.all
        @items = @items.where("tags.name" => params[:tag]) if params[:tag]
      end

      # POST /api/v1/items
      desc 'Creates an item'
      params do
        requires :title, type: String, desc: 'Item Title'
        optional :description, type: String, desc: 'Item Description'
        optional :status, type: String, values: ::Item.statuses, desc: 'Item Description'
        optional :tags, type: Array, desc: 'Item Tags' do
          requires :name, type: String, desc: 'Tag Name'
        end
      end
      post do
       @item = ::Item.create(params)
        if @item.valid?
          render rabl: 'items/item'
          status :created
        else
          render rabl: 'items/errors'
          status :unprocessable_entity
        end
      end

      # PUT /api/v1/items/:id
      desc 'Updates an item'
      params do
        requires :id, type: String, desc: 'Item Id'
        optional :title, type: String, desc: 'Item Title'
        optional :description, type: String, desc: 'Item Description'
        optional :status, type: String, values: ::Item.statuses, desc: 'Item Description'
        optional :tags, type: Array, desc: 'Item Tags' do
          requires :name, type: String, desc: 'Tag Name'
        end
      end
      put ':id' do
        @item = ::Item.find(params[:id])
        if @item.update(params)
          render rabl: 'items/item'
          status :ok
        else
          render rabl: 'items/errors'
          status :unprocessable_entity
        end
      end

      # DELETE /api/v1/items/:id
      desc 'Delete an Item'
      params do
        requires :id, type: String, desc: 'Item Id'
      end
      delete ':id', rabl: 'items/item' do
        @item = ::Item.find(params[:id])
        @item.destroy
        status :ok
      end

      # PUT /api/v1/items/:id/restore
      desc 'Restore an Item'
      params do
        requires :id, type: String, desc: 'Item Id'
      end
      put ':id/restore', rabl: 'items/item' do
        @item = ::Item.unscoped.find(params[:id])
        @item.restore
        status :ok
      end

      # POST /api/v1/items/:id/tag
      desc 'Attach a Tag to Item'
      params do
        requires :name, type: String, desc: 'Tag Name'
      end
      post ':id/tag', rabl: 'items/item' do
        @item = ::Item.find(params[:id])

        tag = @item.tags.find_by(slug: params[:name].parameterize) rescue nil
        if tag
          error!('Tag already exists!', 422)
        else
          @item.tags.create!(name: params[:name])
          status :ok
        end
      end
    end
  end
end
