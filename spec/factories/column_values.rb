FactoryGirl.define do

  factory :column_value do
    field_name    { "created_at" }
    type          { "date" }
    read_only     { true }
    editor        { "datePicker" }
  end
end
