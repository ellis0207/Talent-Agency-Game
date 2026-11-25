extends RefCounted
## Formatting money for display. All money in the game is whole dollars (int).


## 1250 -> "$1,250", -300 -> "-$300"
static func format(amount: int) -> String:
	var digits := str(absi(amount))
	var out := ""
	var count := 0
	for i in range(digits.length() - 1, -1, -1):
		out = digits[i] + out
		count += 1
		if count % 3 == 0 and i > 0:
			out = "," + out
	return ("-$" if amount < 0 else "$") + out


## Like format(), but always shows the sign: 400 -> "+$400", -150 -> "-$150", 0 -> "$0"
static func format_signed(amount: int) -> String:
	if amount > 0:
		return "+" + format(amount)
	return format(amount)
