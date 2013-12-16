#!/bin/sh

#
# runs tests on device
#

LANGS="c python26 stackless unladenswallow ruby irb"

c_RUN="c/@test@"
python26_RUN="/media/sd/python26/bin/python python/@test@.py"
stackless_RUN="/media/sd/stackless/bin/python python/@test@.py"
unladenswallow_RUN="/media/sd/unladenswallow/bin/python python/@test@.py"
ruby_RUN="/usr/local/bin/ruby ruby/@test@.rb"
irb_RUN="/usr/local/bin/irb ruby/@test@.rb"

CPU_TESTS="dd hello import pidgits"
MEM_TESTS="interp import_mem"

OUT_DIR=$(uname -m)-results

mkdir -p $OUT_DIR

for lang in $LANGS; do
    echo "|" $lang
    for test in $CPU_TESTS; do
        r=${lang}_RUN
        eval cmd=\$\(echo \$$r \| sed -e \"s/@test@/\$test/g\"\)

        printf --  "-> %-11s" $test
        for i in $(seq 1 10); do
            if ! /usr/bin/time $cmd 2>$OUT_DIR/$lang-$test-$i.cpu >$OUT_DIR/$lang-$test-$i.stdout; then
                echo -n "X"
            else
                echo -n "."
            fi
        done
        echo
    done

    for test in $MEM_TESTS; do
        r=${lang}_RUN
        eval cmd=\$\(echo \$$r \| sed -e \"s/@test@/\$test/g\"\)

        printf --  "-> %-11s" $test
        for i in $(seq 1 10); do
            if ! ./snapmem.sh 5 $cmd 2>$OUT_DIR/$lang-$test-$i.mem >>$OUT_DIR/$lang-$test-$i.stdout; then
                echo -n "Z"
            else
                echo -n ","
            fi
        done
        echo
    done
done
