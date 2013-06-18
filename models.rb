require 'digest'

Post = Struct.new :author, :avatar, :content

class Avatar
  STORE_DIR = './avatars'

  attr_reader :filename

  def initialize(file, filename)
    file_content   = file.read
    file_extension = File.extname filename
    content_hash   = Digest::SHA2.hexdigest file_content
    @filename = content_hash + file_extension
    write!(file_content)
  end

  private

    def write!(file_content)
      filepath = File.join(STORE_DIR, filename)
      File.open(filepath, 'w') do |file|
        file.write(file_content)
      end
    end
end

# Ensure Avatar::STORE_DIR is present.
unless File.directory?(Avatar::STORE_DIR)
  Dir.mkdir(Avatar::STORE_DIR)
end
