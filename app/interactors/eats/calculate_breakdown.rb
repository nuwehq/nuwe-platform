class Eats::CalculateBreakdown
  include Interactor

  def call
    breakdown = Nutrition::Calculate::Breakdown.new(context.user, context.eat.eaten_on).results["breakdown"]

    Nutrition::Breakdown.where(date: context.eat.eaten_on).destroy_all
    context.breakdown = Nutrition::Breakdown.create!(
      date: context.eat.eaten_on,
      user: context.user,
      kcal_g: breakdown["kcal"]["g"],
      kcal_perc: breakdown["kcal"]["perc"],
      protein_g: breakdown["protein"]["g"],
      protein_perc: breakdown["protein"]["perc"],
      fibre_g: breakdown["fibre"]["g"],
      fibre_perc: breakdown["fibre"]["perc"],
      carbs_g: breakdown["carbs"]["g"],
      carbs_perc: breakdown["carbs"]["perc"],
      fat_u_g: breakdown["fat_u"]["g"],
      fat_u_perc: breakdown["fat_u"]["perc"],
      fat_s_g: breakdown["fat_s"]["g"],
      fat_s_perc: breakdown["fat_s"]["perc"],
      salt_g: breakdown["salt"]["g"],
      salt_perc: breakdown["salt"]["perc"],
      sugar_g: breakdown["sugar"]["g"],
      sugar_perc: breakdown["sugar"]["perc"]
    )

  rescue Nutrition::Calculate::Breakdown::ArgumentError => message
    context.fail! message: [message]
  end

end
