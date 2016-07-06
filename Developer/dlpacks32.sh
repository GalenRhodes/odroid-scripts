#!/bin/bash

wget -O cmake-3.5.2-Linux-aarch32.deb https://www.dropbox.com/s/inqyomu2sn7nvqp/cmake-3.5.2-Linux-armv7l-complete.deb?dl=0 && \
	wget -O libdispatch-0.1.3.1-linux-aarch32.deb https://www.dropbox.com/s/9enhtu90u8di85u/libdispatch-0.1.3.1-0.1.3-linux-armv7l.deb?dl=0 && \
	wget -O libobjc2-1.8-linux-aarch32.deb https://www.dropbox.com/s/bgtnd76vm2hy9na/libobjc2-1.8-linux-armv7l.deb?dl=0 && \
	wget -O llvm-3.9-linux-aarch32.deb https://www.dropbox.com/s/k6shspi7p046qh6/llvm-3.9-linux-armv7l.deb?dl=0 && \
	sudo dpkg -i cmake-3.5.2-Linux-aarch32.deb && \
	sudo dpkg -i llvm-3.9-linux-aarch32.deb && \
	sudo dpkg -i libobjc2-1.8-linux-aarch32.deb && \
	sudo dpkg -i libdispatch-0.1.3.1-linux-aarch32.deb

exit "$?"
