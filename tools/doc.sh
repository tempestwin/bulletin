#!/bin/sh
[ ! -d public ] && mkdir public
cat network/public_ip.txt > public/index.html
