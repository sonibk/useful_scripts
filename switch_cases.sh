#!/bin/bash
animal=$1
case ${animal} in
        cow)
        echo "Here moo"
        ;;
        goat)
        echo "There mee"
        ;;
        duck)
        echo "Everywhere quack quack"
        ;;
        *)
        echo "Old macdonald had a farm"
        ;;
esac
