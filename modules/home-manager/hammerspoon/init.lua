local PaperWM = hs.loadSpoon("PaperWM")

hs.window.animationDuration = 0.03

PaperWM.window_gap = 8
PaperWM.window_ratios = { 0.25, 1 / 3, 0.5, 2 / 3, 0.75 }
PaperWM.default_width = 2 / 3
PaperWM.swipe_fingers = 3
PaperWM.swipe_gain = 4.0

local modifiers = function(additional)
	return hs.fnutils.concat({ "alt" }, additional)
end

PaperWM:bindHotkeys({
	-- switch to a new focused window in tiled grid
	focus_left = { modifiers({}), "h" },
	focus_right = { modifiers({}), "l" },
	focus_up = { modifiers({}), "k" },
	focus_down = { modifiers({}), "j" },

	-- move windows around in tiled grid
	swap_left = { modifiers({ "shift" }), "h" },
	swap_right = { modifiers({ "shift" }), "l" },
	swap_up = { modifiers({ "shift" }), "k" },
	swap_down = { modifiers({ "shift" }), "j" },

	-- position and resize focused window
	center_window = { modifiers({}), "c" },
	full_width = { modifiers({}), "w" },
	cycle_width = { modifiers({}), "r" },
	reverse_cycle_width = { modifiers({ "shift" }), "r" },
	cycle_height = { modifiers({ "ctrl" }), "r" },
	reverse_cycle_height = { modifiers({ "ctrl", "shift" }), "r" },

	-- increase/decrease width
	increase_width = { modifiers({}), "]" },
	decrease_width = { modifiers({}), "[" },

	-- move focused window into / out of a column
	slurp_in = { modifiers({}), "i" },
	barf_out = { modifiers({}), "o" },

	-- split screen focused window with left window
	split_screen = { modifiers({}), "s" },

	-- move the focused window into / out of the tiling layer
	toggle_floating = { modifiers({}), "f" },
	-- raise all floating windows on top of tiled windows
	focus_floating = { modifiers({ "ctrl" }), "f" },

	-- focus the first / second / etc window in the current space
	focus_window_1 = { modifiers({}), "1" },
	focus_window_2 = { modifiers({}), "2" },
	focus_window_3 = { modifiers({}), "3" },
	focus_window_4 = { modifiers({}), "4" },
	focus_window_5 = { modifiers({}), "5" },
	focus_window_6 = { modifiers({}), "6" },
	focus_window_7 = { modifiers({}), "7" },
	focus_window_8 = { modifiers({}), "8" },
	focus_window_9 = { modifiers({}), "9" },
	focus_window_last = { modifiers({}), "0" },

	-- switch to a new Mission Control space
	switch_space_l = { modifiers({ "ctrl" }), "h" },
	switch_space_r = { modifiers({ "ctrl" }), "l" },
	switch_space_1 = { modifiers({ "ctrl" }), "1" },
	switch_space_2 = { modifiers({ "ctrl" }), "2" },
	switch_space_3 = { modifiers({ "ctrl" }), "3" },
	switch_space_4 = { modifiers({ "ctrl" }), "4" },
	switch_space_5 = { modifiers({ "ctrl" }), "5" },
	switch_space_6 = { modifiers({ "ctrl" }), "6" },
	switch_space_7 = { modifiers({ "ctrl" }), "7" },
	switch_space_8 = { modifiers({ "ctrl" }), "8" },
	switch_space_9 = { modifiers({ "ctrl" }), "9" },

	-- move focused window to a new space and tile
	move_window_l = { modifiers({ "ctrl", "shift" }), "h" },
	move_window_r = { modifiers({ "ctrl", "shift" }), "l" },
	move_window_d = { modifiers({ "ctrl", "shift" }), "j" },
	move_window_u = { modifiers({ "ctrl", "shift" }), "k" },
	move_window_1 = { modifiers({ "ctrl", "shift" }), "1" },
	move_window_2 = { modifiers({ "ctrl", "shift" }), "2" },
	move_window_3 = { modifiers({ "ctrl", "shift" }), "3" },
	move_window_4 = { modifiers({ "ctrl", "shift" }), "4" },
	move_window_5 = { modifiers({ "ctrl", "shift" }), "5" },
	move_window_6 = { modifiers({ "ctrl", "shift" }), "6" },
	move_window_7 = { modifiers({ "ctrl", "shift" }), "7" },
	move_window_8 = { modifiers({ "ctrl", "shift" }), "8" },
	move_window_9 = { modifiers({ "ctrl", "shift" }), "9" },
})

PaperWM:start()
