class Gist
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_accessor :id, :description, :created_at, :comments, :files

  validates_presence_of :description

  def initialize args
    @id           = args[:id]
    @description  = args[:description]
    @created_at   = args[:created_at]
    @comments     = args[:comments]
    @files        = args[:files].map { |v| GistFile.new(v) } if args[:files].present?

  end

  def build_from_response(object)
    self.id           = object.id
    self.description  = object.description
    self.created_at   = DateTime.parse(object.created_at)
    self.files        = object.file.map { |f| GistFile.new(filename:f.filename,language:f.language,type:f.type) }
  end

  def to_api
    {
      description: description,
      public: false,
      files: self.files.map{|f|f.to_api}.reduce({}, :merge)
    }
  end

end