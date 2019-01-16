#!/bin/sh
get_price() {
  PRICE=$(curl -s https://www.ing.cz/ing-podilove-fondy/kompletni-nabidka-ing-podilovych-fondu/$1/ | grep $2 | head -1 | awk '{$1=$1};1'| awk -F' ' '{ print $1 }')
  echo "$1;$PRICE;$2"
}

get_price_ing() {
  PRICE=$(curl -s https://www.ing.cz/ing-podilove-fondy/nabidka-fondu/zakladni-nabidka-ing-podilovych-fondu-bez-poplatku/$1/ | grep $2 | grep -v '=' | head -1 | awk '{$1=$1};1' | awk -F' ' '{ print $1 }')
  echo "$1;$PRICE;$2"
}

echo "id;price;currency"
get_price "blackrock-world-healthscience" "USD"
get_price "franklin-technology" "USD"
get_price "fidelity-global-dividend" "CZK"
get_price "fidelity-asian-special-situations" "CZK"
get_price_ing "ing-aria-lion-aggresive" "CZK"
get_price_ing "ing-aria-lion-dynamic" "CZK"
get_price_ing "ing-aria-lion-balanced" "CZK"
get_price_ing "ing-aria-lion-moderate" "CZK"
