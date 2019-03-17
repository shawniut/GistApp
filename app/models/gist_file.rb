class GistFile
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_accessor :id, :filename,:old_filename, :content,:language,:size,:type, :raw_url, :created_at, :updated_at,:truncated

  validates_presence_of :filename, :content

  def initialize args={}
    args = HashWithIndifferentAccess.new(args)
    @id               = args[:id]
    @old_filename     = args[:old_filename]
    @filename         = args[:filename]
    @content          = args[:content]
    @language         = args[:language]
    @size             = args[:size]
    @type             = args[:type]
    @created_at       = args[:created_at]
    @updated_at       = args[:updated_at]
  end

  def build_from_response(response)
    self.content    = response.content
    self.filename   = response.filename
    self.language   = response.language
    self.size       = response.size
    self.type       = response.type
    self.raw_url    = response.raw_url
  end

  def to_api
    api_hash={}
    if content == nil
      api_hash[filename] = nil if content == nil
      return api_hash
    end
    if old_filename != nil  && (old_filename != filename)
      api_hash[old_filename] = {
        filename: filename,
        content:content
      }
    else
      api_hash[filename] = {
        content:content
      }
    end
    api_hash
  end

end