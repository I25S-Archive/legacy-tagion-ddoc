CONTENT=$(cat $1*.html)
BEGIN=$(cat ./candydoc/begin.html)
END=$(cat ./candydoc/end.html)

echo $BEGIN > ./candydoc/index.html
echo $CONTENT >> ./candydoc/index.html
echo $END >> ./candydoc/index.html
