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

func _ready():
	pass
	
func doSpawn(playerId):
	var target:Vector3=Vector3(100.0,0.0,100.0)
	var lockRotation:Vector3=Vector3(0.0,1.0,1.0)
	get_parent().find_node("DummySpawner",true,false).remote_spawn_dummy(0.4,str(playerId),Vector3(0,0,0),Quat(0.0,0.0,0.0,0.0),"","DummyCollection",lockRotation)	
	get_parent().get_root().get_node("ClientsidePredictionSpawner").initBegin("Player","DummyCollection", 30.0,target,"Camera",5.0,false,false)
	get_parent().find_node("ClientsidePrediction",true,false).initBegin("Player","DummyCollection", 30.0,target,"Camera",5.0,false,false)
	
