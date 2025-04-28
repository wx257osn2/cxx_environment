# C++ environment

modern C++ environment using singularity

## Usage

### Use on Github Actions

You can use `cxx-env-run` after `uses: wx257osn2/cxx_environment@v2` .

```yaml
runs:
  - uses: wx257osn2/cxx_environment@v2
    with:
      version: v20250426    # specify image version
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

#### Build

```console
$ ./build.bash
```

or,

```console
# ./build.bash
```

#### Exec some commands on the image

```console
$ ./run clang++ --version
Ubuntu clang version 20.1.4 (++20250425113151+62072e7f877e-1~exp1~20250425233305.108)
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/lib/llvm-20/bin
```

#### Shell

```console
$ ./bash
user@hostname:/path/to/cxx_environment$
```

## License

[MIT](https://github.com/wx257osn2/cxx_environment/blob/master/LICENSE)
