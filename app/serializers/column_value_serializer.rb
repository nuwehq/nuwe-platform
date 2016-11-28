class ColumnValueSerializer < ActiveModel::Serializer
  attributes :id, :fieldname, :type, :readonly, :editor, :visible

  def fieldname
    object.field_name
  end

  def readonly
    object.read_only
  end
end
