# batman-rails-flo

[![Gem Version](https://badge.fury.io/rb/batman-rails-flo.svg)](http://badge.fury.io/rb/batman-rails-flo)

Live-reload your [batman.js](http://batmanjs.org) app with [`fb-flo`](https://github.com/facebook/fb-flo).

![Example](http://i.imgur.com/AflbrPy.gif)

## Features

- Live reloading Models, Controllers and Views
- Live reloading HTML templates
- Live reloading CSS
- Fires `liveReload` on `MyApp` so you can define custom handlers


Also, any class on `MyApp` can implement the class method `liveReload(className, newCodeString)`, where:

-  `className` is the class that was reloaded
-  `newCodeString` is a bunch of JavaScript to be `eval`'d to load the new class.

[Learn more in the wiki!](https://github.com/rmosolgo/batman-rails-flo/wiki)

## Installation

Get the [`fb-flo`](https://chrome.google.com/webstore/detail/fb-flo/ahkfhobdidabddlalamkkiafpipdfchp) Chrome extension.

Add this line to your application's Gemfile:

    gem 'batman-rails-flo'

And then execute:

    $ bundle


Add the client code to your batman.js app's Sprockets manifest:

```coffeescript
#= require batman/live_reload
```

Also, if your app isn't in the /assets/batman folder, you will need to set the pathToHTML variable here so that it knows where to find your views.
```
Batman.config.pathToHTML = '/assets/html'
```

## Run the live-reload server

You'll need node.js. Execute:

    $ bundle exec rake batman:live_reload

And re-connect with the `fb-flo` plugin if necessary

## Known Issues

- You have to reload after adding new files

## Contributing

1. Fork it ( https://github.com/[my-github-username]/batman-rails-flo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
