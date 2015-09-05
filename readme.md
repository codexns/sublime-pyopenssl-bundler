# Sublime pyOpenSSL Bundler

This is a simple bash script that takes the output of
https://github.com/codexns/pyopenssl-build and moves the resulting files into
repos set up for use in Sublime Text.

## Instructions

After compiling the packages on the various environments using `pyopenssl-build`
and creating a new release with all of the output files, check out the following
repos:

```bash
git clone git@github.com:codexns/sublime-pyopenssl-bundler.git
git clone git@github.com:codexns/sublime-cffi.git
git clone git@github.com:codexns/sublime-cryptography.git
git clone git@github.com:codexns/sublime-pyOpenSSL.git
```

Then execute the `update.sh` by providing the tag name from `pyopenssl-build`.
For example:

```bash
cd sublime-pyopenssl-bundler
./update.sh cryptography-0.6.1_pyopenssl-0.14_openssl-1.0.1j
```

Finally you'll need to commit the changes to the `sublime-cffi`,
`sublime-cryptography` and `sublime-pyOpenSSL` repos, tag them and push them up
to GitHub.
