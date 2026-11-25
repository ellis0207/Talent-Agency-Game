extends "res://tests/test_case.gd"

const Money = preload("res://scripts/core/money.gd")


func test_formats_small_amounts() -> void:
	assert_eq(Money.format(0), "$0")
	assert_eq(Money.format(7), "$7")
	assert_eq(Money.format(999), "$999")


func test_adds_thousands_separators() -> void:
	assert_eq(Money.format(1000), "$1,000")
	assert_eq(Money.format(1250), "$1,250")
	assert_eq(Money.format(1234567), "$1,234,567")


func test_negative_amounts() -> void:
	assert_eq(Money.format(-300), "-$300")
	assert_eq(Money.format(-45000), "-$45,000")


func test_signed_format() -> void:
	assert_eq(Money.format_signed(400), "+$400")
	assert_eq(Money.format_signed(-150), "-$150")
	assert_eq(Money.format_signed(0), "$0")
