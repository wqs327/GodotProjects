extends CharacterBody2D

var direction: Vector2
var speed := 50
var player: CharacterBody2D
var health := 3
var is_explode:=false

func _ready() -> void:
	var unique_material = $AnimatedSprite2D.material.duplicate()
	$AnimatedSprite2D.material = unique_material
	unique_material.set_shader_parameter("Progress", 1.0)

func _on_detection_area_2d_body_entered(player_body: CharacterBody2D) -> void:
	player = player_body

func _physics_process(_delta: float) -> void:
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()


func _on_detection_area_2d_body_exited(_player_body: CharacterBody2D) -> void:
	player = null


func _on_collision_area_body_entered(_body: Node2D) -> void:
	explode()

func hit():
	if is_explode:
		return
	health -= 1
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D.material,'shader_parameter/Progress',0.0,0.1)
	tween.tween_property($AnimatedSprite2D.material,'shader_parameter/Progress',1.0,0.5)
	if health <= 0:
		explode()
		
func explode():
	if is_explode:
		return
	is_explode = true
	speed = 0
	$AudioStreamPlayer2D.play()
	$AnimationPlayer.stop()
	$AnimatedSprite2D.hide()
	$ExplosionSprite.show()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished#等待动画播放完毕再销毁动画
	chain_reaction()
	queue_free()

func chain_reaction():
	for drone:CharacterBody2D in get_tree().get_nodes_in_group('Drones'):
		if position.distance_to(drone.position) < 20:
			drone.explode()
