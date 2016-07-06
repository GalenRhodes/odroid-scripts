#!/bin/bash

wget -O cmake-3.5.2-Linux-aarch64.deb https://www.dropbox.com/s/7b9bhny4n1qgrke/cmake-3.5.2-Linux-aarch64.deb?dl=0 && \
	wget -O libdispatch-0.1.3.1-linux-aarch64.deb https://www.dropbox.com/s/gugmv7xd6q36xbe/libdispatch-0.1.3.1-linux-aarch64.deb?dl=0 && \
	wget -O libkqueue0-2.0.4-linux-aarch64.deb https://www.dropbox.com/s/gudfubuuyzeyubg/libkqueue0-2.0.4-linux-aarch64.deb?dl=0 && \
	wget -O libobjc2-1.8-linux-aarch64.deb https://www.dropbox.com/s/nrmyrkjomikqf29/libobjc2-1.8-linux-aarch64.deb?dl=0 && \
	wget -O llvm-3.9-linux-aarch64.deb https://www.dropbox.com/s/ue8imd2qsd35dq0/llvm-3.9-linux-aarch64.deb?dl=0 && \
	sudo dpkg -i cmake-3.5.2-Linux-aarch64.deb && \
	sudo dpkg -i llvm-3.9-linux-aarch64.deb && \
	sudo dpkg -i libobjc2-1.8-linux-aarch64.deb && \
	sudo dpkg -i libkqueue0-2.0.4-linux-aarch64.deb && \
	sudo dpkg -i libdispatch-0.1.3.1-linux-aarch64.deb

exit "$?"
