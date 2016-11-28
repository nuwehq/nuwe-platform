class UserSerializer < ActiveModel::Serializer

  attributes :id, :email, :measurements, :bmi, :weight, :height, :bpm, :blood_pressure, :nu_score, :biometric_score, :activity_score, :nutrition_score, :nutrition

  has_one :profile
  has_many :tokens
  has_many :preferences

  def biometric_score
    {
      score: object.biometric_score,
      freshness: 99
    }
  end

  def activity_score
    {
      score: object.activity_score,
      freshness: 98
    }
  end

  def nutrition_score
    {
      score: object.nutrition_score,
      freshness: 97
    }
  end

  def nutrition
    Measurement::GdaCalculator.new(object).calculate
  rescue Measurement::GdaCalculator::DcnNeededError => error
    {error: {message: error.message}}
  end

end
