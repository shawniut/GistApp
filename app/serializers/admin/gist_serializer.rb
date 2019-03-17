class Admin::GistSerializer < ActiveModel::Serializer
  attributes :id, :description, :created_at,:created_at_display, :comments_count

  has_many :files, serializer: Admin::GistFileSerializer, include: true
  has_many :histories, serializer: Admin::HistorySerializer, include: true
  
  def created_at_display
    Util.pretty_time(object.created_at)
  end

end