class Admin::VideosController < AdminsController
  before_filter :require_user

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Your video has been added."
      redirect_to new_admin_video_path
    else
      flash.now[:danger] = "There were some errors adding your video."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover, :video_url)
  end
end
