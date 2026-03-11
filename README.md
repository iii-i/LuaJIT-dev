# LuaJIT-dev

QtCreator-based LuaJIT development setup.

## Usage

```sh
git submodule update --init --recursive
make qtcreator
```

## Cross-compilation

```sh
CROSS=s390x-linux-gnu- make qtcreator
```

If the system `qemu-s390x-static` is too old, some tests may crash.
In this case build it from source and register with binfmt_misc:

```sh
./configure --target-list=s390x-linux-user --static
make -j"$(nproc)"
echo -1 | sudo tee /proc/sys/fs/binfmt_misc/status >/dev/null
sudo scripts/qemu-binfmt-conf.sh -Q "$PWD/build"
```
