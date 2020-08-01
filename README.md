# use

_this is a prototype_

Getting started
===============

Running a core function:

```sh
$ bash ./launcher.sh internal/strings.sh string_sub Hello 0 3
Hel$
```

Running all tests in the curret shell:

```sh
$ bash ./launcher.sh tests/all.sh _run_tests
```

Running all tests in all shells (requires them installed and docker):

```sh
$ bash ./compatmatrix.sh ./launcher.sh tests/all.sh _run_test
```

# Previous work

https://github.com/alganet/coral
https://github.com/Mosai/workshop

# References

https://wiki.ubuntu.com/DashAsBinSh
https://www.etalabs.net/sh_tricks.html
