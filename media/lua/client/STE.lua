--#################################
--####		MOD BY ACTIC		###
--#################################


require "XpSystem/ISUI/ISSkillProgressBar"
require "XpSystem/ISUI/ISCharacterScreen"

-- Skills
local STEskills = {
	fitness = {
		id = "Fitness",
		type = "Passive"
	},
	strength = {
		id = "Strength",
		type = "Passive"
	},
	mod_scavenging = {
		id = "Scavenging",
		type = "Passive"
	},
	sprinting = {
		id = "Sprinting",
		type = "Agility"
	},
	lightfooted = {
		id = "Lightfoot",
		type = "Agility"
	},
	nimble = {
		id = "Nimble",
		type = "Agility"
	},
	sneaking = {
		id = "Sneak",
		type = "Agility"
	},
	combat = {
		-- One description for all weapon types, as their respective skills affect them in generally the same way
		id = "Axe/Blunt/SmallBlunt/LongBlade/SmallBlade/Spear",
		type = "Combat"
	},
	maintenance = {
		id = "Maintenance",
		type = "Combat"
	},
	carpentry = {
		id = "Woodwork",
		type = "Crafting"
	},
	cooking = {
		id = "Cooking",
		type = "Crafting"
	},
	farming = {
		id = "Farming",
		type = "Crafting"
	},
	firstaid = {
		id = "Doctor",
		type = "Crafting"
	},
	electrical =  {
		id = "Electricity",
		type = "Crafting"
	},
	metalworking = {
		id = "MetalWelding",
		type = "Crafting"
	},
	mechanics = {
		id = "Mechanics",
		type = "Crafting"
	},
	tailoring = {
		id = "Tailoring",
		type = "Crafting"
	},
	aiming = {
		id = "Aiming",
		type = "Firearm"
	},
	reloading = {
		id = "Reloading",
		type = "Firearm"
	},
	fishing = {
		id = "Fishing",
		type = "Survivalist"
	},
	trapping = {
		id = "Trapping",
		type = "Survivalist"
	},
	foraging = {
		id = "PlantScavenging",
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
	for skill, attributes in pairs(STEskills) do
		if string.find(attributes.id, self.perk:getId()) then
			self.message = self.message .. " <LINE> <LINE> " .. getText("Tooltip_STE_" .. skill .. "_desc")
			self.message = self.message .. " <LINE> <LINE> " .. getText("Tooltip_STE_" .. skill .. "_prog") .. " <LINE> "
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