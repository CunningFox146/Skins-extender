return {
    GetSkins = function()
        return mods.open_skins.debug_skins_queue
    end,

    SetItemOpened = function(id)
        table.remove(mods.open_skins.debug_skins_queue, #mods.open_skins.debug_skins_queue)
    end
}
