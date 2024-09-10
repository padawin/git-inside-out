## Branches

### A repository without branches

We saw previously that commits are a linked list type of data structure, and
therefore, having a commit gives us access to all of its parents.

For example, we could have the following repository/graph of commits.

```
> git log --oneline --graph ff5d0ee e0d09fb
* e0d09fb (HEAD) world added
* f1b0f0a hello added
| * ff5d0ee toto added
| * e60c8d1 bar added
|/
* eb096ca (master) foo added
```

#### How to recreate such graph
```bash
> git init .
Initialized empty Git repository in /private/tmp/example/.git

> touch foo toto tata hello world

> git add foo && git commit -m "foo added"
[master (root-commit) 5b049b1] foo added
1 file changed, 0 insertions(+), 0 deletions(-)
create mode 100644 foo

> git checkout 5b049b1 # hash of the previously created commit
Note: switching to '5b049b1'.

# because we do not need branches in this example
> git branch -D master
Deleted branch master (was 5b049b1).

You are in 'detached HEAD' state. You can look around,
make experimental changes and commit them, and you can
discard any commits you make in this state without impacting
any branches by switching back to a branch.

If you want to create a new branch to retain commits you create,
you may do so (now or later) by using -c with the switch command.
Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable
advice.detachedHead to false
HEAD is now at 5b049b1 foo added

> git add toto && git commit -m "toto added"
[detached HEAD 4efd1a9] toto added
1 file changed, 0 insertions(+), 0 deletions(-)
create mode 100644 toto

> git add tata && git commit -m "tata added"
[detached HEAD 2f4ca80] tata added
1 file changed, 0 insertions(+), 0 deletions(-)
create mode 100644 tata

> git checkout 5b049b1 # hash of the first commit
Warning: you are leaving 2 commits behind, not connected to
any of your branches:
2f4ca80 tata added
4efd1a9 toto added
HEAD is now at 5b049b1 foo added

> git add hello && git commit -m "hello added"
[detached HEAD fb82b1e] hello added
1 file changed, 0 insertions(+), 0 deletions(-)
create mode 100644 hello

> git add world && git commit -m "world added"
[detached HEAD f9577e8] world added
1 file changed, 0 insertions(+), 0 deletions(-)
create mode 100644 world

# the two "tip" commits of the graph
> git log --oneline --graph f9577e8 2f4ca80
* f9577e8 (HEAD) world added
* fb82b1e hello added
| * 2f4ca80 tata added
| * 4efd1a9 toto added
|/
* 5b049b1 foo added
```

There:

- `e0d09fb`'s parent is `f1b0f0a`,
- `f1b0f0a`'s parent is `eb096ca`,
- `ff5d0ee`'s parent is `e60c8d1`,
- `e60c8d1`'s parent is `eb096ca`.

And:

- The repository has no branch
- `HEAD` (where we are currently checked out) is located on `e0d09fb` .

### What are branches

When reading the above “graph” representation of the repository, we see 2 paths
of commits, which looks a lot like 2 branches.

But then, this raises the question: **if we have a branching path of commits, while
having no branches, then what are branches?**

In such kind of repository, it would be quite difficult to keep track of important
commits (for example the last one of each branching path). We would need to
remember about their hashes, which would change whenever we would create a
new commit.

Therefore, we need to have something to mark these places, some “bookmarks”
which can be humanly usable.

That is where branches come in, so let’s create two branches in our repository:

```bash
> git branch hello-world f9577e8

> git branch toto-tata 2f4ca8

> git log --oneline --graph hello-world toto-tata
* f9577e8 (HEAD, hello-world) world added
* fb82b1e hello added
| * 2f4ca80 (toto-tata) tata added
| * 4efd1a9 toto added
|/
* 5b049b1 foo added
```

And that is exactly what a branch is, a bookmark pointing to a commit, which
follows us as we commit, in order to help us keeping track of important “places” in
our repository.

When committing on a branch, once the new commit is made, Git then “moves”
the branch to make it point to the newly created commit.

This is also how Git stores them, let’s have a look.

