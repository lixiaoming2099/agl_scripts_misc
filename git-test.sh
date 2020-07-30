#!/bin/sh
url2="https://github.com/linux-test-project/ltp/commits/master"
url3="https://github.com/linux-test-project/ltp/commits/master?after="


wget https://github.com/linux-test-project/ltp/
line_commit_latest=`grep commit\/  index.html | head -1`
test="commit\/"
commit_latest_position=`awk -v a="$a" -v b="$test" 'BEGIN{print index(a,b)}'`
commit_latest=`echo ${commit_latest_position:108:40}`

echo $commit_latest
sleep 1000

for ((i=10; ;i=i+1000));
do
        url_temp=$url4"$i"
        wget $url_temp -O temp.log
        if grep -q "No commits found" temp.log; then
           commit_oldest=$i
           exit
        fi
done


sleep 1000

git init && git remote add origin $1
url_prj=`echo ${1%.*}`



for ((i=$commit_oldest;i>0;i=i-100));
do
        url_temp=$url4"$i"
        wget $url_temp -O temp.log
        if ! grep -q commit: temp.log; then
           exit
        fi

        commit_current=`grep commit: temp.log | sed -n 1p | awk -F'[:"]' '{print $5}'`
        git fetch --depth=1 origin $commit_current && git reset --hard $commit_current

done

