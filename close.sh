if [ -z "$1" ]; then
    echo "Error no base branch, run with parameter with branch name"
    exit 1
fi

#check if feature branch exists
exists=$(hg log -b $1 -r "head() and not closed()" | python -c "import sys; print sys.stdin.read()")
if [ -z "$exists" ]; then
    echo "Error no branch $1"
    exit 1
fi

#if base branch exists
#base_branch=$(python -c "import sys, re; print ''.join(re.split('(\d+)', '$1')[:2])")
base_branch=$(hg log -r "last(parents(max(branch($1))))" --template "{branch}")
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

# echo $base_branch
# #merge feature to base
hg checkout $base_branch
hg merge $1
hg commit -m "Merge "$1

# #close feature
hg checkout $1
hg commit --close-branch -m "Close"
hg commit
hg checkout $base_branch
