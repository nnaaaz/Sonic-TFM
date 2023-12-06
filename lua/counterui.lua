local ids = pshy.require("pshy.utils.ids")

local function create(options)
    if type(options) ~= "table" then
        error("counterui: options must be a table")
    end

    local pointsTextAreaId = ids.AllocTextAreaId()
    local shadowTextAreaId = ids.AllocTextAreaId()

    local imageX, imageY = options.imageX or 0, options.imageY or 40
    local textX, textY = options.x or 50, options.y or 40
    local template = options.text or "<b>%s"
    local shadow = options.shadow
    local shadowOffset = options.shadowOffset or 1
    local image = options.image
    local imageIds = {}
    local width = options.width

    options = nil

    local function remove(name)
        ui.removeTextArea(shadowTextAreaId, name)
        ui.removeTextArea(pointsTextAreaId, name)

        if imageIds[name] then
            tfm.exec.removeImage(imageIds[name])
        end
    end

    local function add(name)
        remove(name)

        if shadow then
            ui.addTextArea(
                shadowTextAreaId,
                shadow:format(0),
                name,
                textX + shadowOffset, textY + shadowOffset,
                width, nil,
                0, 0, 0,
                true
            )
        end

        ui.addTextArea(
            pointsTextAreaId,
            template:format(0),
            name,
            textX, textY,
            width, nil,
            0, 0, 0,
            true
        )

        if image then
            imageIds[name] = tfm.exec.addImage(
                image,
                "~99",
                imageX, imageY,
                name
            )
        end
    end

    local function update(name, points)
        if shadow then
            ui.updateTextArea(
                shadowTextAreaId,
                shadow:format(points),
                name
            )
        end

        ui.updateTextArea(
            pointsTextAreaId,
            template:format(points),
            name
        )
    end

    return {
        add = add,
        remove = remove,
        update = update,
    }
end

return {
    create = create,
}
