# build_docker_oracle_base_image
will build a oracle image with init scripts stored in the sqlscripts directory, you can use it as schema creations with init test data

The base image will start a Oracle_XE 11g and all the sqlscripts will be executed and create a docker image

- also create a jenkins config job as example, to be more flexibel
- the build_image.sh script will take all sqlscripts as a zip file and unzip them and run them
- the jenkins job can get `ONLY A ZIP FILE` as start parameter, where all the sql scripts are zipped. Ordering is important!!!, see example in sqlscripts directory
- Important!!! if you want to run the jenkins Job, you need to create a new Job and replace the config.xml and also adapt the docker hub to your docker hub account 

## building
 `docker build -t hub.docker.com/isai/oracle-xe-11g:sqlexampleV1 .`
# push image
 `docker push hub.docker.com/isai/oracle-xe-11g:sqlexampleV1`
# run image
 `docker run -tid hub.docker.com/isai/oracle-xe-11g:sqlexampleV1`
