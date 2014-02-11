## Overview
A ruby API endpoint to recieve json formatted changelogs to store for 60 Days.

## Dev setup

If you're developing on a mac you'll need to first setup postgress

* Install postgress from http://postgresapp.com

```bash
brew update
```

```bash 
brew install postgresql # The pg gem won't install without
```

```bash
bundle install
```

#### Setup the changelogger database
```bash
psql
```

```bash
create database changelogger
```



