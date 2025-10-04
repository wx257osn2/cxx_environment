# C++ environment

modern C++ environment using singularity

## Usage

### Use on Github Actions

You can use `cxx-env-run` after `uses: wx257osn2/cxx_environment@v3` .

```yaml
runs:
  - uses: wx257osn2/cxx_environment@v3
    with:
      version: v20251004    # specify image version
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
$ singularity pull oras://ghcr.io/wx257osn2/cxx_environment:v20251004-$(uname -m)
$ mv cxx_environment_v20251004-$(uname -m).sif cxx-$(uname -m).sif
```

or,

```console
$ apptainer pull oras://ghcr.io/wx257osn2/cxx_environment:v20251004-$(uname -m)
$ mv cxx_environment_v20251004-$(uname -m).sif cxx-$(uname -m).sif
```

#### Exec some commands on the image

```console
$ ./run clang++ --version
Ubuntu clang version 21.1.3 (++20250923093437+74cb34a6f51a-1~exp1~20250923213555.35)
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/lib/llvm-21/bin
```

#### Shell

```console
$ ./bash
(cxx singularity) user@hostname:/path/to/cxx_environment$
```

## License

[MIT](https://github.com/wx257osn2/cxx_environment/blob/master/LICENSE)
