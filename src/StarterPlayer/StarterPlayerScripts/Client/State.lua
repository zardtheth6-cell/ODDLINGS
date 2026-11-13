-- Client-side mirror of the server snapshot. Read-only: the server decides everything.
local State = {data = nil}
local ev = Instance.new("BindableEvent")
State.Changed = ev.Event
local Remotes = game.ReplicatedStorage.Remotes
Remotes.Sync.OnClientEvent:Connect(function(snap)
	State.data = snap
	State.receivedAt = os.time()
	State.offset = (snap.serverTime or os.time()) - os.time()
	ev:Fire(snap)
end)
function State.Now() return os.time() + (State.offset or 0) end
function State.Request(action, a, b)
	local ok, res = pcall(Remotes.Request.InvokeServer, Remotes.Request, action, a, b)
	if not ok then return {ok = false, msg = "Connection error"} end
	return res or {ok = false}
end
return State
