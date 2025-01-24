FROM rockylinux:9

RUN dnf -y update && \
    dnf -y install epel-release && \
    dnf -y install slurm munge && \
    dnf clean all

CMD ["tail", "-f", "/dev/null"]
