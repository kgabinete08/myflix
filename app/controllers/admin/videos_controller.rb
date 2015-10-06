class Admin::VideosController < ApplicationController
  before_filter :require_user, :require_admin

  def new
    @video = Video.new
  end
end