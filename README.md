#### Installation

As a first step, install;
* Elixir: 1.14.0-otp-25 version. 

Open the ~/.bashrc file and add the following line at the bottom.
```elixir
alias about='/path/to/about/file'
```
Then save the change by running the following command.
```elixir
source .bashrc 
```
It's done.

## Quick Start

The following query returns the translation of the given text:
```elixir
about --q desktop
```

For English response
```elixir
about --q desktop --l en
```

For maximum of 100 queries
```elixir
about --q desktop --l en --n 100
```

## Roadmap/Contributing

First off, welcome & thanks!

We use the Github Issues tracker.

If you have found something wrong, please raise an issue.

If you'd like to contribute, check the issues to see where you can help.

Contributions are welcome from anyone at any time but if the piece of work is
significant in size, please raise an issue first to avoid instances of wasted
work.

## License

MIT. See the [full license](LICENSE).
