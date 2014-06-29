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
require "badgerhash"
require "stringio"

xml = StringIO.new("<alice>bob</alice>")
xml_stream =  Badgerhash::XmlStream.create(xml)
xml_stream.to_badgerfish *=> {"alice" => {"$" => "bob"}}*

xml_stream = Badgerhash::XmlStream.create("<alice>bob</alice>")
xml_stream.to_badgerfish *=> {"alice" => {"$" => "bob"}}*
```

### Generating a BadgerFish Hash Using a Document Parser

```ruby
require "badgerfish"
require "stringio"

xml = StringIO.new("<alice>bob</alice>")
xml_document =  Badgerhash::XmlDocument.create(xml)
xml_document.to_badgerfish *=> {"alice" => {"$" => "bob"}}*

xml_document = Badgerhash::XmlDocument.create("<alice>bob</alice>")
xml_document.to_badgerfish *=> {"alice" => {"$" => "bob"}}*
```

### Developing Alternate Parsers

A document parser implementes a `parse` method that accepts the xml to be 
processed and  must return an object that supports the interface specified in 
the REXML parser implementation. Namely this object must support the `text?`, `attributes`, and `children` which indicate the node contains text, return 
attributes and child nodes respectively. Please reference the REXML parser's 
code for more detail.

A stream parser must implement a `parse` method that accepts a 
`Badgerhash::Handler::SaxHandler` and IO object. The parser must call methods 
on the given handler to construct the Hash. Please refer to th REXML parser 
implementation for an example.

## Contributing

1. Fork it ( http://github.com/gfmurphy/badgerhash/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
