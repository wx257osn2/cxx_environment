# C++ environment

modern C++ environment using singularity

## Usage

### Prerequisites

- required
    - [`singularity`](https://github.com/sylabs/singularity) on `$PATH`
- optional
    - [`docker`](https://docs.docker.com/reference/cli/docker/) on `$PATH` , and
        - you can `sudo` , or
        - [`proot`](https://proot-me.github.io/) exists on `$PATH`

### Build

```console
$ ./build.bash
```

or,

```console
# ./build.bash
```

### Exec some commands on the image

```console
$ ./run clang++ --version
Ubuntu clang version 19.1.0 (++20240815083345+4d4a4100f68d-1~exp1~20240815083400.23)
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/lib/llvm-19/bin
```

### Shell

```console
$ ./bash
user@hostname:/path/to/cxx_environment$
```

## License

[MIT](https://github.com/wx257osn2/cxx_environment/blob/master/LICENSE)
