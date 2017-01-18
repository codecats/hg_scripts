#current branch
branch=$1
if [ -z "$1" ]; then
	branch=$(hg heads . --template "{branch}\n")
fi
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
user=$(cat "$DIR/user.txt")
exclude=$(cat "$DIR/exclude.txt")
echo -e 'Author (in sprint: \e[33m'$branch'\x1B[0m)'
echo -e '\033[31m'$user'\x1B[0m'
echo ''
readarray -t lst < <( hg log --user "$user" -r "children(branch($branch))" --template "{branch}\n" | python -c "import sys; print ' '.join(set([l for l in sys.stdin.read().splitlines()]))")
my_lst=()
for i in $lst
do
	author=$(hg log -r "first(branch('$i'))" --template "{author}")
	if [ "$user" == "$author" ];
		then
			if [[ ! " ${exclude[@]} " =~ " ${i} " ]]; then
			    my_lst+=' '$i
			fi
			
	fi
done
lst=()
for i in $my_lst
do
	opened=$(hg log -r "not closed() and (last(branch($i)))" --template "{branch}")
	last_merge=$(hg log -r "last(parents(last(merge() and branch($i))))" --template "{branch}")

	if [ ! -z "$last_merge" ] && [ "$last_merge" != "$branch" ] && [ "$last_merge" != "$i" ]; then
		opened=''
	fi

	if [ ! -z "$opened" ]; then
		lst+=' '$i
	fi
done

for i in $lst;
do
    echo $i
done

if [ -z "$lst" ]; then
	empty=(" " " " " " "e" "m" "p" "t" "y" " " " " " " " ")

	#echo ${empty[0]}
	#for a in "${empty[@]}"; do echo "$a"; done
	for i in {16..21} {21..16} ; do 
		echo -en "\e[48;5;${i}m${empty[0]}\e[0m" ; 
		unset empty[0]
		empty=( "${empty[@]}" )
	done ; 
	echo $empty
	echo
fi
