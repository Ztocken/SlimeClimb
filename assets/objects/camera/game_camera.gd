extends Camera2D

class_name GameCamera

@export var shakeIntensity: float = 1
@export var shakeDuration: float = 1

var _startTime = 0
var _random = RandomNumberGenerator.new()
var _shouldCalculateShake: bool = false

var tileMap: TileMap

func _ready():
	randomize()
	
func _process(delta):
	if _shouldCalculateShake:
		_calculateShake()

#calculates the camera shake time 
#and sets the x and y offset to random number
func _calculateShake():
	var decreaser = (shakeDuration - (Time.get_ticks_msec() - _startTime)) / shakeDuration
	#calculate the random x and y offset
	var randX = _random.randf_range(-1, 1) * shakeIntensity * decreaser
	var randY = _random.randf_range(-1, 1) * shakeIntensity * decreaser
	print(decreaser)
	offset = Vector2(randX, randY)
	if decreaser < 0:
		#reset back to normal
		offset = Vector2.ZERO
		#disable calculation after done
		_shouldCalculateShake = false

#emit shake
func shake(intensity = 1, duration = 1):
	shakeIntensity = intensity
	shakeDuration = (duration * 1000)
	_startTime = Time.get_ticks_msec()
	_shouldCalculateShake = true

