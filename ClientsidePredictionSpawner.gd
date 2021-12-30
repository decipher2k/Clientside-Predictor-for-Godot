extends Spatial
class_name ClientsidePredictionSpawner

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initBegin(var _speed:float, var _characterNode, var _collectionNode,  var _tickrate, _targetPosition,_rotator, _clamping,_useKeyFrames, _useTarget):
#_node("/root").find_node(_collectionNode,true,false).get_parent().rpc_id(peers[i],"_beginCharacterSync3D",_speed,_characterNode,_collectionNode,_tickrate,_targetPosition,_rotator, _clamping,_useKeyFrames,_useTarget)
	get_tree().get_root().find_node(_collectionNode,true,false).get_parent().rpc("_beginCharacterSync3D",_speed,_characterNode,_collectionNode,_tickrate,_targetPosition,_rotator, _clamping,_useKeyFrames,_useTarget)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
