require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

  let(:item) {create(:item)}

  describe 'GET #index' do

    let(:items) {create_list(:item, 2)}

    before { get :index }

    it 'populates an array of all items' do
      expect(assigns(:items)).to match_array(items)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    #before { get :show, id: item }
    before { get :show, params: { id: item } }

    it 'assigns to requested item to @item' do
      expect(assigns(:item)).to eq item
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before { get :new}

    it 'assigns a new item to @item' do
      expect(assigns(:item)).to be_a_new(Item)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do

    before { get :edit, params: { id: item } }

    it 'assigns to requested item to @item' do
      expect(assigns(:item)).to eq item
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new item in the database' do
        expect { post :create, params: { item: attributes_for(:item) } }.to change(Item, :count).by(1)
      end

      it 'renders show view' do
        #post :create, item: attributes_for(:item)
        post :create, params: {item: attributes_for(:item)}
        expect(response).to redirect_to item_path(assigns(:item))
      end
    end

    context 'with invalid attributes' do
      it 'to not saves the new item in the database' do
        expect { post :create, params: { item: attributes_for(:invalid_item) } }.to_not change(Item, :count)
      end

      it 're-renders new view' do
        #get :show, params: { id: item }
        post :create, params: { item: attributes_for(:invalid_item) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assigns to requested item to @item' do
        expect { patch :update, params: { id: item, item: attributes_for(:item) }}
        expect(assigns(:item)) == item
      end

      it 'change item attributes' do
        patch :update, params: { id: item, item: {title: "new title", body: "new body"}}
        item.reload
        expect(item.title).to eq "new title"
        expect(item.body).to eq "new body"
      end

      it 'redirects to the updated item' do
        patch :update, params: { id: item, item: attributes_for(:item) }
        expect(response).to redirect_to item_path(assigns(:item))
      end
    end

    context 'invalid attributes' do
      before {patch :update, params: { id: item, item: {title: "new title", body: nil}}}
      it 'does not change the item attributes' do
        item.reload
        expect(item.title).to eq "my string"
        expect(item.body).to eq "my text"
      end

      it 're-renders edit view' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before {item}
    it 'deletes item' do
      expect { delete :destroy, params: { id: item } }.to change(Item, :count).by(-1)
    end
  end
end
