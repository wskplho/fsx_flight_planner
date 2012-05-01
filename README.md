# FSX Flight Planner

## What is this?
This is a Ruby on Rails application.

## Who is this for?
For Microsoft Flight Simulator X (MFSX or FSX for short) Gold Edition pilots who are bored and want to fly something new.

## What does it do?
If you give it two ICAO airport codes, it will generate a random flight path between those two airports.
If you don't, it will generate a random flight path between two random airports.
It may randomly split the path into waypoints (other airports) if your aircraft's range is smaller than the total distance.
If you don't select an aircraft, it will pick a random one.
If you don't select a country, it will search airports in all countries.
It shows the flight path on a Google map along with waypoints data.

## Requirements
Ruby 1.9.3+, Rails, MySQL, Apache2 etc.
This means you better have a Linux/Mac laptop nearby.

## Fastest Installation
    git clone git://github.com/ollie/fsx_flight_planner.git
    cd fsx_flight_planner
    bundle install
    cp config/database.yml.example config/database.yml # You might need to edit this
    rake db:create db:migrate db:data:load:latest
    # Or if rake fails for some reason, try this
    bundle exec rake db:create db:migrate db:data:load:latest
    rails s
Open a browser and go to http://127.0.0.1:3000/.

## Seeding
If you don't want to load data directly from YAML (that is `db:data:load:latest`),
you will need to run `rake db:seed`, which populates the database manually.
It does the following:

* Saves aircrafts,
* Parses fs10.Airports.dat,
* Saves countries,
* Saves airports,
* Saves runways,
* Parses airports.csv,
* Saves airport names (they are not in fs10.Airports.dat file).

This might take around 20 minutes or so.

## Warning
I have a few ideas which I would like to implement sooner or later: Saving checkpoints or full plans into the database so they could be restored, edited, maybe even exported, things like that. Right now it's rather static and not very useful, but still more fun than the default FSX planner. :) There might be bugs so please let me know if you find anything.

## Known bugs
Then map is not centered correctly when route goes over the 0 (or 360) degs of longitude.