@tool
extends EditorScript

func _run() -> void:
	# ---- config ----
	var region_side: float = 160.0         # side length of the square we cover, centred on the node
	var grid_step: float = 2.0             # distance between candidate points, in units
	var brightness_cutoff: float = 0.40    # place only where the mask pixel is this bright or brighter (0 = black, 1 = white) we're saying anything above 0.60 is valid
	var max_slope_degrees: float = 5.0     # reject ground steeper than this
	var jitter_units: float = 0.8          #random offset per point, in units (so the trees are clumped up more randomly and realistically)
	var scale_min: float = 0.4             # smallest mesh scale
	var scale_max: float = 0.6             # largest mesh scale
	var y_offset: float = -0.25            # sink the mesh into the ground by this much at scale 1.0
	# -----------------

	var selection: Array = EditorInterface.get_selection().get_selected_nodes()
	if selection.is_empty():
		print("Select a MultiMeshInstance3D.")
		return
	var mmi: MultiMeshInstance3D = selection[0] as MultiMeshInstance3D
	if mmi == null or mmi.multimesh == null:
		print("Select a MultiMeshInstance3D with a MultiMesh.")
		return
	var mesh: Mesh = mmi.multimesh.mesh


	var tex: NoiseTexture2D = load("res://Test/SceneryNoise.tres")
	var img: Image = tex.get_image()
	if img == null:
		print("Texture image not found.")
		return
	var img_w: int = img.get_width()
	var img_h: int = img.get_height()

	var space: PhysicsDirectSpaceState3D = mmi.get_world_3d().direct_space_state

	var to_local: Transform3D = mmi.global_transform.affine_inverse()

	var region_centre: Vector3 = mmi.global_position
	var half_side: float = region_side * 0.5

	var xforms: Array[Transform3D] = []

	var x: float = -half_side
	while x <= half_side:
		var z: float = -half_side
		while z <= half_side:
			var jx: float = x + randf_range(-jitter_units, jitter_units)
			var jz: float = z + randf_range(-jitter_units, jitter_units)

			var px: int = clampi(int((jx + half_side) / region_side * img_w), 0, img_w - 1)
			var pz: int = clampi(int((jz + half_side) / region_side * img_h), 0, img_h - 1) #actually on y, not z

			var brightness: float = img.get_pixel(px, pz).r

			#if brightness <= brightness_cutoff:
			if brightness <=  0.55 and brightness >= 0.45:
				var from: Vector3 = region_centre + Vector3(jx, 500.0, jz)
				var to: Vector3 = from + Vector3.DOWN * 1000.0
				var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)


				# right click intersect_ray -> Lookup Symbol for what's in this dict;
				# we went position and normal
				var hit: Dictionary = space.intersect_ray(query)

				if not hit.is_empty():
					var hit_pos: Vector3 = hit.position
					var hit_normal: Vector3 = hit.normal

					# flat enough ??
					if hit_normal.dot(Vector3.UP) >= cos(deg_to_rad(max_slope_degrees)):
						var s: float = randf_range(scale_min, scale_max)
						var basis: Basis = Basis().rotated(Vector3.UP, randf() * TAU).scaled(Vector3.ONE * s)
						var world_xform: Transform3D = Transform3D(basis, hit_pos + Vector3.UP * y_offset * s)
						xforms.append(to_local * world_xform)

			z += grid_step
		x += grid_step



# rebuild the MultiMesh from the scratch with the transforms we collected
	var mm: MultiMesh = MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh
	mm.instance_count = xforms.size()
	for i in xforms.size():
		mm.set_instance_transform(i, xforms[i])
	mmi.multimesh = mm

	print("Placed %d" % xforms.size())
