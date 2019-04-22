#!/bin/bash
 
version=$1
[[ -z $version ]] && version=1.8.1
 
# prepare
sudo wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O /usr/local/bin/jq
sudo chmod 755 /usr/local/bin/jq
 
ismaster=`cat /mnt/var/lib/info/instance.json | jq -r '.isMaster'`
masterdns=`cat /mnt/var/lib/info/job-flow.json | jq -r '.masterPrivateDnsName'`
 
cd /opt
 
# Download alluxio
sudo wget http://downloads.alluxio.org/downloads/files/${version}/alluxio-${version}-hadoop-2.8-bin.tar.gz
sudo tar -zxf alluxio-${version}-hadoop-2.8-bin.tar.gz
sudo chown -R hadoop:hadoop alluxio-${version}-hadoop-2.8
 
 
initialize_alluxio () {
  cd alluxio-${version}-hadoop-2.8
  sudo chown -R hadoop:hadoop .
   
  cp conf/alluxio-site.properties.template conf/alluxio-site.properties
  echo "alluxio.master.security.impersonation.root.users=*" >> ./conf/alluxio-site.properties
  echo "alluxio.master.security.impersonation.root.groups=*" >> ./conf/alluxio-site.properties
  echo "alluxio.master.security.impersonation.client.users=*" >> ./conf/alluxio-site.properties
  echo "alluxio.master.security.impersonation.client.groups=*" >> ./conf/alluxio-site.properties
  echo "alluxio.security.login.impersonation.username=none" >> ./conf/alluxio-site.properties
  echo "alluxio.security.authorization.permission.enabled=false" >> ./conf/alluxio-site.properties
  echo "alluxio.user.block.size.bytes.default=128MB" >> ./conf/alluxio-site.properties
 
}
 
cd alluxio-${version}-hadoop-2.8
 
if [[ ${ismaster} == "true" ]]; then
  # sudo cp ./conf/alluxio-site.properties.template ./conf/alluxio-site.properties
  # sudo echo "alluxio.master.hostname=localhost" >> ./conf/alluxio-site.properties
  # bootstrap
  sudo ./bin/alluxio bootstrapConf ${masterdns}
 
  initialize_alluxio
  # Format
  sudo ./bin/alluxio format
  # Start master
  sudo ./bin/alluxio-start.sh master
 
else
  # bootstrap
  sudo ./bin/alluxio bootstrapConf ${masterdns}
 
  initialize_alluxio
 
    # Format
  sudo ./bin/alluxio format
  # Start worker
  sudo ./bin/alluxio-start.sh worker Mount
fi
