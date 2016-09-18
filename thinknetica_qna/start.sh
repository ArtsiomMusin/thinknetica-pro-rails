#!/bin/bash

rvm use 2.3.0@qna

puma &

rackup private_pub.ru -s thin -E production &