### Under the hood

Branches are stored in `.git/refs/head/`. Each branch is stored in its own file, with as
name the branch name, and as content, the hash of the commit where the branch
currently points to.

In our previous example, we can see:

```bash
> ls -l .git/refs/heads/
total 8
-rw-r--r-- 1 ghislain wheel 41 Apr 26 14:13 hello-world
-rw-r--r-- 1 ghislain wheel 41 Apr 26 14:13 toto-tata

> cat .git/refs/heads/hello-world
f9577e8716bbd14e22ea54b0a5688bc61ccb5988

> cat .git/refs/heads/toto-tata
2f4ca8025c4182cc6e311aaa7f58431ba96e9ce3
```

If you look back at the graph above, you will find these 2 hashes (their short
version) where the branches are.

<p class="warning">
<b>!! The following is here only for demonstration purposes, it should not be
used for real usage. !!</b>

One could create a branch by manually creating a file like above.

Let’s say that I want to have a branch pointing where the commit `fb82b1e` is
(commit `hello added`). One could do:

```bash
> echo fb82b1e0e11b121706719ae3909a1b43bb21e854 > .git/ref

> git branch
* (HEAD detached from 5b049b1)
hello-world
my-manually-created-branch
toto-tata

> git log --oneline --graph --all
* f9577e8 (HEAD, hello-world) world added
* fb82b1e (my-manually-created-branch) hello added
| * 2f4ca80 (toto-tata) tata added
| * 4efd1a9 toto added
|/
* 5b049b1 foo added
```
</p>

### When deleting branches

Manipulating branches does not affect the commits they point to. For example,
deleting a branch does not delete the chain of commits it was pointing to:

```bash
# Same repository as above
> git log --oneline --graph --all
* f9577e8 (HEAD, hello-world) world added
* fb82b1e hello added
| * 2f4ca80 (toto-tata) tata added
| * 4efd1a9 toto added
|/
* 5b049b1 foo added

> git branch -D toto-tata
Deleted branch toto-tata (was 2f4ca80).

# Commit that the branch toto-tata was pointing at
> git log --oneline --graph 2f4ca80
* 2f4ca80 tata added
* 4efd1a9 toto added
* 5b049b1 foo added
```

### When merging branches

Once a branch is merged with a merge commit, all the information of the merged
branch are accessible through the merge commit’s parents.

```bash
> git checkout hello-world
Previous HEAD position was fb82b1e hello added
Switched to branch 'hello-world'

> git merge --no-ff toto-tata
Merge made by the 'ort' strategy.
tata | 0
toto | 0
2 files changed, 0 insertions(+), 0 deletions(-)
create mode 100644 tata
create mode 100644 toto

# Here in the graph, the branch `hello-world` moved from
# `f9577e8` to `5994b97`.
> git log --oneline --graph
* 5994b97 (HEAD -> hello-world) Merge branch 'toto-tata' into
|\
| * 2f4ca80 (toto-tata) tata added
| * 4efd1a9 toto added
* | f9577e8 world added
* | fb82b1e hello added
|/
* 5b049b1 foo added

> git cat-file commit 5994b97 # This is the merge commit
tree d436887a04c0cb814fd5ffe9bab17296255b2c2b
parent f9577e8716bbd14e22ea54b0a5688bc61ccb5988
parent 2f4ca8025c4182cc6e311aaa7f58431ba96e9ce3
author ...
committer ...
Merge branch 'toto-tata' into hello-world
```

Which means that from that point, all the commits of `toto-tata` are accessible from
the commits of `hello-world` (following the chain of parents). And this also means
that there is no need to keep the branch `toto-tata` and it can safely be deleted.

### To summarize

Branches are only “bookmarks”, “labels” pointing to commits. They do not contain
any information other than a commit hash and most of the information around the
“branching” state of the repository are actually contained in the commits
themselves, through the linked list structure.

### Exercise

Create a branch, add some commits, delete the branch and access the commit on
which the branch was previously pointing (with for example git show , or recreate a
branch pointing there).
