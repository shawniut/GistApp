class Admin::GistSerializer < ActiveModel::Serializer
  attributes :id, :description, :created_at, :comments
end