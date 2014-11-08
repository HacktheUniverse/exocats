class window.Actor
  @geometry: new THREE.BoxGeometry(1, 1, 0)
  @textures: []
  @loadTextures: ->
    for i in [1..7]
      @textures.push(THREE.ImageUtils.loadTexture("img/cats/actual-cat-0000#{i}.png"))

  @texture: -> @textures[parseInt(Math.random() * @textures.length, 10)]

  constructor: (system) ->
    material = new THREE.MeshLambertMaterial(
      map: Actor.texture()
      color: 0x00FFFF
      transparent: true
      overdraw: true
    )

    @mesh = new THREE.Mesh(Actor.geometry, material)

    x = Math.random() * 6 - 3
    y = Math.random() * 6 - 3
    z = -system.distance

    @mesh.position.x = x
    @mesh.position.y = y
    @mesh.position.z = z

    console.log(
      "Setting at"
      x
      y
      z
    )

    @mesh.userData = system

    @mesh.callback = @callback

  userData: -> @mesh.userData

  callback: =>
    $info = $('#info')
    $info.find('.name').text(@userData().name)
    $info.find('.description').text(@userData().description)
    $info.find('.distance').text(@userData().distance)
    $info.show()

    window.s.remove(Actor.sphere)
    geo = new THREE.SphereGeometry(0.5, 10, 10)
    material = new THREE.MeshBasicMaterial(
      color: 0x00FFF0
    )
    mesh = new THREE.Mesh(geo, material)
    p = @mesh.position
    mesh.position.set(p.x, p.y, p.z)
    window.s.add(mesh)
    Actor.sphere = mesh


  @loadTextures()
