# Shinobi CCTV on Docker

This image was inspired by MiGoller. Since forking; mrproper's previous image has been merged to make an ultimate docker image with `docker-compose`.

Due to MiGoller's valiant efforts Shinobi now supports Docker. I hope I speak for everyone when I say thank you MiGoller!

Find MiGoller's original image here : https://hub.docker.com/r/migoller/shinobi/

### How to Dock Shinobi

>  `docker-compose` should already be installed.

1. Clone the Repo and enter the `docker-shinobi` directory.
    ```bash
    git clone https://gitlab.com/Shinobi-Systems/ShinobiDocker.git ShinobiDocker && cd ShinobiDocker
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
    http://xxx.xxx.xxx.xxx:8080/
    ```

5. Enjoy!
