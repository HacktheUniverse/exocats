#= require ./scene

$.getJSON("/js/cleaned.json").success((data) -> window.json_data = data; load())

PI2 = Math.PI * 2
particleMaterial = new THREE.SpriteMaterial(
  color: 0x00FF00
  program: (context) ->
    context.beginPath()
    context.arc( 0, 0, 1, 0, PI2)
    context.fill()
)


detectClick = (event) ->
  event.preventDefault()

  console.log(
    (event.clientX / window.innerWidth) * 2 - 1
    - (event.clientY / window.innerHeight) * 2 + 1
    event.clientX
    event.clientY
    window.innerWidth
    window.innerHeight
    $('#scene').css('width')
    $('#scene').css('height')
  )

  vector = new THREE.Vector3()
  vector.set(
    (event.clientX / window.innerWidth) * 2 - 1
    - (event.clientY / window.innerHeight) * 2 + 1
    0.5
  )
  vector.unproject(window.camera)

  raycaster = new THREE.Raycaster()
  raycaster.ray.set(
    window.camera.position
    vector.sub(window.camera.position).normalize()
  )

  intersects = raycaster.intersectObjects(window.objects)

  if intersects.length > 0
    intersect = intersects[0]
    intersect.object.callback()

load = ->
  scene = new Scene()
  window.camera = scene.getCamera()
  window.s = scene.getScene()
  window.objects = scene.getActors()
  $('canvas').on('click', detectClick)

  $range = $('input[type="range"]')
  $range.on 'change', ->
    val = parseInt($range.val(), 10)
    camera.position.z = (8 - (val / 10))

  camera.position.set(1,1,8)
  camera.lookAt(s.position)

$('.close').on('click', ->
  $('#info').hide('slow')
  window.s.remove(Actor.planet)
)
