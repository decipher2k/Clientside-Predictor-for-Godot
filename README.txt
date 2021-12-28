Clientside Predictor
Character synchronization using clientside prediction for Godot 3D network games.

This asset allows you to implement clientside prediction with just a few lines of code per entity.

Do youn need an 3D artist or a gamedev? In that case, please send a mail to dennis@heine.codes

Usage:
get_parent().find_node("DummyCollection",true,false).get_node("Dummy").spawn_dummy(str(playerId),Vector3(0,0,0),Quat(0.0,0.0,0.0,0.0),"")
get_parent().find_node("ClientsidePrediction",true,false).initBegin(0.4,"Player","DummyCollection", 30.0,Vector3(0,0,0),"Camera",5.0,false,false)

Each entity (for example each player entity, each bullet entity etc - not their instances!) has to have its own ClientsidePrediction node (you will have to rename it in order to use more than one entity.)
To modify the avatar the user sees, the corresponding node should be attached to the node called "Dummy".
That node should also be positions outside the walkable terrain, as it could cause unwanted collissions.

==== ClientsidePredictionDummy.gd====
(attached to the Dummy node, which has to be a subnode of the DummyCollection)
#	Note: 	This script should be attached to the dummy of the corresponding chracter node.
#
#			The dummy node has got to have this script attached,
#			and it has to be a child node of the _collectionNode.
#			To spawn an instance of a character, call the dummy node's spawn_dummy function from the server

#----func spawn_dummy(var idNode:String, var pos:Vector3, var rota:Quat,var _AnimationTreeName):----
#	idNode: Unique ID of the character instance per player (network id)
#	pos:				Start position
#	rota:				Start rotation
#	_AnimationTreeName:	Name of the AnimationTree (can be "" when not using Animation Trees

#----func playAnimation(player:String,animation:String, id,once:bool):----
#	player: 	The AnimationPlayer
#	animation:	The Animation node
#	id:			The id of <something animation specific>
#	once:		Play only once
	


============================================

#==== ClientsidePrediction.gd====
(Attached to the main node of the clientside prediction, most likely labled ClientsidePrediction)
#	Note: 	This script should be attached to the _characterNode.
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
#	_useKeyFrames:	should root motion be applied when animating?
#	_useTarget:		use fixed target instead of character synchronization


