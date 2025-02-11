local SkinsUtils = require(CHEATS_ENABLED and "utils/skinutils_debug" or "utils/skinutils")
local Button = require "widgets/button"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local GiftItemToast = Class(Widget, function(self)
    Widget._ctor(self, "Fox")

    self.root = self:AddChild(Widget("ROOT"))
    self.root:SetScale(.4)
    self.root:SetPosition(0, 500)

    self.anim = self.root:AddChild(UIAnim())
    self.anim:GetAnimState():SetBuild("skingift_popup")
    self.anim:GetAnimState():SetBank("gift_popup")
    self.anim:GetAnimState():AnimateWhilePaused(true)

    self.title = self.root:AddChild(Text(UIFONT, 45))
    self.title:SetPosition(0, 172)
    self.title:SetString(STRINGS.UI.ITEM_SCREEN.RECEIVED)

    self.banner = self.root:AddChild(Image("images/giftpopup.xml", "banner.tex"))
    self.banner:SetPosition(0, -200, 0)
    self.banner:SetScale(0.8)
    self.name_text = self.banner:AddChild(Text(UIFONT, 60))
    self.name_text:SetHAlign(ANCHOR_MIDDLE)
    self.name_text:SetPosition(0, -10, 0)

    self:StartUpdating()
end)

function GiftItemToast:ShowSkin(item, id)
    self.opening = true

    self.root:CancelMoveTo()
    self.root:MoveTo(self.root:GetPosition(), Vector3(0, 0, 0), .5)

    self.name_text:SetTruncatedString(GetSkinName(item), 500, 35, true)
    self.name_text:SetColour(GetColorForItem(item))

    self.anim:GetAnimState():OverrideSkinSymbol("SWAP_ICON", GetBuildForItem(item), "SWAP_ICON")
    self.anim:GetAnimState():PlayAnimation("open")
    self.anim:GetAnimState():SetTime(.65 * self.anim:GetAnimState():GetCurrentAnimationLength())
    self.anim:GetAnimState():PushAnimation("skin_loop")
    self.anim:GetAnimState():PushAnimation("skin_out", false)

    local function AnimDone()
        if not self.anim:GetAnimState():AnimDone() then
            return
        end

        self.opening = nil

        self.root:CancelMoveTo()
        self.root:MoveTo(self.root:GetPosition(), Vector3(0, 500, 0), .5)

        if id then
            SkinsUtils.SetItemOpened(id)
        end
        self.anim.inst:RemoveEventCallback("animover", AnimDone)
    end

    self.anim.inst:ListenForEvent("animover", AnimDone)
end

function GiftItemToast:OnUpdate(dt)
    local item = SkinsUtils.GetSkins()[1]
    if item and not self.opening then
        self:ShowSkin(item.item_type, item.item_id)
    end
end

local p = function(...)
    return false
end

GiftItemToast.CheckControl = p
GiftItemToast.ToggleController = p
GiftItemToast.ToggleHUDFocus = p
GiftItemToast.ToggleCrafting = p

return GiftItemToast
