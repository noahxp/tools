FROM centos:latest  
MAINTAINER noahxp <noahxp@gmail.com>

RUN yum -y update
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y wget
RUN yum install -y autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel


RUN mkdir /src


RUN cd /src \
&& git clone git://github.com/yasm/yasm.git \
&& cd /src/yasm \
&& ./autogen.sh \
&& make \
&& make install



RUN cd /src \
&& wget http://downloads.xiph.org/releases/ogg/libogg-1.3.0.tar.gz \
&& tar xzvf libogg-1.3.0.tar.gz \
&& cd /src/libogg-1.3.0 \
&& ./configure --disable-shared \
&& make \
&& make install



RUN cd /src \
&& wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.gz \
&& tar xzvf libvorbis-1.3.3.tar.gz \
&& cd /src/libvorbis-1.3.3 \
&& ./configure --disable-shared \
&& make \
&& make install


RUN cd /src \
&& git clone https://chromium.googlesource.com/webm/libvpx \
&& cd /src/libvpx \
&& ./configure \
&& make \
&& make install



RUN cd ~/src \
&& wget http://www.libsdl.org/release/SDL-1.2.15.tar.gz \
&& tar xzvf SDL-1.2.15.tar.gz \
&& cd /src/SDL-1.2.15 \
&& ./configure \
&& make \
&& make install



RUN cd ~/src \
&& git clone git://source.ffmpeg.org/ffmpeg.git \
&& cd ffmpeg \
&& ./configure --enable-libvpx --enable-libvorbis \
&& make \
&& make install



ENV TERM="xterm-color"
ENV LANG='en_US.UTF-8'
ENV LANGUAGE='en_US.UTF-8'
