FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y

RUN apt-get install git -y

RUN git clone https://github.com/arut/nginx-rtmp-module

RUN apt-get install build-essential libpcre3 libpcre3-dev libssl-dev -y

RUN apt-get install wget -y

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt install software-properties-common -y
RUN apt install -y nasm gnutls-bin libgnutls-dane0 libopts25 libunbound8 ladspa-sdk fontconfig-config fonts-dejavu-core gir1.2-glib-2.0 gir1.2-harfbuzz-0.0 icu-devtools libass-dev libass9 libblkid-dev libexpat1-dev libffi-dev libfontconfig1 libfontconfig1-dev libfribidi-dev libgirepository-1.0-1 libglib2.0-bin libglib2.0-dev libglib2.0-dev-bin libgraphite2-3 libgraphite2-dev libharfbuzz-dev libharfbuzz-gobject0 libharfbuzz-icu0 libharfbuzz0b libicu-dev libmount-dev libpcre16-3 libpcre3-dev libpcre32-3 libpcrecpp0v5 libselinux1-dev libsepol-dev python3-distutils python3-lib2to3 uuid-dev libdc1394-25 libdc1394-dev libraw1394-11 libraw1394-dev libraw1394-tools libgsm1 libgsm1-dev libmp3lame-dev libmp3lame0 libjpeg9-dev libjpeg9 libopenjp2-7 libopenjp2-7-dev libasyncns0 libflac8 libice6 libogg0 libpulse-dev libpulse-mainloop-glib0 libpulse0 libsm6 libsndfile1 libvorbis0a libvorbisenc2 libx11-xcb1 libxi6 libxtst6 x11-common libsoxr-dev libsoxr-lsr0 libsoxr0 libspeex-dev libspeex1 libcairo2 libogg-dev libpixman-1-0 libtheora-dev libtheora0 libvorbis-dev libvorbisfile3 libvpx-dev libvpx7 libx264-163 libx264-dev libx265-199 libx265-dev libxcb-render0 libxcb-shm0 libxrender1 libxvidcore4 libxvidcore-dev libopenal-data libopenal-dev libopenal1 libsndio7.0 bzip2-doc libbz2-dev libasound2-dev
WORKDIR /root
RUN git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
RUN apt-get install vim -y
WORKDIR /root/ffmpeg
RUN ./configure --enable-bzlib --enable-ladspa --enable-libass --enable-libdc1394 --enable-nonfree --enable-nonfree --disable-indev=jack --enable-libfreetype --enable-libgsm --enable-libmp3lame --enable-openal --enable-libopenjpeg --enable-libpulse --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libx265 --enable-libxvid --enable-avfilter --enable-postproc --enable-pthreads --disable-static --enable-shared --enable-gpl --disable-debug --disable-stripping --shlibdir=/usr/lib64 --enable-runtime-cpudetect --enable-libvpx --enable-alsa
RUN make -j
RUN make install
WORKDIR /
RUN wget http://nginx.org/download/nginx-1.26.0.tar.gz
RUN tar -xf nginx-1.26.0.tar.gz
RUN apt-get install zlib1g zlib1g-dev gettext-base -y
WORKDIR /nginx-1.26.0
RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module && make -j && make install
RUN mkdir -p /mnt/hls/cam1/cam1
RUN mkdir -p /mnt/hls_ad
RUN mkdir -p /mnt/dash/cam1
RUN mkdir -p /mnt/pages
ADD hls.html /mnt/pages/index.html
ADD dash.html /mnt/pages/dash.html

ADD runCommand.sh /usr/local/bin/runCommand.sh
RUN chmod +x /usr/local/bin/runCommand.sh

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ADD ffmpeg.conf /etc/ld.so.conf.d/ffmpeg.conf
RUN ldconfig

ADD nginx_adaptive.conf /tmp/nginx.templ

RUN touch /var/log/syslog
RUN chown nobody:nogroup /var/log/syslog

RUN mkdir /var/run/cams
RUN chown -R nobody:nogroup /var/run/cams

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
