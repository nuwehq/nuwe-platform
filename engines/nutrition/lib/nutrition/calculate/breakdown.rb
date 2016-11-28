module Nutrition
  module Calculate

    # Calculate nutritional breakdown of eats
    class Breakdown
      # transforms the DCN to KCAL
      M_DCN_TO_KCAL_PROTEIN = 13.3
      M_DCN_TO_KCAL_CARBS = 41.1
      M_DCN_TO_KCAL_FAT_U  = 19.9
      M_DCN_TO_KCAL_FAT_S = 9.2
      M_DCN_TO_KCAL_SUGAR = 16.4

      F_DCN_TO_KCAL_PROTEIN = 13.9
      F_DCN_TO_KCAL_CARBS = 41.5
      F_DCN_TO_KCAL_FAT_U = 20.2
      F_DCN_TO_KCAL_FAT_S = 8.1
      F_DCN_TO_KCAL_SUGAR = 16.3

      DCN_TO_KCAL_FIBRE = 24
      DCN_TO_KCAL_SUGAR = 6

      # transforms the KCAL to grams
      KCAL_TO_G_PROTEIN = 4.08
      KCAL_TO_G_CARBS_SUGAR = 3.98
      KCAL_TO_G_FAT = 8.92

      def initialize(user, date=Date.current)
        @user = user
        @date = date
        @sex = @user.profile.sex
        @dcn = @user.historical_scores.find_by(date: Date.current).try(:dcn).to_f
      
        raise ArgumentError, "User #{user.id} <#{user.email}> has no DCN." if @dcn == 0.0
        raise ArgumentError, "Sex must be known for user #{@user.id}" if @sex.nil?

      end

      def results
        if @sex == "M"
          { "score" => nutribu_score,
            "breakdown" =>
            {
            "kcal" => {
              "g" => day_eats(:kcal),
              "perc" => percentage_kcal },
            "protein" => { 
              "g" => day_eats(:protein),
              "perc" => percentage(:protein, M_DCN_TO_KCAL_PROTEIN, KCAL_TO_G_PROTEIN)},
            "fibre" => {
              "g" => day_eats(:fibre),
              "perc" => perc_standard(:fibre, DCN_TO_KCAL_FIBRE)},
            "carbs" => {
              "g" => day_eats(:carbs),
              "perc" => percentage(:carbs, M_DCN_TO_KCAL_CARBS, KCAL_TO_G_CARBS_SUGAR)},
            "fat_u" => {
              "g" => day_eats(:fat_u),
              "perc" => percentage(:fat_u, M_DCN_TO_KCAL_FAT_U, KCAL_TO_G_FAT)},
            "fat_s" => {
              "g" => day_eats(:fat_s),
              "perc" => percentage(:fat_s, M_DCN_TO_KCAL_FAT_S, KCAL_TO_G_FAT)},
            "salt" => {
              "g" => day_eats(:salt),
              "perc" => perc_standard(:salt, DCN_TO_KCAL_SUGAR)},
            "sugar" => {
              "g" => day_eats(:sugar),
              "perc" => percentage(:sugar, M_DCN_TO_KCAL_SUGAR, KCAL_TO_G_CARBS_SUGAR)},
            }
          }
        elsif @sex == "F"
          { "score" => nutribu_score,
            "breakdown" =>
            {
            "kcal" => {
              "g" => day_eats(:kcal),
              "perc" => percentage_kcal },
            "protein" => { 
              "g" => day_eats(:protein),
              "perc" => percentage(:protein, F_DCN_TO_KCAL_PROTEIN, KCAL_TO_G_PROTEIN)},
            "fibre" => {
              "g" => day_eats(:fibre),
              "perc" => perc_standard(:fibre, DCN_TO_KCAL_FIBRE)},
            "carbs" => {
              "g" => day_eats(:carbs),
              "perc" => percentage(:carbs, F_DCN_TO_KCAL_CARBS, KCAL_TO_G_CARBS_SUGAR)},
            "fat_u" => {
              "g" => day_eats(:fat_u),
              "perc" => percentage(:fat_u, F_DCN_TO_KCAL_FAT_U, KCAL_TO_G_FAT)},
            "fat_s" => {
              "g" => day_eats(:fat_s),
              "perc" => percentage(:fat_s, F_DCN_TO_KCAL_FAT_S, KCAL_TO_G_FAT)},
            "salt" => {
              "g" => day_eats(:salt),
              "perc" => perc_standard(:salt, DCN_TO_KCAL_SUGAR)},
            "sugar" => {
              "g" => day_eats(:sugar),
              "perc" => percentage(:sugar, F_DCN_TO_KCAL_SUGAR, KCAL_TO_G_CARBS_SUGAR)},
            }
          }
        end
      end

      def score
        nutribu_score
      end

      private

      # All the user's eats for the day.
      def eats
        @user.eats.where(eaten_on: @date)
      end

      # grab nutrients from eats
      def day_eats(attribute)
        day_eats = 0
        eats.each do |eat|
          day_eats += eat.send(attribute)
        end
        day_eats
      end

      # percentage kcal vs. gda
      def percentage_kcal
        day_eats(:kcal) * 100 / @dcn
      end
      # just fibre & salt vs. gda
      def perc_standard(attribute, percentage)
        100 * day_eats(attribute) / (percentage)
      end
      # percentage nutrients vs. gda
      def percentage(attribute, gda, grams)
        (day_eats(attribute) * 100) / (((gda) * @dcn / 100) / (grams))
      end
      
      def nutribu_score
        return 0 if eats.empty?

        if @sex == "M"
          ((score_calculation(percentage_kcal) +
          score_calculation(percentage(:protein, M_DCN_TO_KCAL_PROTEIN, KCAL_TO_G_PROTEIN)) +
          score_calculation(percentage(:carbs, M_DCN_TO_KCAL_CARBS, KCAL_TO_G_CARBS_SUGAR)) +
          score_calculation(percentage(:fat_u, M_DCN_TO_KCAL_FAT_U, KCAL_TO_G_FAT)) +
          score_calculation(percentage(:sugar, M_DCN_TO_KCAL_SUGAR, KCAL_TO_G_CARBS_SUGAR)) +
          fibre_score) / 10.0).round
        elsif @sex == "F"
          ((score_calculation(percentage_kcal) +
          score_calculation(percentage(:protein, F_DCN_TO_KCAL_PROTEIN, KCAL_TO_G_PROTEIN)) +
          score_calculation(percentage(:carbs, F_DCN_TO_KCAL_CARBS, KCAL_TO_G_CARBS_SUGAR)) +
          score_calculation(percentage(:fat_u, F_DCN_TO_KCAL_FAT_U, KCAL_TO_G_FAT)) +
          score_calculation(percentage(:sugar, F_DCN_TO_KCAL_SUGAR, KCAL_TO_G_CARBS_SUGAR)) +
          fibre_score) / 10.0).round
        end
      end

      # fibre has different calculation
      def fibre_score
        if day_eats(:fibre) * 2 > 20
          20
        else
          day_eats(:fibre) * 2
        end
      end 


      # Nutribu scoring
      def score_calculation(percentage)
        if percentage >= 0 && percentage < 9.49 
          10
        elsif percentage >= 9.49 && percentage < 14.49
          15
        elsif percentage >= 14.49 && percentage < 19.49
          20
        elsif percentage >= 19.49 && percentage < 24.49
          31
        elsif percentage >= 24.49 && percentage < 29.49
          42
        elsif percentage >= 29.49 && percentage < 34.49
          53
        elsif percentage >= 34.49 && percentage < 39.49
          64
        elsif percentage >= 39.49 && percentage < 44.49
          75
        elsif percentage >= 44.49 && percentage < 49.49
          86
        elsif percentage >= 49.49 && percentage < 54.49
          97
        elsif percentage >= 54.49 && percentage < 59.49
          108
        elsif percentage >= 59.49 && percentage < 64.49
          119
        elsif percentage >= 64.49 && percentage < 69.49
          130
        elsif percentage >= 69.49 && percentage < 74.49
          141
        elsif percentage >= 74.49 && percentage < 79.49
          152
        elsif percentage >= 79.49 && percentage < 84.49
          163
        elsif percentage >= 84.49 && percentage < 89.49
          174
        elsif percentage >= 89.49 && percentage < 94.49
          185
        elsif percentage >= 94.49 && percentage < 99.49
          196
        elsif percentage >= 99.49 && percentage < 104.49
          196
        elsif percentage >= 104.49 && percentage < 109.49
          182
        elsif percentage >= 109.49 && percentage < 114.49
          168
        elsif percentage >= 114.49 && percentage < 119.49
          154
        elsif percentage >= 119.49 && percentage < 124.49
          140
        elsif percentage >= 124.49 && percentage < 129.49
          126
        elsif percentage >= 129.49 && percentage < 134.49
          112
        elsif percentage >= 134.49 && percentage < 139.49
          98
        elsif percentage >= 139.49 && percentage < 144.49
          84
        elsif percentage >= 144.49 && percentage < 149.49
          70
        elsif percentage >= 149.49 && percentage < 154.49
          66
        elsif percentage >= 154.49 && percentage < 159.49
          62
        elsif percentage >= 159.49 && percentage < 164.49
          58
        elsif percentage >= 164.49 && percentage < 169.49
          54
        elsif percentage >= 169.49 && percentage < 174.49
          50
        elsif percentage >= 174.49 && percentage < 179.49
          46
        elsif percentage >= 179.49 && percentage < 184.49
          42
        elsif percentage >= 184.49 && percentage < 189.49
          38
        elsif percentage >= 189.49 && percentage < 194.49
          34
        elsif percentage >= 194.49 && percentage < 199.49
          30
        elsif percentage >= 199.49 && percentage < 209.49
          26
        elsif percentage >= 209.49 && percentage < 219.49
          22
        elsif percentage >= 219.49 && percentage < 229.49
          18
        elsif percentage >= 229.49 && percentage < 239.49
          14
        elsif percentage >= 239.49 && percentage < 249.49
          10
        elsif percentage >= 249.49 && percentage < 259.49
          8
        elsif percentage >= 259.49 && percentage < 279.49
          6
        elsif percentage >= 279.49 && percentage < 299.49
          4
        elsif percentage > 299.49
          0
        end
      end

    end
  end
end
