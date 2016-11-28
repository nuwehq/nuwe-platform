class Nutrition::BreakdownSerializer < ActiveModel::Serializer

  attributes :user_id, :date, :kcal_g, :kcal_perc, :protein_g, :protein_perc, :fibre_g, 
  :fibre_perc, :carbs_g, :carbs_perc, :fat_u_g, :fat_u_perc, :fat_s_g, :fat_s_perc, :salt_g,
  :salt_perc, :sugar_g, :sugar_perc

end
