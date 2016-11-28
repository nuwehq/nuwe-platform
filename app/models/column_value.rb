class ColumnValue < ActiveRecord::Base

  self.inheritance_column = nil # because we have a column "type"

  belongs_to :medical_device

end
