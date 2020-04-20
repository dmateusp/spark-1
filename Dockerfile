FROM openjdk:8-jre-slim

ARG BUILD_DATE
ARG SPARK_VERSION=2.4.5
ARG HADOOP_VERSION=2.8.5
ENV HADOOP_CONF_DIR=/usr/hadoop/conf

LABEL org.label-schema.name="Apache Spark ${SPARK_VERSION}" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$SPARK_VERSION

ENV SPARK_HOME /usr/spark
ENV PATH="/usr/spark/bin:/usr/spark/sbin:${PATH}"

RUN apt-get update && \
    apt-get install -y wget netcat procps libpostgresql-jdbc-java && \
    # Spark
    wget -q "http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop-scala-2.12.tgz" && \
    tar xzf "spark-${SPARK_VERSION}-bin-without-hadoop-scala-2.12.tgz" && \
    rm "spark-${SPARK_VERSION}-bin-without-hadoop-scala-2.12.tgz" && \
    mv "spark-${SPARK_VERSION}-bin-without-hadoop-scala-2.12" /usr/spark && \
    # Hadoop
    wget -q "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" && \
    tar xzf "hadoop-${HADOOP_VERSION}.tar.gz" && \
    rm "hadoop-${HADOOP_VERSION}.tar.gz" && \
    mv "hadoop-${HADOOP_VERSION}" /usr/hadoop && \
  # Spark Thrift
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/spark/spark-hive_2.12/${SPARK_VERSION}/spark-hive_2.12-${SPARK_VERSION}.jar && \
    wget -P /usr/spark/jars -q "https://repo1.maven.org/maven2/org/apache/spark/spark-hive-thriftserver_2.12/${SPARK_VERSION}/spark-hive-thriftserver_2.12-${SPARK_VERSION}.jar" && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/thrift/libthrift/0.9.3/libthrift-0.9.3.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/spark-project/hive/hive-jdbc/1.2.1.spark2/hive-jdbc-1.2.1.spark2-standalone.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/spark-project/hive/hive-cli/1.2.1.spark2/hive-cli-1.2.1.spark2.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/hive/hive-metastore/2.3.6/hive-metastore-2.3.6.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/hive/hive-serde/2.3.6/hive-serde-2.3.6.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/hive/hive-llap-common/2.3.6/hive-llap-common-2.3.6.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/hive/hive-llap-client/2.3.6/hive-llap-client-2.3.6.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/hive/hive-exec/2.3.6/hive-exec-2.3.6-core.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/hive/hive-common/2.3.6/hive-common-2.3.6.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/hive/hive-shims/2.3.6/hive-shims-2.3.6.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/hive/hive-vector-code-gen/2.3.6/hive-vector-code-gen-2.3.6.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/apache/hive/hive-storage-api/2.7.1/hive-storage-api-2.7.1.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/spark-project/hive/hive-metastore/1.2.1.spark2/hive-metastore-1.2.1.spark2.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/spark-project/hive/hive-exec/1.2.1.spark2/hive-exec-1.2.1.spark2.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/antlr/antlr-runtime/3.4/antlr-runtime-3.4.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/antlr/antlr/2.7.7/antlr-2.7.7.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/datanucleus/datanucleus-core/3.2.10/datanucleus-core-3.2.10.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/datanucleus/datanucleus-rdbms/3.2.9/datanucleus-rdbms-3.2.9.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/org/datanucleus/datanucleus-api-jdo/3.2.6/datanucleus-api-jdo-3.2.6.jar && \
    # AWS
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.11.682/aws-java-sdk-core-1.11.682.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.11.682/aws-java-sdk-s3-1.11.682.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-kms/1.11.682/aws-java-sdk-kms-1.11.682.jar && \
    wget -P /usr/spark/jars -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.682/aws-java-sdk-1.11.682.jar && \
    find /usr/hadoop/share/hadoop/tools/lib/ -name "hadoop-aws*.jar" -exec mv {} /usr/spark/jars \; && \
    # Postgres (Hadoop metastore)
    ln -s /usr/share/java/postgresql-jdbc4.jar /usr/spark/jars/postgresql-jdbc4.jar


#  && \
    # # Cleanup
    # apt-get remove -y wget && \
    # apt-get autoremove -y && \
    # apt-get clean

COPY entrypoint.sh /scripts/
RUN chmod +x /scripts/entrypoint.sh && \
    echo 'export SPARK_DIST_CLASSPATH=$(/usr/hadoop/bin/hadoop classpath)' > /usr/spark/conf/spark-env.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["--help"]
