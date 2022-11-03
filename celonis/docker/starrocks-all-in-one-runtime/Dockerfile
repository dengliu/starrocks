# ARTIFACTIMAGE is the image of the artifacts that this all-in-one runtime docker will use.
# It can be a docker image from any registry or just a image that built locally
ARG ARTIFACTIMAGE=904263465335.dkr.ecr.us-west-1.amazonaws.com/starrocks-artifacts:2.4.0

FROM ${ARTIFACTIMAGE} as artifacts

FROM centos:7 as dependencies-installed
# Install Java JDK.
RUN yum -y install java-1.8.0-openjdk-devel.x86_64

# Install relevant tools.
RUN yum -y install mysql net-tools telnet tree

FROM dependencies-installed as artifacts-deployed

ARG DEPLOYDIR="/data/deploy"

# STARTMODE: [auto, manual]
ENV STARTMODE=manual
WORKDIR $DEPLOYDIR

# Copy all artifacts to the runtime container image
COPY --from=artifacts /release/be_artifacts/ $DEPLOYDIR/starrocks
COPY --from=artifacts /release/fe_artifacts/ $DEPLOYDIR/starrocks
COPY --from=artifacts /release/broker_artifacts/ $DEPLOYDIR/starrocks

# Create directory for FE meta and BE storage in StarRocks.
RUN mkdir -p $DEPLOYDIR/starrocks/fe/meta && mkdir -p $DEPLOYDIR/starrocks/be/storage


# Copy Setup script.
COPY *.sh $DEPLOYDIR
RUN chmod +x *.sh

COPY *.conf $DEPLOYDIR
RUN cat be.conf >> $DEPLOYDIR/starrocks/be/conf/be.conf && \
    cat fe.conf >> $DEPLOYDIR/starrocks/fe/conf/fe.conf

CMD if [ "$STARTMODE" = 'auto' ] ; then ./start_fe_be_broker.sh ; else ./start_be_broker.sh ; fi
