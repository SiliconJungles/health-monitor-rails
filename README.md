# doctor-strange

[![Gem Version](https://badge.fury.io/rb/doctor-strange.png)](http://badge.fury.io/rb/doctor-strange)
[![Build Status](https://travis-ci.org/lbeder/doctor-strange.png)](https://travis-ci.org/lbeder/doctor-strange)
[![Dependency Status](https://gemnasium.com/lbeder/doctor-strange.png)](https://gemnasium.com/lbeder/doctor-strange)
[![Coverage Status](https://coveralls.io/repos/lbeder/doctor-strange/badge.png)](https://coveralls.io/r/lbeder/doctor-strange)

Monitoring various services (db, cache, sidekiq/resque, email, redis, payment, etc).

## Examples

### HTML Status Page

![alt example](/docs/screenshots/example.png "HTML Status Page")

### JSON Response

```bash
>> curl -s http://localhost:3000/check.json | json_pp
```

```json
{
	"results": [{
		"name": "Database",
		"message": "",
		"status": "OK"
	}, {
		"name": "Redis",
		"message": "",
		"status": "OK"
	}, {
		"name": "Sidekiq",
		"message": "",
		"status": "OK"
	}, {
		"name": "Email",
		"message": "",
		"status": "OK"
	}, {
		"name": "Payment",
		"message": "",
		"status": "OK"
	}],
	"status": "ok",
	"timestamp": "2018-03-12 16:36:55 +0800"
}
```

### XML Response

```bash
>> curl -s http://localhost:3000/check.xml
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <results type="array">
    <result>
      <name>Database</name>
      <message />
      <status>OK</status>
    </result>
    <result>
      <name>Redis</name>
      <message />
      <status>OK</status>
    </result>
    <result>
      <name>Sidekiq</name>
      <message />
      <status>OK</status>
    </result>
    <result>
      <name>Email</name>
      <message />
      <status>OK</status>
    </result>
    <result>
      <name>Payment</name>
      <message />
      <status>OK</status>
    </result>
  </results>
  <status type="symbol">ok</status>
  <timestamp>2018-03-12 16:38:31 +0800</timestamp>
</hash>
```

## Setup

If you are using bundler add doctor-strange to your Gemfile:

```ruby
gem 'doctor-strange'
```

Then run:

```bash
$ bundle install
```

Otherwise install the gem:

```bash
$ gem install doctor-strange
```

## Usage
You can mount this inside your app routes by adding this to config/routes.rb:

```ruby
mount DoctorStrange::Engine, at: '/'
```

## Supported Service Providers
The following services are currently supported:

* DB
* Cache
* Redis
* Sidekiq
* Resque
* Stripe
* MailGun

## Configuration

### Adding AppName

The app name is `SiliconJungles` by default. You can change to your app name.

```ruby
DoctorStrange.configure do |config|
  config.app_name = "YOUR_APP_NAME"
end
```

### Adding Providers
By default, only the database check is enabled. You can add more service providers by explicitly enabling them via an initializer:

```ruby
DoctorStrange.configure do |config|
  config.cache
  config.redis
  config.sidekiq
  # etc
end
```

We believe that having the database check enabled by default is very important, but if you still want to disable it
(e.g., if you use a database that isn't covered by the check) - you can do that by calling the `no_database` method:

```ruby
DoctorStrange.configure do |config|
  config.no_database
end
```

### Provider Configuration

Some of the providers can also accept additional configuration:

```ruby
# Sidekiq
DoctorStrange.configure do |config|
  config.sidekiq.configure do |sidekiq_config|
    sidekiq_config.latency = 3.hours
    sidekiq_config.queue_size = 50
  end
end
```

```ruby
# Redis
DoctorStrange.configure do |config|
  config.redis.configure do |redis_config|
    redis_config.connection = Redis.current # use your custom redis connection
    redis_config.url = 'redis://user:pass@example.redis.com:90210/' # or URL
    redis_config.max_used_memory = 200 # Megabytes
  end
end
```

```ruby
# Email - MailGun by default
DoctorStrange.configure do |config|
  config.email.configure do |email_config|
    email_config.api_key = "abcd"
    email_config.domain = "foo.bar"
  end
end
```

```ruby
# Payment - Stripe by default
DoctorStrange.configure do |config|
  config.payment.configure do |payment_config|
    payment_config.api_key = "sk_live_xxxxx"
  end
end
```

The currently supported settings are:

#### Sidekiq

* `latency`: the latency (in seconds) of a queue (now - when the oldest job was enqueued) which is considered unhealthy (the default is 30 seconds, but larger processing queue should have a larger latency value).
* `queue_size`: the size (maximim) of a queue which is considered unhealthy (the default is 100).

#### Redis

* `url`: the url used to connect to your Redis instance - note, this is an optional configuration and will use the default connection if not specified
* `connection`: Use custom redis connection (e.g., `Redis.current`).
* `max_used_memory`: Set maximum expected memory usage of Redis in megabytes. Prevent memory leaks and keys overstore.

#### Email

- Default transaction email service for now is `MailGun`.

* `api_key`: the mail service api_key - this is a required value and will return unhealthy if not specified
* `domain`: the mail service domain value - this is a required value and will return unhealthy if not specified.

#### Payment

- Default payment service for now is `Stripe`.

* `api_key`: The Payment service's api_key - returns unhealthy if not specified or invalid.

### Adding a Custom Provider
It's also possible to add custom health check providers suited for your needs (of course, it's highly appreciated and encouraged if you'd contribute useful providers to the project).

In order to add a custom provider, you'd need to:

* Implement the `DoctorStrange::Providers::Base` class and its `check!` method (a check is considered as failed if it raises an exception):

```ruby
class CustomProvider < DoctorStrange::Providers::Base
  def check!
    raise 'Oh oh!'
  end
end
```
* Add its class to the configuration:

```ruby
DoctorStrange.configure do |config|
  config.add_custom_provider(CustomProvider)
end
```

### Adding a Custom Error Callback
If you need to perform any additional error handling (for example, for additional error reporting), you can configure a custom error callback:

```ruby
DoctorStrange.configure do |config|
  config.error_callback = proc do |e|
    logger.error "Health check failed with: #{e.message}"

    Raven.capture_exception(e)
  end
end
```

### Adding Authentication Credentials
By default, the `/check` endpoint is not authenticated and is available to any user. You can authenticate using HTTP Basic Auth by providing authentication credentials:

```ruby
DoctorStrange.configure do |config|
  config.basic_auth_credentials = {
    username: 'SECRET_NAME',
    password: 'Shhhhh!!!'
  }
end
```

### Adding Environment Variables
By default, environment variables is `nil`, so if you'd want to include additional parameters in the results JSON, all you need is to provide a `Hash` with your custom environment variables:

```ruby
DoctorStrange.configure do |config|
  config.environment_variables = {
    build_number: 'BUILD_NUMBER',
    git_sha: 'GIT_SHA'
  }
end
```

## TODO

- [ ] Support another transaction Email services such as: SES, Mandrill by MailChimp, SendGird, AliCloud's DirectMail, etc.

- [ ] Support another payment services such as: Adyen, Braintree, etc.

## License

The MIT License (MIT)

Copyright (c) 2018

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
