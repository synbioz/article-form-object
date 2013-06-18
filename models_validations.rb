require_relative 'models'

# Patch the Avatar class
Avatar.class_eval do
  def initialize(file, filename)
    if file.respond_to?(:read) && filename.kind_of?(String)
      file_content   = file.read
      file_extension = File.extname filename
      content_hash   = Digest::SHA2.hexdigest file_content
      @filename = content_hash + file_extension
      write!(file_content)
    end
  end

  def valid?
    !!filename
  end
end

# Patch the Post class
Post.class_eval do
  def valid?
    avatar && avatar.valid?
  end
end
