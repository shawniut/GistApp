class History
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  attr_accessor :version, :committed_at, :deletions,:additions, :total, :files

  def initialize args={}
    hash = HashWithIndifferentAccess.new(args)
    @version            = hash[:version]
    @committed_at       = hash[:committed_at]
    @deletions          = hash[:deletions]
    @additions          = hash[:additions]
    @total              = hash[:total]
    @files              = hash[:files].map { |v| GistFile.new(v) } if args[:files].present?
  end

end