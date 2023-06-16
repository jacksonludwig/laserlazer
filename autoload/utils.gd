extends Node

## check if the `flag_val` bit in `value` is set
func check_bit_flag(value: int, flag_val: int) -> bool:
	return (value & flag_val) == flag_val
