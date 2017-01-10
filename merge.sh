if [ -z "$branch" ]; then
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

for i in $lst;
do
    hg checkout $i
    hg merge $branch
    hg commit -m "Merge with $branch"
done
hg checkout $branch
