## Overview
A ruby API endpoint to recieve json formatted changelogs to store for 60 Days.

## Dev setup

If you're developing on a mac you'll need to first setup postgress

* Install postgress from http://postgresapp.com

```bash
$ brew update
```

```bash 
$ brew install postgresql # The pg gem won't install without
```

```bash
$ bundle install
```

#### Setup the changelogger database

```bash
$ rake create_db
```

#### Execute the Rakefile command to setup the DB schema

```bash
$ rake db:migrate
```

#### Using foreman 

```bash
$ foreman start
```

#### API Examples

Send a new event to changelogger
```bash
$ curl -i -X POST -H "Accept: application/json" -H "Content-type: application/json" -d '{"service": {"mass": "nagios alert!"}}' localhost:5000/changelogger
```

Get all changelogger events
```bash
$ curl -i -X GET http://localhost:5000/events/all
```

Get the last changelogger event
```bash
$ curl -i -X GET http://localhost:5000/events/last
```

#### Tests

Setup the test db

```bash
$ rake create_test_db
```

Run the tests

```bash
$ rake test
```

#### TODO
* Add API method for search
* Get a working /events method for returning events for a specific time period
* Get specs/minitest instantiating a changelogger-test database at the beginning of rake test and dropping at the end.

