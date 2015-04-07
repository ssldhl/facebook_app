class MainController < ApplicationController
  before_action :authenticate_user!, :subscribed
  def index
  end
end
