c="hi there from current script"

echo "calling variable c before caaling other script:$c"
echo "pid status:$$"

./otherscript.sh

echo "after calling other script:$c"
echo "pid status:$$"
