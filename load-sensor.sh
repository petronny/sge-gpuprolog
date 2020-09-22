#!/bin/sh
hostname=`uname -n`
gpu_total=`nvidia-smi -L|wc -l`
smitool=`which nvidia-smi`

while [ 1 ]; do
  read input
  result=$?
  if [ $result != 0 ]; then
    exit 1
  fi
  if [ "$input" == "quit" ]; then
    exit 0
  fi

  result=$?
  if [ $result != 0 ]; then
    gpu_av=0
    gpu_=0
  else
    gpu_free=`nvidia-smi -q | grep -c -P 'Processes.*: None'`
    gpu_used=$(expr $gpu_total - $gpu_free)
  fi

  echo begin
  echo "$hostname:gpu_free:$gpu_free"
  echo "$hostname:gpu_used:$gpu_used"
  echo "$hostname:gpu_total:$gpu_total"
  echo end
done

exit 0
