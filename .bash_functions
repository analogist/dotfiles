#!/bin/bash

case "$OSTYPE" in
    darwin*)
        mkramdisk ()
        {
            if [ "$#" -eq 1 ]
            then
                ramdisk_sectors=$(($1*2048))
                ramdisk_dev=$(hdiutil attach -nomount ram://${ramdisk_sectors})
                newfs_hfs ${ramdisk_dev}
                mount_point=/tmp/ramdisk
                mkdir -p ${mount_point}
                mount -t hfs ${ramdisk_dev} ${mount_point}
                cd ${mount_point}
            else
                echo "Usage: mkramdisk [size MB]"
            fi
        }
        ;;
    linux-gnu*)
        if [ -f ~/.docker_functions ]; then
            . ~/.docker_functions
        fi
        goupgrade()
        {
            if [ "$#" -ne 1 ]
            then
                echo "goupgrade [version #]"
                return 1
            fi

            gofilename="go${1}.linux-amd64.tar.gz"
            gotmpdir=$(mktemp -d "/tmp/goupgrade.XXXXX")
            pushd $gotmpdir
            echo "Downloading $gofilename into $gotmpdir..."
            curl -O "https://dl.google.com/go/$gofilename" && \
                echo "Download success. Installing..." && \
                sudo tar -C /usr/local -zxf "$gofilename"
            echo "Removing $gotmpdir..."
            rm -v "$gofilename"
            popd
            rmdir -v $gotmpdir
            echo "goupgrade to version $1 done."
        }
        ;;
    openbsd*)
        ;;
esac

gsmd5 ()
{
    awk 'BEGIN { \
    decodehash = "base64 -d | xxd -p | tr -d \"\\n\""; \
    truncname = "sed \"s/gs:\/\/[a-z0-9_.\-]*\///\" | sed \"s/:$//\"" } \
    /Hash \(md5\)/ { print $3 | decodehash; close(decodehash); \
        printf "  %s\n",fname | truncname; close(truncname) } \
    /^gs:\/\// { fname = $0 }'
}

computestat ()
{
    awk '{ sum=sum+$1 ; sumX2+=(($1)^2)} END { avg=sum/NR; printf "Sum: %f. Average: %f. Standard Deviation: %f \n", sum, avg, sqrt(sumX2/(NR-1) - 2*avg*(sum/(NR-1)) + ((NR*(avg^2))/(NR-1))) }'
}

gittagsummary ()
{
    awk 'NR==1{last=$1} NR>1{print last".."$1; last=$1} END{print last"..HEAD"}' | xargs -t -I {} git diff --shortstat {}
}

wh_attack ()
{
    if [ "$#" -lt 5 ] || [ "$#" -gt 6 ]
    then
        echo "wh_attack [attacks] [skill] [strength] [toughness] [saving]"
        return 1
    fi

    verbose=1
    if [ "$#" -eq 6 ] && [ "$6" = "-q" ]
    then
        verbose=0
    fi

    attacks=$(($1))
    skill=$(($2))
    strength=$(($3))
    toughness=$(($4))
    saving=$(($5))

    if [ $(($strength)) -gt $(($toughness)) ]
    then
        if [ $(( "$strength"/"$toughness" )) -ge 2 ]
        then
            woundthrow=2
        else
            woundthrow=3
        fi
    elif [ $(($strength)) -lt $((toughness)) ]
    then
        if [ $(( "$toughness"/"$strength" )) -ge 2 ]
        then
            woundthrow=6
        else
            woundthrow=5
        fi
    else
        woundthrow=4
    fi

    if [ "$verbose" -eq 0 ]
    then
        randint 1 6 $(randint 1 6 $(randint 1 6 $attacks | awk -v skill=$skill 'BEGIN{hit = 0} { if ($1 >= skill) hit++} END{ print hit }') | awk -v woundthrow=$woundthrow 'BEGIN{wound = 0} { if ($1 >= woundthrow) wound++} END{ print wound }') | awk -v saving=$saving 'BEGIN{unsaved = 0} { if ($1 < saving) unsaved++} END{ print unsaved }'
    else
        r_attacks=($(randint 1 6 $attacks))
        for i in "${r_attacks[@]}"; do [ "$i" -ge $skill ] && r_hits+=($(randint 1 6)) || r_hits+=(0); done
        for i in "${r_hits[@]}"; do [ "$i" -ge $woundthrow ] && r_wounds+=($(randint 1 6)) || r_wounds+=(0); done
        for i in "${r_wounds[@]}"; do [ "$i" -gt 0 ] && [ "$i" -lt $saving ] && r_unsaved+=(1) || r_unsaved+=(0); done

        echo -e "Attacks:\t${r_attacks[@]}"
        echo -e "Hits:\t\t${r_hits[@]}"
        echo -e "Saves:\t\t${r_wounds[@]}"
        echo -e "Wounds:\t\t${r_unsaved[@]}"

        unset r_attacks r_hits r_wounds r_unsaved
    fi
}

