#    This file and Clientside Predictor are Copyright (c) 2021 by Dennis M. Heine (dennis@heine.codes)
#    This file is part of Clientside Predictor.
#
#    Clientside Predictor is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Clientside Predictor is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Clientside Predictor.  If not, see <http://www.gnu.org/licenses/>.
#
#    Diese Datei ist Teil von Clientside Predictor.
#
#    Clientside Predictor ist Freie Software: Sie können es unter den Bedingungen
#    der GNU General Public License, wie von der Free Software Foundation,
#    Version 3 der Lizenz oder (nach Ihrer Wahl) jeder neueren
#    veröffentlichten Version, weiter verteilen und/oder modifizieren.
#
#    Predictor wird in der Hoffnung, dass es nützlich sein wird, aber
#    OHNE JEDE GEWÄHRLEISTUNG, bereitgestellt; sogar ohne die implizite
#    Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
#    Siehe die GNU General Public License für weitere Details.
#
#    Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
#    Programm erhalten haben. Wenn nicht, siehe <https://www.gnu.org/licenses/>.


extends Spatial
class_name ClientsidePredictionDummy

var posLast: Vector3
var posNetworkTargeted
var posExtrapolated
var lastUpdate: float
var updated: bool=false
signal spawn_dummy
var idNode:String=""
var spawned=false;
var lastRotation: Quat
var _pos
var _rota
var AnimationTreeName

#==== ClientsidePredictionDummy.gd====
#	Note: 	This script should be attached to the dummy of the corresponding chracter node.
#
#			The dummy node has got to have this script attached,
#			and it has to be a child node of the _collectionNode.
#			To spawn an instance of a character, call the dummy node's spawn_dummy function from the server

#----func spawn_dummy(var idNode:String, var pos:Vector3, var rota:Quat,var _AnimationTreeName):----
#	idNode: Unique ID of the character instance per player
#	pos:				Start position
#	rota:				Start rotation
#	_AnimationTreeName:	Name of the AnimationTree (can be "" when not using Animation Trees

#----func playAnimation(player:String,animation:String, id,once:bool):----
#	player: 	The AnimationPlayer
#	animation:	The Animation node
#	id:			The id of <something animation specific>
#	once:		Play only once

func playAnimation(player:String,animation:String, id,once:bool):
	
	var n:Node=find_node(player,true,false)
	if(n.is_class("AnimationTreePlayer")):
		var at:AnimationTree=n
		at.animation_node_set_animation (id, find_node(animation,true,false))		
		if(once):
			at.oneshot_node_start(id)
	else:
		n.play(animation)

func spawn_dummy(var _idNode:String, var pos:Vector3, var rota:Quat,var _AnimationTreeName):
	rpc_id(1,"remote_spawn_dummy",_idNode,pos,rota,_AnimationTreeName)	
		
func _process(delta):
	pass
		
master func remote_spawn_dummy(var idNode:String, var pos:Vector3, var rota:Quat,var _AnimationTreeName):
		
	if(get_parent().find_node(idNode,false,false)==null):
		var node=self.duplicate()	
		node.show()
		node.name=str(idNode)
		get_parent().add_child(node)		
		node.lastRotation=rota
		node.posLast=pos
		node.posNetworkTargeted=pos
		node.posExtrapolated=pos
		node.AnimationTreeName=_AnimationTreeName		

		rpc("spawn_dummy_client",idNode,1,pos,rota, _AnimationTreeName)

puppet func spawn_dummy_client(playerId:String, order:int, var pos:Vector3, var rota:Quat,var _AnimationTreeName):
	if(get_parent().find_node(idNode,false,false)==null &&playerId.to_int()!= get_tree().get_network_unique_id()):
		var node:Spatial=self.duplicate()
		node.show()
		var s:Script=get_script()
		get_parent().add_child(node)		
		node.name=str(playerId)	
		node.lastRotation=rota
		node.posLast=pos
		node.posNetworkTargeted=pos
		node.posExtrapolated=pos

func _ready():
	pass # Replace with function body.
	
