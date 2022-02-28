Build a static cross compiler based on [musl.cc](https://musl.cc/)

Following target architectures are supported :

* x86_64
* i686
* armv7l
* aarch64

Ingredients :

* gcc : 6.5.0
* binutils : 2.25.1
* musl : 1.2.2

See https://github.com/ctn-malone/musl-cross-maker/releases for binary packages

By default, packages will be exported to `packages` directory, at the root of the repository

# Build using *Docker*

<u>NB</u> : This is the recommended way

Run `docker/build_and_export_cross-compiler.sh` script

```
./docker/build_and_export_cross-compiler.sh -h
Build a static cross compiler and export it as compressed tarball)
Usage: ./build_and_export_cross-compiler.sh [-p|--packages-dir <arg>] [-a|--arch <type string>] [--(no-)force-build-image] [-v|--(no-)verbose] [-h|--help] [<commit-id>]
        <commit-id>: musl-cross-make commit id (ex: 53280e53a32202a0ee874911fc52005874db344b) (default: '53280e53a32202a0ee874911fc52005874db344b')
        -p, --packages-dir: directory where package will be exported (default: './packages')
        -a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')
        --force-build-image, --no-force-build-image: force rebuilding docker image (off by default)
        -v, --verbose, --no-verbose: enable verbose mode (off by default)
        -h, --help: Prints help
```

<u>Examples</u>

```
./docker/build_and_export_cross-compiler.sh -v
```

Above command will :

* build a *Docker* image (only if it does not already exist) which will download and build necessary dependencies
* run a temporary container and :
  * enable verbose mode inside the container
  * build a static cross compiler for *default* architecture (`x86_64`)
  * export compressed package to *default* location (`packages` directory at the root of the repository)

```
for arch in x86_64 i686 armv7l aarch64 ; do ./docker/build_and_export_cross-compiler.sh -va ${arch} ; done
```

Same as previous command but will build packages for multiple target architectures

# Build without using *Docker*

Run `builder/build_and_export_cross-compiler.sh` script

```
./builder/build_and_export_cross-compiler.sh -h
Build a static cross compiler and export it as compressed tarball
Usage: ./builder/build_and_export_cross-compiler.sh [-p|--packages-dir <arg>] [-a|--arch <type string>] [--(no-)force-checkout-musl-cross-make] [--(no-)force-build-cross-compiler] [-v|--(no-)verbose] [-h|--help] [<commit-id>]
        <commit-id>: musl-cross-make commit id (ex: 53280e53a32202a0ee874911fc52005874db344b) (default: '53280e53a32202a0ee874911fc52005874db344b')
        -p, --packages-dir: directory where package will be exported (default: './packages')
        -a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')
        --force-checkout-musl-cross-make, --no-force-checkout-musl-cross-make: clone repository even if it exists (off by default)
        --force-build-cross-compiler, --no-force-build-cross-compiler: force rebuild (off by default)
        -v, --verbose, --no-verbose: enable verbose mode (off by default)
        -h, --help: Prints help
```

<u>Examples</u>

```
./builder/build_and_export_cross-compiler.sh
```

Above command will :

* build a static cross compiler for *default* architecture (`x86_64`)
* export compressed package to *default* location (`packages` directory at the root of the repository)
