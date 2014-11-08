#= require ./actor

class window.Scene
  actors: []

  constructor: ->
    $parent = $('#scene')
    width = parseInt($parent.css('width'), 10)
    height = parseInt($parent.css('height'), 10)
    width = window.innerWidth
    height = window.innerHeight

    @scene  = new THREE.Scene()
    @camera = new THREE.PerspectiveCamera(
      750
      width / height
      0.1
      1000
    )

    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize(width, height)
    $parent.prepend(@renderer.domElement)

    @addActors()
    @addBackground()

    pointLight = new THREE.PointLight(0xFFFFFF)
    pointLight.position.set(0, 3, 0)
    @scene.add(pointLight)

    axes = new THREE.AxisHelper(-1)
    @scene.add(axes)

    @camera.position.set(0, 0, 1)

    controls = new THREE.OrbitControls(@camera, @renderer.domElement)
    @scene.add(controls)
    @render()

  addBackground: =>
    texture = THREE.ImageUtils.loadTexture('img/bg.jpg')
    backgroundMesh = new THREE.Mesh(
        new THREE.PlaneBufferGeometry(2, 2, 0),
        new THREE.MeshBasicMaterial({
            map: texture
        }))

    backgroundMesh.material.depthTest = false
    backgroundMesh.material.depthWrite = false

    @backgroundScene = new THREE.Scene()
    @backgroundCamera = new THREE.Camera()
    @backgroundScene .add(@backgroundCamera )
    @backgroundScene .add(backgroundMesh )

  addActors: (geometry, material) ->
    for system in json_data[0...40]

      actor = new Actor(system.system)

      @actors.push(actor.mesh)
      @scene.add(actor.mesh)

  getCamera: -> @camera
  getScene: -> @scene
  getActors: -> @actors


  render: =>
    requestAnimationFrame(@render)

    @renderer.autoClear = false
    @renderer.clear()
    @renderer.render(@backgroundScene, @backgroundCamera)
    @renderer.render(@scene, @camera)
