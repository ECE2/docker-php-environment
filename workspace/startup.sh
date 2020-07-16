#!/bin/bash

crond -l 2 -b

tail -f /dev/null
