--#################################
--####		MOD BY ACTIC		###
--#################################


require "XpSystem/ISUI/ISSkillProgressBar"
require "XpSystem/ISUI/ISCharacterScreen"

-- Skills
local STEskills = {
	fitness = {
		name = "Fitness",
		desc = "Increases endurance and attack speed",
		prog = "Progress by sprinting, melee attacks and doing Fitness Exercises",
		type = "Passive"
	},
	strength = {
		name = "Strength",
		desc = "Increases carry capacity and the chance to knock down zombies",
		prog = "Progress by doing Strength Exercises, carrrying heavy things and running",
		type = "Passive"
	},
	sprinting = {
		name = "Sprinting",
		desc = "Increases running and sprinting speed",
		prog = "Progress by by running and sprinting",
		type = "Agility"
	},
	lightfooted = {
		name = "Lightfooted",
		desc = "Reduces the sound of your footsteps",
		prog = "Progress by sneaking near zombies without being detected",
		type = "Agility"
	},
	nimble = {
		name = "Nimble",
		desc = "Increases movement speed in Combat Stance and reduces footstep sounds",
		prog = "Progress by walking in Combat Stance",
		type = "Agility"
	},
	sneaking = {
		name = "Sneaking",
		desc = "Decreases your footstep sounds and detection chance while sneaking",
		prog = "Progress by sneaking near zombies without being detected",
		type = "Agility"
	},
	combat = {
		-- One description for all weapon types, as their respective skills affect them in generally the same way
		name = "Axe/Long Blunt/Short Blunt/Long Blade/Short Blade/Spear",
		desc = "Increases attack speed, damage and crit chance",
		prog = "Progress by attacking zombies",
		type = "Combat"
	},
	maintenance = {
		name = "Maintenance",
		desc = "Reduces the chance for a melee weapon to lose condition per use",
		prog = "Progress by hitting enemies with melee weapons.",
		type = "Combat"
	},
	carpentry = {
		name = "Carpentry",
		desc = "Unlocks building options and increases overall effectiveness of repairing, building and barricading",
		prog = "Progress by barricading, crafting items from planks, dismantling furniture and sawing logs",
		type = "Crafting"
	},
	cooking = {
		name = "Cooking",
		desc = "Increases effectiveness of crafted food and chance to detect poison <LINE> Level 7: Safely use rotten ingredients in soups an stews",
		prog = "Progress by cooking or crafting food",
		type = "Crafting"
	},
	farming = {
		name = "Farming",
		desc = "Progressively increases the detail of information when checking a crop's status",
		prog = "Progress by harvesting crops",
		type = "Crafting"
	},
	firstaid = {
		name = "First Aid",
		desc = "Wounds heal faster and cause less pain and movement penalty, perform medical actions faster, bandages last longer, more accurately determine severity of wounds <LINE> Level 3: Determine the severity of wounds",
		prog = "Progress by performing medical actions",
		type = "Crafting"
	},
	electrical =  {
		name = "Electrical",
		desc = "Increases the ability to repair generators and create devices, reduces chance of setting off car alarms while hot wiring <LINE> Level 1: hot wire vehicles (req. 2 Mechanics) <LINE> Level 5: Change lights to be battery powered",
		prog = "Progress by repairing generators, dismantling electronics and crafting makeshift electronics",
		type = "Crafting"
	},
	metalworking = {
		name = "Metalworking",
		desc = "Unlocks building options and increases durability of metal barricades. Can be helpful to repair certain parts of vehicles",
		prog = "Progress by building and dismantling metal constructions and barricades",
		type = "Crafting"
	},
	tailoring = {
		name = "Tailoring",
		desc = "Gain the ability to patch and fortify clothing, which becomes progressively more effective <LINE> Higher levels: fully repair clothing, patch holes to their original state",
		prog = "Progress by repairing and fortifying clothing",
		type = "Crafting"
	},
	aiming = {
		name = "Aiming",
		desc = "Improves (movement) accuracy, crit change, range and firing angle of firearms. Reduces the chance for a firearm to lose condition on hit",
		prog = "Progress by successfully hitting enemies with a firearm",
		type = "Firearm"
	},
	reloading = {
		name = "Reloading",
		desc = "Decreases the time it takes to reload",
		prog = "Progress by unloading and repacking magazines and inserting them into any firearm",
		type = "Firearm"
	},
	fishing = {
		name = "Fishing",
		desc = "Increases proficiency in fishing - more frequent catches and bigger fish",
		prog = "Progress by fishing with a fishing rod or a spear. Catching a fish is not a requirement, but increases XP",
		type = "Survivalist"
	},
	trapping = {
		name = "Trapping",
		desc = "Improves chance of catching animals in a trap and gives the ability to make new traps",
		prog = "Progress by retrieving caught animals",
		type = "Survivalist"
	},
	foraging = {
		name = "Foraging",
		desc = "Increases radius and chance of finding items in Search mode. With each level you can find new items",
		prog = "Progress by finding items in Search Mode",
		type = "Survivalist"
	}
}


