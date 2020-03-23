require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let!(:book) { FactoryBot.create(:book) }
  let(:params) { { book_id: book.slug, id: page.id } }

  describe 'GET #index' do
    let!(:pages) { FactoryBot.create_list(:page, 3, book: book) }

    it 'return http status ok' do
      get :index, params: { book_id: book.slug }
      expect(response).to have_http_status(:ok)
    end

    it 'return pages on json' do
      get :index, params: { book_id: book.slug }
      json = JSON.parse(response.body)
      expect(json['pages'].count).to eq(3)
    end
  end

  describe 'GET #show' do
    context 'when page exists' do
      context 'without format param' do
        let(:page) { FactoryBot.create(:page, book: book) }

        before :each do
          get :show, params: params
        end

        it 'return http status ok' do
          expect(response).to have_http_status(:ok)
        end
        
        it 'return page on json' do
          json = JSON.parse(response.body)
          expect(json['page']['content']).to eq(page.content)
          expect(json['page']['page_number']).to eq(page.page_number)
        end
      end

      context 'with format param' do
        let(:page) do
          content = '**bold text**'
          FactoryBot.create(:page, book: book, content: content)
        end

        context 'html' do
          it 'return parsed content' do
            get :show, params: params.merge(format: 'html')
            json = JSON.parse(response.body)
            expect(json['page']['content']).to eq("<p><strong>bold text</strong></p>\n")
          end
        end

        context 'txt' do
          it 'return parsed content' do
            get :show, params: params.merge(format: 'txt')
            json = JSON.parse(response.body)
            expect(json['page']['content']).to eq("bold text\n")
          end
        end
      end
    end

    context 'when page do not exist' do
      it 'return http status not found' do
        get :show, params: { book_id: book.slug, id: -9999 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    let(:payload) do
      { page: page_attributes }.to_json
    end

    context 'with valid params' do
      let(:page_attributes) { FactoryBot.attributes_for(:page) }

      it 'save page on database' do
        expect {
          post :create, params: { book_id: book.slug }, body: payload, as: :json
        }.to change(Page, :count).by(1)
      end

      it 'return http status created' do
        post :create, params: { book_id: book.slug }, body: payload, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'return new page on json' do
        post :create, params: { book_id: book.slug }, body: payload, as: :json
        json = JSON.parse(response.body)
        expect(json['page']['content']).to eq(page_attributes[:content])
        expect(json['page']['page_number']).to eq(page_attributes[:page_number])
      end
    end

    context 'with invalid params' do
      let(:page_attributes) { FactoryBot.attributes_for(:page, content: nil) }
      
      it 'do not save page on database' do
        expect {
          post :create, params: { book_id: book.slug }, body: payload, as: :json
        }.to_not change(Page, :count)
      end

      it 'return http status unprocesable entity' do
        post :create, params: { book_id: book.slug }, body: payload, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return errors on json' do
        post :create, params: { book_id: book.slug }, body: payload, as: :json
        json = JSON.parse(response.body)
        expect(json['errors']).to_not be_empty
      end
    end
  end

  describe 'PUT #update' do
    let!(:page) { FactoryBot.create(:page, book: book) }
    let(:payload) do
      { page: page_attributes }.to_json
    end

    context 'with valid params' do
      let(:page_attributes) { FactoryBot.attributes_for(:page) }

      it 'save page changes on database' do
        put :update, params: params, body: payload, as: :json
        page.reload
        expect(page.content).to eq(page_attributes[:content])
        expect(page.page_number).to eq(page_attributes[:page_number])
      end

      it 'return http status ok' do
        put :update, params: params, body: payload, as: :json
        expect(response).to have_http_status(:ok)
      end

      it 'return new page on json' do
        put :update, params: params, body: payload, as: :json
        json = JSON.parse(response.body)
        expect(json['page']['content']).to eq(page_attributes[:content])
        expect(json['page']['page_number']).to eq(page_attributes[:page_number])
      end
    end

    context 'with invalid params' do
      let(:page_attributes) { FactoryBot.attributes_for(:page, content: nil) }
      
      it 'do not save page on database' do
        old_content = page.content
        old_page_number = page.page_number

        put :update, params: params, body: payload, as: :json
        
        page.reload

        expect(page.content).to eq(old_content)
        expect(page.page_number).to eq(old_page_number)
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
    let!(:page) { FactoryBot.create(:page, book: book) }

    it 'remove page from database' do
      expect {
        delete :destroy, params: params 
      }.to change(Page, :count).by(-1)
    end

    it 'return http status ok' do
      delete :destroy, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'return blank json response' do
      delete :destroy, params: params
      expect(response.body).to eq("")
    end
  end
end
