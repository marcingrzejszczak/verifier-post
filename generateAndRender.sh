#!/usr/bin/env bash

# ensure that bundle install was executed
ruby coalesce_readme.rb
ruby generate_readme.rb
