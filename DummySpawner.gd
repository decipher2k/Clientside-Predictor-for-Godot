extends Spatial

#WARNING!!!! Delete this node on clients. It should ONLY be existing on the server.


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	pass # Replace with function body.
	
func _process(delta):
	pass

func remote_spawn_dummy(var idNode:String, var pos:Vector3, var rota:Quat,var _AnimationTreeName):

	if(get_node("/root").find_node("DummyCollection",true,false).find_node(idNode,false,false)==null):
		var node=get_node("/root").find_node("DummyCollection",true,false).get_node("Dummy").duplicate()	
		node.show()
		node.name=str(idNode)
		get_node("/root").find_node("DummyCollection",true,false).add_child(node)		
		node.lastRotation=rota
		node.posLast=pos
		node.posNetworkTargeted=pos
		node.posExtrapolated=pos
		node.AnimationTreeName=_AnimationTreeName		

		get_node("/root").find_node("DummyCollection",true,false).get_node("Dummy").rpc("spawn_dummy_client",idNode,1,pos,rota, _AnimationTreeName)





# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
