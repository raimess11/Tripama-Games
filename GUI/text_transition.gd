extends CanvasLayer

signal TextTransitionEnd
@onready var root = $"."
@onready var time = $Timer
@onready var button = $TextureButton
@onready var cont = $sceneClose

func _ready():
	root.visible = false
	cont.visible = false
	

func transisition(target: String):
	root.visible = true
	
	playAnim(target)
	await $AnimationPlayer.animation_finished
	
	time.start(2)
	await time.timeout
	cont.visible = true
	button.disabled = false
	

func playAnim(target: String):
	if target == 'test':
		$AnimationPlayer.play("test_TextTrans")
	elif target == 's1guiltend1':
		$AnimationPlayer.play("Story1_GuiltEnd1")
	elif target == 's1guiltend2':
		$AnimationPlayer.play("Story1_GuiltEnd2")
	elif target == 's1honorend':
		$AnimationPlayer.play("Story1_HonorEnd")
	elif target == 's2desc1':
		$AnimationPlayer.play("Story2_Desc1")
	elif target == 's2desc2':
		$AnimationPlayer.play("Story2_Desc2")
	elif target == 's2desc3':
		$AnimationPlayer.play("Story2_Desc3")
	elif target == 's3desc1':
		$AnimationPlayer.play("Story3_Desc1")
	elif target == 's3desc2':
		$AnimationPlayer.play("Story3_Desc2")
	elif target == 's3badend':
		$AnimationPlayer.play("Story3_BadEnd")
	elif target == 's3dumbend':
		$AnimationPlayer.play("Story3_DumbEnd")
	elif target == 's3trueend':
		$AnimationPlayer.play("Story3_TrueEnd")
	else :
		return

func _on_texture_button_pressed():
	root.visible = false
	cont.visible = false
	button.disabled = true
	TextTransitionEnd.emit()
