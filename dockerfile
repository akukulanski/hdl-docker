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

RUN wget http://http.us.debian.org/debian/pool/main/i/iverilog/iverilog_10.1-0.1+b2_amd64.deb && \
    dpkg -i iverilog_10.1-0.1+b2_amd64.deb && \
    apt-get install -f && \
    dpkg -i iverilog_10.1-0.1+b2_amd64.deb && \
    apt-get clean && \
    rm -r iverilog_10.1-0.1+b2_amd64.deb
RUN iverilog -V | grep --color "Icarus Verilog version 10\.1"

RUN python3 -m pip install --upgrade pip pytest numpy ipython
RUN python3 -m pip install cocotb==1.3.1

# last nmigen required for yowasp-yosys
RUN python3 -m pip install --upgrade git+https://github.com/nmigen/nmigen.git@master#egg=nmigen
RUN python3 -m pip install yowasp-yosys
RUN yowasp-yosys --version
RUN python3 -m pip install nmigen-yosys

RUN python3 -m pip install git+https://github.com/akukulanski/nmigen-cocotb.git@master

COPY ./entry_point.sh /bin/
RUN chmod +x /bin/entry_point.sh
ENTRYPOINT ["/bin/entry_point.sh"]