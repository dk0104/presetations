#!/usr/bin/env -S just --justfile

# Globals
diagrams                         := justfile_directory() + "/diagrams"
tmp                              := justfile_directory() + "/tmp"

# show all the justfile recipes
default:
  @just --list

# run graphasy diagram
plantuml diagram:
  #!/usr/bin/env bash  
  export diagram="{{diagram}}"
  java -jar ~/.local/bin/plantuml.jar {{diagrams}}/"$diagram".puml -utxt
  mv {{diagrams}}/"$diagram".utxt {{tmp}}/"$diagram".utxt
  cat {{tmp}}/"$diagram".utxt

# show intro ascii using figlet
intro *pres_title:
  #!/usr/bin/env bash
  export title="{{pres_title}}"
  if command -v figlet &>/dev/null; then
    echo "$title" | figlet -f banner3-D -w 240
  else
    echo "$title"
  fi

