# lita-line

[![Build Status](https://img.shields.io/travis/aar0nTw/lita-line.svg)](https://travis-ci.org/aar0nTw/lita-line)
[![Coverage Status](https://img.shields.io/coveralls/aar0nTw/lita-line.svg)](https://coveralls.io/github/aar0nTw/lita-line?branch=master)

## Installation

Add lita-line to your Lita instance's Gemfile:

``` ruby
gem "lita-line"
```

## Configuration
### Required attributes

- `channel_secret` _(String)_: Bot's Channel secret
- `channel_token` _(String)_: Bot's Channel token

Create a line bot at https://business.line.me/ and get it's secret and token in https://developers.line.me 
  
## Usage

- Deploy your lita app to heroku
- Setting the webhook callback address: `https://{your-lita-app-name}.herokuapp.com/callback` in https://developers.line.me 
