module Measurement

  class GdaCalculator
    # transforms the DCN to KCAL
    MALE_DCN_TO_KCAL_PROTEIN = 13.3
    MALE_DCN_TO_KCAL_CARBS = 41.1
    MALE_DCN_TO_KCAL_FAT_U  = 19.9
    MALE_DCN_TO_KCAL_FAT_S = 9.2
    MALE_DCN_TO_KCAL_SUGAR = 16.4

    FEMALE_DCN_TO_KCAL_PROTEIN = 13.9
    FEMALE_DCN_TO_KCAL_CARBS = 41.5
    FEMALE_DCN_TO_KCAL_FAT_U = 20.2
    FEMALE_DCN_TO_KCAL_FAT_S = 8.1
    FEMALE_DCN_TO_KCAL_SUGAR = 16.3

    FIBRE_FIXED = 24
    SALT_FIXED = 6

    # transforms the KCAL to grams
    KCAL_TO_G_PROTEIN = 4.08
    KCAL_TO_G_CARBS_SUGAR = 3.98
    KCAL_TO_G_FAT = 8.92

    class DcnNeededError < ArgumentError; end

    def initialize(user)
      @user = user
      raise DcnNeededError, "User #{user.id} <#{user.email}> has no profile" if @user.profile == nil
      @sex = user.profile.sex
      @dcn = user.historical_scores.find_by(date: Date.current).try(:dcn).to_f

      raise DcnNeededError, "User #{user.id} <#{user.email}> has no DCN." if @dcn == 0.0
      
    end

    def calculate
      if @sex == "M"
        {
          "personalised_gda" => 
            {
            "kcal" => 
              {"g" => @dcn,
              "kcal" => @dcn },
            "protein" => 
              {"g" => (@dcn * MALE_DCN_TO_KCAL_PROTEIN/100) /KCAL_TO_G_PROTEIN,
              "kcal" => @dcn * MALE_DCN_TO_KCAL_PROTEIN/100},
            "fibre" => 
              {"g" => FIBRE_FIXED,
              "kcal" => 0},
            "carbs" => 
              {"g" => (@dcn *  MALE_DCN_TO_KCAL_CARBS/100) /KCAL_TO_G_CARBS_SUGAR,
              "kcal" => @dcn *  MALE_DCN_TO_KCAL_CARBS/100},
            "fat_u" => 
              {"g" => (@dcn * MALE_DCN_TO_KCAL_FAT_U/100) /KCAL_TO_G_FAT,
              "kcal" => @dcn * MALE_DCN_TO_KCAL_FAT_U/100},
            "fat_s" => 
              {"g" => (@dcn * MALE_DCN_TO_KCAL_FAT_S/100) /KCAL_TO_G_FAT,
              "kcal" => @dcn * MALE_DCN_TO_KCAL_FAT_S/100 },
            "salt" => 
              {"g" => SALT_FIXED,
              "kcal" => 0},
            "sugar" => 
              {"g" => (@dcn * MALE_DCN_TO_KCAL_SUGAR/100) /KCAL_TO_G_CARBS_SUGAR,
              "kcal" => @dcn * MALE_DCN_TO_KCAL_SUGAR/100},  
            }
          }
      elsif @sex == "F"
        {
          "personalised_gda" => 
            {
            "kcal" => 
              {"g" => @dcn,
              "kcal" => @dcn },
            "protein" => 
              {"g" => (@dcn * FEMALE_DCN_TO_KCAL_PROTEIN/100) /KCAL_TO_G_PROTEIN,
              "kcal" => @dcn * FEMALE_DCN_TO_KCAL_PROTEIN/100},
            "fibre" => 
              {"g" => FIBRE_FIXED,
              "kcal" => 0},
            "carbs" => 
              {"g" => (@dcn *  FEMALE_DCN_TO_KCAL_CARBS/100) /KCAL_TO_G_CARBS_SUGAR,
              "kcal" => @dcn *  FEMALE_DCN_TO_KCAL_CARBS/100},
            "fat_u" => 
              {"g" => (@dcn * FEMALE_DCN_TO_KCAL_FAT_U/100) /KCAL_TO_G_FAT,
              "kcal" => @dcn * FEMALE_DCN_TO_KCAL_FAT_U/100},
            "fat_s" => 
              {"g" => (@dcn * FEMALE_DCN_TO_KCAL_FAT_S/100) /KCAL_TO_G_FAT,
              "kcal" => @dcn * FEMALE_DCN_TO_KCAL_FAT_S/100 },
            "salt" => 
              {"g" => SALT_FIXED,
              "kcal" => 0},
            "sugar" => 
              {"g" => (@dcn * FEMALE_DCN_TO_KCAL_SUGAR/100) /KCAL_TO_G_CARBS_SUGAR,
              "kcal" => @dcn * FEMALE_DCN_TO_KCAL_SUGAR/100},  
            }
          }
      end
    end
  end
end
