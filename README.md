# docker-aria2-with-ariang

[![](https://images.microbadger.com/badges/version/maxduke/aria2-with-ariang.svg)](https://microbadger.com/images/maxduke/aria2-with-ariang "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/maxduke/aria2-with-ariang.svg)](https://microbadger.com/images/maxduke/aria2-with-ariang "Get your own image badge on microbadger.com")

[![Docker Pulls](https://img.shields.io/docker/pulls/maxduke/aria2-with-ariang.svg)](https://hub.docker.com/r/maxduke/aria2-with-ariang/ "Docker Pulls")
[![Docker Stars](https://img.shields.io/docker/stars/maxduke/aria2-with-ariang.svg)](https://hub.docker.com/r/maxduke/aria2-with-ariang/ "Docker Stars")
[![Docker Automated](https://img.shields.io/docker/automated/maxduke/aria2-with-ariang.svg)](https://hub.docker.com/r/maxduke/aria2-with-ariang/ "Docker Automated")

## Usage

0. Prepare config and download directories with following commands.

    ```bash
    # Create config dir
    mkdir /storage/aria2/conf

    # Get uid and gid, see below
    id

    # Set proper permissions. Change 1001:1002 to your own uid:gid .
    chown -R 1001:1002 /storage/aria2/conf

    find /storage/aria2/conf -type d -exec chmod 755 {} +
    find /storage/aria2/conf -type f -exec chmod 644 {} +

    # Create download dir
    mkdir /storage/aria2/downloads

    # Set proper permissions. Change 1001:1002 to your own uid:gid .
    chown -R 1001:1002 /storage/aria2/downloads
    find /storage/aria2/downloads -type d -exec chmod 755 {} +
    find /storage/aria2/downloads -type f -exec chmod 644 {} +
    ```
0. Put `aria2.conf` file in the config dir, with following content.

    ```ini
    save-session=/aria2/conf/aria2.session
    input-file=/aria2/conf/aria2.session
    save-session-interval=60

    dir=/aria2/downloads

    file-allocation=prealloc
    disk-cache=128M

    enable-rpc=true
    rpc-listen-port=6800
    rpc-allow-origin-all=true
    rpc-listen-all=true

    rpc-secret=<password>

    auto-file-renaming=false

    max-connection-per-server=16
    min-split-size=1M
    split=16
    ```
0. Run following command to start aria2 instance

    ```bash
    # Change 1001:1002 to your own uid:gid .
    docker run \
      -d \
      --name aria2 \
      -u=1001:1002 \
      -v /storage/aria2/conf:/aria2/conf \
      -v /storage/aria2/downloads:/aria2/downloads \
      -p 6800:6800 \
      -p 56881:56881 \
	  -p 80:80 \
	  -p 8080:8080 \
      maxduke/aria2-with-ariang
    ```

Note:
* Make sure the download folder is writable by the given uid/gid.
* `aria2.conf` will be created automatically if not exists.
* Learn more about tuning `aria2.conf`: [Config reference](https://aria2.github.io/manual/en/html/aria2c.html#aria2-conf)

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
`http://192.168.x.x:8080` would show you what's running INSIDE the container on port 80.


* `-p 6800:6800` - port for aria2 rpc
* `-p 56881:56881` - port for DHT
* `-p 80:80` - port for AriaNG http service
* `-p 8080:8080` - port for downloads directory http service
* `-v /storage/aria2/conf:/aria2/conf` - where aria2 should store config files and logs
* `-v /storage/aria2/downloads:/aria2/downloads` - local path for downloads
* `-u 1001` for UserID - see below for explanation
* `-u 1001:1002` for GroupID - see below for explanation

It is based on alpine linux, for shell access whilst the container is running do `docker exec -it maxduke/aria2-with-ariang /bin/sh`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `-u 1001:1002`. To find yours use `id user` as below:

```bash
  $ id dockeruser
    uid=1001(dockeruser) gid=1002(dockergroup) groups=1002(dockergroup)
```

