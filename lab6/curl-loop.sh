#!/bin/bash

# pass in port 
while true; do curl -H 'Cache-Control: no-cache' "http://127.0.0.1:$1/api/vehicles/driver/City%20Truck";  echo "";  sleep .5;  done
