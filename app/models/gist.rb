class Gist
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_accessor :id, :description, :created_at,:updated_at, :comments_count, :files,:histories

  validates_presence_of :description

  def initialize args={}
    hash = HashWithIndifferentAccess.new(args)
    puts hash['description']
    puts hash[:description]
    @id                 = hash[:id]
    @description        = hash[:description]
    @created_at         = hash[:created_at]
    @comments_count     = hash[:comments_count]
    @files              = hash[:files].map { |v| GistFile.new(v) } if args[:files].present?
    @histories          = hash[:histories].map { |v| GistFile.new(v) } if args[:histories].present?
  end

  def build_from_response(object)
    self.id                 = object.id
    self.description        = object.description
    self.comments_count     = object.comments
    self.created_at         = DateTime.parse(object.created_at)
    self.updated_at         = DateTime.parse(object.updated_at)
    self.files              = object.files.map { |filename,file| GistFile.new(filename:filename,content:file.content,language:file.language,type:file.type,size:file.size,truncated:file.truncated) }
  end

  def to_api
    {
      description: description,
      public: false,
      files: self.files.map{|f|f.to_api}.reduce({}, :merge)
    }
  end

end