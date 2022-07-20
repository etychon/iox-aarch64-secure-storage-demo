FROM devhub-docker.cisco.com/iox-docker/ir1101/base-rootfs as builder
RUN opkg update
RUN opkg install iox-toolchain curl

FROM devhub-docker.cisco.com/iox-docker/ir1101/base-rootfs
COPY --from=builder /usr/bin/curl /usr/bin/curl
COPY iox-ss-stress-test.sh /
RUN chmod +x /iox-ss-stress-test.sh
CMD /iox-ss-stress-test.sh
