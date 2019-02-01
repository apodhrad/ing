#!/bin/sh
ING_FILE="$1"
FUNDS_FILE="$2"
FUNDS=$(cat $FUNDS_FILE | tail -n +2 | awk -F',' '{ print $2 }' | sort | uniq)

print_info() {
  TOTAL_COUNT=$(cat $FUNDS_FILE | grep "$1" | awk -F',' '{ print $3 }' | paste -sd '+' - | bc)
  TOTAL_PRICE=$(cat $FUNDS_FILE | grep "$1" |  awk -F',' '{ print $3 "*" $4 }' | paste -sd '+' - | bc)
  CURRENT_PRICE=$(cat $ING_FILE | jq -r --arg FUND "$1" '.[] | select (.id == $FUND) | .price')
  CURRENT_PRICE=$(echo "$TOTAL_COUNT*$CURRENT_PRICE" | bc)
  DIFF=$(echo "$CURRENT_PRICE/$TOTAL_PRICE*100-100" | bc -l |  awk '{printf "%.2f", $0}')
  echo "$1,$DIFF"
}

echo "fund,diff"
for FUND in $FUNDS; do
  print_info "$FUND"
done
