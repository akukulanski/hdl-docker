FROM debian:buster

RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommend && \
    apt-get update && \
    apt-get -y install \
        git \
        ssh \
        make \
        wget \
        build-essential\
        iputils-ping \
        iverilog \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        python3-setuptools \
        python3-tk \
        python3-wheel \
        libftdi-dev \
        libtinfo5 && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip pytest numpy ipython
RUN python3 -m pip install cocotb==1.4.0

# last nmigen required for yowasp-yosys
RUN python3 -m pip install --upgrade git+https://github.com/nmigen/nmigen.git@master#egg=nmigen
RUN python3 -m pip install yowasp-yosys
# first run of yowasp-yosys takes some time, so it's done here
RUN yowasp-yosys --version
RUN python3 -m pip install nmigen-yosys

# nmigen-cocotb, with tuned version for -g2005
RUN python3 -m pip install git+https://github.com/akukulanski/nmigen-cocotb.git@icarus-g2005

COPY ./entry_point.sh /bin/
RUN chmod +x /bin/entry_point.sh
ENTRYPOINT ["/bin/entry_point.sh"]