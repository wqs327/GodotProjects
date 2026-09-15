extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: int = 100

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	animation()
	move_and_slide()
	
		
func animation():
	if direction:
		$AnimatedSprite2D.flip_h = direction.x > 0#若方向向右，将画面翻转
		if direction.x != 0:
			$AnimatedSprite2D.animation = 'left'#当水平移动，使用left动画
		else:
			$AnimatedSprite2D.animation = 'up' if direction.y < 0 else 'down'
	else: 
		$AnimatedSprite2D.frame = 0#当无用户输入时，动画定格在当前动画的第一帧静止
