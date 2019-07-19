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


### Configuration

Suppose method "current_user" is available for controllers and views,

and user has an attribute called admin and only admin can modify resource "users",

then prepare config/acl.yml
```yaml
current_user:
  users:
    new: admin?
    create: admin?
    edit: admin?
    update: admin?
    destroy: admin?
```
In above case, when a non-admin user try to access new_user_path for example, StrongActions::ForbiddenAction will be thrown.

if all actions are restricted in the same way, you can make a definition on controller level.
```yaml
current_user:
  users: admin?
```
controller definition can be namespaced.
```yaml
current_user:
  admin/users: admin?
```
if you have multiple controllers under a namespace, namespace can be used.
ending with '/' indicates that it is for namespace 'admin' and not controller 'admin'.
```yaml
current_user:
  admin/: admin?
```

### Handling error in controller

In application_controller.rb, the error should be rescued like
```ruby
rescue_from StrongActions::ForbiddenAction do
  render file: 'public/403.html', layout: false, status: :forbidden
end
```
In above case, all the forbidden accesses are handled by public/403.html.

### Disabling forbidden link in view

In views, use helper method "available?" so that links for forbidden actions are not shown.
```erb
<%= link_to 'Add User' new_user_path if available?('users', 'new') %>
```
## Contributing

1. Fork it ( https://github.com/hybitz/strong_actions/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
