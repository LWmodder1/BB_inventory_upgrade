::mods_registerMod("mod_inventory_upgrade", 1.0, "Better Inventory Upgrade");
::mods_queue("mod_inventory_upgrade", ">mod_stronghold", function()
{
    local gt = this.getroottable();
    gt.Const.World.InventoryUpgradeGain <- 54;
    gt.Const.World.InventoryUpgradeCosts = [
      10000,
      20000,
      40000
    ];
    gt.Const.Strings.InventoryUpgradeCosts = [
        "10,000",
        "20,000",
        "40,000"
    ];

    ::mods_hookNewObject("retinue/retinue_manager.nut", function(o)
    {
        o.upgradeInventory = function()
        {
            ++this.m.InventoryUpgrades;
            this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + this.Const.World.InventoryUpgradeGain);
        }
    });
    
    ::mods_hookNewObject("ui/screens/world/modules/world_campfire_screen/campfire_main_dialog_module", function(o)
    {
	local oldFunction = ::mods_getMember(o, "onCartClicked");
        o.onCartClicked = function()
        {
	    local isBuyUpgrade = false;
            if (this.World.Retinue.getInventoryUpgrades() < this.Const.World.InventoryUpgradeCosts.len())
            {
		isBuyUpgrade = true;
                if (this.World.Assets.getMoney() >= this.Const.World.InventoryUpgradeCosts[this.World.Retinue.getInventoryUpgrades()])
                {
                    this.showDialogPopup(this.Const.Strings.InventoryUpgradeHeader[this.World.Retinue.getInventoryUpgrades()], "You can choose to " + this.Const.Strings.InventoryUpgradeText[this.World.Retinue.getInventoryUpgrades()] + " in order to gain " + this.Const.World.InventoryUpgradeGain + " more inventory slots for the cost of " + this.Const.Strings.InventoryUpgradeCosts[this.World.Retinue.getInventoryUpgrades()] + " crowns. Is this what you want to do?", this.onUpgradeInventorySpace.bindenv(this), null);
                }
                else
                {
                    this.showDialogPopup(this.Const.Strings.InventoryUpgradeHeader[this.World.Retinue.getInventoryUpgrades()], "Sadly, you can not afford the " + this.Const.Strings.InventoryUpgradeCosts[this.World.Retinue.getInventoryUpgrades()] + " crowns necessary to " + this.Const.Strings.InventoryUpgradeText[this.World.Retinue.getInventoryUpgrades()] + " and gain more inventory space at this time.", null, null, true);
                }
            }
		
	    if (!isBuyUpgrade && ::mods_getRegisteredMod("mod_stronghold") != null) oldFunction();
	}
    });
})
