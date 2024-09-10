## Reflog

### Definition

From man `git-reflog`:

> Reference logs, or "reflogs", record when the tips of branches and other references (e.g. HEAD) were updated in the local repository.

A reference is a "label" pointing somewhere (rings a bell?). Branches, tags and
`HEAD` are references.

Whenever we run commands (like commit, checkout, reset, rebase, cherry-
pick…) which make a reference "move" (point to another commit), this new
position is logged.

These logs:

- are called **reflog**.
- are a **history** of each position that each reference had.
- are **local**.

Each reference has its own reflog.

Two clones of the same project will have different reflogs, and the reflogs of a
repository is not passed on to its clone(s).

The default format of the reflog is as follow:

```
<hash> (reference) <current target>:<index> <commit message>
```

Each entry of the reflog points to a commit, and multiple reflog entries can
point to the same commit.

### Example

Making some initial commits:

```bash
> git add foo && git commit -m "foo added"
[master (root-commit) d67824a] foo added
1 file changed, 0 insertions(+), 0 deletions(-)
create mode 100644 foo

> git add bar && git commit -m "bar added"
[master 30c5442] bar added
1 file changed, 0 insertions(+), 0 deletions(-)
create mode 100644 bar
```

Looking at `master`'s reflog:

```bash
> git reflog master
30c5442 (HEAD -> master) master@{0}: commit: bar added
d67824a master@{1}: commit (initial): foo added
```

Adding a new commit:

```bash
> git add toto && git commit -m "toto added"
[master 5078fd1] toto added
1 file changed, 0 insertions(+), 0 deletions(-)
create mode 100644 toto
```

`master` gets a new reflog entry:

```bash
> git reflog master
5078fd1 (HEAD -> master) master@{0}: commit: toto added
30c5442 master@{1}: commit: bar added
d67824a master@{2}: commit (initial): foo added
```

Let’s now look at `HEAD`'s reflog:

```bash
> git reflog HEAD
5078fd1 (HEAD -> master) HEAD@{0}: commit: toto added
30c5442 HEAD@{1}: commit: bar added
d67824a HEAD@{2}: commit (initial): foo added
```

Because we were on the same branch until now, `HEAD` followed `master`.

Let’s now create (and checkout) a new branch:

```bash
> git checkout -b my-branch
Switched to a new branch 'my-branch'
```

Now, let’s look at the reflogs of `HEAD`, `master` and `my-branch`:

```bash
> git reflog HEAD
5078fd1 (HEAD -> my-branch, master) HEAD@{0}: checkout: moving from master to my-branch
5078fd1 (HEAD -> my-branch, master) HEAD@{1}: commit: toto added
30c5442 HEAD@{2}: commit: bar added
d67824a HEAD@{3}: commit (initial): foo added

> git reflog master
5078fd1 (HEAD -> my-branch, master) master@{0}: commit: toto added
30c5442 master@{1}: commit: bar added
d67824a master@{2}: commit (initial): foo added

> git reflog my-branch
5078fd1 (HEAD -> my-branch, master) my-branch@{0}: branch: Created from HEAD
```

`HEAD` got a new entry, pointing to the same commit as the previous one: we
changed its "position" from `master` to `my-branch`, and these two point on the
same commit.

`master`'s reflog is left unchanged.

`my-branch` has its own reflog with a single entry, as it has been created now.

### Accessing specific points in the reflog

It is possible to access the different points in a reference’s reflog using the
`ref@{...}` notation:

```bash
# reference's current position
@{0}

# reference's previous position
@{1}

# reference's position last week
@{1 week ago}
```

So, for example, the previous position of `master` would be `master@{1}`.

**!! The previous position is not the parent commit. It is where the branch was pointing to previously. !!**

The `ref@{...}` notation can be used the same way as a normal reference (a
branch, a tag), or a commit hash. For example one can see the commit where
`HEAD` was previously with:

```bash
git show HEAD@{1}
```

This notation is used in each reflog’s entry.

### Reflog expiry

The reflog is configured by default to be saved for 90 days. Git will regularly
run its garbage collector, and will prune reflog entries older than the configured
duration.

### Safety net

The reflog is a log of the user’s actions in a repository. It reflects many of the
actions of the user.

It can be used for example to bring a branch back to a previous state if
something "wrong" happen (e.g. cancelling a rebase, we will get to that).

### Exercises

In a repository of your choice:
- Look at some reflogs: `HEAD` and some of your branches. Do you recognise the different actions that you did?
- Execute some actions like `commit`, or `checkout`, then look at the reflogs of the affected references (branches and `HEAD`), are your actions reflected there?
