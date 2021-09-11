::mods_hookNewObject("retinue/retinue_manager.nut", function(o)
{
    o.upgradeInventory = function()
    {
        ++this.m.InventoryUpgrades;
        this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 54);
    }
})