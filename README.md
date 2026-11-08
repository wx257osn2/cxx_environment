# C++ environment

modern C++ environment using singularity

## Usage

### Use on Github Actions

You can use `cxx-env-run` after `uses: wx257osn2/cxx_environment@v3` .

```yaml
runs:
  - uses: wx257osn2/cxx_environment@v3
    with:
      version: v20261108    # specify image version
  - run: cxx-env-run g++ --version
```

### Use on Local Environment

#### Prerequisites

- required
    - [`singularity`](https://github.com/sylabs/singularity) or [`apptainer`](https://github.com/apptainer/apptainer) on `$PATH`
- optional
    - [`docker`](https://docs.docker.com/reference/cli/docker/) on `$PATH` , and
        - you can `sudo` , or
        - [`proot`](https://proot-me.github.io/) exists on `$PATH`

#### Option A: Build an image

```console
$ ./build.bash
```

or,

```console
# ./build.bash
```

#### Option B: Download a prebuilt image

```console
$ ./pull.bash
```

#### Exec some commands on the image

```console
$ ./run clang++ --version
Ubuntu clang version 23.1.6 (++20261103094334+2875c6073a7e-1~exp1~20261103214345.93)
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/lib/llvm-23/bin
Configuration file: /usr/lib/llvm-23/bin/clang++.cfg
```

#### Shell

```console
$ ./bash
(cxx singularity) user@hostname:/path/to/cxx_environment$
```

## License

[MIT](https://github.com/wx257osn2/cxx_environment/blob/master/LICENSE)
