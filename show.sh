#current branch
branch=$1
if [ -z "$1" ]; then
	branch=$(hg heads . --template "{branch}\n")
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
user=$(cat "$DIR/user.txt")

readarray -t lst < <( hg log --user "$user" -r "head() and not closed()" --template "{branch}\n" | python -c "import sys; print ' '.join(set([l for l in sys.stdin.read().splitlines() if '"$branch"' != l and l.startswith('"$branch"')]))")
readarray -t lst2 < <( hg log --user "$user" -r "children(ancestor($branch)) and merge()" --template "{branch}\n" | python -c "import sys; print ' '.join(set([l for l in sys.stdin.read().splitlines()]))")

#lst+=lst2
for I in $lst2
do
    lst=$lst" $I"
done

echo 'Author (in sprint: '$branch')'
echo $user
echo ''
for i in $lst;
do
    echo $i
done