# StrongActions

Access control for rails controller/action.

## Installation

Add this line to your application's Gemfile:

    gem 'strong_actions'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strong_actions

## Usage

Suppose method "current_user" is available for controllers and views,

and user has an attribute called admin and only admin can modify resource "users",

then prepare config/acl.yml

    current_user:
        users:
            new: admin?
            create: admin?
            edit: admin?
            update: admin?
            destroy: admin?

In above case, when a non-admin user try to access new_user_path, StrongActions::ForbiddenAction is thrown.

In views, use helper method "available?" so that links for forbidden actions are not shown.

    <%= link_to 'Add User' new_user_path if available?('users', 'new') %>

## Contributing

1. Fork it ( https://github.com/[my-github-username]/strong_actions/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
