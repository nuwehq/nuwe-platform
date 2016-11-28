## NUWE Platform

![build status](https://codeship.io/projects/18b39a80-94ff-0132-a925-7662f2587706/status)

This is a web application that can be used to power your business API, providing an environment for rapid iteration of new ideas, products and services.

At the heart of this application, is the JSON API and it also serves up the developer platform, which allows developers to create an application to consume your web services, API endpoints and business logic.

### Who Can Use It?

Anyone who has a business with an interest in building new digital products and services, that requires a scaleable back end platform, access to data and other rich features in order to build new and personalised front end experiences for their customers.

You can focus your investment on things that matter for your customers, and let the Nuwe platform handle much of the investment in back end technology.

Companies using the Nuwe platform include those in Healthcare, Sports & fitness, Ticketing, IoT Hardware creators, Medical Device companies, Social Care services, Web Development services and really, the limit is your imagination.


### Core Stack

It's a Ruby on Rails application. You need to know ruby, the rails framework and associated tools to really get to grips with customising the current code base for your needs.

We’ve tried to develop the Rails app with the least amount of magic and the least amount of gems. We have found that this allows us to be more flexible when things need to change.

If you'd like help figuring out how you can use the Nuwe platform for your company, with installation & setup or custom feature development, speak to our [Preferred Partner](http://beach.io)


### Key Features

Core User Class is centralised to a single identity. Users can share data between applications using OAuth2 and Scopes.

API-first design - all resources have available endpoints, available through either Bearer token or App ID / Secret authorisation.

Extensible data sources through Service Integrations

Flexible commercial options - you can charge users of your Nuwe instance for access and usage, with account level subscriptions, per site subscriptions and per Service subscriptions.


### Design philosophy

We have a very good test suite, so we can stay up to date with versions. To run all the tests, just use `bin/rake`.

Asset pipeline is only used for /apps.

We use PostgreSQL as the core database. We prefer it, because of strict type checks, performance, stability.

Case insensitive search in PostgreSQL using `citext`.

`active_model_serializers` for JSON output.

Rails `has_secure_password` for authentication.

Some rack middlewares for CORS and request throttling.

Sidekiq for background workers.

Doorkeeper as the Oauth2 provider for the developer platform.

### Engines

Engines are small, self contained apps that live inside the core application, making it easier to structure and manage concerns as the platform grows.

For example, in the Nuwe Health Platform, I have written engines for taking measurements. Every kind of data that we fetch from HumanAPI, Withings, Moves, Fitbit and the iOS M7 chip is in the measurement engine.
The calculation of the scores from those measurements, is in the Nu engine. Both are in the engines folder.

It will take you some time to get to know these engines, but I felt that moving this outside the main app makes everything smaller and easier to understand.

### Column creation and data tables

Users can create their own columns and data tables via the API for use on the developer platform. When a user connects a medical device on the platform, a `medical_device.token` is given, which is used in the URI to make requests for both `device_results` (data) and `column_values` (columns). Both `device_results` and `column_values` have a `belongs_to` relationship with the `medical_device`.

## Production environment

The application is managed through [Cloud 66](https://app.cloud66.com). You can SSH to the server(s) using the [Cloud66 Toolbelt](http://help.cloud66.com/toolbelt/toolbelt-introduction).


## Elastic Search

Nuwe uses Elastic Search for rich text search capabilities out of the box.

We use the very useful and battle-tested [SearchKick](https://github.com/ankane/searchkick) gem to manage Elastic Search in our rails app.

After initial setup it's important to populate the Elasticsearch indexes:

```
Ingredient.reindex
Meal.reindex
```

### Parse server

We also have the ability to add individual [Parse-Server](https://github.com/ParsePlatform/parse-server) instances to a developer app which gives a fully flexible, hosted development, resource endpoints and client SDKs out of the box. Parse-Server is a node.js / express.js instance with MongoDB database. You can create multiple parse-server instances with a single MongoDB easily using the Nuwe platform.

You'll want to use [our Fork](https://github.com/nuwehq/nuwe-parse-server) of the main Parse Server repo for using with Nuwe Platform.

TODO: We need to update this fork to the latest version of Parse-Server and have a better process for keeping it up to date.

### Image Uploads

Certain models, such as Users, Meals & Products allow for images to be uploaded to the platform.

By default, images will be uploaded using the [Paperclip](https://github.com/thoughtbot/paperclip) gem to your app's database. This probably isn't ideal and you'll want to instead upload images to Amazon S3. This is [quite simple to enable](https://github.com/thoughtbot/paperclip/wiki/Paperclip-with-Amazon-S3), using Paperclip.

Beware that depending on the version of Paperclip and AWS SDK you are using, there are some configurations required, I'll write a wiki page on this soon.

### Secrets

Application secrets such as API keys must never be stored in Ruby code. Secrets must be placed in an environment variable, and used via the `ENV` in Ruby. When you want to add secrets to the code, put fake values in the `config/application.yml` file for working with them locally and place the actual secrets in the environment variables sheet on the your stack.

### Exception Handling

Currently the app is setup to log exceptions using Airbrake. The example in the code, sends these exceptions to [Codebase](http://codebasehq.com), but you can change this for any exception tracking service, like [Rollbar](http://rollbar.com) or [LogEntries](http://logentries.com). These are generally all paid services, so pay attention to the pricing plans and usage.

For Codebase, you can find in `config/initializers/airbrake.rb`:

```
Airbrake.configure do |config|
  config.host = 'exceptions.codebasehq.com'
  config.api_key = 'YOUR API KEY'
end
```

Add your codebase API key where stated to start logging exceptions.

### Deployment

This is completely optional, but...

We like to use Continuous Integration for managing deployments to our cloud hosting provider (e.g. AWS EC2, Rackspace Cloud, Digital Ocean etc.). Before getting to a deployment, we like to run the code through a process that runs our test suite. If the tests pass, then the deploy is allowed to continue. If not, the team is notified and fixes can be made before deployment can be completed.

We have this linked to our repository, so when we push to a branch it will automatically run the tests. If the branch is master, then successful tests result will then deploy automatically. Sweet!

Our preferred service for running the tests is [Codeship](https://www.codeship.io), but you can use your preferred service.

Alternatively you can manually deploy the master branch using Cloud66 by hitting the 'Deploy Stack' button.

We used to use [Capistrano](http://capistranorb.com/) and [Ansible](https://www.ansible.com/) for managing deployments, so you may still find code in the project that relates to this (the ansible script is in another repo). You could also use this in future if you prefer.

### Hosting

Nuwe developer platform will run on most Cloud Hosting providers, including

[AWS](https://aws.amazon.com/) - recommended!
[Rackspace Cloud](https://www.rackspace.com/cloud)
[Digital Ocean](https://www.digitalocean.com/)

### System dependencies

These additional software components need to be installed and running:

* PostgreSQL
* Redis
* Elasticsearch

## development

### Development setup

```
bundle
```

If you'd like to run the background jobs:

```
bundle exec sidekiq
```

### Database initialization

Name your database in `config/database.rb`

```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5

development:
  <<: *default
  database: YOURNAME_development

test:
  <<: *default
  database: YOURNAME_test
```

to create your database:

```
bin/rake db:create
```

or to run the full database setup, including running the `db/seeds.rb`:

```
bin/rake db:setup
```

if you want to drop your database and setup again:

```
bin/rake db: drop db:setup
```


### How to run the test suite

```
bin/rake
```

## api versions

V3 is the latest version of the API. It takes the Doorkeeper applications from the development platform into account.

## api documentation

Every time you change API methods, you should update your API documentation. This
is currently maintained in a separate folder, using Slate. The code for the Docs can be found on Github.

See `slate/README.md` for more information.


## api throttling

Implemented by `Rack::Attack`. See `config/initializers/rack_attack.rb` for its configuration.
`Rack::Attack` is a good enough solution for now, to prevent abusive clients.
However for per-user throttling a different solution must be created.

# Custom development

[Beach.io](http://beach.io), is available for custom installations, development of new features, support and maintenance. [Speak to Steve](steve@beach.io) for more information.

# Resources

[Community Discussion at the GUILD](http://guild.beach.io)
[Nuwe Blog](http://blog.nuwe.co)

[Health Platform Example Demo](http://developer.nuwe.co)


# authors

```
Steve Schofield <steve@beach.io>
Joost Baaij <joost@spacebabies.nl>
Melanie Keatley <melanie@spacebabies.nl>
```
