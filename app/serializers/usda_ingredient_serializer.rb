class UsdaIngredientSerializer < ActiveModel::Serializer
  attributes :id, :name, :summary, :detailed

  def summary
    {
      protein: object.protein,
      carbs:   object.carbs,
      kcal:    object.kcal,
      fibre:   object.fibre,
      fat_s:   object.fat_s,
      fat_u:   object.fat_u,
      salt:    object.salt,
      sugar:   object.sugar
    }
  end

  def detailed
    {
      proximates: object.proximates,
      minerals:   object.minerals,
      vitamins:   object.vitamins,
      lipids:     object.lipids,
      other:      object.other,
      portions:   object.portions
    }
  end

end
