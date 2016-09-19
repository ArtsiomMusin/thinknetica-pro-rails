#!/bin/bash

rvm use 2.3.0@qna

bundle install

puma &

rackup private_pub.ru -s thin -E production &
