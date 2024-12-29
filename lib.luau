local process = require("@lune/process")
local Result = require("./lune_packages/Result")

local function execute(
	program: string,
	params: { string }?,
	options: process.SpawnOptions?
): Result.Result<process.SpawnResult, process.SpawnResult>
	local result = process.spawn(program, params, options)
	if result.ok then
		return Result.Ok(result)
	else
		return Result.Err(result)
	end
end

local function stdout(result: process.SpawnResult): string
	return result.stdout:gsub("\r\n$", "")
end

local function nothing(): nil
	return nil
end

local function read(): Result.Result<string, process.SpawnResult>
	if process.os == "linux" then
		return execute("xclip", { "-selection", "clipboard", " -o" }):map(stdout)
	elseif process.os == "macos" then
		return execute("pbpaste"):map(stdout)
	elseif process.os == "windows" then
		return execute("Get-Clipboard", nil, { shell = true }):map(stdout)
	end

	error("unreachable")
end

local function write(text: string): Result.Result<nil, process.SpawnResult>
	if process.os == "linux" then
		return execute("xclip", { "-selection", "clipboard" }, { stdin = text }):map(nothing)
	elseif process.os == "macos" then
		return execute("pbcopy", nil, { stdin = text }):map(nothing)
	elseif process.os == "windows" then
		return execute("Set-Clipboard", nil, { shell = true, stdin = text }):map(nothing)
	end

	error("unreachable")
end

return {
	read = read,
	write = write,
}
