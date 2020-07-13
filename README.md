# SivaDKP

A KISS, easy-to-use DKP system.

This simple project is designed to be used in World of Warcraft guilds to
enable guilds to easily manage DKP in their guilds.

The DKP values are stored in the officer notes of all guild players.

Unlike most DKP addons, **SivaDKP** aims to enable a command-line interface to
all guild members, regardless of whether they have the addon or not, so long as
one guild member with the addon is online.

The following commands are available to users of the addon. Users are guild
members who issue commands in `/g`.
Each command will report its `stdout` to the user, unless noted otherwise.
Commands may require administrative privileges. Privileged commands are marked
with an asterisk. Optional arguments are given with a question mark.
* `!dkp status [?name]` - Whispers the user their current DKP, or if `name` is
passed, the DKP of the `name`. Eg: `!dkp status`
* `!dkp award [name] [num]` - Awards `name` with `num` DKP. Eg:
`!dkp award avatar 40`.
* `!dkp deduce [name] [num]` - Deducts `num` DKP from `name`. Eg:
`!dkp deduce avatar 40`.
* `!dkp startbidding [item_link]` - Opens bidding for an `item_link`. Note that
this command will start tracking all submitted bids. Eg:
`!dkp startbidding [Shadow Singed Fang]`.
* `!dkp finishbidding` - Closes bidding, announces the winner and automatically
deducts the DKP from the winner.
* `!dkp cancelbidding` - Similarly to `!dkp finishbidding`, this command closes
bidding, but does not announce the winner and discards all memory of bids. Eg:
`!dkp cancelbidding`

## Getting Started

The current addon version is designed for v`7.3.5` interface `70300`.

The following describes setting up a development environment.

### Prerequisites

Make sure you have WoW `7.3.5` `70300` installed.

### Installing

Installation is very simple. You can navigate to your `WoW` directory and
simply:

```bash
git clone git@github.com:markovejnovic/SivaDKP.git
```

Make sure you enable the addon in your WoW addon configuration.

## Authors

* **Marko Vejnovic** - *Initial work* - [markovejnovic](https://github.com/markovejnovic)

See also the list of [contributors](https://github.com/markovejnovic/SivaDKP/contributors) who participated in this project.

## License

This project is licensed under the GPLv3 License - see the [LICENSE](LICENSE) file for details