--#################################
--####		MOD BY ACTIC		###
--#################################


require "XpSystem/ISUI/ISSkillProgressBar"
require "XpSystem/ISUI/ISCharacterScreen"
require "STEskills"

-- mod options support
local SETTINGS = {
  options = { 
    showSkillLevelStats = true,
  },
  names = {
    showSkillLevelStats = getText("IGUI_STE_showSkillLevelStats"),
  },
  mod_id = "AT_SkillsTraitsExplained",
  mod_shortname = "Skills and Traits Explained"
}

-- Mod Settings - Connecting the options to the menu, so user can change and save them.
if ModOptions and ModOptions.getInstance then
	ModOptions:getInstance(SETTINGS)
end


-- override vanilla function
function ISSkillProgressBar:updateTooltip(lvlSelected)
	-- we display the correct message
	self.message = self.perk:getName()
	-- first if the lvl is unlocked

	-- MOD BEGIN --

	STEskill = self.perk:getId()
	Translation_Id = STEskill

	-- Check, if there is a parent set - if yes, use the parent's data
	if STEskills[STEskill].parent then 
		Translation_Id = STEskills[STEskill].parent 
	end

	-- Show basic description of what the skill does
	if getText("Tooltip_STE_" .. Translation_Id .. "_desc") then
		self.message = self.message .. " <LINE> <LINE> " .. getText("Tooltip_STE_" .. Translation_Id .. "_desc")
		self.message = self.message .. " <LINE> <LINE> " .. getText("Tooltip_STE_" .. Translation_Id .. "_prog")
	end

	self.message = self.message .. " <LINE> <LINE> " .. xpSystemText.lvl .. lvlSelected + 1 .. " - "

	-- MOD END --


	if lvlSelected < self.level then
		self.message = self.message .. xpSystemText.unlocked;
	-- if we selected the level wich is in progress, we display the xp we already got / xp needed for lvl
	elseif self.level == lvlSelected then
		self.message = self.message .. getText("IGUI_XP_tooltipxp", round(self.xp, 2), self.xpForLvl);
		-- if we got a multiplier, we show it
		local multiplier = self.char:getXp():getMultiplier(self.perk:getType());
		if multiplier > 0 then
			self.message = self.message .. " <LINE> " .. getText("IGUI_skills_Multiplier", round(multiplier, 2));
		end
	else
		self.message = self.message .. xpSystemText.locked;
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


	if SETTINGS.options.showSkillLevelStats then
		if type(STEskills[STEskill].levelstats) == "table" then
			for stat, statlvls in pairs(STEskills[STEskill].levelstats) do
				self.message = self.message .. " <LINE> " .. getText("Tooltip_STE_levelstats_" .. stat) .. ": " .. statlvls[lvlSelected + 1]
			end
		end
	end
	-- MOD END --

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