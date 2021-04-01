#!/bin/bash
$(which squid) -N -f /etc/squid/squid.conf -z
exec $(which squid) -f /etc/squid/squid.conf -NYCd 1