require 'rails_helper'

RSpec.describe RoutesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index, {route: "1_name"}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show", vcr: true do
    it "returns http success" do
      get :show, id: 0
      expect(response).to have_http_status(:success)
    end
  end
end
