---
title: "Releasing"
linkTitle: "Releasing"
weight: 3
description: >
  How to create a new Quarks Operator release on GHA
---

We're releasing based on tags, which contain our version number. The format is 'v0.0.0'.
The release title will be set to this version.

Releases are done with Github Actions, a shell script extracts the version number from the Git state.

To trigger the Action, push a release tag to the repo. Release tags begin with 'v'.


## Create a new release

Every major release should have it's own branch, i.e. `v7.x`.

Merge the current state into the release branch:

  git checkout v7.x
  git merge master
  # this will run CI, can be canceled
  git push

Create a tag on that branch and push it, to create a new release:

   git tag v7.2.0
   # this will run CI again, release-drafter, then publish
   git push origin v7.2.0
   # runs ci, release drafter, publish

*Note*: Do not edit/create a  release on Github before the publish step has finished, as it will overwrite the draft or create an additional draft.

## Release Artifacts

The `release-drafter` will create a new draft release on Github.


* Helm chart in our repo at https://cloudfoundry-incubator.github.io/quarks-helm/
* Docker image of the operator on ghcr.io
* quarks-operator binary attachment

If the pipeline runs again for the same release version, it will fail, unless the binary attachment is removed from the release.
After requesting to remove the binary, it takes up to twenty minutes for Github to really remove it.


## Checklist

### Major Release

1. Create version branch

### Minor Bump

1. Tag commit with new release version
1. Push commit
1. Wait for pipeline to finish
1. Publish the draft Github release for the release version tag


Note: If trying to re-release: remove old binary attachment first.

## Docs

Documentation for releases is kept in branches of the quarks-doc repo.
Release docs are pushed to Cloudfoundry via Github Actions, as defined in the branch.

On the release branch:
* Use a unique app name in `manifest.yaml`.
* Edit `.github/workflows/pages` branch to match the release branch.

Be sure to adapt menus in all branches (`config.toml`) to match the new app URL.

# Troubleshooting

## Provoke tag push events

Delete the tag and push it again:

    git push -d origin v9.9.9
    git push origin v9.9.9

## Publishing the Github Release fails

Delete the attached binary, wait and run retrigger job.

## Publishing the Helm Chart fails

The Helm charts are stored in a Github repository, concurrent access can lead to merge conflicts.

## Release-Drafter does not trigger

Probably needs a different token, to be triggered by another Github Action.
