#!/bin/bash

case $1 in
  run)
    python3 src/runtime/runtime.zc "$2"
    ;;
  compile)
    python3 src/compiler/compiler.zc "$2"
    ;;
  debug)
    python3 src/debugger/debugger.zc "$2"
    ;;
  transpile)
    python3 src/transpilers/$2.zc "$3"
    ;;
  *)
    echo "ZEN CLI"
    echo "Commands: run, compile, debug, transpile"
    ;;
esac
