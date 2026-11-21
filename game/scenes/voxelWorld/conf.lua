local Conf = {
    presentation = { navigation = false, menuKey = 'tab', menuButton = true },
    cameraButtons = false,
    voxels = {
        seed = 1337,
        viewDistance = 6, -- chunks around the player that are drawn
        maxGenerating = 6, -- terrain requests in flight at once
        maxMeshing = 6, -- mesh requests in flight at once
        meshesPerFrame = 3, -- finished meshes uploaded per frame (keeps frames short)
    },
    player = {
        walkSpeed = 4.3,
        sprintSpeed = 6.5,
        flySpeed = 11,
        flySprintSpeed = 22,
        jumpSpeed = 9,
        gravity = 32,
        reach = 6,
        eyeHeight = 1.62,
        sensitivity = 0.15,
        fov = 75,
    },
}

return Conf
