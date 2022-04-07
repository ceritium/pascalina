# Pascalina

## Usage

You can try a basic REPL:

```bash
$ pascalina
=> Pascalina REPL
=> Write `exit` for quit
pascalina> 4 + 3
=> 7.0
```

Or run your pascalina scripts from console:

```bash
$ pascalina examples/demo1.lina
6.0
```

But Pascalina is meant to be embebed in your app and let your users build their
own calculus:

```ruby
Pascalina::Calculator.new.evaluate("1+1")
```

### AST cache

Pascalina doesn't handle the AST cache like other alternatives, but you can
cache it your-self and pass it with `evaluate_ast`.

Check the `benchmark/ast.rb` to see the usage:

```
Warming up --------------------------------------
            evaluate   634.000  i/100ms
marshal evaluate_ast     1.464k i/100ms
 direct evaluate_ast     1.595k i/100ms
Calculating -------------------------------------
            evaluate      5.783k (±14.2%) i/s -     29.164k in   5.146870s
marshal evaluate_ast     14.502k (±18.1%) i/s -     70.272k in   5.015046s
 direct evaluate_ast     22.910k (±19.1%) i/s -    106.865k in   5.046620s

Comparison:
 direct evaluate_ast:    22910.4 i/s
marshal evaluate_ast:    14502.0 i/s - 1.58x  (± 0.00) slower
            evaluate:     5782.7 i/s - 3.96x  (± 0.00) slower
```

## Similar stuff

- [keisan](https://github.com/project-eutopia/keisan):  A Ruby-based expression parser, evaluator, and programming language
Topics
- [dentaku](https://github.com/rubysolo/dentaku): Math and logic formula parser and evaluator
- [rlox](https://github.com/malavbhavsar/rlox): Ruby implementation of Lox, the language described in Crafting Interpreters
- [stoffle](https://github.com/alexbrahastoll/stoffle): A toy programming language developed as a series of blog posts for the Honeybadger blog.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pascalina'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pascalina

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ceritium/pascalina. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ceritium/pascalina/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pascalina project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ceritium/pascalina/blob/master/CODE_OF_CONDUCT.md).
