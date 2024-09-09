## Goal

Help people understand the tool, unlock its possibilities, get the ability to intervene when “things go wrong” and demystify some pre-conceived ideas.
This might include some occasional trips in the depths of Git codebase, many examples, demos and children toys.
Being a long time command line user, everything will happen there, no GUI, no editor’s integration. This will allow us to explore Git’s concepts with no or little sugaring.

## Introduction

Git is a toolbox. Like a woodworker’s toolbox, it offers a whole collection of tools (screwdriver, drill, saws, L-keys; commit, rebase, branches, bisect…). Just like in a woodworker’s tool box, these tools:

- have a or some specific role
- have all their use
- can sometimes be swapped with another, sometimes not.
- can be dangerous, or harmless

Git does not tell you what to do, which workflow to use. Instead, people can have the workflow which works best for them, for their team with the provided tools.

In overall, aside from offering the whole version control and collaboration, Git can also offer a great safety net for the user.
My goal here is to demystify, explain, uncover a whole selection of Git’s tools in order to offer comfort to the user, to go beyond pull, checkout, commit, push. I want to help people feeling safe with this toolbox, to help them leveraging it, in order for it to be a better safety net.

## Program, WIP

### Topics

- [Repository](#repository)
- [Commits](#commits)
- [Branches](#branches)
- [Reflog](#reflog)
- [Rebase](#rebase)

### Concepts

- [X] Repository
- [X] commits, what are they, what do they mean?
- [X] branches, what are they, what are they NOT?
- [X] reflog
- [ ] conflicts, an unfortunate name. what does it mean?
- [ ] communication with remotes?
- [ ] commit ranges
- [ ] .git directory
- [X] difference between `^` and `~`

### Operations

- Staging area, what is it? how to use it? how to leverage it?
	- `-p` option
- cherry picking
- Merging
- Reset and Checkout: the two most dangerous commands in Git, seriously.
- Pulling
- [-] Rebase
	- [X] What is it? What does it do?
		Depends on:
		- commits
	- How to verify that everything went good
		Depends on:
		- diff
		- commit ranges
		- range diffs
	- Something went wrong, how to fix it?
		Depends on:
		- reflog
		- reset
		- conflicts
	- Interactive rebase
- Bisecting
- Fixup and Squash
- Stash

### Thoughts

toolbox vs workflow (merge, squash, …)

### Personal workflows

- day to day work, branch organisation, rework
- other people’s branch review
- branches integration (child in parent, parent in child)
- Value of dates of commits and merge (has a branch been rebased, how long after the last commit has the branch been merged)

### Personal favourite commands

- merge in parent
- rework
- conflict resolution
- review
- history
- char and word diff
