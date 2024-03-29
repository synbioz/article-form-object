require 'sinatra'
require_relative 'models'
require_relative 'form_objects'

# Use in memory arrays instead of a persistence layer
$avatars = []
$posts   = []

set :public_folder, Avatar::STORE_DIR

# List all posts
get '/' do
  erb :index
end

# Display the for to add a new post
get '/new' do
  erb :new
end

# Display the full post
get '/view/:id' do
  @post = $posts[params[:id].to_i]
  erb :view
end

# Submit a new post
post '/' do
  form_object = CreatePostForm.new(params)
  if form_object.success?
    $avatars << form_object.avatar
    $posts   << form_object.post
    redirect to("/view/#{$posts.size - 1}")
  else
    redirect to('/new') # TODO: Add an error message
  end
end

__END__

@@ layout
  <html>
    <head>
    </head>
    <body>
      <%= yield %>
    </body>
  </html>

@@ index
  <ul>
    <% $posts.each_with_index do |post, index| %>
      <li>
        <a href="/view/<%= index %>">
          <span class="author"><%= post.author %></span>
          <span class="content"><%= post.content[0..30] %></span>
        </a>
      </li>
    <% end %>
    <a href="/new">New post</a>
  <ul>

@@ new
  <form action="/" method="post" enctype="multipart/form-data">
    <p>
      <label for="author">Author</label>
      <input id="author" type="text" name="author" />
    </p>
    <p>
      <label for="new_avatar">New avatar</label>
      <input id="new_avatar" type="file" name="new_avatar" />
      OR
      <label for="existing_avatar">Existing avatar</label>
      <select id="existing_avatar" name="existing_avatar">
        <option value="">None</option>
        <% $avatars.each_with_index do |avatar, index| %>
          <option value="<%= index %>"><%= avatar.filename %></option>
        <% end %>
      </select>
    </p>
    <p>
      <label for="content">Content</label>
      <textarea id="content" name="content"></textarea>
    </p>
    <p>
      <input type="submit" value="Add a new post" />
    </p>
  </form>
  <a href="/">Home</a>

@@ view
  <p>
    <span class="author"><%= @post.author %></span>
    <span class="avatar"><img src="/<%= @post.avatar.filename %>" /></span>
  </p>
  <div>
    <%= @post.content %>
  </div>
  <a href="/">Home</a>
