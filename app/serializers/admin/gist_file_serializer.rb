class Admin::GistFileSerializer < ActiveModel::Serializer
  attributes :id, :filename,:content,:language,:size,:type,:created_at, :updated_at, :deleted, :old_filename

  def deleted
    false
  end
  def old_filename
    object.filename
  end
end