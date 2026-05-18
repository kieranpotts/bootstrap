# Releasing

Releases are tagged in Git. I use the version numbers to pin builds of my [devcontainer](https://hub.docker.com/r/kieranpotts/docker-devcontainer) to a specific point in this repository's history.

Update the changelog and release note, and commit those:

```
$ git add CHANGELOG.md
$ git add RELEASE.md
$ git commit -m "release: v<major>.<minor>.<patch>"
```

Tag the release:

```
$ git tag -a v<major>.<minor>.<patch> -F RELEASE.md
```

Then push the commit and tag:

```
$ git push
$ git push --tags
```
