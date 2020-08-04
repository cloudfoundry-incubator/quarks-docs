---
title: "Contribution Guidelines"
linkTitle: "Contribution Guidelines"
weight: 10
description: >
  How to contribute to Quarks
---

{{% pageinfo %}}
The intended audience of this document are developers wishing to
contribute to the Quarks project.

It provides a basic overview of various aspects of the project below,
and uses these overviews as the launching points to other documents
which go deeper into the details of each aspect.
{{% /pageinfo %}}

# Contributing to CF-Operator

First, thanks for taking the time to contribute to the project!

The following is a set of guidelines for contributing to CF-Operator.
Use your best judgment, and feel free to propose changes to this document in a pull
request.

## How to contribute

**Please do not report security vulnerabilities in public issues**!

Instead, report to the CloudFoundry Foundation team first <security@cloudfoundry.org> and give us
some time to fix it in a timely matter before disclosing it to the public. For more
information check the CloudFoundry Security [page](https://www.cloudfoundry.org/security/).

Don't forget to familiarize yourself with our processes and tools, by reading about them [here](../development/tooling).

### Conversation

When contributing to this repository, please discuss the changes through an existing Github issue 
with the core team. We believe it's the right place to have an open conversation.

### Pull Request

Pull Requests are the most well-known way to contribute to any project and they are more than welcome
in the CF-Operator project.
Commit messages must be clear and concise to help the reviewer understand what the PR is doing.

## Issues tracker

The CF-Operator workload is tracked [here](https://www.pivotaltracker.com/n/projects/2192232).
All Github issues are synced with this tracker, so all community issues (either bugs or features) should go to Github.

We want short and accurate templates for different types of issues, to gather required information and to start a conversation.
Once again, feel free to improve them by opening a pull request.

### How to report a bug

Start by searching [bugs][1] for some similar issues and/or extra information. If your search
doesn't bring you any help then open an issue by selecting the issue type "Bug" and fill the
template as accurately as possible.

### How to suggest a feature/enhancement

If you find yourself wishing for a feature/enhancement that doesn'y exist yet in CF-Operator, start
by running a quick [search][2] - you may not be alone! If you're out of luck, then go ahead and open a
new issue by selecting the "Feature" issue type and answer some needed questions.

### How are Github issues handled

When you create a github issue, cf-bot creates a story in the `IceBox` board in the tracker automatically 
and comments on the issue with the link to the story.
The core team conducts its planning session once every week during which your issue will be discussed.

* If the story is moved to the `Current Iteration/Backlog` board, then expect that the story would be worked on in the coming sprints.
* If the story is left out in the `IceBox` board itself, then expect that the story low in priority.
* If the github issue becomes stale, it might be closed even though we plan to work on it. The core team will reopen it when work begins.
* Both the github issue and the story will be closed if there is no response for more than 30 days when contacted.

### How are tracker stories handled

* By default, a story is in an `Unstarted` state. 
* When the developer clicks on the `Start` button, the story moves to `Started` state. 
* When the developer finishes the story, submits a PR and clicks on `Finish` button, the story moves to `Finished` state.
* After approving all PRs that belong to a story, the reviewer and author then try to merge and rebase those PRs, changing references as needed, and ensure all tests are still green. Finally one of them clicks the `Deliver` button which is when the story moves to the `Delivered` state. 
* The team lead, after checking the feature/bugfix, will accept the story. That is the end of the life of a story. A detailed flow diagram can be found [here](https://www.pivotaltracker.com/help/articles/story_states/).

## Code review process

The core team looks to Pull Requests regularly and in a best effort.

## Community

You can chat with the core team on the Slack channel #quarks-dev, on the [Cloud Foundry Slack](https://cloudfoundry.slack.com/archives/C1BQKKNP4).

## Code of conduct

Please refer to [Code of Conduct](https://www.cloudfoundry.org/code-of-conduct/)

## Links

- [Bugs](https://github.com/cloudfoundry-incubator/cf-operator/issues?q=is%3Aopen+is%3Aissue+label%3Abug)
- [Features](https://github.com/cloudfoundry-incubator/cf-operator/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement)
- [Readme](https://github.com/cloudfoundry-incubator/cf-operator#cf-operator)

