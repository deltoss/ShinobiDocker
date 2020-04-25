# Publishing

This repository uses `buildx` to build and publish the docker image.
At time of writing, multi-architectural builds with `buildx` is an experimental feature. You'd need to enable the experimental features for docker.

To enable experimental features on Windows `Docker Desktop`:
1. Right click on the docker icon on the bottom right tray.
2. Click on `Settings`.
   ![Settings Context Menu](/assets/Publishing%20-%20Buildx%20-%20Enable%20Windows%20Docker%20Experimental%20Features%20-%2001.jpg)
3. Click on the `Enable Experimental Features` switch under the `Command Line` tab.
4. ![Command Line Experimental Features Switch](/assets/Publishing%20-%20Buildx%20-%20Enable%20Windows%20Docker%20Experimental%20Features%20-%2002.jpg)
5. Click `Apply and Restart`.

Now to build a docker image, we'll use the new docker command line tool called `buildx`.

1. Navigate to where you `Dockerfile` resides.
   ```powershell
   cd <PathToDockerFileDirectory>
   ```
2. You need to create your custom builder, and use it. You can't use the default docker builder as it doesn't support multi-architectural builds.
   ```powershell
   docker buildx create --name <YourBuilderName>
   docker buildx use <YourBuilderName>
   ```
3. Login to your docker image repository. This will prompt you for your username and password if you haven't logged in before.
   ```powershell
   docker login
   ```
4. Now to do the actual build using `buildx`. For the most part, `buildx` is just an extension to the `build` command, meaning it has the same syntax, just a few extended flags and features, such as `--platform` which we can use for multi-architectural builds.
   ```powershell
   docker buildx build --platform <SupportedCpuArchitectures> -t "<YourDockerUserName>/<YourImageName>:<tag>" --push .
   ```
   > The `<SupportedCpuArchitectures>` is a string of CPU architectures to support, delimited by comma (e.g. `linux/amd64,linux/arm/v6,linux/arm64/v8`). The CPU architectures that can be supported depends on:
   > 1. The base image you're using in the `Dockerfile`. It must support the architecture you've provided. You can check what CPU architecture your base image supports through finding the image in [DockerHub](https://hub.docker.com/), click on the image, and then click on the `Tags` tab. There, you'd be able to see a list of `OS/Arch` it supports. Your list of supported CPU architectures must be a subset of that list.
   >   ![Searching the Supported Architecture for Docker Image](/assets/Publishing%20-%20Buildx%20-%20Searching%20the%20Supported%20Architectures%20for%20a%20Docker%20Image.jpg)
   > 2. The architecture that's supported by your installed software & architecture. You can find what is supported through running the below command:
   >    ```powershell
   >    docker buildx inspect --bootstrap
   >    ```

Here's an example with putting everything together:

```powershell
cd shinobi
docker buildx create --name shinobibuilder
docker buildx use shinobibuilder
docker login
docker buildx build --platform linux/amd64,linux/arm/v6,linux/arm64/v8 -t mtran0011/shinobi --push .
```

If you'd like to remove your custom builder, you can use:

```powershell
docker buildx use default
docker buildx rm shinobibuilder
```

For more information, see:
* [https://medium.com/@artur.klauser/building-multi-architecture-docker-images-with-buildx-27d80f7e2408](https://medium.com/@artur.klauser/building-multi-architecture-docker-images-with-buildx-27d80f7e2408)
* [https://dev.to/arturklauser/building-multi-architecture-docker-images-with-buildx-1mii](https://dev.to/arturklauser/building-multi-architecture-docker-images-with-buildx-1mii)