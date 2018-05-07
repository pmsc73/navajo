-- skilltree.lua

local skillTreeSkillInit = false
local SKILLS = {}

local SkillTreeSkill = {


	--[[
	   - @param name:string - name of skill from the skill database
	   - @param cost:int - AP cost of the skill
	   - @param level_req:int - level required to purchase skill
	   - @param child:string - name of SkillTree which is unlocked upon attaining skill
	   - 
	   - Constructor for SkillTreeSkill objects
	  ]]	
	new = function(name, cost, level_req, child)
		local s = {}
		s.name = name
		s.cost = cost
		s.level_req = level_req
		s.child = child

		return s
	end,
}
function SkillTreeSkill.get(name)
	if skillTreeSkillInit ~= true then
		-- SKILL_TREE_SKILL_INIT happens here because encapsulating this
		-- behaviour outside of this scope is currently a little difficult

		table.insert(SKILLS, 
			SkillTreeSkill.new("Skill 1", 1, 1, nil))
		table.insert(SKILLS, 
			SkillTreeSkill.new("Skill 2", 1, 1, nil))
		table.insert(SKILLS, 
			SkillTreeSkill.new("Skill 3", 1, 1, 
				SkillTreeSkill.new("Skill 3.1", 1, 1, nil)))
		table.insert(SKILLS, 
			SkillTreeSkill.new("Skill 4", 1, 1, 
				SkillTreeSkill.new("Skill 4.1", 1, 1, 
					SkillTreeSkill.new("Skill 4.1.1", 1, 1, nil))))

		skillTreeSkillInit = true
	end

	local s = {}
	for _, skill in pairs(SKILLS) do
		if skill.name == name then
			return skill
		end
	end
	return SkillTreeSkill.new("ERROR", 1,1, SkillTreeSkill.new("ERROR!", 1,1, nil))
end


SkillTree = {

	


	--[[ SkillTree.new
	   - @param name:string - name of skill tree
	   - @param children:SkillTreeSkill[] - collection of SkillTreeSkills in this tree
	   -
	   - Constructor for SkillTree objects
	  ]]
	new = function(name, children)
		local st = {}
		st.name = name
		st.children = {}

		--[[ SkillTree.populate
		   - @param st:SkillTree - SkillTree to be populated
		   - @param children:SkillTreeSkill[] - list of skills to populate st with
		  ]]
		st.populate = function(children) 
			for _, child in pairs(children) do
				local skill = SkillTreeSkill.get(child.name)
				if skill.child == nil then 
					table.insert(st.children, skill)
				else 
					table.insert(st.children, {[""..skill.name] = skill.child})
				end
			end
		end

		--[[ skilltree.to_string
           - 
           - 
		  ]]
		st.to_string = function() 
			local st_string = ""
			for _, child in pairs(st.children) do 
				if SkillTreeSkill.get(child.name).child ~= nil then
					st_string = st_string .. "\n" .. SkillTreeSkill.get(child.name).child.to_string()
				else
					st_string = st_string .. child.name .. "\n"
				end
			end
			return st_string
		end

		--[[ skilltree.display
           -
           - Print out a readable display of the skill tree [debug]
           - Show the navigatible display for the UI [~debug]
		  ]]
		st.display = function(x, y)
			display_string = st.to_string()
			gfx.print(display_string, x, y)
		end

		st.populate(children)
		return st
	end,
}