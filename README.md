# Tricera-shopper!

Tricerashopper is a dashboard for for collection development for the University of Cincinnati Libraries. It it a Ruby on Rails application that uses the locally developed [ActiveSierra Rails Engine](https://github.com/uclibs/active_sierra) to interface with the Sierra ILS and provide useful information for library staff.

Select Content Services department workflows are also supported by the app.

## Notes on usage:

Access restricted information is managed by Devise. Application administrators must manually create authorized users on the Rails console, using the following pattern:

```ruby
@user = User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password', :location => ["loc1", "loc2"])
@user.save
```
