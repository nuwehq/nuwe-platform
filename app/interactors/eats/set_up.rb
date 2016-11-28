require 'interactor'

class Eats::SetUp
  include Interactor

  def call
    eat = Eat.new context.eat_params
    eat.user = context.user

    if eat.save
      context.eat = eat
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: eat.errors.full_messages
    end
  end

end
