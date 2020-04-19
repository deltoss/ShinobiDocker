# Shinobi CCTV on Docker

This is based on the official [Shinobi docker image](https://gitlab.com/Shinobi-Systems/ShinobiDocker).

This is a `docker-compose` setup where the Shinobi image and the MariaDB is not in the same image. This keeps things easy to maintain and swap the database out.

The database can even be on a separate server machine, or not even dockerised.

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
