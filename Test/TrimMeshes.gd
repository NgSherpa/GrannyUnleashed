@tool
extends EditorScript


const MAX_LEAN: float = 5.0


func _run() -> void:
	var selection: Array = EditorInterface.get_selection().get_selected_nodes()
	#checking if the MultiMesh exists
	if selection.is_empty():
		print("Select a MultiMeshInstance3D.")
		return
	var mmi: MultiMeshInstance3D = selection[0] as MultiMeshInstance3D
	if mmi == null or mmi.multimesh == null:
		print("Select a MultiMeshInstance3D with a MultiMesh.")
		return



	#we can't remove instances from a MultiMesh one by one, so we read the old one,
	# collect the keepers, and build a fresh MultiMesh at the end
	var old_mm: MultiMesh = mmi.multimesh
	var kept: Array[Transform3D] = []

	for i in old_mm.instance_count:
		var t: Transform3D = old_mm.get_instance_transform(i)
		var up: Vector3 = t.basis.y.normalized()

		# dot of two unit vectors = cos (angle between them) so acos gives us the
		# angle back. clampf guards against float error pushing it past +/-1, which
		#would make acos return to NAN. Then convert radians to degrees to compare.
		# 0 degrees = perfectly upright, 90 =  lying on its side, 180 = upside down

		var lean: float = rad_to_deg(acos(clampf(up.dot(Vector3.UP), -1.0, 1.0)))

		if lean <= MAX_LEAN:
			kept.append(t)


#build the replacement. Note we resuse old_mm.mesh - we're only changing WHICH instances exist, not what they look like
	var new_mm: MultiMesh = MultiMesh.new()
	new_mm.transform_format = MultiMesh.TRANSFORM_3D
	new_mm.mesh = old_mm.mesh
	new_mm.instance_count = kept.size()
	for j in kept.size():
		new_mm.set_instance_transform(j, kept[j])

#swap it in. This is final !! the old transforms are gone, so if you get the #MAX_LEAN wrong you have to repopulate and try again


	mmi.multimesh = new_mm
	print("Kept %d / %d instances." % [kept.size(), old_mm.instance_count])
