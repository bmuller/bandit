# bandit
[![Build Status](https://secure.travis-ci.org/bmuller/bandit.png?branch=master)](https://travis-ci.org/bmuller/bandit)
[![Dependency Status](https://gemnasium.com/bmuller/bandit.png)](https://gemnasium.com/bmuller/bandit)

Bandit is a multi-armed bandit optimization framework for Rails.  It provides an alternative to A/B testing in Rails.  For background and a comparison with A/B testing, see the whybandit.rdoc document or the blog post [here](http://findingscience.com/rails/vanity/statistics/testing/2011/11/12/bandit:-a-b-testing-alternative-for-rails.html).

# Installation
First, add the following to your Gemfile in your Rails 3 app:

```ruby
gem 'bandit'
```

Then, run the following:

```
bundle install
rails generate bandit:install
```

You can then edit the bandit.yml file in your config directory to set your storage and player parameters.  Redis, memcache, dalli, memory, pstore and yaml-store storage options are available (you will need to add either the memcache-client, redis, or dalli gem to your Gemfile if you chose to use one of these. PStore and YamlStore do not require you to add additional gems though).  Memory storage should only be used for testing. YamlStore is a nice option for testing as well since it is plaintext and you can have a look into it to see what is going on. If you have a simple application with only one server and just a hand full of tests, you might want to use PStore.

See the file players.rdoc for information about available players.

## Configuration
To set up an experiment, add it either somewhere in your code or in the bandit initializer.  Creating an experiment is simple:

```ruby
Bandit::Experiment.create(:click_test) do |exp|
  exp.alternatives = [ 20, 30, 40 ]
  exp.title = "Click Test"
  exp.description = "A test of clicks on purchase page with varying link sizes."
end
```


## View
To get an alternative (per viewer, based on cookies):

```erb
<%= bandit_choose :click_test %>
```

For instance, in a link:

```erb
<%= link_to "new purchase", new_purchase_path, :style => "font-size: #{bandit_choose(:click_test)}px;" %>
```

You can force a particular alternative by adding a query parameter named "bandit_<experiment name>" and setting it's value to the alternative you want.  For instance, given the above experiment in the configuration example:

    http://<yourhost>/<path>?bandit_click_test=40

will then force the alternative to be "40".

## Controller
To track a conversion in your controller:

```ruby
bandit_convert! :click_test
```

You can also request a choice in the controller:

```ruby
redirect_to bandit_choose(:some_url_test)
```


# Dashboard

The dashboard is a Rails engine so it just needs to be mounted in your `config/routes.rb` file:

```ruby
mount Bandit::Engine, :at => '/bandit' # or any path you want
```

To view the dashboard with relevant information, go to:

    http://<yourhost>/bandit

# User Tracking
There are a few different ways that users/conversions can be tracked.  Instead of calling `bandit_choose` and `bandit_convert!` in your code, you may alternatively use one of the following method combinations:

    bandit_simple_choose/bandit_simple_convert!   (no cookies involved, same as raw impressions)
    bandit_session_choose/bandit_session_convert! (session cookie, same as bandit_choose)
    bandit_sticky_choose/bandit_sticky_convert!   (persistent cookies)

`bandit_sticky_convert!` creates a `_converted` cookie which stops additional conversions from being counted. For example, if you are collecting email addresses, a user may enter their email address more than once, but you may want to count all these attempts as one conversion.

You may also use the `bandit_sticky_choose`/`bandit_session_convert!` combination if you wish to use persistent cookies but allow each user to convert multiple times. This way visitors are always presented with the same alternative until they convert, at which point they are presented with another and so on.

Finally, if you use `bandit_simple_convert!`, please remember the second argument (alternative) is not optional, as we have no cookie to read from.

The default `bandit_choose`/`bandit_convert` methods use the session based choose/convert.

# Tests
To run tests:

    rake test_memory
    rake test_memcache
    rake test_redis
    rake test_dalli
    rake test_pstore
    rake test_yamlstore

To produce fake data for the past week, first create an experiment definition.  Then, run the following rake task:

    rake bandit:populate_data[<experiment_name>]

For instance, to generate a week's worth of fake data for the click_test above:

    rake bandit:populate_data[click_test]

# Fault Tolerance
If the storage mechanism fails, then Bandit will automatically switch to in memory storage.  It will then check every 5 minutes after that to see if the original storage mechanism is back up.  If you have distributed front ends then each front end will continue to optimize (based on the in memory storage), but this optimization will be inefficient compared to shared storage among all front ends.
