#!/bin/sh

print_currency() {
  BUY_SELL_PRICE=$(curl -s https://www.ing.cz/o-ing-bank/kurzovni-listek/ | grep -A 15 "<b>$1</b>" | awk '{$1=$1};1' | tr -dc '0-9,\n' | sed '/^$/d' | sed 's/,/./g' | paste -sd "," -)
  echo "$1,$BUY_SELL_PRICE"
}

echo "id,buy,sell"
print_currency "USD/CZK"
print_currency "EUR/CZK"
