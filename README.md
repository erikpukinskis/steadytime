# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Auth

### Google OAuth

Contact email: steadytime@googlegroups.com (https://groups.google.com/g/steadytime)
Project: https://console.cloud.google.com/auth/clients?invt=AbuZ4w&project=steadytime-dev

### Best practices

Generating models with string primary keys:

```sh
rails generate model GoogleAccount --primary-key=id id:string:index email:string ...
```

Editing credentials:

```sh
VISUAL="cursor --wait" rails credentials:edit --environment development
```

### Design

 - "Don't forget" list (with some suggested tags, "today", "regularly", "soon", "eventually")
 - 