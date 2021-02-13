FROM python:3.7-alpine as gfe-graph-builder

MAINTAINER Pradeep Bashyal <pbashyal@nmdp.org>

WORKDIR /opt

ARG IMGT="3360"
ARG K=False
ARG AN=False

ENV RELEASES $IMGT
ENV KIR $K
ENV ALIGN $AN

RUN apk add --no-cache --virtual \
	.build-deps build-base gcc libc-dev \
	libxslt-dev libxslt \
	curl

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
	html5lib==1.0.1 \
	lxml==4.4.1

RUN pip install --no-cache-dir \
	py-gfe==1.1.0 \
	py-ard==0.6.1

# FROM nmdpbioinformatics/gfe-base as gfe-graph-builder
# RUN apk add curl

# Copy the build scripts to /opt
COPY bin/get_alignments.sh /opt/
COPY bin/build_gfedb.py /opt/build_gfedb.py
COPY bin/build.sh /opt/

RUN sh /opt/build.sh /opt

# # Neo4j image
# FROM neo4j:3.1 as neo4j-db-builder

# COPY --from=gfe-graph-builder --chown=neo4j:neo4j /data/csv /csv

# COPY bin/load_graph_docker.sh /opt/
# RUN /opt/load_graph_docker.sh /csv

# FROM neo4j:3.1

# COPY --from=neo4j-db-builder --chown=neo4j:neo4j /var/lib/neo4j/gfedb/graph.db /data/databases/graph.db
