# Alluxio-EMR-bootstrap
bootstrap script for Alluxio on EMR

Inspire by https://github.com/kernel164/emr-bootstrap-alluxio but with Alluxio 1.8.1 on EMR 5.17

EMR cluster configurations

```
[
  {
    "Classification": "core-site",
    "Properties": {
      "fs.alluxio.impl": "alluxio.hadoop.FileSystem",
      "fs.AbstractFileSystem.alluxio.impl": "alluxio.hadoop.AlluxioFileSystem"
    }
  },
  {
    "Classification": "spark-defaults",
    "Properties": {
          "spark.driver.extraClassPath": ":/usr/lib/hadoop-lzo/lib/*:/usr/lib/hadoop/hadoop-aws.jar:/usr/share/aws/aws-java-sdk/*:/usr/share/aws/emr/emrfs/conf:/usr/share/aws/emr/emrfs/lib/*:/usr/share/aws/emr/emrfs/auxlib/*:/usr/share/aws/emr/security/conf:/usr/share/aws/emr/security/lib/*:/opt/alluxio-1.8.1-hadoop-2.8/client/alluxio-1.8.1-client.jar",
          "spark.executor.extraClassPath": ":/opt/alluxio-1.8.1-hadoop-2.8/client/alluxio-1.8.1-client.jar"
     }
  }
]
```
