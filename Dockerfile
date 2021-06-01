# From https://github.com/aws/aws-cli/blob/v2/docker/Dockerfile
FROM amazonlinux:2 as installer

RUN yum update -y \
  && yum install -y unzip \
  && unzip $EXE_FILENAME \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install --bin-dir /aws-cli-bin/

FROM amazonlinux:2
RUN yum update -y \
  && yum install -y less groff \
  && yum clean all
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
WORKDIR /aws

# Install Session Manager Items
RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm" \
    && yum install -y session-manager-plugin.rpm \
    && rm -rf session-manager-plugin.rpm

ENTRYPOINT ["/usr/local/bin/aws"]