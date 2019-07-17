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
