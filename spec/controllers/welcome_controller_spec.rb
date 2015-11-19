require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #route" do
    it "returns http success" do
      get :route, {route: {id: 1}}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #nearby" do
    it "returns http success" do
      get :near_by, stop_id: 1
      expect(response).to have_http_status(:success)
    end
  end
end
