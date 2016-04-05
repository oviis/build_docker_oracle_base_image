# build_docker_oracle_base_image
will build a oracle image with init scripts stored in the sqlscripts directory, you can use it as schema creations with init test data

The base image will start a Oracle_XE 11g and all the sqlscripts will be executed and create a docker image

- also create a jenkins config job as example, to be more flexibel
- the build_image.sh script will take all sqlscripts as a zip file and unzip them and run them
- the jenkins job will take a zip file as a parameter when you run the creation of the image

## building
 `docker build -t hub.docker.com/isai/oracle-xe-11g:sqlexampleV1 .`
# push image
 `docker push hub.docker.com/isai/oracle-xe-11g:sqlexampleV1`
# run image
 `docker run -tid hub.docker.com/isai/oracle-xe-11g:sqlexampleV1`
