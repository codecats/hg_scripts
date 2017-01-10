#current branch
branch=$1
if [ -z "$1" ]; then
	branch=$(hg heads . --template "{branch}\n")
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
user=$(cat "$DIR/user.txt")
readarray -t lst < <( hg log --user "$user" -r "children(branch($branch))" --template "{branch}\n" | python -c "import sys; print ' '.join(set([l for l in sys.stdin.read().splitlines()]))")
my_lst=()
for i in $lst
do
	author=$(hg log -r "first(branch('$i'))" --template "{author}")
	if [ "$user" == "$author" ];
		then
			my_lst+=' '$i
	fi
done
lst=()
for i in $my_lst
do
	opened=$(hg log -r "not closed() and (last(branch($i)))" --template "{branch}")
	if [ ! -z "$opened" ]; then
		lst+=' '$i
		#echo $i, open
	fi
done
echo 'Author (in sprint: '$branch')'
echo $user
echo ''
for i in $lst;
do
    echo $i
done