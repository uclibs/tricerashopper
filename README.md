# Tricera-shopper!

Tricerashopper is a collection development dashboard for the University of Cincinnati Libraries. It is a Ruby on Rails application that uses the locally developed [ActiveSierra Rails Engine](https://github.com/uclibs/active_sierra) to interface with the Sierra ILS and provide useful information for library staff.

Select Content Services Department workflows are also supported by the app.

## Notes on usage:

Access restricted information is managed by Devise. Application administrators must manually create authorized users on the Rails console using the following pattern:

```ruby
@user = User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')

@user.save

```

Tricerashopper includes apps to support acquisitions workflows, including a materials request form. To support this workflow, users can be created with one of three roles: selector, assistant, and admin.

Selector type allows users to submit and edit orders.

```ruby
@user = Selector.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password', :location => ["loc1", "loc2"], :lmlo_receives_report => true,)

@user.save

```

Assistant type is a delegate account, tied to a selector, allowing the user to submit and edit orders to be reviewed and approved by assigned selector.

```ruby
@user = Assistant.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password', :selector_id => 1)

@user.save

```

Admin type is for Acquisitions staff to review and process the orders.
```ruby
@user = Admin.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password')

@user.save

```

Updating a user
```ruby
u = User.find(idnumber)

u.update_attributes(attribute: value)

u.save
```

Listing user info
```ruby
y User.all
````

=====================================================================================================
Search and Index

Sunspot is used to provide interaction with Solr. [Sunspot Docs](https://github.com/sunspot/sunspot)

When installing, run 
```
bundle exec rake sunspot:solr:start
```

When updating the searchable definition in a model, be sure to reindex:
```
bundle exec rake sunspot:solr:reindex
```
