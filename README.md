# oe-builder - containers to run yocto builds

oe-builder is a small self-extractable script that generates docker containers
suitable to build each release of Open Embedded or Yocto Project releases.

Having felt building particularly old releases (morty), the idea came up of
generating a self-extractable archive launches the container suitable to build
each of the supported Yocto Project releases. If the container is not created
yet, the attached payload of the launcher is used to generate all containers
on-the-fly.

## Main features

* oe-builder automatically detects a present ssh-agent socket and bind-mounts it
  so that it can be used from within the container.
* oe-builder runs internally with the same user and group id as the user that
  launched the container

## Building

Clone the sources:

```
https://github.com/amsobr/oe-builder.git
```

Enter the sources directory and run `make`
```
cd oe builder
make
```

The redistributable launcher will be created in `build/oe-builder`


## Using

Copy `oe-builder` into some location belonging to `$PATH` and run:

* `oe-builder list` to list all supported images
* `oe-builder run release` to launch a container suitable to build given release
  of the Yocto Project


## Sharing files between host and container

The launcher bind-mounts the current working directory of the host to the
`/workdir` directory in the container. The container runs as the same user and
group id as the user on the host to allow seamless sharing of files.

## Typical workflow

Clone the poky sources into your workspace
```
$ git clone -b morty git://git.yoctoproject.org/poky
Cloning into 'poky'...
remote: Enumerating objects: 659553, done.
remote: Counting objects: 100% (111/111), done.
remote: Compressing objects: 100% (76/76), done.
remote: Total 659553 (delta 41), reused 76 (delta 35), pack-reused 659442
Receiving objects: 100% (659553/659553), 208.39 MiB | 5.21 MiB/s, done.
Resolving deltas: 100% (480226/480226), done.

```

Launch the container, which will take us into the containerized environment.

```
$ oe-builder run morty
Checking if required images are present...
Welcome to the OE morty Build Environment 0.1
Please keep in mind that all files outside  are volatile!
AGAIN: ANY changes made outside /workdir will be lost on exit.
oe-builder@02b3ae576ebf:workdir$
```

Initialize the bitbake environment and start building.

```
$ . poky/oe-init-build-env
You had no conf/local.conf file. This configuration file has therefore been
created for you with some default values. You may wish to edit it to, for
example, select a different MACHINE (target hardware). See conf/local.conf
for more information as common configuration options are commented.

You had no conf/bblayers.conf file. This configuration file has therefore been
created for you with some default values. To add additional metadata layers
into your configuration please add entries to conf/bblayers.conf.

The Yocto Project has extensive documentation about OE including a reference
manual which can be found at:
    http://yoctoproject.org/documentation

For more information about OpenEmbedded see their website:
    http://www.openembedded.org/


### Shell environment set up for builds. ###

You can now run 'bitbake <target>'

Common targets are:
    core-image-minimal
    core-image-sato
    meta-toolchain
    meta-ide-support

You can also run generated qemu images with a command like 'runqemu qemux86'

oe-builder@02b3ae576ebf:build$ bitbake core-image-minimal


```


## Supported Yocto Project Releases

For now only morty is supported, with new releases, especially LTS versions,
expected to land in the short term.

