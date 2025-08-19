#!/bin/sh
PROJECT_HOME=$1
echo "PROJECT_HOME=$PROJECT_HOME,pwd=$(pwd)"
mkdir -p $PROJECT_HOME/docs/kityminder
rm -rf $PROJECT_HOME/docs/kityminder/*
cp -f README.md docs/index.md
for km_file in $(ls $PROJECT_HOME/docs/assets/mindmap|grep -E ".km$"); do
  [ $? -ne 0 ] && exit 1
  echo "![400px,1000px](../assets/mindmap/${km_file})" > $PROJECT_HOME/docs/kityminder/${km_file}.md
done
mkdir -p $PROJECT_HOME/docs/drawio
rm -rf $PROJECT_HOME/docs/drawio/*
for km_file in $(ls $PROJECT_HOME/docs/assets/drawio|grep -E ".drawio$"); do
  for page_name in $(grep "<diagram" $PROJECT_HOME/docs/assets/drawio/$km_file| sed -r "s/.*name=\"([^\"]+)\".*/\1/g"); do
    [ $? -ne 0 ] && exit 1
    echo "- $page_name ![$page_name](../assets/drawio/${km_file})" >> $PROJECT_HOME/docs/drawio/${km_file}.md;
  done
done
