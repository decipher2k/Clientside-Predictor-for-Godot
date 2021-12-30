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


extends KinematicBody
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
var lockRotation
var speed

#
#			The dummy node has got to have this script attached,
#			and it has to be a child node of the _collectionNode.
#			To spawn an instance of a character, call the DummySpawner node's remote_spawn_dummy function from the server



func play_sound(var _sound, var id_node, var _nodeCollection, var _soundNodeName):
	rpc_id(1,"master_play_sound",id_node,_sound,_nodeCollection,_soundNodeName)

master func master_play_sound(var nodeId, var _sound, var collectionNode, var _soundNodeName):
	if(get_tree().get_rpc_sender_id()==nodeId):
		rpc("puppet_play_sound",nodeId,_sound,collectionNode,_soundNodeName)
		
puppet func puppet_play_sound(var nodeId, var _sound, var collectionNode, var _soundNodeName):	
	if(get_parent().get_node_or_null(nodeId)==null):
		return
	if(!is_class(ClientsidePredictionDummy)):
		return
	if(get_node_or_null(_soundNodeName)==null):
		return				
	get_node(_soundNodeName).stream=load(_sound)
	get_node(_soundNodeName).play()
	

func playAnimation(idDummy, player:String,animation:String, id,once:bool):	
	rpc_id(1,"animationProxy",idDummy,player,animation, id,once)


master func animationProxy(idDummy,player:String,animation:String, id,once:bool):
	if(get_parent().get_node_or_null(idDummy)==null):
		return
	if(!is_class(ClientsidePredictionDummy)):
		return		
	if(get_node_or_null(player)==null):
		return				
	if(get_tree().get_rpc_sender_id()==idDummy):
		var node=self
		if(!node.is_class("ClientsidePredictionDummy")):
			pass
		var peers=get_tree().get_network_connected_peers()	
		var i=0
		while i < peers.size():		
			if(peers[i]!=ServerNetwork.SERVER_ID):											
				rpc_id(peers[i],"puppetPlayAnimation",idDummy,player,animation,id,once,idDummy)							
			i=i+1

puppet func puppetPlayAnimation(animationPlayer,animationName,animationNodeId,once,idDummy):	
	if(get_parent().get_node_or_null(idDummy)==null):
		return		
	if(!self.is_class("ClientsidePredictionDummy")):
		return
	if(get_node_or_null(animationPlayer)==null):
		return				
	var playerNode:Node =find_node(animationPlayer,true,false)	
	if(playerNode.is_class("AnimationTreePlayer")):
		playerNode.animation_node_set_animation (animationNodeId, find_node(animationName,true,false))		
		if(once):
			playerNode.oneshot_node_start(animationNodeId)
	else:
		if(playerNode.is_class("AnimationPlayer")):
			var prevAnimation=playerNode.get_queue()[playerNode.get_queue().size()-1]
			playerNode.play(animationName)
			playerNode.queue(prevAnimation)
		else:
			return

func set_mesh(var _mesh, var id_node, var _nodeCollection, var _meshNodeName):
	if(get_parent().get_node_or_null(id_node)==null):
		return
	if(!is_class(ClientsidePredictionDummy)):
		return		
	if(get_node_or_null(_meshNodeName)==null):
		return						
	get_node(_meshNodeName).mesh=load(_mesh)
	rpc_id(1,"master_set_mesh",id_node,_mesh,_nodeCollection)

master func master_set_mesh(var nodeId, var _mesh, var collectionNode, var _meshNodeName):
	if(get_parent().get_node_or_null(nodeId)==null):
		return	
	if(!is_class(ClientsidePredictionDummy)):
		return	
	if(get_node_or_null(_meshNodeName)==null):
		return				
	if(get_tree().get_rpc_sender_id()==nodeId):
		rpc("puppet_set_mesh",_meshNodeName,_mesh,nodeId)

puppet func puppet_set_mesh(var _meshNodeName, var _mesh, nodeId):
	if(get_parent().get_node_or_null(nodeId)==null):
		return	
	if(!is_class(ClientsidePredictionDummy)):
		return	
	if(get_node_or_null(_meshNodeName)==null):
		return					
	get_node(_meshNodeName).mesh=load(_mesh)
	
func set_speed(var _speed, var id_node, var _nodeCollection):
	speed=_speed
	rpc_id(1,"master_set_speed",id_node,_speed,_nodeCollection)

master func master_set_speed(var nodeId, var speed, var collectionNode):
	if(get_parent().get_node_or_null(nodeId)==null):
		return	
	if(!is_class(ClientsidePredictionDummy)):
		return
	if(get_node_or_null(collectionNode)==null):
		return				
	if(get_tree().get_rpc_sender_id()==nodeId):
		get_node("/root").find_node(collectionNode,true,false).get_node(nodeId).speed=speed

	
func is_class(var className):
	if(className=="ClientsidePredictionDummy"):
		return true


#Warning! This should be safe concerning the specs. Reomtely injecting code is _allways_ dangerous though.
#Delete this function if you are unsure.

#puppet func callFunction(var functionNode, var functionName):
#	var n:Node=get_parent().get_node("DummyFunctions").find_node(functionNode,true,false)
#	var ref = funcref(n, functionName)
#	ref.call_func()

puppet func spawn_dummy_client(_speed: float,playerId:String, order:int, var pos:Vector3, var rota:Quat,var _AnimationTreeName, var _lockRotation):
	if(get_parent().get_node_or_null(playerId)==null &&playerId.to_int()!= get_tree().get_network_unique_id()):
		var node:Spatial=self.duplicate()
		node.show()
		var s:Script=get_script()
		get_parent().add_child(node)		
		node.name=str(playerId)	
		node.speed=_speed
		node.lastRotation=rota
		node.posLast=pos
		node.posNetworkTargeted=pos
		node.posExtrapolated=pos
		node.lockRotation=_lockRotation
func _ready():
	pass # Replace with function body.
	
