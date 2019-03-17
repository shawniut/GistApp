class Admin::HistorySerializer < ActiveModel::Serializer
  attributes :version, :committed_at, :committed_at_display, :deletions,:additions, :total
  
  def committed_at_display
    Util.pretty_time(object.committed_at)
  end

end