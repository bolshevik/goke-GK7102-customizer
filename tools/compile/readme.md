# Example of using GOKE SDK to cross-compile CURL

Pre-requisites: Docker Engine or Docker for Desktop https://www.docker.com/products/docker-desktop

1. Download SDK from https://github.com/ant-thomas/zsgx1hacks/issues/124 und unpack it into this directory. Then locate `goke-arm1176-linux3.4.43-gcc4.6.1-uClibc.tar.bz2` and also unpack it.

2. Prepare the builder Ubuntu image:
    `docker build --tag test_ubuntu .`
3. Enter the image:
    `docker run --rm -it -v $(pwd):/home/ test_ubuntu /bin/bash`

    On Windows replace `$(pwd)` just with your full path to the current directory.

4. Download LibreSSL https://github.com/libressl-portable/portable/releases.
   Replace `/home/GK710X_LinuxSDK_v2.0.0/tools/toolchain/arm-linux/4.6.1/usr/bin/` further with your SDK path.

    ```
    cd /home
    mkdir -p /home/tools/libressl
    cd PATH_TO_LIBRE_SSL_SRC
    ./autogen.sh --prefix=/home/tools/libressl
    export PATH=/home/GK710X_LinuxSDK_v2.0.0/tools/toolchain/arm-linux/4.6.1/usr/bin/:$PATH
    ./configure --host=arm-goke-linux-uclibcgnueabi --prefix=/home/tools/libressl

    make

    make install
    ```

5. Download CURL source code from: https://github.com/curl/curl/releases and unpack it. For example, `curl-7.68.0.zip`.
6. Configure CURL:
    ```
    cd PATH_TO_CURL_SRC
    export PATH=/home/GK710X_LinuxSDK_v2.0.0/tools/toolchain/arm-linux/4.6.1/usr/bin/:$PATH

    LDFLAGS="-s -w -L/home/tools/libressl/lib" CPPFLAGS=-I/home/tools/libressl/include ./configure --disable-shared --enable-static --with-ssl=/home/tools/libressl/ --host=arm-goke-linux-uclibcgnueabi

    make
    ```

7. Build it:
    `make`
8. Copy these into the camera:
    * `src/curl`
    * `/home/tools/libressl/lib/libcrypto.so.45.0.5` rename to `libcrypto.so.45`
    * `/home/tools/libressl/lib/libssl.so.47.0.6` rename to `libssl.so.47`
    * `/home/tools/libressl/lib/libtls.so.19.0.7` rename to `libtls.so.19`
9. Strip all files with `arm-goke-linux-uclibcgnueabi-strip`