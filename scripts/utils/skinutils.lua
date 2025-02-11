return {
    GetSkins = function()
        return TheInventory:GetUnopenedItems()
    end,

    SetItemOpened = function(id)
        TheInventory:SetItemOpened(id)
    end
}
