## Repository
Git is called a distributed system, that means that there is no need for a central
repository to be present when working with Git.

It is possible to have a repository connected to no remote at all.

It can be very useful to be able to create a “sandbox/playground” repository to
run some experiments.

To create a new repository, run:

```bash
# For example, "git init ." for the current directory
git init <path>
```

The directory provided as argument will then be tracked by Git, and a .git
directory will be created there.

### Exercise

Create a new directory in `/tmp`.
Create a new repository in this directory.
Create some files there and commit them.
