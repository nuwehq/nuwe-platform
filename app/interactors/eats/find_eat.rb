class Eats::FindEat
  include Interactor

  def call
    eat = context.eat
    eat.user = context.user

    if eat.update context.eat_params
      context.eat = eat
    else
      context.status = :bad_request
      context.fail! message: eat.errors.full_messages
    end
  end

end