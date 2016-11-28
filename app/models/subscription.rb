class Subscription < ActiveRecord::Base

  has_many :purchases, dependent: :nullify

  def formatted_price
    if self.price % 100 == 0
      "$#{self.price / 100}"
    else
      "$#{(self.price / 100.to_f)}"
    end
  end

  DURATION = 1.month

end
