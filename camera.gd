extends Camera3D

@export var mouse_sensitivity: float = 0.1 # Degrees per pixel

# Use more descriptive names: pitch for up/down, yaw for left/right
var yaw: float = 0.0   # Rotation around Y-axis (left/right)
var pitch: float = 0.0 # Rotation around X-axis (up/down)

# Define the limits for looking up and down (in degrees)
@export var min_pitch: float = -90.0
@export var max_pitch: float = 90.0

func _ready() -> void:
	# Capture the mouse cursor so it doesn't leave the window and movement is tracked
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called when any input event occurs.
func _input(event: InputEvent) -> void:
	# Check if the event is mouse motion
	if event is InputEventMouseMotion:
		# Calculate rotation based on mouse movement
		# Subtracting relative.y makes mouse movement upwards look up (decrease pitch angle in Godot's convention)
		# Subtracting relative.x makes mouse movement rightwards look right (decrease yaw angle in Godot's convention)
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity

		# Clamp the pitch to prevent looking too far up or down
		pitch = clamp(pitch, min_pitch, max_pitch)

		# Apply the rotation
		# IMPORTANT: Godot's rotation order is YXZ.
		# We set rotation_degrees directly. X component controls pitch, Y component controls yaw.
		# We don't typically rotate around Z (roll) for this kind of camera.
		self.rotation_degrees = Vector3(pitch, yaw, 0)

# Use _unhandled_input for things like pausing or UI interactions
# that shouldn't happen if the event was already handled (e.g., by GUI).
func _unhandled_input(event: InputEvent) -> void:
	# Check if the Escape key was pressed to release the mouse cursor
	if event.is_action_pressed("ui_cancel"): # "ui_cancel" is usually mapped to Escape by default
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Optional: You might want to pause the game here or open a menu

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Not strictly needed for this specific mouse look logic, but often used for movement.
func _process(delta: float) -> void:
	pass

	# Example: If the mouse is visible, don't process further input until re-captured
	# You might want to add logic here or in _input to only rotate if mouse is captured:
	# if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
	#     # process mouse look
	# else:
	#     # don't process mouse look
	# (The current _input function already handles this implicitly because
	# relative mouse motion events only fire reliably when captured)

	# If you need to re-capture the mouse, you could do it on a click:
	# if Input.is_action_just_pressed("ui_accept") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
	#    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
