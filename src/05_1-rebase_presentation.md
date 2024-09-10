### Presentation

Rebasing is an operation used when one wants to update a branch (usually) with
commits not accessible by the branch, by “basing” it on top of these new
commits. The branch ends up being “re-based”.

#### What does “Rebase” mean?

`man git-rebase` says:

> Reapply commits on top of another base tip

In other words, it means to “move” a set of commits from one place of the
repository to another. I put here “move” in quotes, because it is an easy
representation of the result of a rebase operation, but as we will see, it is not quite
correct, just an oversimplification.

#### Example

Say we have the following repository, with two branches (`my-branch-1` and `my-branch-2`) which diverged from one another:

```bash
> git log --oneline --graph my-branch-1 my-branch-2
* 49ef66c (my-branch-1) world added
* e79805f hello added
| * fd734ff (HEAD -> my-branch-2) tata added
| * b7414fa toto added
|/
* e0500f3 bar added
* 9817f8b foo added
```

💡 How to recreate such graph
```bash
# In a new repository:
# Create some files
> touch foo bar toto tata hello world

# Create my-branch-1 and its commits
> git checkout -b my-branch-1
> git add foo
> git commit -m "foo added"
> git add bar
> git commit -m "bar added"

# Create my-branch-2 for later
> git branch my-branch-2 # Here the branch is created, but

# Add the 2 last commits of my-branch-1
> git add hello
> git commit -m "hello added"
> git add world
> git commit -m "world added"

# Check my-branch-2 and create its commits
> git checkout my-branch-2
> git add toto
> git commit -m "toto added"
> git add tata
> git commit -m "tata added"
```

Running `git rebase my-branch-1` while being checked out on `my-branch-2` means
"reapply the commits accessible from where HEAD is (`my-branch-2`) on top of the
provided target (`my-branch-1`)".

This would lead to the following result:

```bash
> git rebase my-branch-1
Successfully rebased and updated refs/heads/my-branch-2.

> git log --oneline --graph --all
* a66e900 (HEAD -> my-branch-2) tata added
* 953f39f toto added
* 49ef66c (my-branch-1) world added
* e79805f hello added
* e0500f3 bar added
* 9817f8b foo added
```

We can see here that the commits accessible from `my-branch-1` are unchanged
(the hashes are the same) and we have a new set of commits exclusively for
`my-branch-2` (`953f39f` and `a66e900`).

💡 One of the reasons the hashes changed is because:
- The commit `b7414fa toto added` had as parent `e0500f3`, but after the rebase,
  its new parent is `49ef66c`, and as we saw in the commits chapter, the
  hash of a commit depends on its parent(s).
- The commit `fd734ff tata added` had as parent `b7414fa toto added` but as we
  saw in the previous bullet point, this commit has a new hash.
- And recursively, each commit would have their hash changed due to the change
  of hash of their parent (among other).

#### What does git rebase do?

`git rebase <new-base>` always reapplies the commits accessible from HEAD on top
of the provided `<new-base>`. The command follows 4 steps:
- **Step1: Identify which commits are reachable by `HEAD` and which are not
  reachable by `<new-base>`**. It does this by following the linked list of
  commits, through their parents. In the above example, these commits would be
  `b7414fa` and `fd734ff`.
- **Step 2: Move `HEAD` to the targeted `<new-base>`**. In the above example,
  `HEAD` would point at `49ef66c`.
- **Step 3: Apply each commit identified in step 1 on top of `HEAD`**.
- **Step 4**: If a branch was checked out when starting rebasing, it will move it to
  point to the last commit which was applied, **updating its reflog**.

#### Reflog changes

These steps are reflected in the reflogs of `HEAD` and the rebased branch.

In `HEAD`'s reflog, we can see each step (from 2 to 4) identified by an arrow and a
number:

![Rebase steps reflected in HEAD's reflog](images/05-rebase-reflected-in-reflog-head.png "Rebase steps reflected in HEAD's reflog")

And in `my-branch-2`'s reflog, only step 4 is present, the branch itself does not know
about the details of the rebase:

![Rebase steps reflected in my-branch-2's reflog](images/05-rebase-reflected-in-reflog-branch.png "Rebase steps reflected in my-branch-2's reflog")

In `my-branch-2`'s reflog, we see the previous entries for the branch (the
commit at which it has been created, its different commits, and when it got
moved after the rebase). **And these commits are still accessible after the rebase
is done. They can still be accessed by their hash, or reflog entries.**

💡 Important

Because the rebase will add a single entry in the rebased branch’s reflog, the
version of the branch just before the rebase can always be accessed with the
notation (for example `my-branch-2@{1}`), of course until the branch is changed
again and new entries of the reflog are added. `<branch-name>@{1}` This will
prove extremely useful when:

- verifying that a rebase went well,
- fixing a rebase which did not go well

This means that the version of the branch before the rebase is left untouched.
**Which in itself means that the rebase operation is a creative operation, it does
not delete anything. Which means that the rebase operation is a safe operation
to execute.**

What we do with a rebased branch is however another question, and we will cover
this in due time.

#### Conclusion and important points

- The rebase is a “create” only type of operation, although a rebased branch
  looks as if it has been “moved” from one point to another, it really is
  “copied”.
- The reflog gives us details in what happened during a rebase.
- The previous version of a rebased branch is accessible with <branch-name>@{1} .
- As a result of the above, a rebase can be undone.

#### Exercises

- Create a sandbox repository with two **diverging** branches (an example of such repository can be found above in this page):
	- Rebase one of these branches on top of the other
		- Is the result as you expected it to be in terms of commits? You can
		  check for example with a git log as seen above.
		- Create a new branch where the one you just rebased used to be.
		- Look at the reflog of your branches and HEAD , do you recognize your
		  actions through it?
- Create also in a sandbox repository (it can be the same as above) 2 branches,
one (`branch-1`) ahead (aka “based” on the other) of the other (`branch-2`).
	- Rebase the branch `branch-1` against `branch-2`.
		- Observe the resulting commits, what happened? Is it what you expected?
