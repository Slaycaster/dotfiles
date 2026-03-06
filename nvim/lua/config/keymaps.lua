local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better paste (don't lose register)
map("x", "<leader>p", [["_dP]], { desc = "Paste without losing register" })

-- LazyVim-style search/grep keybindings
map("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
map("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>sr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
map("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
map("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Grep Word" })

-- Also keep the f-prefixed ones
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })

-- Save
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("i", "<C-s>", "<esc><cmd>w<cr>a", { desc = "Save" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
