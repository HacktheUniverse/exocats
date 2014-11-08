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

    #texture = THREE.ImageUtils.loadTexture("img/test-cat-1.png")

    @addActors()

    @addBackground()

    @scene.fog = new THREE.FogExp2( 0x9999ff, 0.00025 )

    @camera.position.set(0, 0, 1)

    light = new THREE.AmbientLight(0xFFFFFF)
    @scene.add(light)

    directionalLight = new THREE.DirectionalLight(0xffffff, 0.5)
    directionalLight.position.set(0, 1, 0)
    @scene.add(directionalLight)

    axes = new THREE.AxisHelper(5)
    @scene.add(axes)

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
    for system in json_data[0...30]

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
