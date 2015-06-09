# backlog_bulk

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/backlog_bulk`. To experiment with that code, run `bin/console` for an interactive prompt.

backlog_bulk is a script to post the issues and comments the same content on multiple projects of backlog.jp.

## Installation

install it yourself as:

    $ gem install backlog_bulk

## Usage

```
Commands:
  backlog_bulk close --issuekeys <issuekeysfile>
  backlog_bulk comment --issuekeys <issuekeysfile> --content <content_name>
  backlog_bulk help [COMMAND]
  backlog_bulk issue --projects <project_key_file>
  backlog_bulk showissue --issuekeys <issuekeysfile>

Options:
  c, [--config=CONFIG]        # use config file
                              # Default: backlog_bulk.conf
  d, [--debug], [--no-debug]  # enable debug mode
```

### create issues

Create a file that contains project key per line.
for example:

```
$ cat projects
ABC
DEF
GHI
```

Create a config file (YAML format) named `backlog_bulk.conf`.
for example:

```
---
space: 'your backlog space name'
api_key: 'your backlog api key'
summary: 'issue subject'
startDate: '2015-01-01'
dueDate: '2015-12-31'
description: |
  Hi, all

  This is a multipost issue.
```

Execute `backlog_bulk issue --projects projects`

### comment

Create a `issuekeys` file that contains issue key per line.
for example:

```
ABC-3
DEF-123
GHI-408
```

Add config to comment content.
for example:

```
---
space: 'your backlog space name'
api_key: 'your backlog api key'
summary: 'issue subject'
startDate: '2015-01-01'
dueDate: '2015-12-31'
description: |
  Hi, all

  This is a multipost issue.
comment1: |
  This is a comment example.
comment2: |
  This is a comment example, too.
```



`$ backlog_bulk comment --issuekeys issuekeys --content comment1`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec backlog_bulk` to use the code located in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/backlog_bulk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
