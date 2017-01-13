branch=$1
if [ -z "$1" ]; then
	branch=$(hg heads . --template "{branch}")
fi
echo -e "Branch: \033[31m$branch\x1B[0m"
hg log -r "branch($branch) and not merge()" --template "\x1B[32m{node|formatnode}\x1B[0m - \x1B[4m{desc}\x1B[0m {date|age} - {author}\n"

closed=$(hg log -r "branch($branch) and closed() and head()" --template "{date|age}")
last_merge=$(hg log -r "last(children(branch($branch)) and merge())" --template "{branch} {date|age} \x1B[32m{node|formatnode}\x1B[0m")

echo ""
if [ ! -z "$closed" ] && [ ! -z "$last_merge" ]; then
	echo -e '⋋ \e[33mMerged\x1B[0m to '$last_merge
elif [ ! -z "$last_merge" ]; then
	echo -e "⋋ \e[33mLast Merged\x1B[0m to "$last_merge
fi

if [ ! -z "$closed" ]; then
	echo ""
	echo -e '⊺ \e[33mClosed\x1B[0m '$closed
fi
