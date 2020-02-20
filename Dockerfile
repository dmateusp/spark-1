FROM openjdk:11-jre-slim

ARG BUILD_DATE
ARG SPARK_VERSION=3.0.0-preview2

LABEL org.label-schema.name="Apache Spark ${SPARK_VERSION}" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$SPARK_VERSION      
      
ENV SPARK_HOME /opt/spark
ENV PYTHON_HASHSEED 1337
ENV PYSPARK_PYTHON python3
ENV PATH="/opt/spark/bin:${PATH}"
  
RUN apt-get update && \
	apt-get install -y wget tini python3 && \
    wget -q "http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz" && \
    tar xzf "spark-${SPARK_VERSION}-bin-hadoop3.2.tgz" && \
    rm "spark-${SPARK_VERSION}-bin-hadoop3.2.tgz" && \
    mv "spark-${SPARK_VERSION}-bin-hadoop3.2" /opt/spark && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    apt-get clean

COPY log4j.properties /opt/spark/conf/log4j.properties
COPY entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["--help"]