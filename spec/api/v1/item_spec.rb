# frozen_string_literal: true

require 'spec_helper'

describe API::V1::Items do

  describe 'GET /api/v1/items' do
    context 'without tag filter' do
      before do
        2.times { create(:item, :valid) }
      end
      it 'returns all items' do
        get '/api/v1/items'
        expect(parsed_json["items"].count).to eq(2)
        expect(response.status).to eq(200)
      end
    end

    context 'with tag filter' do
      before do
        create(:item, :valid)
        create(:item, tags: [build(:tag, name: 'test')])
      end
      it 'returns items having tag test' do
        get '/api/v1/items?tag=test'
        expect(parsed_json["items"].count).to eq(1)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST /api/v1/items' do
    context 'with valid data' do
      let(:attr) {{title: 'test', tags: [{name: 'bad'}]}}

      it 'returns successfully created item' do
        post '/api/v1/items', attr
        expect(parsed_json["item"]['title']).to eq('test')
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid data' do
      let(:attr) {{tags: [{name: 'bad'}]}}

      it 'returns error for #missing title' do
        post '/api/v1/items', attr
        expect(parsed_json['error']).to eq('title is missing')
        expect(response.status).to eq(201)
      end
    end
  end

  describe 'PUT /api/v1/items/:id' do
    let(:item) { create(:item, :valid) }

    context 'with valid data' do
      let(:attr) {{title: 'Test', tags: [{name: 'bad'}]}}

      it 'returns successfully created item' do
        put "/api/v1/items/#{item.id.to_s}", attr
        expect(parsed_json["item"]['title']).to eq('Test')
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid data' do
      let(:attr) {{tags: [{name: 'bad'},{name: 'bad'}]}}

      it 'returns error for #missing title' do
        put "/api/v1/items/#{item.id.to_s}", attr
        expect(parsed_json['error']).to eq(["Tags is invalid"])
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /api/v1/items/:id' do
    context 'with valid Item ID' do
      let(:item) { create(:item, :valid) }
      it 'returns successfully created item' do
        delete "/api/v1/items/#{item.id.to_s}"
        expect(parsed_json["item"]['title']).to eq(item.title)
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid Item ID' do
      it 'returns error for #record not foound' do
        delete "/api/v1/items/5dc1469cd450cb7a0db5e739"
        expect(parsed_json['error']).to eq("Record Not Found!")
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'PUT /api/v1/items/:id' do
    context 'with valid Item ID' do
      let(:item) { create(:item, :valid) }
      it 'returns successfully created item' do
        put "/api/v1/items/#{item.id.to_s}/restore"
        expect(parsed_json["item"]['title']).to eq(item.title)
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid Item ID' do
      it 'returns error for #record not foound' do
        put "/api/v1/items/5dc1469cd450cb7a0db5e739/restore"
        expect(parsed_json['error']).to eq("Record Not Found!")
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST /api/v1/items/:id/tag' do
    context 'with valid Tag' do
      let(:item) { create(:item, :valid) }
      it 'returns successfully updated item' do
        post "/api/v1/items/#{item.id.to_s}/tag", {name: 'test tag'}
        expect(parsed_json["item"]['title']).to eq(item.title)
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid Tag' do
      let(:item) { create(:item, tags: [build(:tag, name: 'bad')]) }
      it 'returns error for #Tag already exists!' do
        post "/api/v1/items/#{item.id.to_s}/tag", {name: 'bad'}
        expect(parsed_json['error']).to eq("Tag already exists!")
        expect(response.status).to eq(422)
      end
    end

    context 'with invalid Item ID' do
      it 'returns error for #record not found' do
        post "/api/v1/items/5dc1469cd450cb7a0db5e739/tag", {name: 'test tag'}
        expect(parsed_json['error']).to eq("Record Not Found!")
        expect(response.status).to eq(404)
      end
    end
  end
end
