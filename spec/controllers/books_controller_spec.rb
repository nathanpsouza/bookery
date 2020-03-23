require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:params) { { id: book.slug } }

  describe 'GET #index' do
    let!(:books) { FactoryBot.create_list(:book, 3) }

    it 'return http status ok' do
      get :index 
      expect(response).to have_http_status(:ok)
    end

    it 'return books on json' do
      get :index
      json = JSON.parse(response.body)
      expect(json['books'].count).to eq(3)
    end
  end

  describe 'GET #show' do
    context 'when book exists' do
      let(:book) { FactoryBot.create(:book) }

      before :each do
        get :show, params: params
      end

      it 'return http status ok' do
        expect(response).to have_http_status(:ok)
      end
      
      it 'return book on json' do
        json = JSON.parse(response.body)
        expect(json['book']['title']).to eq(book.title)
        expect(json['book']['description']).to eq(book.description)
      end
    end

    context 'when book do not exist' do
      it 'return http status not found' do
        get :show, params: { id: -9999 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    let(:payload) do
      { book: book_attributes }.to_json
    end

    context 'with valid params' do
      let(:book_attributes) { FactoryBot.attributes_for(:book) }

      it 'save book on database' do
        expect {
          post :create, body: payload, as: :json
        }.to change(Book, :count).by(1)
      end

      it 'return http status created' do
        post :create, body: payload, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'return new book on json' do
        post :create, body: payload, as: :json
        json = JSON.parse(response.body)
        expect(json['book']['title']).to eq(book_attributes[:title])
        expect(json['book']['description']).to eq(book_attributes[:description])
      end
    end

    context 'with invalid params' do
      let(:book_attributes) { FactoryBot.attributes_for(:book, title: nil) }
      
      it 'do not save book on database' do
        expect {
          post :create, body: payload, as: :json
        }.to_not change(Book, :count)
      end

      it 'return http status unprocesable entity' do
        post :create, body: payload, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return errors on json' do
        post :create, body: payload, as: :json
        json = JSON.parse(response.body)
        expect(json['errors']).to_not be_empty
      end
    end
  end

  describe 'PUT #update' do
    let!(:book) { FactoryBot.create(:book) }
    let(:payload) do
      { book: book_attributes }.to_json
    end

    context 'with valid params' do
      let(:book_attributes) { FactoryBot.attributes_for(:book) }

      it 'save book changes on database' do
        put :update, params: params, body: payload, as: :json
        book.reload
        expect(book.title).to eq(book_attributes[:title])
        expect(book.description).to eq(book_attributes[:description])
      end

      it 'return http status ok' do
        put :update, params: params, body: payload, as: :json
        expect(response).to have_http_status(:ok)
      end

      it 'return new book on json' do
        put :update, params: params, body: payload, as: :json
        json = JSON.parse(response.body)
        expect(json['book']['title']).to eq(book_attributes[:title])
        expect(json['book']['description']).to eq(book_attributes[:description])
      end
    end

    context 'with invalid params' do
      let(:book_attributes) { FactoryBot.attributes_for(:book, title: nil) }
      
      it 'do not save book on database' do
        old_title = book.title
        old_description = book.description

        put :update, params: params, body: payload, as: :json
        
        book.reload

        expect(book.title).to eq(old_title)
        expect(book.description).to eq(old_description)
      end

      it 'return http status unprocesable entity' do
        put :update, params: params, body: payload, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return errors on json' do
        put :update, params: params, body: payload, as: :json
        json = JSON.parse(response.body)
        expect(json['errors']).to_not be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:book) { FactoryBot.create(:book) }

    it 'return http status ok' do
      delete :destroy, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'return blank json response' do
      delete :destroy, params: params
      expect(response.body).to eq("")
    end

    context 'without pages' do
      it 'remove book from database' do
        expect {
          delete :destroy, params: params 
        }.to change(Book, :count).by(-1)
      end
    end

    context 'with pages' do
      let!(:pages) { FactoryBot.create_list(:page, 2, book: book) }

      it 'remove book from database' do
        expect {
          delete :destroy, params: params 
        }.to change(Book, :count).by(-1)
      end

      it 'remove pages from database' do
        expect {
          delete :destroy, params: params 
        }.to change(Page, :count).by(-2)
      end
    end
  end
end
