FROM openjdk:8 AS build

# Install sbt
RUN mkdir -p /spark/ && \
curl -fsL https://archive.apache.org/dist/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz | tar xfz - -C /spark/ && \
rm /spark/spark-2.4.4-bin-hadoop2.7/jars/kubernetes-*-4.1.2.jar && \
wget https://repo1.maven.org/maven2/io/fabric8/kubernetes-model-common/4.4.2/kubernetes-model-common-4.4.2.jar -P /spark/spark-2.4.4-bin-hadoop2.7/jars/ && \
wget https://repo1.maven.org/maven2/io/fabric8/kubernetes-client/4.4.2/kubernetes-client-4.4.2.jar -P /spark/spark-2.4.4-bin-hadoop2.7/jars/ && \
wget https://repo1.maven.org/maven2/io/fabric8/kubernetes-model/4.4.2/kubernetes-model-4.4.2.jar -P /spark/spark-2.4.4-bin-hadoop2.7/jars/


FROM openjdk:8-alpine AS spark

ARG spark_home=/spark/spark-2.4.4-bin-hadoop2.7

RUN set -ex && \
    apk upgrade --no-cache && \
    apk add --no-cache bash tini libc6-compat gcompat linux-pam nss && \
    mkdir -p /opt/spark && \
    mkdir -p /opt/spark/work-dir && \
    touch /opt/spark/RELEASE && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd

COPY --from=build ${spark_home}/jars /opt/spark/jars
COPY --from=build ${spark_home}/bin /opt/spark/bin
COPY --from=build ${spark_home}/sbin /opt/spark/sbin
COPY --from=build ${spark_home}/examples /opt/spark/examples
COPY --from=build ${spark_home}/kubernetes/dockerfiles/spark/entrypoint.sh /opt/

FROM spark AS final

# #COPY --from=build /opt/input/target/scala-2.11/spark-on-eks-assembly-v1.0.jar  /opt/spark/jars

COPY ./target/eb-data-scommon-assembly-dev.jar /opt/spark/jars

ENV SPARK_HOME /opt/spark

WORKDIR /opt/spark/work-dir

ENTRYPOINT [ "/opt/entrypoint.sh" ]
