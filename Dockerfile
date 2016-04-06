###########################################################
# Dockerfile to build a OracleServer@Sixt
############################################################

FROM wnameless/oracle-xe-11g

# File Author / Maintainer
MAINTAINER Ovi oviis <mischovi@yahoo.de>

###########################################################
###
#  ALL sql files, like schema etc, should be placed into the directory sqlscripts
#  ALL Sqlscripts will be put in the image at build time, 
#  and on run time the OracleServer will  be started and ALL sqlscripts will be executed
### 
### building
#  docker build -t hub.docker.com/oviis/oracle-xe-11g:sqlexampleV1 .
### push
# docker push hub.docker.com/oviis/oracle-xe-11g:sqlexampleV1
### run
# docker run -tid hub.docker.com/oviis/oracle-xe-11g:sqlexampleV1
############################################################

WORKDIR /tmp
ADD sqlscripts /tmp/sqlscripts
ADD run.sh /tmp/run.sh

RUN chmod +x run.sh
CMD [ "/tmp/run.sh" ]
