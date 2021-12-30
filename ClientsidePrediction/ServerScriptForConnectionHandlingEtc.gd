extends Spatial

func _ready():
	pass
	
func doSpawn(playerId):
	var target:Vector3=Vector3(100.0,0.0,100.0)
	var lockRotation:Vector3=Vector3(0.0,1.0,1.0)
	get_parent().find_node("DummySpawner",true,false).remote_spawn_dummy(0.4,str(playerId),Vector3(0,0,0),Quat(0.0,0.0,0.0,0.0),"","DummyCollection",lockRotation)	
	get_parent().get_root().get_node("ClientsidePredictionSpawner").initBegin("Player","DummyCollection", 30.0,target,"Camera",5.0,false,false)
	get_parent().find_node("ClientsidePrediction",true,false).initBegin("Player","DummyCollection", 30.0,target,"Camera",5.0,false,false)
	
