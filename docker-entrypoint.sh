#!/bin/bash

export USER=${USER}
export PASSWORD=${PASSWORD}
export HI_URI=${HI_URI}
export LO_URI=${LO_URI}
export request_method='$request_method'

envsubst < /tmp/nginx.templ > /usr/local/nginx/conf/nginx.conf
cat /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx 2>&1
