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
class_name ClientsidePrediction
	
var running:bool=false
var targetNode
var speed:float
var characterNode=null
var collectionNode
var collectionNodeName
var targetPosition=null
var modeIsCharacterSync:bool=false
var tickrate: int
var dummyNode
var start=false
var started=false
var isMaster=false
var rotator
var clamping
var characterNodeName
var useKeyFrames
var lastFrame:int=OS.get_ticks_msec()

#==== ClientsidePrediction.gd====
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

func _ready():
	pass
	
func get_root(n:Node):
	if(n.get_parent()):
		return n
	else:
		return get_root(n.get_parent())
		

func initBegin(var _speed:float, var _characterNode, var _collectionNode,  var _tickrate, _targetPosition,_rotator, _clamping,_useKeyFrames, _useTarget):

	speed=_speed
	collectionNode=get_node("/root").find_node(_collectionNode,true,false)
	if(collectionNode==null):
		return
	rotator=_rotator
	targetPosition=_targetPosition
	collectionNodeName=_collectionNode
	if(!_useTarget):
		modeIsCharacterSync=true
	tickrate=_tickrate
	isMaster=true
	rotator=_rotator
	#running=true
	clamping=_clamping
	useKeyFrames=_useKeyFrames	
	

	
puppet func _beginCharacterSync3D(var _speed:float, var _characterNode, var _collectionNode, var _tickrate, var _targetPosition, var _rotator,_clamping,_useKeyFrames,_useTarget):
	speed=_speed
	characterNode=get_node("/root").find_node(_characterNode,true,false)
	if(characterNode==null):
		return	

	collectionNode=get_node("/root").find_node(_collectionNode,true,false)
	targetPosition=_targetPosition
	rotator=_rotator
	collectionNodeName=_collectionNode
	modeIsCharacterSync=!_useTarget
	tickrate=_tickrate
	running=true
	clamping=_clamping
	useKeyFrames=_useKeyFrames

master func animationProxy(idDummy,player:String,animation:String, id,once:bool):
	var peers=get_tree().get_network_connected_peers()	
	var i=0
	while i < peers.size():		
		if(peers[i]!=ServerNetwork.SERVER_ID):											
			rpc_id(peers[i],"animationPuppet",idDummy,player,animation,id,once)							
		i=i+1

puppet func animationPuppet(idDummy,player:String,animation:String, id,once:bool):
	var node=find_node(collectionNodeName,true,false).get_node(idDummy)
	if(!node.is_class("ClientsidePredictionDummy")):
		pass
	node.playAnimation(player,animation,id,once)

func playAnimation(idDummy, player:String,animation:String, id,once:bool):	
	rpc_id(1,"animationProxy",idDummy,player,animation, id,once)


func _physics_process(delta):
	if(running):	
		if(!get_tree().is_network_server()):
			
			var peers=get_tree().get_network_connected_peers()
			var i=0
			while i < collectionNode.get_children().size():
				if(int(collectionNode.get_children()[i].name)!=get_tree().get_network_unique_id()):
					var name=collectionNode.get_children()[i].name	
					if(name!="Dummy"):
						updatePos(name,delta)			
				i=i+1

func _process(delta):	
	if(start && !started):
		started=true		
		rpc_id(1,"initBegin",speed,characterNodeName,collectionNodeName,tickrate,targetPosition)
		
	if(OS.get_ticks_msec()-lastFrame>tickrate):
		lastFrame=OS.get_ticks_msec()
		if(get_tree().is_network_server()):	
			var i=0

			var peers=get_tree().get_network_connected_peers()			
			while i < peers.size():		
				if(peers[i]!=ServerNetwork.SERVER_ID):			
					var y=0								
					while y < collectionNode.get_children().size():											
						var a:Spatial
						a=collectionNode.get_children()[y]
						rpc_unreliable_id(peers[i],"update_puppets",a.global_transform.origin,Quat(a.global_transform.basis),a.name)
						y=y+1							
				i=i+1
		if(!get_tree().is_network_server() && running):
			process_movement()

func updatePos(playerID: String, delta):
	if(running):
		
		var node
		node=collectionNode.get_node(str(playerID))
		
		if(!node.is_class("ClientsidePredictionDummy")):
			return
		if(node.posExtrapolated!=null):
			
			if(node!=null):

				var lastPos=node.posLast
				var currentPos:Vector3=node.global_transform.origin
				var networkPos=node.posNetworkTargeted			
				var lastUpdate:float=node.lastUpdate

				var newPos
				
				if(currentPos.distance_to(node.posExtrapolated)<clamping):
					node.posExtrapolated=currentPos		

				if(node.posExtrapolated.distance_to(currentPos)!=0.0):
					var newSpeed=(speed*10.0)/node.posExtrapolated.distance_to(currentPos)
					var deltaPos=node.posExtrapolated-currentPos
					
					newPos=(currentPos+(newSpeed*deltaPos)*delta)
				else:
					newPos=node.posExtrapolated
					
				node.global_transform.basis=Basis(Quat(node.global_transform.basis).slerp(node.lastRotation,0.25))
				node.global_transform.origin=newPos
				


puppet func update_puppets(networkPosition,newRotation,id: String):

		if(running):
			if(collectionNode.get_node_or_null(str(id))==null):
				return
			if(!collectionNode.get_node(str(id)).is_class("ClientsidePredictionDummy")):
				return
			if(collectionNode.get_node(str(id))!=null && !isMaster):
				if(collectionNode.get_node(str(id)).lastUpdate==0):
					collectionNode.get_node(str(id)).lastUpdate=OS.get_ticks_msec()
					
				if(!useKeyFrames):
					collectionNode.get_node(str(id)).posExtrapolated=networkPosition+((networkPosition-collectionNode.get_node(str(id)).posLast))
				else:
					if(collectionNode.get_node(str(id)).AnimationTreeName!=null && collectionNode.get_node(str(id)).AnimationTreeName!=""):
						collectionNode.get_node(str(id)).posExtrapolated=networkPosition+((networkPosition-collectionNode.get_node(str(id)).posLast))
										
				collectionNode.get_node(str(id)).posNetworkTargeted=networkPosition
				collectionNode.get_node(str(id)).lastUpdate=OS.get_ticks_msec()
				collectionNode.get_node(str(id)).lastRotation=newRotation		
				collectionNode.get_node(str(id)).posLast=collectionNode.get_node(str(id)).global_transform.origin
	
func process_movement():
	if(modeIsCharacterSync):
		rpc_unreliable_id(ServerNetwork.SERVER_ID,"network_update1", characterNode.global_transform.origin,get_tree().get_network_unique_id(),Quat(get_node("/root").find_node(rotator,true,false).global_transform.basis))
	else:
		rpc_unreliable_id(ServerNetwork.SERVER_ID,"network_update1", targetPosition,get_tree().get_network_unique_id(),Quat(get_node("/root").find_node(collectionNodeName,true,false).get_node(str(get_tree().get_network_unique_id())).global_transform.basis))
			
master func network_update1(pos: Vector3,id: int, rotation: Quat):	
	if(!get_node("/root").find_node(collectionNodeName,true,false).get_node(str(id)).is_class("ClientsidePredictionDummy")):
		return
	get_node("/root").find_node(collectionNodeName,true,false).get_node(str(id)).global_transform.origin=pos
	if(modeIsCharacterSync):
		get_node("/root").find_node(collectionNodeName,true,false).get_node(str(id)).global_transform.basis=Basis(rotation)
