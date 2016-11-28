# Since measurement namespace is also the same name as an engine,
# it is necessary to patch kaminari so it knows to look for this
# in the main_app and not in the measurement engine.

module Kaminari
  module Helpers
    class Tag
      def page_url_for(page)
        @template.main_app.url_for @params.merge(@param_name => (page))
      end
    end
  end
end
