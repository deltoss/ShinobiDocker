# Shinobi CCTV on Docker

This is based on the official [Shinobi docker image](https://gitlab.com/Shinobi-Systems/ShinobiDocker).

This is a `docker-compose` setup where the Shinobi image and the MariaDB is not in the same image. This keeps things easy to maintain and swap the database out.

The database can even be on a separate server machine, or not even dockerised.

### Features

* Shinobi & MariaDB image are two separate containers.
  * You can easily swap out MariaDB for another DB image, such as MySQL, or change the MariaDB version.
  * You can even decide to have a DB sitting directly on a physical machine, rather then as a container.
* Multi-arch builds, which means the Shinobi image is compatible with different CPU architectures.
  * Such as ARM used by Raspberry Pis, etc.
* `PHP My Admin` is included, so you can manage the data in your database, simply by browsing to `http://xxx.xxx.xxx.xxx:8888`.

### How to Dock Shinobi

>  `docker-compose` should already be installed.

1. Clone the Repo and enter the `docker-shinobi` directory.
    ```bash
    git clone https://github.com/deltoss/ShinobiDocker.git ShinobiDocker && cd ShinobiDocker
    ```

2. Spark one up.
    ```bash
    docker-compose up -d
    ```

3. Open your computer's IP address in your web browser on port `8080`. Open the superuser panel to create an account.
    ```
    Web Address : http://xxx.xxx.xxx.xxx:8080/super
    Username : admin@shinobi.video
    Password : admin
    ```

4. After account creation head on over to the main `Web Address` and start using Shinobi!
    ```
    http://xxx.xxx.xxx.xxx:8080
    ```

5. Enjoy!

### Working on the Raspberry Pi

Raspberry Pi 3 & 4 uses the ARMv7 32-bit architecture. This Shinobi image supports ARMv7 architecture, however the official MariaDB docker image does not. At time of writing, it only supports ARM64

Thus, you could either make your own image, and build it to support ARMv7, or use a non-official MariaDB image which supports ARMv7.

To change the MariaDB image, you can simply change the value of `MARIADB_IMAGE` in the `.env` file.

For example, change this:

```env
MARIADB_IMAGE=mariadb:latest
```

To this:

```env
MARIADB_IMAGE=yobasystems/alpine-mariadb:latest
```

[yobasystems/alpine-mariadb](https://github.com/yobasystems/alpine-mariadb) is a third-party MariaDB image which supports ARMv7.