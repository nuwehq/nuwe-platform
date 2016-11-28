class ProductSerializer < ActiveModel::Serializer
  attributes :id, :upc, :name, :brand, :weight, :type, :lat, :lon, :favourite, :serving_size, :kcal, :protein, :fibre, :carbs, :fat_u, :fat_s, :salt, :sugar, :preview, :raw_nutritional_data

  attribute :factual_ingredients, :key => :ingredient_names

  def raw_nutritional_data
    {
      serving_size: object.serving_size,
      servings: object.other_nutrients["servings"],
      kcal:    object.kcal,
      fat_kcal: object.other_nutrients["fat_calories"],
      total_fat: object.other_nutrients["total_fat"],
      fat_s:   object.fat_s,
      fat_u:   object.fat_u,
      fat_polyunsat: object.other_nutrients["polyunsat_fat"],
      fat_monounsat: object.other_nutrients["monounsat_fat"],
      cholesterol: object.other_nutrients["cholesterol"],
      sodium:    object.salt,
      potassium: object.other_nutrients["potassium"],
      carbs:   object.carbs,
      fibre:   object.fibre,
      soluble_fibre: object.other_nutrients["soluble_fiber"],
      insoluble_fibre: object.other_nutrients["insoluble_fiber"],
      sugar:   object.sugar,
      sugar_alcohol: object.other_nutrients["sugar_alcohol"],
      protein: object.protein,
      vitamin_a: object.other_nutrients["vitamin_a"],
      vitamin_c: object.other_nutrients["vitamin_c"],
      calcium: object.other_nutrients["calcium"],
      iron: object.other_nutrients["iron"]
    }
  end


  has_many :images
  has_many :places

  def favourite
    if current_user.present?
      object.users.include?(current_user)
    else
      []
    end
  end

  def preview
    if current_user.present?
      MealPreview.new(current_user, product: self).results
    else
      []
    end
  rescue MealPreview::DcnNeededError => message
    {error: {message: message}}
  end

end
