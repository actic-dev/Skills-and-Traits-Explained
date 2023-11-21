--***********************************************************
--**                    ROBERT JOHNSON                     **
--** A bar wich display square for each lvl of a skill (you need one for each skills) **
--***********************************************************

require "ISUI/ISPanel"

ISSkillProgressBar = ISPanel:derive("ISSkillProgressBar");

ISSkillProgressBar.alpha = 0.0;
ISSkillProgressBar.upAlpha = true;

-- MOD BEGIN --

-- Skills
local CSDskills = {
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

-- MOD END --

function ISSkillProgressBar:initialise()
	ISPanel.initialise(self);
end

function ISSkillProgressBar:render()
	self:renderPerkRect();
	if self.message ~= nil then
		if self.tooltip == nil then
			self.tooltip = ISToolTip:new();
			self.tooltip:initialise();
			self.tooltip:addToUIManager();
			self.tooltip:setOwner(self)
		end
		self.tooltip.description = self.message;
	end
end

-- when you click on an available skill
function ISSkillProgressBar:onMouseUp(x, y)
	-- our selected lvl
	local lvlSelected = math.floor(self:getMouseX()/20);
	-- if you have skill pts and the skill is ready to evolve and if you clicked on the right lvl
	if self.xp >= self.xpForLvl and self.level == lvlSelected and not self.perk:isPassiv() then
		self.char:LevelPerk(self.perk:getType());
		-- recalcul some stats
		-- our current perk lvl
		self.level = self.char:getPerkLevel(self.perk:getType());
		-- how much xp we need for the next lvl
		self.xpForLvl = ISSkillProgressBar.getXpForLvl(self.perk, self.level);
		-- reset the tooltip
		self.message = nil;
		if self.tooltip ~= nil then
			self.tooltip:setVisible(false);
			self.tooltip:removeFromUIManager();
			self.tooltip = nil;
		end
	end
end

function ISSkillProgressBar:updateTooltip(lvlSelected)
	-- we display the correct message
	self.message = self.perk:getName() .. xpSystemText.lvl .. lvlSelected + 1;
	-- first if the lvl is unlocked


	-- MOD BEGIN --

	-- Show basic description of what the skill does
	for k, v in pairs(CSDskills) do
		if string.find(v.name, self.perk:getName()) then
			self.message = self.message .. " <LINE> <LINE> " .. v.desc
			self.message = self.message .. " <LINE> " .. v.prog .. " <LINE> "
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

function ISSkillProgressBar:onMouseMove(dx, dy)
	if not self:isMouseOver() then -- handle other windows in front
		self:onMouseMoveOutside(dx, dy)
		return
	end
	-- display the tooltip
	-- first we get the square the mouse is on
	local lvlSelected = math.floor(self:getMouseX()/20);
	if lvlSelected > 9 then
		return;
	end
	self:updateTooltip(lvlSelected)
end

function ISSkillProgressBar:onMouseMoveOutside(dx, dy)
	self.message = nil;
	if self.tooltip ~= nil then
		self.tooltip:setVisible(false);
		self.tooltip:removeFromUIManager();
		self.tooltip = nil;
	end
end

function ISSkillProgressBar:activate()
end

function ISSkillProgressBar:renderPerkRect()
	local x = 0;
	local y = 0;

	-- perks level up automatically, update the UI
	if self.level ~= self.char:getPerkLevel(self.perk:getType()) then
		self.level = self.char:getPerkLevel(self.perk:getType())
		self.xpForLvl = ISSkillProgressBar.getXpForLvl(self.perk, self.level)
		self.parent.lastLeveledUpPerk = self.perk
		self.parent.lastLevelUpTime = 1
	end
	
	-- how much xp we already aquire for this perk
	self.xp = ISSkillProgressBar.getPerkXp(self);

	if self.xp > self.xpForLvl then
		self.xp = self.xpForLvl;
	end

	-- we start to render our first rect : all the lvl we already got, we render them in a simple white rect
	-- ex : if we're lvl 3, we gonna render 2 (lvl 1 and 2) white rect
	for i=0,self.level - 1 do
--~ 		self:drawRect(x, y, 19, 19, 1.0, 1.0, 1.0, 1.0);
		if self.parent.lastLeveledUpPerk == self.perk then
			--this fades over time to return to the original colour
			self:drawTexture(self.UnlockedSkill, x, y, 1,1-self.parent.lastLevelUpTime,1,1-self.parent.lastLevelUpTime);
		else
			self:drawTexture(self.UnlockedSkill, x, y, 1,1,1,1);
		end
		x = x + 20;
	end
	-- the most important square : the one in progress !
	-- for this one we got multiple choice :
	-- * In progress : light grey rect filled with light grey depending on the progress
	-- * In faster progress : if you read a book 'bout this skill or if a npc trained you, it's a light blue/filled with light blue too
	-- * Finished but no skills pts available : a white rect full filled with light grey
	-- * Finished and ready to take : a white rect that glow filled with light grey
	if self.level < 10 then
		-- we gonna fill with light grey our rect, depending on the progress of our lvl (50% xp mean a rect filled at 50%)
		-- this width correspond to 1% xp progress
		local sliceWidth = 18 / 100;
		-- our progress into the current lvl in %
		local percentProgress = (self.xp / self.xpForLvl) * 100;
		if percentProgress < 0 then percentProgress = 0 end
		-- we now draw our rect with the correct width
		-- our border, a bit darker than the filled rect or if the skill is rdy to unlock it's a white border
		if percentProgress == 100 then
			if self.perk:isPassiv() then
				self:drawTexture(self.UnlockedSkill, x, y, 1,1,1,1);
			else -- the skill is ready to be trained but no skill pts available, we set up just a white border
					self:drawTexture(self.ProgressSkill, x, y, 1,1,1,1);
				self:drawTexture(self.SkillBtnEmptWhitey, x, y, 1,1,1,1);
			end
		else -- skill is in progress, we set up a grey rect and fill it depending on the skill progress
			self:drawTexture(self.SkillBtnEmpty, x, y, 1,1,1,1);
			self:drawTextureScaled(self.ProgressSkill, x, y, sliceWidth * percentProgress, 18, 1,1,1,1);
		end
		x = x + 20;
	end

	-- our last square : the no available ones, this is just an empty dark grey rect
	for i=self.level + 1, 9 do
--~ 		self:drawRect(x, y, 19, 19, 0.5, 0.41, 0.41, 0.41);
		self:drawTexture(self.SkillBtnEmpty, x, y, 1,1,1,1);
		x = x + 20;
	end
end

function ISSkillProgressBar.updateAlpha()
	if ISSkillProgressBar.upAlpha then
		ISSkillProgressBar.alpha = ISSkillProgressBar.alpha + 0.1 * (30 / getPerformance():getUIRenderFPS());
		if ISSkillProgressBar.alpha > 1.0 then
			ISSkillProgressBar.alpha = 1.0;
			ISSkillProgressBar.upAlpha = false;
		end
	else
		ISSkillProgressBar.alpha = ISSkillProgressBar.alpha - 0.1 * (30 / getPerformance():getUIRenderFPS());
		if ISSkillProgressBar.alpha < 0 then
			ISSkillProgressBar.alpha = 0;
			ISSkillProgressBar.upAlpha = true;
		end
	end
end

function ISSkillProgressBar:new (x, y, width, height, playerNum, perk, parent)
	local o = {};
	o = ISPanel:new(x, y, 200, 19);
	setmetatable(o, self);
	self.__index = self;
	o.playerNum = playerNum
	o.char = getSpecificPlayer(playerNum)
	o.perk = perk;
	o.parent = parent;
	o.xp = 0;
	o.message = nil;
	o.tooltip = nil;
	o:noBackground();
	-- our current perk lvl
	o.level = o.char:getPerkLevel(perk:getType());
	-- how much xp we need for the next lvl
	o.xpForLvl = ISSkillProgressBar.getXpForLvl(perk, o.level);
	o.UnlockedSkill = getTexture("media/ui/XpSystemUI/UnlockedSkill.png")
	o.AddSkillBtn = getTexture("media/ui/XpSystemUI/AddSkillBtn.png")
	o.SkillBtnEmptyBig = getTexture("media/ui/XpSystemUI/SkillBtnEmptyBig.png")
	o.ProgressSkill = getTexture("media/ui/XpSystemUI/ProgressSkill.png")
	o.SkillBtnEmpty = getTexture("media/ui/XpSystemUI/SkillBtnEmpty.png")
	o.SkillBtnEmptWhitey = getTexture("media/ui/XpSystemUI/SkillBtnEmptWhitey.png")
	return o;
end

ISSkillProgressBar.getXpForLvl = function(perk, level)
	return perk:getXpForLevel(level + 1)
end

ISSkillProgressBar.getPreviousXpLvl = function(perk, level)
	if level == 0 then
		return 0;
	end
	level = level - 1;
	local previousXp = perk:getXp1();
	if level >= 1 then
		previousXp = previousXp + perk:getXp2();
	end
	if level >= 2 then
		previousXp = previousXp + perk:getXp3();
	end
	if level >= 3 then
		previousXp = previousXp + perk:getXp4();
	end
	if level >= 4 then
		previousXp = previousXp + perk:getXp5();
    end
    if level >= 5 then
        previousXp = previousXp + perk:getXp6();
    end
    if level >= 6 then
        previousXp = previousXp + perk:getXp7();
    end
    if level >= 7 then
        previousXp = previousXp + perk:getXp8();
    end
    if level >= 8 then
        previousXp = previousXp + perk:getXp9();
    end
    if level >= 9 then
        previousXp = previousXp + perk:getXp10();
    end
	return previousXp;
end

ISSkillProgressBar.getPerkXp = function(self)
	return self.char:getXp():getXP(self.perk:getType()) - ISSkillProgressBar.getPreviousXpLvl(self.perk, self.level);
end
