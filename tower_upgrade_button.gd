extends HBoxContainer
class_name TowerUpgradeButton

func setup(upgrade: TowerUpgrade):
	$Left/Title.text = upgrade.name + ("[purchased]" if upgrade.purchased else "")
	$Left/Description.text = upgrade.description
	$Right/Cost.text = str(upgrade.cost)

func handle_upgrade(index: int):
	pass
