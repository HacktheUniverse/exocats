class window.Actor
  @geometry: new THREE.BoxGeometry(1, 1, 0.01)
  @textures: []
  @planet: null
  @loadTextures: ->
    for i in [1..9]
      @textures.push(THREE.ImageUtils.loadTexture("img/cats/actual-cat-0000#{i}.png"))

    for i in [10..26]
      @textures.push(THREE.ImageUtils.loadTexture("img/cats/actual-cat-000#{i}.png"))

    geo = new THREE.SphereGeometry(0.6, 20, 20)
    material = new THREE.MeshLambertMaterial(
      map: THREE.ImageUtils.loadTexture("img/planet-texture.png")
      color: 0xFFFFFF
    )
    @planet = new THREE.Mesh(geo, material)

  @texture: -> @textures[parseInt(Math.random() * @textures.length, 10)]

  constructor: (system) ->
    material = new THREE.MeshPhongMaterial(
      map: Actor.texture()
      color: 0xFFFFFF
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

    @mesh.userData = system

    @mesh.callback = @callback

  userData: -> @mesh.userData

  callback: =>
    $info = $('#info')
    $info.find('.name').text(@userData().name)
    $info.find('.description').text(@userData().description)
    $info.find('.distance').text(@userData().distance)
    $info.slideDown("fast")

    p = @mesh.position
    Actor.planet.position.set(p.x, p.y, p.z)
    window.s.remove(Actor.planet)
    window.s.add(Actor.planet)

  @loadTextures()
