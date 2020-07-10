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
        iverilog \
        libftdi-dev \
        libtinfo5 && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip pytest numpy ipython
RUN python3 -m pip install cocotb==1.3.1
RUN python3 -m pip install git+https://github.com/akukulanski/nmigen-cocotb.git@master


# last nmigen required for yowasp-yosys
RUN python3 -m pip install --upgrade git+https://github.com/nmigen/nmigen.git@master#egg=nmigen

# so nmigen uses yowasp-yosys
RUN python3 -m pip install nmigen-yosys

COPY ./entry_point.sh /bin/
RUN chmod +x /bin/entry_point.sh
ENTRYPOINT ["/bin/entry_point.sh"]