# - Uppercasing Text with sed
# [a-z] is the regular expression which will match lowercase letters.
# \U& is used to replace these lowercase letters with the uppercase version. 
str="hello world!"
echo $str | sed 's/[a-z]/\U&/g'

# - Lowercasing Text with sed
# [A-Z] is the regular expression which will match uppercase letters. 
# \L& is used to replace these uppercase letters with the lowercase version. 
str="HELLO WORLD!"
echo $str | sed 's/[A-Z]/\L&/g'

# ------------
cat > tmp.txt <<EOF
12345_test6789
12345_test6789
123456789
EOF

#Delete first charactor of each line
sed 's/.//' tmp.txt

#Delete last charactors of each line with matched pattern
sed '/test/s/..$//g' tmp.txt

#Add a word after tail of matched pattern
sed 's/_test/&log/g' tmp.txt

