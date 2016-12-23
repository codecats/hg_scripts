if [ -z "$1" ]; then
    echo "Error no base branch, run with parameter with branch name"
    exit 1
fi

#check if feature branch exists
exists=$(hg log -b -r "head() and not closed()" $1 | python -c "import sys; print sys.stdin.read()")
if [ -z "$exists" ]; then
    echo "Error no branch $1"
    exit 1
fi

#if base branch exists
base_branch=$(python -c "import sys, re; print ''.join(re.split('(\d+)', '$1')[:2])")
exists=$(hg log -b $base_branch -r "head() and not closed()" | python -c "import sys; print sys.stdin.read()")
if [ -z "$exists" ]; then
    echo "Error no base branch $base_branch"
    exit 1
fi

#if base branch is not feature branch
if [ "$1" == "$base_branch" ]; then
	echo "Same base branch and future branch $base_branch"
    exit 1
fi

#merge feature to base
hg checkout $base_branch
hg merge $1
hg commit -m "Merge"

#close feature
hg checkout $1
hg commit --close-branch -m "Close"
