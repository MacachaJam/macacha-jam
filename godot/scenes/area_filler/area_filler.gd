# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool
class_name AreaFiller
extends Node
## Fills a CollisionObject3D with child scenes, spaced randomly with a minimum
## separation.
##
## This can be used with [StaticBody3D] to create a forest at the boundary of
## the map which the player cannot walk through, or with [Area3D] to create a
## patch of wild flowers.
## [br][br]
## Create this node as a child of a [StaticBody3D] or [Area3D] (or another
## [CollisionObject3D]). Define the collisions shapes with
## [CollisionPolygon3D]. Assign at least one scene to [member
## scenes], adjust other parameters to taste, then click [b]Refill[/b] in the
## inspector to fill the area with a new random arrangement of instances of
## [member scenes]. These children are saved to the owning scene: no random
## generation occurs at runtime.

## Scenes that will be randomly placed into [member area]. There is an equal
## probability of each scene being used each time. This list must not be
## empty.
@export var scenes: Array[PackedScene] = []:
	set(new_value):
		scenes = new_value
		update_configuration_warnings()

## If non-empty, each placed scene will have a randomly-selected element of this
## list assigned to its [code]sprite_frames[/code] property.
@export var sprite_frames: Array[SpriteFrames] = []

## Minimum separation between placed scenes. The maximum separation is twice
## this value.
@export_range(.1, 10.0, .1, "suffix:m", "or_more") var minimum_separation: float = 1

@export_range(.01, 2.0, .01, "or_more") var escala_mínima: float = 1
@export_range(.01, 2.0, .01, "or_more") var escala_máxima: float = 1


@warning_ignore("unused_private_class_variable")
@export_tool_button("Refill") var _fill_button: Callable = fill

var _area: CollisionObject3D
var _undoredo: Object  # EditorUndoRedoManager


func _enter_tree() -> void:
	var parent := get_parent()
	if parent is CollisionObject3D:
		_area = parent
	update_configuration_warnings()


func _exit_tree() -> void:
	_area = null
	update_configuration_warnings()


func _ready() -> void:
	if not Engine.is_editor_hint():
		self.queue_free()
		return

	var plugin: Node = ClassDB.instantiate("EditorPlugin")
	_undoredo = plugin.get_undo_redo()
	plugin.queue_free()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray

	if not _area:
		warnings.append("Parent is not a CollisionObject3D (e.g. Area2D or StaticBody2D)")

	if not scenes:
		warnings.append("At least one scene must be provided")

	return warnings


# Merges [param polygon] into [param merged], combining with any polygons it
# overlaps. Returns the updated set of disjoint polygons.
#
# TODO: Holes in merged results (rare for convex inputs) are not handled.
func _merge_into(
	polygon: PackedVector2Array, merged: Array[PackedVector2Array]
) -> Array[PackedVector2Array]:
	var current := polygon
	var result: Array[PackedVector2Array] = []
	for existing in merged:
		var union: Array[PackedVector2Array] = Geometry2D.merge_polygons(existing, current)
		if union.size() == 1:
			# Polygons overlapped; continue merging the combined shape
			current = union[0]
		else:
			# Disjoint; keep existing polygon unchanged
			result.append(existing)
	result.append(current)
	return result


func transform3d_to_transform2d_topdown(t3d: Transform3D) -> Transform2D:
	var t2d = Transform2D()

	# Map 3D X to 2D X (discarding 3D Z component)
	t2d.x = Vector2(t3d.basis.x.x, t3d.basis.x.y)
	
	# Map 3D Y to 2D Y (discarding 3D Z component)
	t2d.y = Vector2(t3d.basis.y.x, t3d.basis.y.y)
	
	# Map 3D Position to 2D Position
	t2d.origin = Vector2(t3d.origin.x, t3d.origin.y)
	
	return t2d

## Generate random points that fill the shapes of [param area], at least
## [param minimum_separation] px apart.
func _generate_points() -> PackedVector2Array:
	var points: PackedVector2Array

	# Collect polygons from all shape owners, converting as needed.
	# If the polygon has a transform we have to apply it here so that
	# minimum_separation is interpreted in the parent's coordinate space.
	var polygons: Array[PackedVector2Array] = []
	var transforms: Dictionary[CollisionPolygon3D, Transform3D]
	for owner_id: int in _area.get_shape_owners():
		var o := _area.shape_owner_get_owner(owner_id)
		var polygon: PackedVector2Array
		if o is CollisionPolygon3D:
			transforms[o as CollisionPolygon3D] = o.transform
			o.rotate_x(-PI/2)
			var t2d := transform3d_to_transform2d_topdown(o.transform)
			polygon = t2d * o.polygon
		else:
			push_warning("%s not supported" % o)
			continue
		polygons.append(polygon)

	# Merge overlapping polygons so that overlap regions are not over-sampled.
	var merged: Array[PackedVector2Array] = []
	for polygon in polygons:
		merged = _merge_into(polygon, merged)

	# Sample each disjoint polygon region.
	for polygon in merged:
		var sampler := PoissonDiscSampler.new()
		sampler.initialise(polygon, minimum_separation)
		sampler.fill()
		points.append_array(sampler.points)

	for o in transforms:
		o.transform = transforms[o]

	return points


func _prepare_child(pos: Vector2) -> Node3D:
	var scene: PackedScene = scenes.pick_random()
	var child: Node3D = scene.instantiate(PackedScene.GenEditState.GEN_EDIT_STATE_INSTANCE)
	child.position = Vector3(pos.x, 0, pos.y)
	if escala_mínima != 1 or escala_máxima != 1:
		var nueva_escala := randf_range(escala_mínima, escala_máxima)
		child.scale.x = nueva_escala
		child.scale.y = nueva_escala
		child.scale.z = nueva_escala
	if sprite_frames and "sprite_frames" in child:
		child.sprite_frames = sprite_frames.pick_random()
	return child


## Clears [member area] (except for this node and any collision shapes),
## generate a new set of points according to the current
## parameters, and fill [member area] with instances of [member scenes]
## at those points.
func fill() -> void:
	var scene := get_tree().edited_scene_root

	_undoredo.create_action("Refill area", UndoRedo.MergeMode.MERGE_DISABLE, scene, false)

	var old_children: Array[Node]
	var new_children: Array[Node]

	for child: Node in _area.get_children():
		if child != self and child is not CollisionPolygon3D:
			old_children.append(child)

	var points := _generate_points()
	for point in points:
		new_children.append(_prepare_child(point))

	# When performing the action in either direction, we want to remove, then add.
	for child in old_children:
		_undoredo.add_do_method(_area, "remove_child", child)

	for child in new_children:
		_undoredo.add_do_method(_area, "add_child", child, true)
		_undoredo.add_do_property(child, "owner", scene)
		_undoredo.add_undo_method(_area, "remove_child", child)

	for child in old_children:
		_undoredo.add_undo_method(_area, "add_child", child, true)
		_undoredo.add_undo_property(child, "owner", scene)

	_undoredo.commit_action()
