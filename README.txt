Clientside Predictor
Character synchronization using clientside prediction for Godot 3D network games.

This asset allows you to implement clientside prediction with just a few lines of code per entity.

Do youn need an 3D artist or a gamedev? In that case, please send a mail to github@decipher2k.ml


=================================


Usage (all functions have to be called from the server):

	var target:Vector3=Vector3(100.0,0.0,100.0)
	var lockRotation:Vector3=Vector3(0.0,1.0,1.0)
	get_parent().find_node("DummySpawner",true,false).remote_spawn_dummy(0.4,str(playerId),Vector3(0,0,0),Quat(0.0,0.0,0.0,0.0),"","DummyCollection",lockRotation)	
	get_parent().get_root().get_node("ClientsidePredictionSpawner").initBegin("Player","DummyCollection", 30.0,target,"Camera",5.0,false,false)
	get_parent().find_node("ClientsidePrediction",true,false).initBegin("Player","DummyCollection", 30.0,target,"Camera",5.0,false,false)
	
Each entity (for example each player entity, each bullet entity etc - not their instances!) has to have its own ClientsidePrediction node (you will have to rename it in order to use more than one entity.)
To modify the avatar the user sees, the corresponding node should be attached to the node called "Dummy".
That node should be positioned outside the walkable terrain, as it could cause unwanted collissions.

===================================

Dummy states to implement into state machine: (!!! Untested !!! Please write GitHub issue in case of failure)
These have to be called from the client. Only states of nodes with client's ID can be changed, and the
states will be replicated over the network.

var dummyNode:ClientsidePredictionDummy=get_tree().find_node("DummyCollection").get_node(nodeID)

Play sound: 	dummyNode.play_sound("res://sound.ogg", nodeID, "DummyCollection", "<SoundNodeName>")
Play animation:	dummyNode.playAnimation(nodeID, "<AnimationPlayerName>","SomeCoolAnimation", animationNodeId,true):	
Set mesh:	dummyNode.set_mesh(var "res://mesh",nodeID, "DummyCollection", "<MeshNodeName>"):
Set speed_	dummyNode.set_speed(0.4, nodeID, "DummyCollection"):


=================================

Node Structure:

===Client===
-root
--"Player" (type: KinematicBody) - has to have the player controller script attached
  (name can be changed for more entities)
--"ClientsidePrediction" (type: Spatial) ClientsidePrediction.gd
  (name can be changed for more entities)
----"DummyFunctions" (type: Spatial) 
     (feature not yet implemented)
----""DummyCollection" (type: Spatial)
------"Dummy" (type: KinematicBody) ClientsidePredictionDummy.gd
--------"MeshInstance" (type: MeshInstance)
--------"CollissionShape" (type: CollissionShape)

===Server===
-root
--"Player" (type: KinematicBody)
  (name can be changed for more entities)
--"DummySpawner" (type: Spatial) DummySpawner.gd
--"ClientsidePredictionSpawner" (Type: Spatial) ClientsidePredictionSpawner.gd
--"ClientsidePrediction" (type: Spatial) ClientsidePrediction.gd
   (name can be changed for more entities)
----"DummyFunctions" (type: Spatial) 
     (feature not yet implemented)
----"DummyCollection" (type: Spatial) 
    (name can be changed for more entities)
------"Dummy" (type: KinematicBody) ClientsidePredictionDummy.gd
--------"MeshInstance" (type: MeshInstance)
--------"CollissionShape" (type: CollissionShape)

=================================

ToDo:
-individual nodes per player, if possible. If not, individual meshes.
-callback functions for the "Dummy" nodes
-add animation and sound

=================================

Update:
v0.2: -Seperated client scene from server scene.
       The server scene now has got to have a DummySpawner.gd node attached.   
      -Added demo scenes. (You will have to add an own connection handling part, which calls the DummySpawner, though.
      				The player controller for the "Player" node also has to be implemented, it is not included.)
v0.2.1 -added some sanity checks
v0.2.2 -parametrized ClientsidePrediction.tscn name in DummySpawner 
v0.3   -moved spawning of ClientsidePrediction.gd to server, making it being called by ClientsidePredictionSpawner
v0.5   -addes states
v0.5   -added more sanity checks

=================================

#==== DummySpawner.gd====
#	Note: 	This script should be attached to a seperate node on the server only.
#----func remote_spawn_dummy(var idNode:String, var pos:Vector3, var rota:Quat,var _AnimationTreeName,  var _collectionName):----
#	idNode: Unique ID of the character instance per player
#	pos:				Start position
#	rota:				Start rotation
#	_AnimationTreeName:	Name of the AnimationTree (can be "" when not using Animation Trees
#	_collectionName:	Name of the node with the ClientsidePrediction.tscn
	


#==== ClientsidePrediction.gd====
(Attached to the main node of the clientside prediction, most likely labled ClientsidePrediction)
#	Note: 	This script should be attached to the _collectionNode.
#
#			The dummy node has got to have the script ClientsidePredictionDummy.gd attached,
#			and it has to be a child node of the _collectionNode.
#			To spawn an instance of a character, call the dummy node's spawn_dummy function from the server
#			The rotational node should be the node from which to get the rotation, for example the Camera node		
#	
#----func initBegin(var _speed:float, var _characterNode, var _collectionNode,  var _tickrate, _targetPosition, var _rotator, var _clamping,_useKeyFrames,_useTarget):
#	_speed: 		speed of interpolation
#	_characterNode: node that should be interpolated
#	_collectionNode:node to that holds the character list
#	_tickrate: 		rate at that the position is being updated (milliseconds)
#	_target: 		target position when using direct position instead of character sync
#	_rotation:		target rotation when using direct position instead of character sync
#	_clamping:		distance from extrapolated position to current position at which to snap
#	_useKeyFrames:		should root motion be applied when animating?
#	_useTarget:		use fixed target instead of character synchronization


