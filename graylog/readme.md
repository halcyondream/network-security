# Graylog

Configuration files and notes for Graylog.

# About the docker-compose file

The `docker-compose.yml` from their official docs has some spacing issues.
Understandably, that throws off the `docker-compose` utility. This version 
will build successfully, however.

Note: if Graylog complains about not being able to connect to elasticsearch,
there's a good chance that the memory ran out of the system and that
container crashed. Do a docker-compose down and up again (worked for
me).

# About the content pack

This is a really basic system configuration. It has enough to analyze
suspicious IP or port-access activity. Should be sufficient to view basic
information about suspicious network activity.
