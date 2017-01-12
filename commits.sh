branch=$1
if [ -z "$1" ]; then
	branch=$(hg heads . --template "{branch} \n")
fi
echo "Branch: $branch"
hg log -r "branch($branch) and not merge()" --template "\x1B[32m{node|formatnode}\x1B[0m - \x1B[4m{desc}\x1B[0m {date|age} - {author}\n"