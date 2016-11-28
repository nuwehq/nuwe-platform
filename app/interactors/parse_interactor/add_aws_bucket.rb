class ParseInteractor::AddAwsBucket
  include Interactor

  def call
    application = context.application
    parse_app = application.parse_app

    bucket_name = "parse-app-#{parse_app.application_id}-bucket"
    begin
      bucket = Aws::S3::Bucket.new(name: bucket_name, region: 'eu-west-1')
      response = bucket.create
      if response.location == "http://parse-app-#{parse_app.application_id}-bucket.s3.amazonaws.com/"
        parse_app.bucket = bucket_name
        parse_app.save
        context.parse_app = parse_app
        context.status = :ok
      else
        context.status = :bad_request
        context.fail! message: "Parse App could not be created."
      end

    rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
      parse_app.bucket = bucket_name
      parse_app.save
      context.parse_app = parse_app
      context.status = :ok
    end
  end
end
