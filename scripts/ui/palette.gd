extends RefCounted
## The placeholder art palette. See docs/ART_STYLE.md.
## Colors are written as floats; the hex code is in the comment.

const BACKGROUND := Color(0.145, 0.188, 0.275)  # #253046  App background behind the panels
const SKY := Color(0.561, 0.827, 1.000)  # #8fd3ff
const SKY_LOW := Color(0.780, 0.925, 1.000)  # #c7ecff
const SUN := Color(1.000, 0.820, 0.400)  # #ffd166
const CLOUD := Color(1.000, 1.000, 1.000)  # #ffffff
const SKYLINE := Color(0.435, 0.659, 0.788)  # #6fa8c9  Distant buildings
const STREET := Color(0.290, 0.306, 0.412)  # #4a4e69
const SIDEWALK := Color(0.604, 0.549, 0.596)  # #9a8c98
const BRICK := Color(0.788, 0.392, 0.294)  # #c9644b  Building facade
const BRICK_DARK := Color(0.612, 0.290, 0.216)  # #9c4a37
const ROOF := Color(0.239, 0.251, 0.357)  # #3d405b
const OFFICE_WALL := Color(1.000, 0.910, 0.761)  # #ffe8c2  Your rented room
const OFFICE_FLOOR := Color(0.710, 0.514, 0.353)  # #b5835a
const VACANT_WALL := Color(0.427, 0.349, 0.478)  # #6d597a  Floors you don't rent yet
const WINDOW_GLASS := Color(0.659, 0.855, 0.863)  # #a8dadc
const WOOD := Color(0.553, 0.353, 0.231)  # #8d5a3b
const PLANT := Color(0.322, 0.718, 0.533)  # #52b788
const PAPER := Color(1.000, 0.965, 0.898)  # #fff6e5  Panels and cards
const PAPER_DARK := Color(0.949, 0.886, 0.769)  # #f2e2c4
const INK := Color(0.169, 0.176, 0.259)  # #2b2d42  Text
const INK_SOFT := Color(0.361, 0.373, 0.478)  # #5c5f7a  Secondary text
const OUTLINE := Color(0.169, 0.176, 0.259)  # #2b2d42  Chunky outlines
const MONEY_GREEN := Color(0.165, 0.616, 0.561)  # #2a9d8f
const MONEY_RED := Color(0.902, 0.224, 0.275)  # #e63946
const ACCENT := Color(0.957, 0.635, 0.380)  # #f4a261  Buttons
const ACCENT_HOVER := Color(0.969, 0.722, 0.514)  # #f7b883
const ACCENT_PRESSED := Color(0.878, 0.478, 0.184)  # #e07a2f
const ATHLETES := Color(0.906, 0.435, 0.318)  # #e76f51
const MUSICIANS := Color(0.608, 0.365, 0.898)  # #9b5de5
const ACTORS := Color(0.839, 0.157, 0.224)  # #d62839
const MODELS := Color(0.000, 0.651, 0.651)  # #00a6a6
const AGENCY := Color(0.271, 0.482, 0.616)  # #457b9d


## Tag color for each division (and "agency" for office news).
static func division_color(division: String) -> Color:
	match division:
		"athletes":
			return ATHLETES
		"musicians":
			return MUSICIANS
		"actors":
			return ACTORS
		"models":
			return MODELS
		_:
			return AGENCY
