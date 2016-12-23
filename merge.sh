if [ -z "$1" ]; then
    echo "Error no base branch, run with parameter with branch name"
    exit 1
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
user=$(cat "$DIR/user.txt")

readarray -t lst < <( hg log --user "$user" -r "head() and not closed()" --template "{branch}\n" | python -c "import sys; print ' '.join(set([l for l in sys.stdin.read().splitlines() if '"$1"' != l and l.startswith('"$1"')]))")


for i in $lst;
do
    hg checkout $i
    hg merge $1
    hg commit -m "Merge with $1"
done
hg checkout $1
