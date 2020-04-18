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
    # Spark Thrift Server
    wget -q "https://repo1.maven.org/maven2/org/apache/spark/spark-hive-thriftserver_2.12/${SPARK_VERSION}/spark-hive-thriftserver_2.12-${SPARK_VERSION}.jar" && \
    mv "spark-hive-thriftserver_2.12-${SPARK_VERSION}.jar" /usr/spark/jars/ && \
    # Hive
    wget -q https://repo1.maven.org/maven2/org/apache/spark/spark-hive_2.12/${SPARK_VERSION}/spark-hive_2.12-${SPARK_VERSION}.jar && \
    mv "spark-hive_2.12-${SPARK_VERSION}.jar" /usr/spark/jars/ && \
    # Hadoop
    wget -q "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" && \
    tar xzf "hadoop-${HADOOP_VERSION}.tar.gz" && \
    rm "hadoop-${HADOOP_VERSION}.tar.gz" && \
    mv "hadoop-${HADOOP_VERSION}" /usr/hadoop && \
    # AWS
    find /usr/hadoop/share/hadoop/tools/lib/ -name "*aws*" -exec mv {} /usr/spark/jars \; && \
    # Postgres (Hadoop metastore)
    ln -s /usr/share/java/postgresql-jdbc4.jar /usr/spark/jars/postgresql-jdbc4.jar && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    apt-get clean

COPY entrypoint.sh /scripts/
RUN chmod +x /scripts/entrypoint.sh && \
    echo 'export SPARK_DIST_CLASSPATH=$(/usr/hadoop/bin/hadoop classpath)' > /usr/spark/conf/spark-env.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["--help"]
