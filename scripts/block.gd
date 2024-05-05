extends StaticBody2D

# From https://youtu.be/JOytyzK7Z94?si=dbY6T7ujesF19KrV
class_name Block

func bump():
	var bump_tween = get_tree().create_tween()
	bump_tween.tween_property(self, "position", position + Vector2(0, -5), 0.12)
	bump_tween.chain().tween_property(self, "position", position, 0.12)
