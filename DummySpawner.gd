
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

#WARNING!!!! Delete this node on clients. It should ONLY be existing on the server.


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	pass # Replace with function body.
	
func _process(delta):
	pass


#==== DummySpawner.gd====
#	Note: 	This script should be attached to a seperate node on the server only.


#----func remote_spawn_dummy(var idNode:String, var pos:Vector3, var rota:Quat,var _AnimationTreeName):----
#	idNode: Unique ID of the character instance per player
#	pos:				Start position
#	rota:				Start rotation
#	_AnimationTreeName:	Name of the AnimationTree (can be "" when not using Animation Trees

func remote_spawn_dummy(var idNode:String, var pos:Vector3, var rota:Quat,var _AnimationTreeName, var _collectionName):

	if(get_node("/root").find_node(_collectionName,true,false).get_node("DummyCollection").get_node_or_null(idNode)==null):
		var node=get_node("/root").find_node(_collectionName,true,false).get_node("DummyCollection").get_node("Dummy").duplicate()	
		node.show()
		node.name=str(idNode)
		get_node("/root").find_node(_collectionName,true,false).get_node("DummyCollection").add_child(node)		
		node.lastRotation=rota
		node.posLast=pos
		node.posNetworkTargeted=pos
		node.posExtrapolated=pos
		node.AnimationTreeName=_AnimationTreeName		

		get_node("/root").find_node(_collectionName,true,false).get_node("DummyCollection").get_node("Dummy").rpc("spawn_dummy_client",idNode,1,pos,rota, _AnimationTreeName)





# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
