FROM docker.elastic.co/logstash/logstash:5.6.0

COPY pkg/*.gem /tmp
RUN /usr/share/logstash/bin/logstash-plugin install /tmp/logstash-output-rethinkdb-*.gem
