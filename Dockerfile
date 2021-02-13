FROM python:3.7-slim

WORKDIR /opt

ARG IMGT="3360"
ARG K=False
ARG AN=False

ENV RELEASES $IMGT
ENV KIR $K
ENV ALIGN $AN

# RUN apk add --no-cache --virtual \
# 	.build-deps build-base gcc libc-dev \
# 	libxslt-dev libxslt \
# 	curl

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
	html5lib==1.0.1 \
	lxml==4.4.1

RUN pip install --no-cache-dir \
	py-gfe==1.1.0 \
	py-ard==0.6.1

# Copy the build scripts to /opt
COPY bin/get_alignments.sh /opt/
COPY bin/build_gfedb.py /opt/build_gfedb.py
COPY bin/build.sh /opt/

RUN sh /opt/build.sh /opt