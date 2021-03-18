#!/usr/bin/env bash

A="${A:-''}" 
B="${B:-''}" 

# A function to compare semver versions
vercomp () {
    if [[ $A == $B ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($A) ver2=($B)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}
