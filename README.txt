Clientside Predictor
Character synchronization using clientside prediction for Godot 3D network games.

This asset allows you to implement clientside prediction with just a few lines of code per entity.

Do youn need an 3D artist or a gamedev? In that case, please send a mail to dennis@heine.codes


=================================


Usage:
get_parent().find_node("DummyCollection",true,false).get_node("Dummy").spawn_dummy(str(playerId),Vector3(0,0,0),Quat(0.0,0.0,0.0,0.0),"")
get_parent().find_node("ClientsidePrediction",true,false).initBegin(0.4,"Player","DummyCollection", 30.0,Vector3(0,0,0),"Camera",5.0,false,false)

Each entity (for example each player entity, each bullet entity etc - not their instances!) has to have its own ClientsidePrediction node (you will have to rename it in order to use more than one entity.)
To modify the avatar the user sees, the corresponding node should be attached to the node called "Dummy".
That node should be positioned outside the walkable terrain, as it could cause unwanted collissions.

=================================

Node Structure:

===Client===
-root
--"Player" (type: KineticBody) - has to have the player controller script attached
--"ClientsidePrediction" (type: Spatial) ClientsidePrediction.gd
  (name can be changed)
----"DummyFunctions" (type: Spatial) 
     (feature not yet implemented)
----""DummyCollection" (type: Spatial) 
------"Dummy" (type: KineticBody) ClientsidePredictionDummy.gd
--------"MeshInstance" (type: MeshInstance)
--------"CollissionShape" (type: CollissionShape)

===Server===
-root
--"Player" (type: KineticBody)
--"DummySpawner" (type: Spatial) DummySpawner.gd
--"ClientsidePrediction" (type: Spatial) ClientsidePrediction.gd
  (name can be changed)
----"DummyFunctions" (type: Spatial) 
     (feature not yet implemented)
----"DummyCollection" (type: Spatial) 
------"Dummy" (type: KineticBody) ClientsidePredictionDummy.gd
--------"MeshInstance" (type: MeshInstance)
--------"CollissionShape" (type: CollissionShape)

=================================

ToDo:
-individual nodes per player, if possible. If not, individual meshes.
-callback functions for the "Dummy" nodes
-lock rotation
-add a function to modify speed during runtime withouth restart
-add animation and sound

=================================

Update:
v0.2: -Seperated client scene from server scene.
       The server scene now has got to have a DummySpawner.gd node attached.   
      -Added demo scenes. (You will have to add an own connection handling part, which calls the DummySpawner, though.
      				The player controller for the "Player" node also has to be implemented, it is not included.)
v0.2.1 -added some sanity checks
v0.2.2 -parametrized ClientsidePrediction.tscn name in DummySpawner 


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

#	Entry point:
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


