-- task.lua

-- Task construction object
Task = {

	--[[ Task.new 
	   - @param goal:double - numerical value at which task is completed or leveled
       - @param oncomplete:() - function to be called on completion of task
       - @param goalScale:double - scaling value for subsequent levels of goal
       - @param rewardScale:double - scaling value for subsequent rewards of goal
       -
       - Constructor for Task objects
	  ]]
	new = function(goal, oncomplete, goalScale, rewardScale) 
		local t = {}
		t.level = 0
		t.goal = goal
		t.current = 0
		t.oncomplete = function()
			t.level = t.level + 1
			oncomplete()
		end
		t.goalScale = goalScale
		t.rewardScale = rewardScale

		--[[ task.update
		   - @param delta - change in task associated variable 
		   -
		   - Call update when the task needs to be given new information, e.g. kill tasks are
		   - updated when an enemy is killed

		]]
		t.update = function(delta)
			t.current = t.current + delta
			if t.current >= t.goal then
				t.oncomplete()
				if t.goalScale > 0 then
					t.goal = t.goal * t.goalScale
				end
			end
		end

		return t
	end,
}