## Commits

This talk will not be about how to use the git commit command, but rather about understanding what are commits.
In term of datastructure, commits are represented as a Linked List, where each commit has a reference to its parent(s).
A commit is represented by:

- The current state of the repository's files, called “the tree”,
- 0, 1 or n parents.
- An author (who wrote the code),
- The authoring date,
- A committer (who committed the code),
- The committing date,
- A message.

A commit is identified by a hash, which is can be re-constructed as follow:

```bash
> cat /tmp/commit.sh
#!/bin/bash

# The commit's information
TREE="93ca827d4cef039fb7300fceece4008fef2bcd3d"
PARENT="b4bc498a222ec212bc7bba03a9feac2408b38605"
AUTHOR="John Doe <jdoe@mail.me>"
AUTHOR_DATE="1713516486 +0200"
COMMITTER="John Doe <jdoe@mail.me>
COMMITTER_DATE="1713519251 +0200"
MESSAGE="Message"

# Let's format them a bit
COMMIT_INFO="tree $TREE
parent $PARENT
author $AUTHOR $AUTHOR_DATE
committer $COMMITTER $COMMITTER_DATE
$MESSAGE"

# As security, let's calculate how many characters the previo
COMMIT_INFO_LENGTH=$(echo "$COMMIT_INFO" | wc -c)

# Let's now put all that in a string and hash it
printf "commit %s\0%s\n" $COMMIT_INFO_LENGTH "$COMMIT_INFO" \
	| shasum

> /tmp/commit.sh
80ef824c60495819aaa001480925153cd42cb3aa -

> git show --summary HEAD
commit 80ef824c60495819aaa001480925153cd42cb3aa (HEAD -> branch)
Author: John Doe <jdoe@mail.me>
Date:   Fri Apr 19 10:48:06 2024 +0200

	Message
```

The `COMMIT_INFO` part can be reconstructed with any commit, by running:

```bash
git cat-file commit <commit hash>
```

Knowing how to reconstruct a commit hash is not super useful in itself (maybe only as party trick), but it makes the hash less “magical”, and it highlights the fact that if any of elements representing a commit change, then the hash will change (and now we know why the hash changes, as we know how the hash is constructed).

### On the commit parents

As I said before, a commit can have 0, 1, or multiple parents.

A commit with 0 parent would usually be the first commit of the repository.

A commit with 1 parent would be any commit that we make every day.

A commit with more than one parent is what we call a merge commit.

If a commit is parent of more than one commits, that means that multiple diverging branches start from it.

### On commits graph

In this book, I will often show graph representation of commits. This representation can be created with the `--graph` option of `git log` (along with the `--oneline` option, to display commits on a single line).

In this representation:

- Each commit is represented with a `*` ,
- The top commit is the most recent,
- Commits can be connected with `|` , `\` and `/` to represent the edges of the graph,
- To simplify the output, the edges are only displayed when needed.

For example, in the following commit graph (result of a command like `git log --oneline --graph master` :

```
* 5b856be (HEAD -> master, origin/master, origin/HEAD)
* 9d48051
* 4d3a25e
|\
| * 862728c
| * d802530
| * d8ba4fa
| * 23600e3
|/
* 84cf7cc
```

Is to be read the following way:

```
* 5b856be (HEAD -> master, origin/master, origin/HEAD)
|
* 9d48051
|
* 4d3a25e
|\
| * 862728c
| |
| * d802530
| |
| * d8ba4fa
| |
| * 23600e3
|/
* 84cf7cc
```

- `5b856be` has one parent (`9d48051`),
- `4d3a25e` has two parents (`84cf7cc` and `862728c`), it is a merge commit, and its message is probably `Merge branch xyz in master`,
- `23600e3` has one parent (`84cf7cc`),
- `84cf7cc` has no parent, but is also parent of two commits (`4d3a25e` and `23600e3`)

There are graphical tools existing to show similar information, a selection of them can be found at [https://git-scm.com/downloads/guis](https://git-scm.com/downloads/guis). That being said, this guide being around understanding Git and its inner sides better, I will use exclusively the terminal along with a lot of reproducible terminal outputs.

### Accessing parents of a given commit

This is possible through 2 notations: `^` and `~`. This notation is used after a commit hash (or a reference name, e.g. a branch name), for example `5b856be^` or `5b856be~` (used like this example on a commit would yield the same result and would mean `9d48051`, `5b856be`'s parent).

They can also be combined, repeated and used with numbers, for example:
- `5b856be~~~~` is the same as `5b856be~4`
- `5b856be~~^2~` would be a valid expression

These notations have some difference. They talk about “parent” and “ancestor”.

- `~` is used to access ancestors
- `^` is used to access parents

The difference is a bit of a vertical vs horizontal matter.
`~` goes through the chain of parents:
- `~` is the direct parent of a commit,
- `~2` (or `~~`) is the grand-parent
- and so on

For example `5b856be~~` is the parent's parent of `5b856be`, which means that it is `4d3a25e`.
This is the vertical side, if you look at a log, using `~` will make you go down through the commits.

Now, when two branches are merged, it makes a merge commit. A merge commit, by definition, is merging two, or more, paths of commits together. So the merge commit will have two or more parents.

From a merge commit, if you want to access its different parents, you use `^` (it actually looks like a merge of two branches).

Let's have again a subpart of the above example:

```
* 5b856be (HEAD -> master, origin/master, origin/HEAD)
* 9d48051
* 4d3a25e
|\
| * 862728c
| * d802530
| * d8ba4fa
| * 23600e3
|/
* 84cf7cc
```

`4d3a25e` is a merge commit, with 2 parents (`84cf7cc` and `862728c`). The notation `^` allows to access these:

- `^`or `^1` is the first parent,
- `^^`or `^2` is the second parent,
- `^^^`or `^3` does not exist, `4d3a25e` only has two parents.

Let's look back at the more exotic example of `5b856be~~^2~` and read it step by step:

- the 2 `~` mean the commit's grand parent, which is the merge commit `4d3a25e`,
- the following `^2` means the `4d3a25e`'s 2nd parent, so `862728c`,
- then, the last `~` means `862728c`'s parent, so `d802530`

To summarise, it is possible to access different parents of a merge with `^` and generations of commits with `~`.

It can be illustrated as follow with a more complex merge (`6af2936d` is a merge commit of 4 branches merged at once):
```
----------> use ^ to go through the parents of the merge
|
|	*-----.  6af2936d
|	|\ \ \ \
|	| | | | * 20d6fb23
|	| | | * | e589d446
|	| | | * | ec6088bd
|	| | | |/
|	| | * | 38dcecfa
|	| | |/
|	| * | 698c3daa
|	| |/
|	|/
|   *  2d97958e
|   |\
|   | * 8989f1d3
|   | * d907cb7a
|   |/
|   *  af368002
V
use ~ to go this way (through the ancestors)
```

### On the commit authors and dates

The commit's author and date are set when a commit is originally made.

The commit's committer and date are initially set with the same value as the commit's author and date, but would change if:
- the commit is amended
- the commit is cherry picked
- the commit is part of a rebase

### Exercises

- Find an example (or recreate in a sandbox repository) of commits with 0, 1 and more than one parents, and look at the output of `git cat-file <hash>` for each of them.
- Harder: Find and example (or recreate in a sandbox repository) of commit(s) with different authors and committers (or different dates).
