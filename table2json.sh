cat > aa <<EOF
1        119.33    120.33
4        389.33    489.33
8        689.31    889.32
EOF

str2json(){
echo "{"
for n in {2..3};do
    [ $n -eq 2 ]&& echo "\"pre\": {" || echo "\"post\": {"
    awk -v var=$n 'BEGIN {count=0;} {id[count]=$1;col[count] = $var;count++;}; END{for (i = 0; i < NR; i++) if(i<NR-1) printf("\"%s_user_tps\":%2.f,",id[i],col[i]); else printf("\"%s_u
ser_tps\":%2.f",id[i],col[i])}' aa
    [ $n -eq 2 ]&& echo "}," || echo "}"
done
echo "}"
}

main(){
    str2json |python -m json.tool
}

#---------------- Main Program --------------
main "$@"
