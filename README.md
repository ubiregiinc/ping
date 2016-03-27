# Delegate Heroku Deploy Hook to Web Services

Proxy Heroku deploy hook to other web services.

## Motivation

Heroku deploy hook is provided as an addon, and it is not allowed to have more than one hooks for an app.

## Setup

1. Deploy this as a web app. (You can use Heroku!)
2. Add `Deploy Hooks - HTTP Post Hook` addon to your Heroku app, and configure it to post to the app you have setup at 1.
3. Deploy your new version!

## Configure Web Services

### New Relic

Specify the following env vars:

* NEWRELIC_API_KEY
* NEWRELIC_APP_ID

However, you can use Heroku addon version of New Relic, if you just want to be notified to New Relic.

### AirBrake

Specify the following env vars:

* AIRBRAKE_API_KEY
* AIRBRAKE_RAILS_ENV
* AIRBRAKE_REPOSITORY

### Slack

Specify the following env vars:

* SLACK_HOOK_URL
* REVISION_URL_BASE (optional, used to link the commit digest)

## Running test

```
$ bundle install
$ rake test
```

## Contributing

* Send me your pull requests!
