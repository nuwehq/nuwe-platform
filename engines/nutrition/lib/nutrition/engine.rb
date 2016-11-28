module Nutrition
  class Engine < ::Rails::Engine
    isolate_namespace Nutrition

    # http://pivotallabs.com/leave-your-migrations-in-your-rails-engines/
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    rake_tasks do
      load root.join("lib", "tasks", "nutrition_tasks.rake")
    end
  end
end
