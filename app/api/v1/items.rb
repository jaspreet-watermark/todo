module API::V1
  class Items < Grape::API

    # helpers
    helpers ::API::V1::NamedParams
    helpers do
      def item_params(params)
        declared(params, include_missing: false)
      end
    end

    resources :items do
      # GET /api/v1/items
      desc 'Returns all items, result is paginated'
      params do
        optional :tag, type: String, desc: 'Search by Tag'
        optional :limit, type: Integer, default: 10, desc: "Limit the number of returned orders, default to 10."
        optional :page,  type: Integer, default: 1, desc: "Specify the page of paginated results."
      end
      get rabl: 'items/items' do
        @items = Item.page(params[:page]).per(params[:limit])
        @items = @items.where("tags.slug" => params[:tag].parameterize) if params[:tag]
      end

      # POST /api/v1/items
      desc 'Creates an item'
      params do
        requires :title, type: String, desc: 'Item Title'
        use :item
      end
      post do
       @item = Item.create(item_params(params))
        if @item.persisted?
          render rabl: 'items/item'
          status :created
        else
          render rabl: 'items/errors'
          status :unprocessable_entity
        end
      end

      # GET /api/v1/items/:id
      desc 'Fetch an item'
      get ':id', rabl: 'items/item' do
        @item = Item.find(params[:id])
        status :ok
      end

      # PUT /api/v1/items/:id
      desc 'Updates an item'
      params do
        optional :title, type: String, desc: 'Item Title'
        use :item
      end
      put ':id' do
        @item = Item.find(params[:id])
        if @item.update(item_params(params))
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
        @item = Item.find(params[:id])
        @item.destroy
        status :ok
      end

      # PUT /api/v1/items/:id/restore
      desc 'Restore an Item'
      params do
        requires :id, type: String, desc: 'Item Id'
      end
      put ':id/restore', rabl: 'items/item' do
        @item = Item.unscoped.find(params[:id])
        @item.restore
        status :ok
      end

      # POST /api/v1/items/:id/tag
      desc 'Attach a Tag to Item'
      params do
        requires :name, type: String, desc: 'Tag Name'
      end
      post ':id/tag', rabl: 'items/item' do
        @item = Item.find(params[:id])

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
