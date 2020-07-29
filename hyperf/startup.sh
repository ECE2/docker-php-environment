#!/bin/bash

cd backend-high-performance

composer install --no-dev -vvv -o && php bin/hyperf.php

php bin/hyperf.php start