-- override vanilla function
function ISSkillProgressBar:updateTooltip(lvlSelected)
	-- we display the correct message
	self.message = self.perk:getName() .. xpSystemText.lvl .. lvlSelected + 1;
	-- first if the lvl is unlocked


	-- MOD BEGIN --

	-- Show basic description of what the skill does
	for k, v in pairs(STEskills) do
		if string.find(v.name, self.perk:getName()) then
			self.message = self.message .. " <LINE> <LINE> " .. v.desc
			self.message = self.message .. " <LINE> <LINE> " .. v.prog .. " <LINE> "
		end
	end

	-- MOD END --


	if lvlSelected < self.level then
		self.message = self.message .. " <LINE> " .. xpSystemText.unlocked;
	-- if we selected the level wich is in progress, we display the xp we already got / xp needed for lvl
	elseif self.level == lvlSelected then
		self.message = self.message .. " <LINE> " .. getText("IGUI_XP_tooltipxp", round(self.xp, 2), self.xpForLvl);
		-- if we got a multiplier, we show it
		local multiplier = self.char:getXp():getMultiplier(self.perk:getType());
		if multiplier > 0 then
			self.message = self.message .. " <LINE> " .. getText("IGUI_skills_Multiplier", round(multiplier, 2));
		end
	else
		self.message = self.message .. " <LINE> " .. xpSystemText.locked;
    end
    local xpBoost = self.char:getXp():getPerkBoost(self.perk:getType());
    local percentage = nil;
    if xpBoost == 1 then
        percentage = "75%";
    elseif xpBoost == 2 then
        percentage = "100%";
    elseif xpBoost == 3 then
        percentage = "125%";
    end

    if percentage then
        self.message = self.message .. " <LINE> " .. getText("IGUI_XP_tooltipxpboost", percentage);
    end
end


--override vanilla function
ISCharacterScreen.loadTraits = function(self)

	for _,image in ipairs(self.traits) do
		self:removeChild(image)
	end
	table.wipe(self.traits);
	self:setDisplayedTraits()
	for _,trait in ipairs(self.displayedTraits) do
		local textImage = ISImage:new(0, 0, trait:getTexture():getWidthOrig(), trait:getTexture():getHeightOrig(), trait:getTexture());
		textImage:initialise();

		-- MOD BEGIN --

		textImage:setMouseOverText(trait:getLabel() .. " <LINE> " .. trait:getDescription());

		-- MOD END --

		textImage:setVisible(false);
		textImage.trait = trait;
		self:addChild(textImage);
		table.insert(self.traits, textImage);
	end
	self.Strength = self.char:getPerkLevel(Perks.Strength)
	self.Fitness = self.char:getPerkLevel(Perks.Fitness)
end