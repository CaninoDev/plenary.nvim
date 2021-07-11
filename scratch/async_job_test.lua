local uv = vim.loop

local async = R "plenary.async"
local async_job = R "plenary.async_job"
local OneshotLines = R "plenary.async_job.oneshot_lines"

local bufnr = 7
Append = function(...)
  local text = table.concat({...}, "  ")
  if not text then return end

  async.api.nvim_buf_set_lines(bufnr, -1, -1, false, { text })
end

vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

async.void(function()
  local start = uv.hrtime()

  local pipe = OneshotLines:new()
  async_job.AsyncJob.start { "rg", "--files", "/home/tjdevries/", stdout = pipe }
  -- async_job.AsyncJob.start { "./scratch/ajob/line_things.sh", stdout = pipe }

  local text = 0
  for val in pipe:iter() do
    text = text + #val
  end

  async.util.scheduler()
  print("Time Elapsed:", (uv.hrtime() - start) / 1e9, " // Total lines processed:", text)
end)()
