#!/bin/bash

#Read score
while read -r score
do
  #Break scores into array
  scores=$(echo $score | grep -o .)
  scores=($scores)
 
  #vars 
  total=0
  totalRolls=${#scores[@]}

  #Change chars to numbers
  for ((i=0; i<${#scores[@]}; i++));
  do
    if [ ${scores[$i]} == "X" ]; then
      scores[$i]=10
    elif [ ${scores[$i]} == "-" ]; then
      scores[$i]=0
    fi
  done
  
  #Add up score
  for ((i=0; i<${#scores[@]}; i++));
  do
    roll=0
    #If last frame
    if (( $totalRolls-3 <= $i )); then
      if [ ${scores[$i]} == "/" ]; then
        roll=$((10-${scores[$i-1]}))
	total=$(($total+$roll))
      else
	 roll=${scores[$i]}
	 total=$(($total+$roll))
      fi
    #If strike
    elif [ ${scores[$i]} = 10 ]; then
	if [ ${scores[$i+2]} == "/" ]; then
          roll=$((10+${scores[$i+1]}+10-${scores[$i+1]}))
          total=$(($total+$roll))
	else
          roll=$((10+${scores[$i+1]}+${scores[$i+2]}))
          total=$(($total+$roll))
	fi
    #If spare
    elif [ ${scores[$i]} == "/" ]; then
        roll=$((10-${scores[$i-1]}+${scores[$i+1]}))
        total=$(($total+$roll))
    else
      roll=${scores[$i]}
      total=$(($total+$roll))
    fi
  done
  echo "score: $score |  total: $total"
done < scores.txt
