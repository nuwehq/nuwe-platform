require 'interactor'
require 'factual'
require 'uri'

# Could not find this product in our db, find it on factual db.
class ProductInteractor::CreateFromFactual

  include Interactor

  def call
    return if context.product.present?

    if factual_product.present?

      if factual_product["calories"].present?
        context.product = edible_product
      else
        context.product = inedible_product
      end

      if context.product.save
        if factual_product["image_urls"].present?
          factual_product["image_urls"].each do |url|
            begin
              unless context.product.images.create image: URI.parse(url)
                Rails.logger.debug "unable to save image #{url}"
              end
            rescue => error
              Rails.logger.debug error.message
            end
          end

          # We need to clear out invalid images; so reload the entire product from the database.
          context.product.reload
        end
      else
        context.status = :bad_request
        context.fail! message: context.product.errors.full_messages
      end

    else
      context.status = :not_found
      context.fail! message: ["Could not find product info"]
    end
  end

  private

  def factual
    Factual.new(context.remote_application_key, context.remote_application_secret)
  end

  def factual_product
    context.factual_product ||= factual.table("products-cpg-nutrition").filters("upc" => context.upc).last
  end

  # create edible product from raw data
  # nutritional details are per serving, because Factual's serving sizes are erratic at best
  def edible_product
    Product.create_with({
      name: factual_product["product_name"],
      brand: factual_product["brand"],
      weight: factual_product["unit_weight"],
      serving_size: factual_product["serving_size"],
      kcal: factual_product["calories"],
      protein: factual_product["protein"],
      fibre: factual_product["dietary_fiber"],
      carbs: factual_product["total_carb"],
      fat_u: factual_product["trans_fat"],
      fat_s: factual_product["sat_fat"],
      salt: factual_product["sodium"],
      sugar: factual_product["sugars"],
      factual_ingredients: factual_product["ingredients"],
      eat_ready: true,
      other_nutrients: {
        servings: factual_product["servings"],
        fat_kcal: factual_product["fat_calories"],
        total_fat: factual_product["total_fat"],
        fat_polyunsat: factual_product["polyunsat_fat"],
        fat_monounsat: factual_product["monounsat_fat"],
        cholesterol: factual_product["cholesterol"],
        soluble_fibre: factual_product["soluble_fiber"],
        insoluble_fibre: factual_product["insoluble_fiber"],
        sugar_alcohol: factual_product["sugar_alcohol"],
        potassium: factual_product["potassium"],
        calcium: factual_product["calcium"],
        iron: factual_product["iron"],
        vitamin_a: factual_product["vitamin_a"],
        vitamin_c: factual_product["vitamin_c"]
      }
    }).find_or_initialize_by({
      upc: factual_product["upc"]
    })
  end

  # Create non-edible product from raw data
  def inedible_product
    Product.create_with({
        name: factual_product["product_name"],
        brand: factual_product["brand"],
        eat_ready: false
      }).find_or_initialize_by({
        upc: factual_product["upc"]
      })
  end

end
