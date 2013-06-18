class CreatePostForm
  attr_reader :post, :avatar

  def initialize(form_params)
    @post    = nil
    @avatar  = nil
    @params  = form_params
    @success = build_avatar! && build_post!
  end

  def success?
    !!@success
  end

private

  def build_avatar!
    @avatar = @params[:existing_avatar] != "" ?
      find_avatar(@params[:existing_avatar]) :
      create_new_avatar(@params[:new_avatar])
  rescue
    false
  end

  def build_post!
    author  = @params[:author]
    content = @params[:content]
    @post   = Post.new @params[:author], @avatar, @params[:content]
  end

  def find_avatar(id)
    $avatar[id.to_i]
  end

  def create_new_avatar(rack_file_upload)
    tempfile = rack_file_upload[:tempfile]
    filename = rack_file_upload[:filename]
    Avatar.new(tempfile, filename)
  end
end
