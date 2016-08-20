enemies =
{
	ZOMBIE = {
		name = "Zombie",
		image = res.enemy_zombie,
		stats = {
			strength = 1
			endurance = 1
			constitution = 5

			intelligence = 0
			wisdom = 3
			will = 0
		}
	}
}

function new(name, image, str, endr, con, agi, wis, int, will)
	local e = {}
	e.name = name
	e.image = image
	e.stats = {
		strength = str,
		endurance = endr,
		constitution = con,
		agility = agi,
		wisdom = wis,
		intelligence = int,
		willpower = will
	}
