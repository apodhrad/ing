#!/bin/sh
ING_FILE="$1"
FUNDS_FILE="$2"
ING_CURRENCY_FILE="$3"
FUNDS=$(cat $FUNDS_FILE | tail -n +2 | awk -F',' '{ print $2 }' | sort | uniq)
FINAL_TOTAL_PRICE=0
FINAL_CURRENT_PRICE=0

print_info() {
  TOTAL_COUNT=$(cat $FUNDS_FILE | grep "$1" | awk -F',' '{ print $3 }' | paste -sd '+' - | bc)
  TOTAL_PRICE=$(cat $FUNDS_FILE | grep "$1" | awk -F',' '{ print $3 "*" $4 }' | paste -sd '+' - | bc)
  TOTAL_PRICE_CZK=$(cat $FUNDS_FILE | grep "$1" | awk -F',' '{ print $7 }' | paste -sd '+' - | bc)
  FINAL_TOTAL_PRICE=$(echo "$FINAL_TOTAL_PRICE + $TOTAL_PRICE_CZK" | bc)
  CURRENT_PRICE=$(cat $ING_FILE | jq -r --arg FUND "$1" '.[] | select (.id == $FUND) | .price')
  CURRENT_PRICE=$(echo "$TOTAL_COUNT*$CURRENT_PRICE" | bc)
  CURRENT_PRICE_CZK=$CURRENT_PRICE
  CURRENCY=$(cat $FUNDS_FILE | grep "$1" | awk -F',' '{ print $6 }' | uniq)
  if [ "$CURRENCY" = "USD" ]; then
    CURRENCY_BUY=$(cat $ING_CURRENCY_FILE | grep "USD/CZK" | awk -F',' '{ print $2 }')
    CURRENT_PRICE_CZK=$(echo "$CURRENT_PRICE*$CURRENCY_BUY" | bc)
  fi
  FINAL_CURRENT_PRICE=$(echo "$FINAL_CURRENT_PRICE + $CURRENT_PRICE_CZK" | bc)
  DIFF=$(echo "$CURRENT_PRICE/$TOTAL_PRICE*100-100" | bc -l |  awk '{printf "%.2f", $0}')
  echo "$1,$DIFF"
}

echo "fund,diff"
for FUND in $FUNDS; do
  print_info "$FUND"
done
DIFF=$(echo "$FINAL_CURRENT_PRICE/$FINAL_TOTAL_PRICE*100-100" | bc -l |  awk '{printf "%.2f", $0}')
echo "total,$DIFF"