randint ()
{
    # Generate unbiased integers between arbitrary ranges using kernel cryptographic random

    # check for invalid arguments
    if [ "$#" -lt 1 ] || [ "$#" -gt 3 ]
    then
        echo "Usage: randint [MAXINT]"
        echo "Usage: randint [MININT] [MAXINT] ([NUMROLLS])"
        return 1
    else
        if [ "$#" -ge 2 ]
        then
            # two arguments: generate range [MININT, MAXINT] inclusive
            if [ "$1" -lt "$2" ]
            then
                # generate: randint(0, target) + offset
                target=$(( "$2" - "$1" ))
                offset=$(($1))
            else
                # error: MININT >= MAXINT
                echo "Usage: randint [MININT] [MAXINT]"
                echo "MAXINT must be greater than MININT"
                return 1
            fi

            # check for numrolls
            if [ "$#" -eq 3 ]
            then
                if [ "$3" -ge 1 ]
                then
                    numrolls=$(($3))
                else
                    # error: NUMROLLS < 1
                    echo "Usage: randint [MININT] [MAXINT] [NUMROLLS]"
                    echo "NUMROLLS must be greater than 0"
                    return 1
                fi
            else
                # two arguments: implies numrolls of 1
                numrolls=1
            fi
        else
            # one argument: MAXINT; implies [0, MAXINT] inclusive
            target=$(( "$1" ))
            offset=0
            numrolls=1
        fi
    fi

    if [ "$target" -lt 1 ] # catches errors such as one argument MAXINT <= 0
    then
        echo "Requested MAXINT - MININT less than 1"
        return 1
    fi

    # get the smallest number of bits (rounded up) to encompass the range [0, target]
    # round up log2(target) using printf rounding
    # for example, randint [0, 100] requires targetbits = 7 to get [0, 128]

    targetbits=$(printf "%.0f" $(echo "l(${target}) / l(2) + 0.50001" | bc -l))

    # /dev/urandom only provides full bytes, round up to find the number of bytes to read
    # for example, if targetbits = 7, read in randbytes = 1 (8 bits) and truncate 1 later

    randbytes=$(( (targetbits+7)/8 ))

    # After we read in full bytes, we can then truncate to targetbits using bitshift >>
    # In this example, truncatebits = 1

    truncatebits=$(( randbytes*8 - targetbits ))

    for (( c=0; c<$numrolls; c++ ))
    do
        while true
        do
            # read in hex bytes, convert hex to decimal with bash $(( 16#HEXNUMBER )) notation
            # and bitshift to truncate bits to get a number within [0, 2^targetbits]

            generatedint="$(( 16#$(head -c $randbytes /dev/urandom | xxd -p) >> truncatebits ))"

            # check to see if it also happens to be within [0, target], if so, success!

            [ "$generatedint" -le "$target" ] && break

            # otherwise, try again
        done

        echo "$(( generatedint + offset ))"
    done
}

host ()
{
    if [ -z "$1" ]
    then
        echo "Usage: host [host]"
        return 1
    fi

    /usr/bin/host $1
    whois $(dig +short $1 | head -n 1) | grep -e "Organization\|org.*name"
    echo -n "$1 DNS SOA is "
    dig +short $1 SOA | sed 's/[0-9 ]*$//'
}

binwatch ()
{
    [ -z "$1" ] && bytecount=1024 || bytecount=$(($1))
    watch -n 1 "tail -c $bytecount "'$(ls -tr | tail -n 1) | xxd -c 32'
}

cdlast ()
{
    [ -z "$1" ] && lastcount=1 || lastcount=$(($1))

    if [ $lastcount -ge 1 ]
    then
        cd $(ls -tF | grep -E "/$" | awk "NR==$lastcount")
    else
        echo "Usage: cdlast [last # modified dir]"
        return 1
    fi
}

watchdir ()
{
    [ -z "$2" ] && interval=1 || interval=$(($2))

    if [ "$#" -lt 1 ]
    then
        echo "Usage: watchdir 'cmd' [interval]"
        return 1
    fi

    dirlastl=$(ls -l)
    while true;
    do
        dirnowl=$(ls -l)
        if [ -n "$(diff -q <(echo \"$dirlastl\") <(echo \"$dirnowl\"))" ]
        then
            eval $1
            dirlastl=$dirnowl
        fi
        sleep 1
    done
}

flacbin ()
{
    [ -z "$1" -o ! -f "$1" ] && echo "Usage: flacbin [file.bin] [Sps]" && return 1

    barename=$(basename $1 ".bin")

    [ -z "$2" ] && fs=25000 || fs =$(($2))

    tail -c +9 "$1" | flac -6 --force-raw-format --endian=little --sign=signed --channels=8 --bps=16 --sample-rate "$fs" - -o "${barename}.flac"
    if [ -f "${barename}.flac" ]
    then
        head -c 8 "$1" >> "${barename}.flac"
    else
        echo "Error occurred"
    fi
}

deflacbin ()
{
    [ -z "$1" -o ! -f "$1" ] && echo "Usage: deflacbin [file.flac]" && return 1

    barename=$(basename $1 ".flac")

    [ -f "${barename}.bin" ] && echo ".bin with that name already exist, not overwriting" && return 1

    tail -c 8 "$1" > "${barename}.bin"
    head -c -8 "$1" | flac -d --force-raw-format --endian=little --sign=signed "$1" -o - >> "${barename}.bin"
}

