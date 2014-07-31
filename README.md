# batman-rails-flo

Live-reload your [batman.js](http://batmanjs.org) app with [`fb-flo`](https://github.com/facebook/fb-flo).


## Features

- Live reloading Models, Controllers and Views
- Live reloading HTML templates
- Live reloading CSS
- Fires `liveReload` on `MyApp` so you can define custom handlers

## Installation

Get the [`fb-flo`](https://chrome.google.com/webstore/detail/fb-flo/ahkfhobdidabddlalamkkiafpipdfchp) Chrome extension.

Add this line to your application's Gemfile:

    gem 'batman-rails-flo'

And then execute:

    $ bundle

## Run the live-reload server

You'll need node.js. Execute:

    $ bundle exec rake batman:live_reload

And re-connect with the `fb-flo` plugin if necessary


## Contributing

1. Fork it ( https://github.com/[my-github-username]/batman-rails-flo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
