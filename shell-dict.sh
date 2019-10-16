#!/bin/bash
main(){
    declare -A dict

    dict["key1"]=val1
    dict+=( ["key2"]=val2 ["key3"]=val3 )
    # Iterate dictionary and print keys- values.
    for key in ${!dict[@]}; do
        echo "${key}:${dict[${key}]}"
    done
    dict["key1"]=val11 # modify a key's value
    echo "dict:key1->${dict["key1"]}"
    echo ${dict[@]} # get all values
    echo ${!dict[*]} # get all keys
    unset dict[key1]  # lets delete key1
    echo ${dict[*]} # get all values
}

#---------------- Main Program --------------
main "$@"
