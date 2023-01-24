#!/bin/bash

# Define the values to iterate over
source_inits=("touch a" "mkdir a && touch a/b")
srcs=("a" "a/")
trgs=("." "a" "a/" "c" "c/")

# Iterate over the values
for init in "${source_inits[@]}"
do
for src in "${srcs[@]}"
do
for trg in "${trgs[@]}"
do
  rm -rf a
  eval "$init"
  echo "$init -> $src -> $trg"
  docker build -t container -f - . > /dev/null <<EOF
    FROM alpine
    WORKDIR /app
    COPY $src $trg
    CMD ["find", ".", "-exec", "printf", "{} ", ";"]
EOF
  docker run container
  echo ""
  docker image rm --force container > /dev/null
  rm -rf a
done
done
done
