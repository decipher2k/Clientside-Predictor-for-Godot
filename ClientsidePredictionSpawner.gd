
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
class_name ClientsidePredictionSpawner

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func initBegin(var _characterNode, var _collectionNode,  var _tickrate, _targetPosition,_rotator, _clamping,_useKeyFrames, _useTarget):
#_node("/root").find_node(_collectionNode,true,false).get_parent().rpc_id(peers[i],"_beginCharacterSync3D",_speed,_characterNode,_collectionNode,_tickrate,_targetPosition,_rotator, _clamping,_useKeyFrames,_useTarget)
	get_tree().get_root().find_node(_collectionNode,true,false).get_parent().rpc("_beginCharacterSync3D",_characterNode,_collectionNode,_tickrate,_targetPosition,_rotator, _clamping,_useKeyFrames,_useTarget)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
