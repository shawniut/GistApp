class GistFile
  include ActiveModel::Serialization
  include ActiveModel::Validations
  extend ActiveModel::Naming
  attr_accessor :id, :filename,:content,:language,:size,:type, :created_at, :updated_at

  validates_presence_of :filename, :content

  def initialize args
    @id               = args[:id]
    @filename         = args[:filename]
    @content          = args[:content]
    @language         = args[:language]
    @size             = args[:size]
    @type             = args[:type]
    @created_at       = args[:created_at]
    @updated_at       = args[:updated_at]
  end

  def build_from_response(response)
    self.id         = response.id
    self.filename   = response.filename
    self.language   = response.language
    self.size       = response.size
    self.type       = response.type
  end

  def to_api
    api_hash={}
    api_hash[filename] = {
      content:content
    }
    api_hash
  end

end