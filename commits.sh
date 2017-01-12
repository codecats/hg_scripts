branch=$1
if [ -z "$1" ]; then
	branch=$(hg heads . --template "{branch} \n")
fi
echo "Branch: $branch"
hg log -r "branch($branch) and not merge()" --template "{node|formatnode} - {desc} - {author}\n"