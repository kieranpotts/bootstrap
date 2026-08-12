# Releasing

Major milestones are tagged in Git. Version tags may be used to pin dependent
scripts to particular stable revisions. But no artifacts are "released" as such.

Follow these steps to prepare a new version tag.

1.  Review the `[Unreleased]` section of the `CHANGELOG.md` file.
2.  Commit your changes to that file.
3.  Clear the Git working tree of any other dirty changes.
4.  Run `make version` and follow the steps.
5.  Review the `version:` commit generated. Push it: `git push --follow-tags`.
