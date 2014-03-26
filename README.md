# Badgerhash
[![Build Status](https://travis-ci.org/gfmurphy/badgerhash.svg?branch=master)](https://travis-ci.org/gfmurphy/badgerhash)
[![Code Climate](https://codeclimate.com/github/gfmurphy/badgerhash.png)](https://codeclimate.com/github/gfmurphy/badgerhash)

Convert XML to a Ruby Hash using the BadgerFish convention: http://badgerfish.ning.com/

The resulting Hash can be easily converted to JSON using a JSON library.

The reference implementation of the generators use REXML for parsing the given
XML. REXML is included in the Ruby Standard Library so no depencies are
introduced. Nevertheless, this library provides interfaces that allow using
alternate parsers if performance is a concern.

## Installation

Add this line to your application's Gemfile:

    gem 'badgerhash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install badgerhash

## Usage

### Generating a BadgerFish Hash Using a Stream Parser

```ruby
require "badgerfish"

xml = StringIO.new("<alice>bob</alice>")
xml_stream =  BadgerHash::XmlStream.create

puts xml_stream.to_badgerfish(xml).inspect
```

## Contributing

1. Fork it ( http://github.com/gfmurphy/badgerhash/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
