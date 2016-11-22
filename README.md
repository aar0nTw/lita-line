# lita-line
[![Gem](https://img.shields.io/gem/v/lita-line.svg)](https://rubygems.org/gems/lita-line)
[![Gem](https://img.shields.io/gem/dt/lita-line.svg)](https://rubygems.org/gems/lita-line)
[![Gemnasium](https://img.shields.io/gemnasium/aar0nTw/lita-line.svg)](https://gemnasium.com/github.com/aar0nTw/lita-line)
[![Build Status](https://img.shields.io/travis/aar0nTw/lita-line.svg)](https://travis-ci.org/aar0nTw/lita-line)
[![Coverage Status](https://img.shields.io/coveralls/aar0nTw/lita-line.svg)](https://coveralls.io/github/aar0nTw/lita-line?branch=master)

Line Messanging webhook adapter for [Lita](https://github.com/litaio/lita)

## Installation

Add lita-line to your Lita instance's Gemfile:

``` ruby
gem "lita-line"
```

## Configuration

Use line adapter in `lita_config.rb`

``` ruby
config.robot.adapter = :line
config.adapters.line.channel_secret = ENV["LINE_CHANNEL_SECRET"]
config.adapters.line.channel_token = ENV["LINE_CHANNEL_TOKEN"]
```

### Required attributes

- `channel_secret` _(String)_: Bot's Channel secret
- `channel_token` _(String)_: Bot's Channel token

Create a line bot at https://business.line.me/ and get it's secret and token in https://developers.line.me 
  
## Usage

- Deploy your lita app to heroku
- Setting the webhook callback address: `https://{your-lita-app-name}.herokuapp.com/callback` in https://developers.line.me 

## API documentation

The API documentation, useful for plugin authors, can be found for the latest gem release on [RubyDoc.info](http://www.rubydoc.info/gems/lita-line)

## License

[MIT](http://opensource.org/licenses/MIT)
