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

for holder_folder in network; do
  ABS_TXT_FILE_FOLDER=$PROJECT_HOME/docs/$holder_folder
  for txt_file in $(ls $ABS_TXT_FILE_FOLDER |grep -E ".txt$"); do
    txt_file_basename=$(basename $txt_file .txt)
    input_file="$ABS_TXT_FILE_FOLDER/$txt_file"
    output_file="$ABS_TXT_FILE_FOLDER/${txt_file_basename}.md"
    lines_per_page=40
    line_count=0

    # 清空输出文件
    > "$output_file"
    while IFS= read -r line || [[ -n $line ]]; do
      # 写入当前行，后面加两个空格和换行符，实现Markdown换行
      trimmed_line="${line#"${line%%[![:space:]]*}"}"
      echo "${trimmed_line}  " >> "$output_file"

      ((line_count++))

      # 每40行插入分页符
      if (( line_count % lines_per_page == 0 )); then
        echo -e "\n第$line_count页\n<div style=\"page-break-after: always;\"></div>\n" >> "$output_file"
      fi
    done < "$input_file"
  done
done