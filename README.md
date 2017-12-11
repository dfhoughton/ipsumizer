# Ipsumizer

`Ipsumizer` generates random sentences based on the sample text it is initialized with.

## Synopsis

```ruby
require 'ipsumizer'

# sample text -- the Aeneid (only first lines shown)
text = <<-END
Arma virumque cano, Troiae qui primus ab oris
Italiam, fato profugus, Laviniaque venit
litora, multum ille et terris iactatus et alto
vi superum saevae memorem Iunonis ob iram;
multa quoque et bello passus, dum conderet urbem,
inferretque deos Latio, genus unde Latinum,
Albanique patres, atque altae moenia Romae.

Musa, mihi causas memora, quo numine laeso,
quidve dolens, regina deum tot volvere casus
insignem pietate virum, tot adire labores
impulerit. Tantaene animis caelestibus irae?

...

END

ip = Ipsumizer.new text

ip.speak                 # "Illi ingere glaebae; faciat tempora magno miserae lustri non data dum excutitur, dona Cupido Tyrius artit, et prodimus urbine Byrsam, neque, Troesque corpora mortalis, foret Troiaque qui taliam rabili portuna viros inhumati unda dextra, donis?"
ip.speak                 # "'Rex erat pectore pontus, nostrata pelago pectore tot captas epulis Achates et patres, haere duce reconderat, ut supplexu Aeneas, Tyria fluctus antiquentem tum excidio Libyae: sic ore cadis agminem." 
ip.speak                 # "Adsit lacrimisque matrem arrectisque ruunt et alas et placidam Iunonis?"

ip = Ipsumizer.new text, prefix: 2

ip.speak                 # "Hissalia ma cubem gerefix, Iuripsilis ocubvolut ciantensii, iturue perbata gerecurore Iulcelacriscenthomasumin lo.]"

```

## Description

`Ipsumizer` builds a "character language model" based on the sample *sentences* you give it. This means it discovers the probability
that a particular letter follows particular sequences of preceding letters within a sentence. "Letters" in this case include the
beginning of the sentence and the end. Given this information it can build a new sentence like so:

1. Pick the starting character based on the frequence of starting letters in the sample sentences
2. Pick the next character based on the frequency of second characters given the first
3. Pick the third character based on the frequency of the preceding two
4. etc.

Once it reaches its "prefix" limit, it trims the preceding sequence to this length. The longer the sequence, the less creative
`Ipsumizer` will be and the more the generated text will resemble the sample. At some length it will stop generating any
novel sentences and will simply return some random sentence from the sample it ingested.

### Sentencing

If you give `Ipsumizer` an array as the first argument to its initializer it will assume these are the sample sentences.
Alternatively, if you give it a `String` it will use a regular expression to splits this string into sample sentences.
As is generally the case with regular expression parsing, this won't always be as sophisticated as you might like. You can
either do the sentencing yourself beforehand or provide your own sentencing regexp, like so:

```ruby
ip = Ipsumizer.new text, sentencer: /([.?!])/
```

Note the capturing group around the expression. `Ipsumizer` assumes sentencing expressions capture their separators. It
will look for the these in the `split` output, therefore, and glue them back onto their sentences.

### Normalization

The only normalization `Ipsumizer` provides by default is the stripping of whitespace and the conversion of all
internal whitespace into ' '. If you want to remove macrons, for example, you need to do it to the text yourself.

## Methods

### `initialize(text, sentencer: DEFAULT_SENTENCER, prefix: DEFAULT_PREFIX)`

The `text` parameter is either a string or an array of strings. In the former case, the string will be
split into sentences using the sentencer pattern. The `prefix` parameter is a non-negative integer. The bigger
the prefix, the more faithful generated sentences will be to the original.

### `speak`

Generate a random sentence.

### `sentence(text)`

Split the `text` parameter into sentences using the `Ipsumizer`'s sentence boundary pattern.

### `sentencer`

Accessor for the sentencer pattern.

### `prefix`

Accessor for the prefix length.

## Defaults and Constants

```ruby
  DEFAULT_SENTENCER = Regexp.new %r{([.!?][.!?\p{Final_Punctuation}\p{Close_Punctuation}"\s]*)}

  DEFAULT_PREFIX = 4
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ipsumizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ipsumizer

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dfhoughton/ipsumizer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

