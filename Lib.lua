cloneref = cloneref or function(...) return ... end;
cloenfunction = cloenfunction or function(...) return ... end;
hookfunction = hookfunction or function(a,b) return a end;
local getidentity = getidentity or getthreadidentity or getthreadcontext or function() return 8 end;
local setidentity = setidentity or setthreadidentity or setthreadcontext or function() end;

export type Services = {
	UserInputService : UserInputService,
	Players : Players,
	ContentProvider : ContentProvider,
	CoreGui : PlayerGui
};

local NeverZen = {};

NeverZen.Services = {
	UserInputService = cloneref(game:GetService('UserInputService')),
	Players = cloneref(game:GetService('Players')),
	ContentProvider = cloneref(game:GetService('ContentProvider')),
	CoreGui = cloneref(game:FindFirstChild('CoreGui')),
	ContextActionService = cloneref(game:GetService('ContextActionService')),
};

local TextService = cloneref(game:GetService('TextService'));
local TweenService = cloneref(game:GetService('TweenService'));
local CurrentCamera = workspace.CurrentCamera;
local RunService = cloneref(game:GetService('RunService'));

local LocalPlayer : Player = NeverZen.Services.Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

NeverZen.ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end;
NeverZen.Services.CoreGui = (gethui and gethui()) or NeverZen.Services.CoreGui or LocalPlayer.PlayerGui;

NeverZen.MinimumTabSize = 500;

local Services : Services = NeverZen.Services;

local function enumItem(enumType, wanted, fallbacks)
	if not enumType then return nil end;
	local ok, item = pcall(function() return enumType[wanted] end);
	if ok and item ~= nil then return item end;
	if fallbacks then
		for _, name in ipairs(fallbacks) do
			local ok2, alt = pcall(function() return enumType[name] end);
			if ok2 and alt ~= nil then return alt end;
		end
	end
	return nil;
end

local WEIGHT_FALLBACKS = {
	Thin       = { "ExtraLight", "Light", "Regular" },
	ExtraLight = { "Light", "Regular" },
	Light      = { "Regular" },
	Regular    = {},
	Medium     = { "Regular", "SemiBold" },
	SemiBold   = { "Medium", "Bold" },
	Bold       = { "Medium", "Heavy" },
	ExtraBold  = { "Heavy", "Bold", "Medium" },
	Black      = { "Heavy", "ExtraBold", "Bold", "Medium", "Regular" },
	Heavy      = { "ExtraBold", "Bold", "Medium", "Regular" },
};

local WEIGHT_CACHE = {};
NeverZen.ResolveWeight = function(name)
	if WEIGHT_CACHE[name] == nil then
		WEIGHT_CACHE[name] = enumItem(Enum.FontWeight, name, WEIGHT_FALLBACKS[name]);
	end
	return WEIGHT_CACHE[name];
end
local FW = setmetatable({}, { __index = function(_, name) return NeverZen.ResolveWeight(name) end });

local FONT_FALLBACKS = {
	GothamBlack  = { "GothamBold", "GothamMedium", "Gotham", "SourceSansBold", "SourceSans", "Arial" },
	GothamBold   = { "GothamMedium", "Gotham", "SourceSansSemibold", "SourceSans", "Arial" },
	GothamMedium = { "Gotham", "SourceSansSemibold", "SourceSans", "Arial" },
	Gotham       = { "SourceSans", "Arial" },
	Arial        = { "Legacy" },
	Legacy       = { "Arial" },
};

local FONT_CACHE = {};
NeverZen.ResolveFont = function(name)
	if FONT_CACHE[name] == nil then
		FONT_CACHE[name] = enumItem(Enum.Font, name, FONT_FALLBACKS[name]);
	end
	return FONT_CACHE[name];
end
local FONT = setmetatable({}, { __index = function(_, name)
	return NeverZen.ResolveFont(name) or Enum.Font.Arial;
end });

NeverZen.FontWeight = FW;
NeverZen.Font = FONT;

function NeverZen:SafeParent(instance)
	local oldIdentity = getidentity();
	setidentity(8);
	local ok = pcall(function()
		instance.Parent = Services.CoreGui;
	end);
	if not ok then
		local ok2 = pcall(function()
			instance.Parent = LocalPlayer:WaitForChild("PlayerGui");
		end);
		if not ok2 then
			instance.Parent = LocalPlayer.PlayerGui;
		end;
	end;
	setidentity(oldIdentity);
	return instance;
end;

function NeverZen:MousePosition()
	local ok, position = pcall(function()
		return UserInputService:GetMouseLocation();
	end);
	if ok and position then
		return position.X, position.Y;
	end
	return Mouse.X, Mouse.Y;
end

function NeverZen:IsMouseOverFrame(Frame)
	if not Frame or not Frame.Parent then return false end;

	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;
	local x, y = self:MousePosition();

	if x >= AbsPos.X and x <= AbsPos.X + AbsSize.X and y >= AbsPos.Y and y <= AbsPos.Y + AbsSize.Y then
		return true;
	end

	return false;
end;

NeverZen.HoverRegistry = {};

function NeverZen:Hover(frame, onEnter, onLeave)
	if not frame then return nil end;

	local entry = {
		Frame = frame,
		Inside = false,
		OnEnter = onEnter,
		OnLeave = onLeave,
	};

	table.insert(self.HoverRegistry, entry);

	local function sync(inside)
		if entry.Inside == inside then return end;
		entry.Inside = inside;
		if inside then
			if entry.OnEnter then
				pcall(entry.OnEnter);
			end
		else
			if entry.OnLeave then
				pcall(entry.OnLeave);
			end
		end
	end

	entry.Sync = sync;

	frame.MouseEnter:Connect(function()
		if entry.Dead then return end;
		sync(true);
	end);
	frame.MouseLeave:Connect(function()
		if entry.Dead then return end;
		sync(false);
	end);

	return entry;
end

local hoverAccumulated = 0;
local hoverLastMouse = nil;
local hoverIdlePasses = 0;

RunService.Heartbeat:Connect(function(dt)
	hoverAccumulated += dt;
	if hoverAccumulated < 0.12 then return end;
	hoverAccumulated = 0;

	local registry = NeverZen.HoverRegistry;
	if #registry == 0 then return end;

	local mouseX, mouseY = NeverZen:MousePosition();
	local mouse = { X = mouseX, Y = mouseY };

	if hoverLastMouse and math.abs(mouse.X - hoverLastMouse.X) < 1 and math.abs(mouse.Y - hoverLastMouse.Y) < 1 then
		hoverIdlePasses += 1;
		if hoverIdlePasses < 8 then return end;
	else
		hoverIdlePasses = 0;
	end
	hoverLastMouse = mouse;
	hoverIdlePasses = 0;

	for index = #registry, 1, -1 do
		local entry = registry[index];
		local frame = entry.Frame;

		if not frame or not frame.Parent then
			entry.Dead = true;
			table.remove(registry, index);
			continue;
		end

		local ok, inside = pcall(function()
			return NeverZen:IsMouseOverFrame(frame);
		end);

		if ok and inside ~= entry.Inside then
			entry.Sync(inside);
		end
	end
end);

function NeverZen:Hook()
	if hookfunc then
		local hooking = hookfunc or hookfunction or function() end;
		local newcclosure = newcclosure or function() end;
		local getconnections = getconnections or function() return {} end;

		hooking(game:GetService('ContentProvider').PreloadAsync,function()
			return 1;
		end);

		hooking(game:GetService('ContentProvider').Preload,function()
			return 2;
		end);

		hooking(game:GetService('ContentProvider').GetAssetFetchStatus,function()
			return 3;
		end);
	end;
end;

function NeverZen:SinkKey(keycode)
	if typeof(keycode) ~= "EnumItem" then return end;

	local CAS = NeverZen.Services.ContextActionService;
	if not CAS then return end;

	local actionName = "NZ_SINK_" .. tostring(keycode.Name) .. "_" .. tostring(math.random(100000, 999999));

	pcall(function()
		CAS:BindActionAtPriority(actionName, function()
			return Enum.ContextActionResult.Sink;
		end, false, 4000, keycode);
	end);

	task.delay(0.45, function()
		pcall(function()
			CAS:UnbindAction(actionName);
		end);
	end);
end;

function NeverZen:SinkKeys(keycodes)
	if typeof(keycodes) ~= "table" then return end;
	for _, keycode in ipairs(keycodes) do
		NeverZen:SinkKey(keycode);
	end;
end;

function NeverZen:NewInput(frame : Frame , call) : TextButton
	local Bth = Instance.new('TextButton',frame);

	Bth.ZIndex = frame.ZIndex + 10;
	Bth.Size = UDim2.fromScale(1,1);
	Bth.BackgroundTransparency = 1;
	Bth.TextTransparency = 1;
	Bth.Text = "";
	Bth.AutoButtonColor = false;
	Bth.BorderSizePixel = 0;

	if call then
		Bth.MouseButton1Click:Connect(call)
	end

	return Bth;
end;
NeverZen.Lucide = {
	["lucide-accessibility"] = "rbxassetid://10709751939",
	["lucide-activity"] = "rbxassetid://10709752035",
	["lucide-air-vent"] = "rbxassetid://10709752131",
	["lucide-airplay"] = "rbxassetid://10709752254",
	["lucide-alarm-check"] = "rbxassetid://10709752405",
	["lucide-alarm-clock"] = "rbxassetid://10709752630",
	["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
	["lucide-alarm-minus"] = "rbxassetid://10709752732",
	["lucide-alarm-plus"] = "rbxassetid://10709752825",
	["lucide-album"] = "rbxassetid://10709752906",
	["lucide-alert-circle"] = "rbxassetid://10709752996",
	["lucide-alert-octagon"] = "rbxassetid://10709753064",
	["lucide-alert-triangle"] = "rbxassetid://10709753149",
	["lucide-align-center"] = "rbxassetid://10709753570",
	["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
	["lucide-align-center-vertical"] = "rbxassetid://10709753421",
	["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
	["lucide-align-end-vertical"] = "rbxassetid://10709753808",
	["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
	["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
	["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
	["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
	["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
	["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
	["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
	["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
	["lucide-align-justify"] = "rbxassetid://10709759610",
	["lucide-align-left"] = "rbxassetid://10709759764",
	["lucide-align-right"] = "rbxassetid://10709759895",
	["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
	["lucide-align-start-vertical"] = "rbxassetid://10709760244",
	["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
	["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
	["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
	["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
	["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
	["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
	["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
	["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
	["lucide-anchor"] = "rbxassetid://10709761530",
	["lucide-angry"] = "rbxassetid://10709761629",
	["lucide-annoyed"] = "rbxassetid://10709761722",
	["lucide-aperture"] = "rbxassetid://10709761813",
	["lucide-apple"] = "rbxassetid://10709761889",
	["lucide-archive"] = "rbxassetid://10709762233",
	["lucide-archive-restore"] = "rbxassetid://10709762058",
	["lucide-armchair"] = "rbxassetid://10709762327",
	["lucide-arrow-big-down"] = "rbxassetid://10747796644",
	["lucide-arrow-big-left"] = "rbxassetid://10709762574",
	["lucide-arrow-big-right"] = "rbxassetid://10709762727",
	["lucide-arrow-big-up"] = "rbxassetid://10709762879",
	["lucide-arrow-down"] = "rbxassetid://10709767827",
	["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
	["lucide-arrow-down-left"] = "rbxassetid://10709767656",
	["lucide-arrow-down-right"] = "rbxassetid://10709767750",
	["lucide-arrow-left"] = "rbxassetid://10709768114",
	["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
	["lucide-arrow-left-right"] = "rbxassetid://10709768019",
	["lucide-arrow-right"] = "rbxassetid://10709768347",
	["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
	["lucide-arrow-up"] = "rbxassetid://10709768939",
	["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
	["lucide-arrow-up-down"] = "rbxassetid://10709768538",
	["lucide-arrow-up-left"] = "rbxassetid://10709768661",
	["lucide-arrow-up-right"] = "rbxassetid://10709768787",
	["lucide-asterisk"] = "rbxassetid://10709769095",
	["lucide-at-sign"] = "rbxassetid://10709769286",
	["lucide-award"] = "rbxassetid://10709769406",
	["lucide-axe"] = "rbxassetid://10709769508",
	["lucide-axis-3d"] = "rbxassetid://10709769598",
	["lucide-baby"] = "rbxassetid://10709769732",
	["lucide-backpack"] = "rbxassetid://10709769841",
	["lucide-baggage-claim"] = "rbxassetid://10709769935",
	["lucide-banana"] = "rbxassetid://10709770005",
	["lucide-banknote"] = "rbxassetid://10709770178",
	["lucide-bar-chart"] = "rbxassetid://10709773755",
	["lucide-bar-chart-2"] = "rbxassetid://10709770317",
	["lucide-bar-chart-3"] = "rbxassetid://10709770431",
	["lucide-bar-chart-4"] = "rbxassetid://10709770560",
	["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
	["lucide-barcode"] = "rbxassetid://10747360675",
	["lucide-baseline"] = "rbxassetid://10709773863",
	["lucide-bath"] = "rbxassetid://10709773963",
	["lucide-battery"] = "rbxassetid://10709774640",
	["lucide-battery-charging"] = "rbxassetid://10709774068",
	["lucide-battery-full"] = "rbxassetid://10709774206",
	["lucide-battery-low"] = "rbxassetid://10709774370",
	["lucide-battery-medium"] = "rbxassetid://10709774513",
	["lucide-beaker"] = "rbxassetid://10709774756",
	["lucide-bed"] = "rbxassetid://10709775036",
	["lucide-bed-double"] = "rbxassetid://10709774864",
	["lucide-bed-single"] = "rbxassetid://10709774968",
	["lucide-beer"] = "rbxassetid://10709775167",
	["lucide-bell"] = "rbxassetid://10709775704",
	["lucide-bell-minus"] = "rbxassetid://10709775241",
	["lucide-bell-off"] = "rbxassetid://10709775320",
	["lucide-bell-plus"] = "rbxassetid://10709775448",
	["lucide-bell-ring"] = "rbxassetid://10709775560",
	["lucide-bike"] = "rbxassetid://10709775894",
	["lucide-binary"] = "rbxassetid://10709776050",
	["lucide-bitcoin"] = "rbxassetid://10709776126",
	["lucide-bluetooth"] = "rbxassetid://10709776655",
	["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
	["lucide-bluetooth-off"] = "rbxassetid://10709776344",
	["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
	["lucide-bold"] = "rbxassetid://10747813908",
	["lucide-bomb"] = "rbxassetid://10709781460",
	["lucide-bone"] = "rbxassetid://10709781605",
	["lucide-book"] = "rbxassetid://10709781824",
	["lucide-book-open"] = "rbxassetid://10709781717",
	["lucide-bookmark"] = "rbxassetid://10709782154",
	["lucide-bookmark-minus"] = "rbxassetid://10709781919",
	["lucide-bookmark-plus"] = "rbxassetid://10709782044",
	["lucide-bot"] = "rbxassetid://10709782230",
	["lucide-box"] = "rbxassetid://10709782497",
	["lucide-box-select"] = "rbxassetid://10709782342",
	["lucide-boxes"] = "rbxassetid://10709782582",
	["lucide-briefcase"] = "rbxassetid://10709782662",
	["lucide-brush"] = "rbxassetid://10709782758",
	["lucide-bug"] = "rbxassetid://10709782845",
	["lucide-building"] = "rbxassetid://10709783051",
	["lucide-building-2"] = "rbxassetid://10709782939",
	["lucide-bus"] = "rbxassetid://10709783137",
	["lucide-cake"] = "rbxassetid://10709783217",
	["lucide-calculator"] = "rbxassetid://10709783311",
	["lucide-calendar"] = "rbxassetid://10709789505",
	["lucide-calendar-check"] = "rbxassetid://10709783474",
	["lucide-calendar-check-2"] = "rbxassetid://10709783392",
	["lucide-calendar-clock"] = "rbxassetid://10709783577",
	["lucide-calendar-days"] = "rbxassetid://10709783673",
	["lucide-calendar-heart"] = "rbxassetid://10709783835",
	["lucide-calendar-minus"] = "rbxassetid://10709783959",
	["lucide-calendar-off"] = "rbxassetid://10709788784",
	["lucide-calendar-plus"] = "rbxassetid://10709788937",
	["lucide-calendar-range"] = "rbxassetid://10709789053",
	["lucide-calendar-search"] = "rbxassetid://10709789200",
	["lucide-calendar-x"] = "rbxassetid://10709789407",
	["lucide-calendar-x-2"] = "rbxassetid://10709789329",
	["lucide-camera"] = "rbxassetid://10709789686",
	["lucide-camera-off"] = "rbxassetid://10747822677",
	["lucide-car"] = "rbxassetid://10709789810",
	["lucide-carrot"] = "rbxassetid://10709789960",
	["lucide-cast"] = "rbxassetid://10709790097",
	["lucide-charge"] = "rbxassetid://10709790202",
	["lucide-check"] = "rbxassetid://10709790644",
	["lucide-check-circle"] = "rbxassetid://10709790387",
	["lucide-check-circle-2"] = "rbxassetid://10709790298",
	["lucide-check-square"] = "rbxassetid://10709790537",
	["lucide-chef-hat"] = "rbxassetid://10709790757",
	["lucide-cherry"] = "rbxassetid://10709790875",
	["lucide-chevron-down"] = "rbxassetid://10709790948",
	["lucide-chevron-first"] = "rbxassetid://10709791015",
	["lucide-chevron-last"] = "rbxassetid://10709791130",
	["lucide-chevron-left"] = "rbxassetid://10709791281",
	["lucide-chevron-right"] = "rbxassetid://10709791437",
	["lucide-chevron-up"] = "rbxassetid://10709791523",
	["lucide-chevrons-down"] = "rbxassetid://10709796864",
	["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
	["lucide-chevrons-left"] = "rbxassetid://10709797151",
	["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
	["lucide-chevrons-right"] = "rbxassetid://10709797382",
	["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
	["lucide-chevrons-up"] = "rbxassetid://10709797622",
	["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
	["lucide-chrome"] = "rbxassetid://10709797725",
	["lucide-circle"] = "rbxassetid://10709798174",
	["lucide-circle-dot"] = "rbxassetid://10709797837",
	["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
	["lucide-circle-slashed"] = "rbxassetid://10709798100",
	["lucide-citrus"] = "rbxassetid://10709798276",
	["lucide-clapperboard"] = "rbxassetid://10709798350",
	["lucide-clipboard"] = "rbxassetid://10709799288",
	["lucide-clipboard-check"] = "rbxassetid://10709798443",
	["lucide-clipboard-copy"] = "rbxassetid://10709798574",
	["lucide-clipboard-edit"] = "rbxassetid://10709798682",
	["lucide-clipboard-list"] = "rbxassetid://10709798792",
	["lucide-clipboard-signature"] = "rbxassetid://10709798890",
	["lucide-clipboard-type"] = "rbxassetid://10709798999",
	["lucide-clipboard-x"] = "rbxassetid://10709799124",
	["lucide-clock"] = "rbxassetid://10709805144",
	["lucide-clock-1"] = "rbxassetid://10709799535",
	["lucide-clock-10"] = "rbxassetid://10709799718",
	["lucide-clock-11"] = "rbxassetid://10709799818",
	["lucide-clock-12"] = "rbxassetid://10709799962",
	["lucide-clock-2"] = "rbxassetid://10709803876",
	["lucide-clock-3"] = "rbxassetid://10709803989",
	["lucide-clock-4"] = "rbxassetid://10709804164",
	["lucide-clock-5"] = "rbxassetid://10709804291",
	["lucide-clock-6"] = "rbxassetid://10709804435",
	["lucide-clock-7"] = "rbxassetid://10709804599",
	["lucide-clock-8"] = "rbxassetid://10709804784",
	["lucide-clock-9"] = "rbxassetid://10709804996",
	["lucide-cloud"] = "rbxassetid://10709806740",
	["lucide-cloud-cog"] = "rbxassetid://10709805262",
	["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
	["lucide-cloud-fog"] = "rbxassetid://10709805477",
	["lucide-cloud-hail"] = "rbxassetid://10709805596",
	["lucide-cloud-lightning"] = "rbxassetid://10709805727",
	["lucide-cloud-moon"] = "rbxassetid://10709805942",
	["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
	["lucide-cloud-off"] = "rbxassetid://10709806060",
	["lucide-cloud-rain"] = "rbxassetid://10709806277",
	["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
	["lucide-cloud-snow"] = "rbxassetid://10709806374",
	["lucide-cloud-sun"] = "rbxassetid://10709806631",
	["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
	["lucide-cloudy"] = "rbxassetid://10709806859",
	["lucide-clover"] = "rbxassetid://10709806995",
	["lucide-code"] = "rbxassetid://10709810463",
	["lucide-code-2"] = "rbxassetid://10709807111",
	["lucide-codepen"] = "rbxassetid://10709810534",
	["lucide-codesandbox"] = "rbxassetid://10709810676",
	["lucide-coffee"] = "rbxassetid://10709810814",
	["lucide-cog"] = "rbxassetid://10709810948",
	["lucide-coins"] = "rbxassetid://10709811110",
	["lucide-columns"] = "rbxassetid://10709811261",
	["lucide-command"] = "rbxassetid://10709811365",
	["lucide-compass"] = "rbxassetid://10709811445",
	["lucide-component"] = "rbxassetid://10709811595",
	["lucide-concierge-bell"] = "rbxassetid://10709811706",
	["lucide-connection"] = "rbxassetid://10747361219",
	["lucide-contact"] = "rbxassetid://10709811834",
	["lucide-contrast"] = "rbxassetid://10709811939",
	["lucide-cookie"] = "rbxassetid://10709812067",
	["lucide-copy"] = "rbxassetid://10709812159",
	["lucide-copyleft"] = "rbxassetid://10709812251",
	["lucide-copyright"] = "rbxassetid://10709812311",
	["lucide-corner-down-left"] = "rbxassetid://10709812396",
	["lucide-corner-down-right"] = "rbxassetid://10709812485",
	["lucide-corner-left-down"] = "rbxassetid://10709812632",
	["lucide-corner-left-up"] = "rbxassetid://10709812784",
	["lucide-corner-right-down"] = "rbxassetid://10709812939",
	["lucide-corner-right-up"] = "rbxassetid://10709813094",
	["lucide-corner-up-left"] = "rbxassetid://10709813185",
	["lucide-corner-up-right"] = "rbxassetid://10709813281",
	["lucide-cpu"] = "rbxassetid://10709813383",
	["lucide-croissant"] = "rbxassetid://10709818125",
	["lucide-crop"] = "rbxassetid://10709818245",
	["lucide-cross"] = "rbxassetid://10709818399",
	["lucide-crosshair"] = "rbxassetid://10709818534",
	["lucide-crown"] = "rbxassetid://10709818626",
	["lucide-cup-soda"] = "rbxassetid://10709818763",
	["lucide-curly-braces"] = "rbxassetid://10709818847",
	["lucide-currency"] = "rbxassetid://10709818931",
	["lucide-database"] = "rbxassetid://10709818996",
	["lucide-delete"] = "rbxassetid://10709819059",
	["lucide-diamond"] = "rbxassetid://10709819149",
	["lucide-dice-1"] = "rbxassetid://10709819266",
	["lucide-dice-2"] = "rbxassetid://10709819361",
	["lucide-dice-3"] = "rbxassetid://10709819508",
	["lucide-dice-4"] = "rbxassetid://10709819670",
	["lucide-dice-5"] = "rbxassetid://10709819801",
	["lucide-dice-6"] = "rbxassetid://10709819896",
	["lucide-dices"] = "rbxassetid://10723343321",
	["lucide-diff"] = "rbxassetid://10723343416",
	["lucide-disc"] = "rbxassetid://10723343537",
	["lucide-divide"] = "rbxassetid://10723343805",
	["lucide-divide-circle"] = "rbxassetid://10723343636",
	["lucide-divide-square"] = "rbxassetid://10723343737",
	["lucide-dollar-sign"] = "rbxassetid://10723343958",
	["lucide-download"] = "rbxassetid://10723344270",
	["lucide-download-cloud"] = "rbxassetid://10723344088",
	["lucide-droplet"] = "rbxassetid://10723344432",
	["lucide-droplets"] = "rbxassetid://10734883356",
	["lucide-drumstick"] = "rbxassetid://10723344737",
	["lucide-edit"] = "rbxassetid://10734883598",
	["lucide-edit-2"] = "rbxassetid://10723344885",
	["lucide-edit-3"] = "rbxassetid://10723345088",
	["lucide-egg"] = "rbxassetid://10723345518",
	["lucide-egg-fried"] = "rbxassetid://10723345347",
	["lucide-electricity"] = "rbxassetid://10723345749",
	["lucide-electricity-off"] = "rbxassetid://10723345643",
	["lucide-equal"] = "rbxassetid://10723345990",
	["lucide-equal-not"] = "rbxassetid://10723345866",
	["lucide-eraser"] = "rbxassetid://10723346158",
	["lucide-euro"] = "rbxassetid://10723346372",
	["lucide-expand"] = "rbxassetid://10723346553",
	["lucide-external-link"] = "rbxassetid://10723346684",
	["lucide-eye"] = "rbxassetid://10723346959",
	["lucide-eye-off"] = "rbxassetid://10723346871",
	["lucide-factory"] = "rbxassetid://10723347051",
	["lucide-fan"] = "rbxassetid://10723354359",
	["lucide-fast-forward"] = "rbxassetid://10723354521",
	["lucide-feather"] = "rbxassetid://10723354671",
	["lucide-figma"] = "rbxassetid://10723354801",
	["lucide-file"] = "rbxassetid://10723374641",
	["lucide-file-archive"] = "rbxassetid://10723354921",
	["lucide-file-audio"] = "rbxassetid://10723355148",
	["lucide-file-audio-2"] = "rbxassetid://10723355026",
	["lucide-file-axis-3d"] = "rbxassetid://10723355272",
	["lucide-file-badge"] = "rbxassetid://10723355622",
	["lucide-file-badge-2"] = "rbxassetid://10723355451",
	["lucide-file-bar-chart"] = "rbxassetid://10723355887",
	["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
	["lucide-file-box"] = "rbxassetid://10723355989",
	["lucide-file-check"] = "rbxassetid://10723356210",
	["lucide-file-check-2"] = "rbxassetid://10723356100",
	["lucide-file-clock"] = "rbxassetid://10723356329",
	["lucide-file-code"] = "rbxassetid://10723356507",
	["lucide-file-cog"] = "rbxassetid://10723356830",
	["lucide-file-cog-2"] = "rbxassetid://10723356676",
	["lucide-file-diff"] = "rbxassetid://10723357039",
	["lucide-file-digit"] = "rbxassetid://10723357151",
	["lucide-file-down"] = "rbxassetid://10723357322",
	["lucide-file-edit"] = "rbxassetid://10723357495",
	["lucide-file-heart"] = "rbxassetid://10723357637",
	["lucide-file-image"] = "rbxassetid://10723357790",
	["lucide-file-input"] = "rbxassetid://10723357933",
	["lucide-file-json"] = "rbxassetid://10723364435",
	["lucide-file-json-2"] = "rbxassetid://10723364361",
	["lucide-file-key"] = "rbxassetid://10723364605",
	["lucide-file-key-2"] = "rbxassetid://10723364515",
	["lucide-file-line-chart"] = "rbxassetid://10723364725",
	["lucide-file-lock"] = "rbxassetid://10723364957",
	["lucide-file-lock-2"] = "rbxassetid://10723364861",
	["lucide-file-minus"] = "rbxassetid://10723365254",
	["lucide-file-minus-2"] = "rbxassetid://10723365086",
	["lucide-file-output"] = "rbxassetid://10723365457",
	["lucide-file-pie-chart"] = "rbxassetid://10723365598",
	["lucide-file-plus"] = "rbxassetid://10723365877",
	["lucide-file-plus-2"] = "rbxassetid://10723365766",
	["lucide-file-question"] = "rbxassetid://10723365987",
	["lucide-file-scan"] = "rbxassetid://10723366167",
	["lucide-file-search"] = "rbxassetid://10723366550",
	["lucide-file-search-2"] = "rbxassetid://10723366340",
	["lucide-file-signature"] = "rbxassetid://10723366741",
	["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
	["lucide-file-symlink"] = "rbxassetid://10723367098",
	["lucide-file-terminal"] = "rbxassetid://10723367244",
	["lucide-file-text"] = "rbxassetid://10723367380",
	["lucide-file-type"] = "rbxassetid://10723367606",
	["lucide-file-type-2"] = "rbxassetid://10723367509",
	["lucide-file-up"] = "rbxassetid://10723367734",
	["lucide-file-video"] = "rbxassetid://10723373884",
	["lucide-file-video-2"] = "rbxassetid://10723367834",
	["lucide-file-volume"] = "rbxassetid://10723374172",
	["lucide-file-volume-2"] = "rbxassetid://10723374030",
	["lucide-file-warning"] = "rbxassetid://10723374276",
	["lucide-file-x"] = "rbxassetid://10723374544",
	["lucide-file-x-2"] = "rbxassetid://10723374378",
	["lucide-files"] = "rbxassetid://10723374759",
	["lucide-film"] = "rbxassetid://10723374981",
	["lucide-filter"] = "rbxassetid://10723375128",
	["lucide-fingerprint"] = "rbxassetid://10723375250",
	["lucide-flag"] = "rbxassetid://10723375890",
	["lucide-flag-off"] = "rbxassetid://10723375443",
	["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
	["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
	["lucide-flame"] = "rbxassetid://10723376114",
	["lucide-flashlight"] = "rbxassetid://10723376471",
	["lucide-flashlight-off"] = "rbxassetid://10723376365",
	["lucide-flask-conical"] = "rbxassetid://10734883986",
	["lucide-flask-round"] = "rbxassetid://10723376614",
	["lucide-flip-horizontal"] = "rbxassetid://10723376884",
	["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
	["lucide-flip-vertical"] = "rbxassetid://10723377138",
	["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
	["lucide-flower"] = "rbxassetid://10747830374",
	["lucide-flower-2"] = "rbxassetid://10723377305",
	["lucide-focus"] = "rbxassetid://10723377537",
	["lucide-folder"] = "rbxassetid://10723387563",
	["lucide-folder-archive"] = "rbxassetid://10723384478",
	["lucide-folder-check"] = "rbxassetid://10723384605",
	["lucide-folder-clock"] = "rbxassetid://10723384731",
	["lucide-folder-closed"] = "rbxassetid://10723384893",
	["lucide-folder-cog"] = "rbxassetid://10723385213",
	["lucide-folder-cog-2"] = "rbxassetid://10723385036",
	["lucide-folder-down"] = "rbxassetid://10723385338",
	["lucide-folder-edit"] = "rbxassetid://10723385445",
	["lucide-folder-heart"] = "rbxassetid://10723385545",
	["lucide-folder-input"] = "rbxassetid://10723385721",
	["lucide-folder-key"] = "rbxassetid://10723385848",
	["lucide-folder-lock"] = "rbxassetid://10723386005",
	["lucide-folder-minus"] = "rbxassetid://10723386127",
	["lucide-folder-open"] = "rbxassetid://10723386277",
	["lucide-folder-output"] = "rbxassetid://10723386386",
	["lucide-folder-plus"] = "rbxassetid://10723386531",
	["lucide-folder-search"] = "rbxassetid://10723386787",
	["lucide-folder-search-2"] = "rbxassetid://10723386674",
	["lucide-folder-symlink"] = "rbxassetid://10723386930",
	["lucide-folder-tree"] = "rbxassetid://10723387085",
	["lucide-folder-up"] = "rbxassetid://10723387265",
	["lucide-folder-x"] = "rbxassetid://10723387448",
	["lucide-folders"] = "rbxassetid://10723387721",
	["lucide-form-input"] = "rbxassetid://10723387841",
	["lucide-forward"] = "rbxassetid://10723388016",
	["lucide-frame"] = "rbxassetid://10723394389",
	["lucide-framer"] = "rbxassetid://10723394565",
	["lucide-frown"] = "rbxassetid://10723394681",
	["lucide-fuel"] = "rbxassetid://10723394846",
	["lucide-function-square"] = "rbxassetid://10723395041",
	["lucide-gamepad"] = "rbxassetid://10723395457",
	["lucide-gamepad-2"] = "rbxassetid://10723395215",
	["lucide-gauge"] = "rbxassetid://10723395708",
	["lucide-gavel"] = "rbxassetid://10723395896",
	["lucide-gem"] = "rbxassetid://10723396000",
	["lucide-ghost"] = "rbxassetid://10723396107",
	["lucide-gift"] = "rbxassetid://10723396402",
	["lucide-gift-card"] = "rbxassetid://10723396225",
	["lucide-git-branch"] = "rbxassetid://10723396676",
	["lucide-git-branch-plus"] = "rbxassetid://10723396542",
	["lucide-git-commit"] = "rbxassetid://10723396812",
	["lucide-git-compare"] = "rbxassetid://10723396954",
	["lucide-git-fork"] = "rbxassetid://10723397049",
	["lucide-git-merge"] = "rbxassetid://10723397165",
	["lucide-git-pull-request"] = "rbxassetid://10723397431",
	["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
	["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
	["lucide-glass"] = "rbxassetid://10723397788",
	["lucide-glass-2"] = "rbxassetid://10723397529",
	["lucide-glass-water"] = "rbxassetid://10723397678",
	["lucide-glasses"] = "rbxassetid://10723397895",
	["lucide-globe"] = "rbxassetid://10723404337",
	["lucide-globe-2"] = "rbxassetid://10723398002",
	["lucide-grab"] = "rbxassetid://10723404472",
	["lucide-graduation-cap"] = "rbxassetid://10723404691",
	["lucide-grape"] = "rbxassetid://10723404822",
	["lucide-grid"] = "rbxassetid://10723404936",
	["lucide-grip-horizontal"] = "rbxassetid://10723405089",
	["lucide-grip-vertical"] = "rbxassetid://10723405236",
	["lucide-hammer"] = "rbxassetid://10723405360",
	["lucide-hand"] = "rbxassetid://10723405649",
	["lucide-hand-metal"] = "rbxassetid://10723405508",
	["lucide-hard-drive"] = "rbxassetid://10723405749",
	["lucide-hard-hat"] = "rbxassetid://10723405859",
	["lucide-hash"] = "rbxassetid://10723405975",
	["lucide-haze"] = "rbxassetid://10723406078",
	["lucide-headphones"] = "rbxassetid://10723406165",
	["lucide-heart"] = "rbxassetid://10723406885",
	["lucide-heart-crack"] = "rbxassetid://10723406299",
	["lucide-heart-handshake"] = "rbxassetid://10723406480",
	["lucide-heart-off"] = "rbxassetid://10723406662",
	["lucide-heart-pulse"] = "rbxassetid://10723406795",
	["lucide-help-circle"] = "rbxassetid://10723406988",
	["lucide-hexagon"] = "rbxassetid://10723407092",
	["lucide-highlighter"] = "rbxassetid://10723407192",
	["lucide-history"] = "rbxassetid://10723407335",
	["lucide-home"] = "rbxassetid://10723407389",
	["lucide-hourglass"] = "rbxassetid://10723407498",
	["lucide-ice-cream"] = "rbxassetid://10723414308",
	["lucide-image"] = "rbxassetid://10723415040",
	["lucide-image-minus"] = "rbxassetid://10723414487",
	["lucide-image-off"] = "rbxassetid://10723414677",
	["lucide-image-plus"] = "rbxassetid://10723414827",
	["lucide-import"] = "rbxassetid://10723415205",
	["lucide-inbox"] = "rbxassetid://10723415335",
	["lucide-indent"] = "rbxassetid://10723415494",
	["lucide-indian-rupee"] = "rbxassetid://10723415642",
	["lucide-infinity"] = "rbxassetid://10723415766",
	["lucide-info"] = "rbxassetid://10723415903",
	["lucide-inspect"] = "rbxassetid://10723416057",
	["lucide-italic"] = "rbxassetid://10723416195",
	["lucide-japanese-yen"] = "rbxassetid://10723416363",
	["lucide-joystick"] = "rbxassetid://10723416527",
	["lucide-key"] = "rbxassetid://10723416652",
	["lucide-keyboard"] = "rbxassetid://10723416765",
	["lucide-lamp"] = "rbxassetid://10723417513",
	["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
	["lucide-lamp-desk"] = "rbxassetid://10723417016",
	["lucide-lamp-floor"] = "rbxassetid://10723417131",
	["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
	["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
	["lucide-landmark"] = "rbxassetid://10723417608",
	["lucide-languages"] = "rbxassetid://10723417703",
	["lucide-laptop"] = "rbxassetid://10723423881",
	["lucide-laptop-2"] = "rbxassetid://10723417797",
	["lucide-lasso"] = "rbxassetid://10723424235",
	["lucide-lasso-select"] = "rbxassetid://10723424058",
	["lucide-laugh"] = "rbxassetid://10723424372",
	["lucide-layers"] = "rbxassetid://10723424505",
	["lucide-layout"] = "rbxassetid://10723425376",
	["lucide-layout-dashboard"] = "rbxassetid://10723424646",
	["lucide-layout-grid"] = "rbxassetid://10723424838",
	["lucide-layout-list"] = "rbxassetid://10723424963",
	["lucide-layout-template"] = "rbxassetid://10723425187",
	["lucide-leaf"] = "rbxassetid://10723425539",
	["lucide-library"] = "rbxassetid://10723425615",
	["lucide-life-buoy"] = "rbxassetid://10723425685",
	["lucide-lightbulb"] = "rbxassetid://10723425852",
	["lucide-lightbulb-off"] = "rbxassetid://10723425762",
	["lucide-line-chart"] = "rbxassetid://10723426393",
	["lucide-link"] = "rbxassetid://10723426722",
	["lucide-link-2"] = "rbxassetid://10723426595",
	["lucide-link-2-off"] = "rbxassetid://10723426513",
	["lucide-list"] = "rbxassetid://10723433811",
	["lucide-list-checks"] = "rbxassetid://10734884548",
	["lucide-list-end"] = "rbxassetid://10723426886",
	["lucide-list-minus"] = "rbxassetid://10723426986",
	["lucide-list-music"] = "rbxassetid://10723427081",
	["lucide-list-ordered"] = "rbxassetid://10723427199",
	["lucide-list-plus"] = "rbxassetid://10723427334",
	["lucide-list-start"] = "rbxassetid://10723427494",
	["lucide-list-video"] = "rbxassetid://10723427619",
	["lucide-list-x"] = "rbxassetid://10723433655",
	["lucide-loader"] = "rbxassetid://10723434070",
	["lucide-loader-2"] = "rbxassetid://10723433935",
	["lucide-locate"] = "rbxassetid://10723434557",
	["lucide-locate-fixed"] = "rbxassetid://10723434236",
	["lucide-locate-off"] = "rbxassetid://10723434379",
	["lucide-lock"] = "rbxassetid://10723434711",
	["lucide-log-in"] = "rbxassetid://10723434830",
	["lucide-log-out"] = "rbxassetid://10723434906",
	["lucide-luggage"] = "rbxassetid://10723434993",
	["lucide-magnet"] = "rbxassetid://10723435069",
	["lucide-mail"] = "rbxassetid://10734885430",
	["lucide-mail-check"] = "rbxassetid://10723435182",
	["lucide-mail-minus"] = "rbxassetid://10723435261",
	["lucide-mail-open"] = "rbxassetid://10723435342",
	["lucide-mail-plus"] = "rbxassetid://10723435443",
	["lucide-mail-question"] = "rbxassetid://10723435515",
	["lucide-mail-search"] = "rbxassetid://10734884739",
	["lucide-mail-warning"] = "rbxassetid://10734885015",
	["lucide-mail-x"] = "rbxassetid://10734885247",
	["lucide-mails"] = "rbxassetid://10734885614",
	["lucide-map"] = "rbxassetid://10734886202",
	["lucide-map-pin"] = "rbxassetid://10734886004",
	["lucide-map-pin-off"] = "rbxassetid://10734885803",
	["lucide-maximize"] = "rbxassetid://10734886735",
	["lucide-maximize-2"] = "rbxassetid://10734886496",
	["lucide-medal"] = "rbxassetid://10734887072",
	["lucide-megaphone"] = "rbxassetid://10734887454",
	["lucide-megaphone-off"] = "rbxassetid://10734887311",
	["lucide-meh"] = "rbxassetid://10734887603",
	["lucide-menu"] = "rbxassetid://10734887784",
	["lucide-message-circle"] = "rbxassetid://10734888000",
	["lucide-message-square"] = "rbxassetid://10734888228",
	["lucide-mic"] = "rbxassetid://10734888864",
	["lucide-mic-2"] = "rbxassetid://10734888430",
	["lucide-mic-off"] = "rbxassetid://10734888646",
	["lucide-microscope"] = "rbxassetid://10734889106",
	["lucide-microwave"] = "rbxassetid://10734895076",
	["lucide-milestone"] = "rbxassetid://10734895310",
	["lucide-minimize"] = "rbxassetid://10734895698",
	["lucide-minimize-2"] = "rbxassetid://10734895530",
	["lucide-minus"] = "rbxassetid://10734896206",
	["lucide-minus-circle"] = "rbxassetid://10734895856",
	["lucide-minus-square"] = "rbxassetid://10734896029",
	["lucide-monitor"] = "rbxassetid://10734896881",
	["lucide-monitor-off"] = "rbxassetid://10734896360",
	["lucide-monitor-speaker"] = "rbxassetid://10734896512",
	["lucide-moon"] = "rbxassetid://10734897102",
	["lucide-more-horizontal"] = "rbxassetid://10734897250",
	["lucide-more-vertical"] = "rbxassetid://10734897387",
	["lucide-mountain"] = "rbxassetid://10734897956",
	["lucide-mountain-snow"] = "rbxassetid://10734897665",
	["lucide-mouse"] = "rbxassetid://10734898592",
	["lucide-mouse-pointer"] = "rbxassetid://10734898476",
	["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
	["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
	["lucide-move"] = "rbxassetid://10734900011",
	["lucide-move-3d"] = "rbxassetid://10734898756",
	["lucide-move-diagonal"] = "rbxassetid://10734899164",
	["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
	["lucide-move-horizontal"] = "rbxassetid://10734899414",
	["lucide-move-vertical"] = "rbxassetid://10734899821",
	["lucide-music"] = "rbxassetid://10734905958",
	["lucide-music-2"] = "rbxassetid://10734900215",
	["lucide-music-3"] = "rbxassetid://10734905665",
	["lucide-music-4"] = "rbxassetid://10734905823",
	["lucide-navigation"] = "rbxassetid://10734906744",
	["lucide-navigation-2"] = "rbxassetid://10734906332",
	["lucide-navigation-2-off"] = "rbxassetid://10734906144",
	["lucide-navigation-off"] = "rbxassetid://10734906580",
	["lucide-network"] = "rbxassetid://10734906975",
	["lucide-newspaper"] = "rbxassetid://10734907168",
	["lucide-octagon"] = "rbxassetid://10734907361",
	["lucide-option"] = "rbxassetid://10734907649",
	["lucide-outdent"] = "rbxassetid://10734907933",
	["lucide-package"] = "rbxassetid://10734909540",
	["lucide-package-2"] = "rbxassetid://10734908151",
	["lucide-package-check"] = "rbxassetid://10734908384",
	["lucide-package-minus"] = "rbxassetid://10734908626",
	["lucide-package-open"] = "rbxassetid://10734908793",
	["lucide-package-plus"] = "rbxassetid://10734909016",
	["lucide-package-search"] = "rbxassetid://10734909196",
	["lucide-package-x"] = "rbxassetid://10734909375",
	["lucide-paint-bucket"] = "rbxassetid://10734909847",
	["lucide-paintbrush"] = "rbxassetid://10734910187",
	["lucide-paintbrush-2"] = "rbxassetid://10734910030",
	["lucide-palette"] = "rbxassetid://10734910430",
	["lucide-palmtree"] = "rbxassetid://10734910680",
	["lucide-paperclip"] = "rbxassetid://10734910927",
	["lucide-party-popper"] = "rbxassetid://10734918735",
	["lucide-pause"] = "rbxassetid://10734919336",
	["lucide-pause-circle"] = "rbxassetid://10735024209",
	["lucide-pause-octagon"] = "rbxassetid://10734919143",
	["lucide-pen-tool"] = "rbxassetid://10734919503",
	["lucide-pencil"] = "rbxassetid://10734919691",
	["lucide-percent"] = "rbxassetid://10734919919",
	["lucide-person-standing"] = "rbxassetid://10734920149",
	["lucide-phone"] = "rbxassetid://10734921524",
	["lucide-phone-call"] = "rbxassetid://10734920305",
	["lucide-phone-forwarded"] = "rbxassetid://10734920508",
	["lucide-phone-incoming"] = "rbxassetid://10734920694",
	["lucide-phone-missed"] = "rbxassetid://10734920845",
	["lucide-phone-off"] = "rbxassetid://10734921077",
	["lucide-phone-outgoing"] = "rbxassetid://10734921288",
	["lucide-pie-chart"] = "rbxassetid://10734921727",
	["lucide-piggy-bank"] = "rbxassetid://10734921935",
	["lucide-pin"] = "rbxassetid://10734922324",
	["lucide-pin-off"] = "rbxassetid://10734922180",
	["lucide-pipette"] = "rbxassetid://10734922497",
	["lucide-pizza"] = "rbxassetid://10734922774",
	["lucide-plane"] = "rbxassetid://10734922971",
	["lucide-play"] = "rbxassetid://10734923549",
	["lucide-play-circle"] = "rbxassetid://10734923214",
	["lucide-plus"] = "rbxassetid://10734924532",
	["lucide-plus-circle"] = "rbxassetid://10734923868",
	["lucide-plus-square"] = "rbxassetid://10734924219",
	["lucide-podcast"] = "rbxassetid://10734929553",
	["lucide-pointer"] = "rbxassetid://10734929723",
	["lucide-pound-sterling"] = "rbxassetid://10734929981",
	["lucide-power"] = "rbxassetid://10734930466",
	["lucide-power-off"] = "rbxassetid://10734930257",
	["lucide-printer"] = "rbxassetid://10734930632",
	["lucide-puzzle"] = "rbxassetid://10734930886",
	["lucide-quote"] = "rbxassetid://10734931234",
	["lucide-radio"] = "rbxassetid://10734931596",
	["lucide-radio-receiver"] = "rbxassetid://10734931402",
	["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
	["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
	["lucide-recycle"] = "rbxassetid://10734932295",
	["lucide-redo"] = "rbxassetid://10734932822",
	["lucide-redo-2"] = "rbxassetid://10734932586",
	["lucide-refresh-ccw"] = "rbxassetid://10734933056",
	["lucide-refresh-cw"] = "rbxassetid://10734933222",
	["lucide-refrigerator"] = "rbxassetid://10734933465",
	["lucide-regex"] = "rbxassetid://10734933655",
	["lucide-repeat"] = "rbxassetid://10734933966",
	["lucide-repeat-1"] = "rbxassetid://10734933826",
	["lucide-reply"] = "rbxassetid://10734934252",
	["lucide-reply-all"] = "rbxassetid://10734934132",
	["lucide-rewind"] = "rbxassetid://10734934347",
	["lucide-rocket"] = "rbxassetid://10734934585",
	["lucide-rocking-chair"] = "rbxassetid://10734939942",
	["lucide-rotate-3d"] = "rbxassetid://10734940107",
	["lucide-rotate-ccw"] = "rbxassetid://10734940376",
	["lucide-rotate-cw"] = "rbxassetid://10734940654",
	["lucide-rss"] = "rbxassetid://10734940825",
	["lucide-ruler"] = "rbxassetid://10734941018",
	["lucide-russian-ruble"] = "rbxassetid://10734941199",
	["lucide-sailboat"] = "rbxassetid://10734941354",
	["lucide-save"] = "rbxassetid://10734941499",
	["lucide-scale"] = "rbxassetid://10734941912",
	["lucide-scale-3d"] = "rbxassetid://10734941739",
	["lucide-scaling"] = "rbxassetid://10734942072",
	["lucide-scan"] = "rbxassetid://10734942565",
	["lucide-scan-face"] = "rbxassetid://10734942198",
	["lucide-scan-line"] = "rbxassetid://10734942351",
	["lucide-scissors"] = "rbxassetid://10734942778",
	["lucide-screen-share"] = "rbxassetid://10734943193",
	["lucide-screen-share-off"] = "rbxassetid://10734942967",
	["lucide-scroll"] = "rbxassetid://10734943448",
	["lucide-search"] = "rbxassetid://10734943674",
	["lucide-send"] = "rbxassetid://10734943902",
	["lucide-separator-horizontal"] = "rbxassetid://10734944115",
	["lucide-separator-vertical"] = "rbxassetid://10734944326",
	["lucide-server"] = "rbxassetid://10734949856",
	["lucide-server-cog"] = "rbxassetid://10734944444",
	["lucide-server-crash"] = "rbxassetid://10734944554",
	["lucide-server-off"] = "rbxassetid://10734944668",
	["lucide-settings"] = "rbxassetid://10734950309",
	["lucide-settings-2"] = "rbxassetid://10734950020",
	["lucide-share"] = "rbxassetid://10734950813",
	["lucide-share-2"] = "rbxassetid://10734950553",
	["lucide-sheet"] = "rbxassetid://10734951038",
	["lucide-shield"] = "rbxassetid://10734951847",
	["lucide-shield-alert"] = "rbxassetid://10734951173",
	["lucide-shield-check"] = "rbxassetid://10734951367",
	["lucide-shield-close"] = "rbxassetid://10734951535",
	["lucide-shield-off"] = "rbxassetid://10734951684",
	["lucide-shirt"] = "rbxassetid://10734952036",
	["lucide-shopping-bag"] = "rbxassetid://10734952273",
	["lucide-shopping-cart"] = "rbxassetid://10734952479",
	["lucide-shovel"] = "rbxassetid://10734952773",
	["lucide-shower-head"] = "rbxassetid://10734952942",
	["lucide-shrink"] = "rbxassetid://10734953073",
	["lucide-shrub"] = "rbxassetid://10734953241",
	["lucide-shuffle"] = "rbxassetid://10734953451",
	["lucide-sidebar"] = "rbxassetid://10734954301",
	["lucide-sidebar-close"] = "rbxassetid://10734953715",
	["lucide-sidebar-open"] = "rbxassetid://10734954000",
	["lucide-sigma"] = "rbxassetid://10734954538",
	["lucide-signal"] = "rbxassetid://10734961133",
	["lucide-signal-high"] = "rbxassetid://10734954807",
	["lucide-signal-low"] = "rbxassetid://10734955080",
	["lucide-signal-medium"] = "rbxassetid://10734955336",
	["lucide-signal-zero"] = "rbxassetid://10734960878",
	["lucide-siren"] = "rbxassetid://10734961284",
	["lucide-skip-back"] = "rbxassetid://10734961526",
	["lucide-skip-forward"] = "rbxassetid://10734961809",
	["lucide-skull"] = "rbxassetid://10734962068",
	["lucide-slack"] = "rbxassetid://10734962339",
	["lucide-slash"] = "rbxassetid://10734962600",
	["lucide-slice"] = "rbxassetid://10734963024",
	["lucide-sliders"] = "rbxassetid://10734963400",
	["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
	["lucide-smartphone"] = "rbxassetid://10734963940",
	["lucide-smartphone-charging"] = "rbxassetid://10734963671",
	["lucide-smile"] = "rbxassetid://10734964441",
	["lucide-smile-plus"] = "rbxassetid://10734964188",
	["lucide-snowflake"] = "rbxassetid://10734964600",
	["lucide-sofa"] = "rbxassetid://10734964852",
	["lucide-sort-asc"] = "rbxassetid://10734965115",
	["lucide-sort-desc"] = "rbxassetid://10734965287",
	["lucide-speaker"] = "rbxassetid://10734965419",
	["lucide-sprout"] = "rbxassetid://10734965572",
	["lucide-square"] = "rbxassetid://10734965702",
	["lucide-star"] = "rbxassetid://10734966248",
	["lucide-star-half"] = "rbxassetid://10734965897",
	["lucide-star-off"] = "rbxassetid://10734966097",
	["lucide-stethoscope"] = "rbxassetid://10734966384",
	["lucide-sticker"] = "rbxassetid://10734972234",
	["lucide-sticky-note"] = "rbxassetid://10734972463",
	["lucide-stop-circle"] = "rbxassetid://10734972621",
	["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
	["lucide-stretch-vertical"] = "rbxassetid://10734973130",
	["lucide-strikethrough"] = "rbxassetid://10734973290",
	["lucide-subscript"] = "rbxassetid://10734973457",
	["lucide-sun"] = "rbxassetid://10734974297",
	["lucide-sun-dim"] = "rbxassetid://10734973645",
	["lucide-sun-medium"] = "rbxassetid://10734973778",
	["lucide-sun-moon"] = "rbxassetid://10734973999",
	["lucide-sun-snow"] = "rbxassetid://10734974130",
	["lucide-sunrise"] = "rbxassetid://10734974522",
	["lucide-sunset"] = "rbxassetid://10734974689",
	["lucide-superscript"] = "rbxassetid://10734974850",
	["lucide-swiss-franc"] = "rbxassetid://10734975024",
	["lucide-switch-camera"] = "rbxassetid://10734975214",
	["lucide-sword"] = "rbxassetid://10734975486",
	["lucide-swords"] = "rbxassetid://10734975692",
	["lucide-syringe"] = "rbxassetid://10734975932",
	["lucide-table"] = "rbxassetid://10734976230",
	["lucide-table-2"] = "rbxassetid://10734976097",
	["lucide-tablet"] = "rbxassetid://10734976394",
	["lucide-tag"] = "rbxassetid://10734976528",
	["lucide-tags"] = "rbxassetid://10734976739",
	["lucide-target"] = "rbxassetid://10734977012",
	["lucide-tent"] = "rbxassetid://10734981750",
	["lucide-terminal"] = "rbxassetid://10734982144",
	["lucide-terminal-square"] = "rbxassetid://10734981995",
	["lucide-text-cursor"] = "rbxassetid://10734982395",
	["lucide-text-cursor-input"] = "rbxassetid://10734982297",
	["lucide-thermometer"] = "rbxassetid://10734983134",
	["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
	["lucide-thermometer-sun"] = "rbxassetid://10734982771",
	["lucide-thumbs-down"] = "rbxassetid://10734983359",
	["lucide-thumbs-up"] = "rbxassetid://10734983629",
	["lucide-ticket"] = "rbxassetid://10734983868",
	["lucide-timer"] = "rbxassetid://10734984606",
	["lucide-timer-off"] = "rbxassetid://10734984138",
	["lucide-timer-reset"] = "rbxassetid://10734984355",
	["lucide-toggle-left"] = "rbxassetid://10734984834",
	["lucide-toggle-right"] = "rbxassetid://10734985040",
	["lucide-tornado"] = "rbxassetid://10734985247",
	["lucide-toy-brick"] = "rbxassetid://10747361919",
	["lucide-train"] = "rbxassetid://10747362105",
	["lucide-trash"] = "rbxassetid://10747362393",
	["lucide-trash-2"] = "rbxassetid://10747362241",
	["lucide-tree-deciduous"] = "rbxassetid://10747362534",
	["lucide-tree-pine"] = "rbxassetid://10747362748",
	["lucide-trees"] = "rbxassetid://10747363016",
	["lucide-trending-down"] = "rbxassetid://10747363205",
	["lucide-trending-up"] = "rbxassetid://10747363465",
	["lucide-triangle"] = "rbxassetid://10747363621",
	["lucide-trophy"] = "rbxassetid://10747363809",
	["lucide-truck"] = "rbxassetid://10747364031",
	["lucide-tv"] = "rbxassetid://10747364593",
	["lucide-tv-2"] = "rbxassetid://10747364302",
	["lucide-type"] = "rbxassetid://10747364761",
	["lucide-umbrella"] = "rbxassetid://10747364971",
	["lucide-underline"] = "rbxassetid://10747365191",
	["lucide-undo"] = "rbxassetid://10747365484",
	["lucide-undo-2"] = "rbxassetid://10747365359",
	["lucide-unlink"] = "rbxassetid://10747365771",
	["lucide-unlink-2"] = "rbxassetid://10747397871",
	["lucide-unlock"] = "rbxassetid://10747366027",
	["lucide-upload"] = "rbxassetid://10747366434",
	["lucide-upload-cloud"] = "rbxassetid://10747366266",
	["lucide-usb"] = "rbxassetid://10747366606",
	["lucide-user"] = "rbxassetid://10747373176",
	["lucide-user-check"] = "rbxassetid://10747371901",
	["lucide-user-cog"] = "rbxassetid://10747372167",
	["lucide-user-minus"] = "rbxassetid://10747372346",
	["lucide-user-plus"] = "rbxassetid://10747372702",
	["lucide-user-x"] = "rbxassetid://10747372992",
	["lucide-users"] = "rbxassetid://10747373426",
	["lucide-utensils"] = "rbxassetid://10747373821",
	["lucide-utensils-crossed"] = "rbxassetid://10747373629",
	["lucide-venetian-mask"] = "rbxassetid://10747374003",
	["lucide-verified"] = "rbxassetid://10747374131",
	["lucide-vibrate"] = "rbxassetid://10747374489",
	["lucide-vibrate-off"] = "rbxassetid://10747374269",
	["lucide-video"] = "rbxassetid://10747374938",
	["lucide-video-off"] = "rbxassetid://10747374721",
	["lucide-view"] = "rbxassetid://10747375132",
	["lucide-voicemail"] = "rbxassetid://10747375281",
	["lucide-volume"] = "rbxassetid://10747376008",
	["lucide-volume-1"] = "rbxassetid://10747375450",
	["lucide-volume-2"] = "rbxassetid://10747375679",
	["lucide-volume-x"] = "rbxassetid://10747375880",
	["lucide-wallet"] = "rbxassetid://10747376205",
	["lucide-wand"] = "rbxassetid://10747376565",
	["lucide-wand-2"] = "rbxassetid://10747376349",
	["lucide-watch"] = "rbxassetid://10747376722",
	["lucide-waves"] = "rbxassetid://10747376931",
	["lucide-webcam"] = "rbxassetid://10747381992",
	["lucide-wifi"] = "rbxassetid://10747382504",
	["lucide-wifi-off"] = "rbxassetid://10747382268",
	["lucide-wind"] = "rbxassetid://10747382750",
	["lucide-wrap-text"] = "rbxassetid://10747383065",
	["lucide-wrench"] = "rbxassetid://10747383470",
	["lucide-x"] = "rbxassetid://10747384394",
	["lucide-x-circle"] = "rbxassetid://10747383819",
	["lucide-x-octagon"] = "rbxassetid://10747384037",
	["lucide-x-square"] = "rbxassetid://10747384217",
	["lucide-zoom-in"] = "rbxassetid://10747384552",
	["lucide-zoom-out"] = "rbxassetid://10747384679",
};
local function Fixed(planePos, planeNormal, rayOrigin, rayDirection)
	local n = planeNormal
	local d = rayDirection
	local v = rayOrigin - planePos

	local num = (n.x*v.x) + (n.y*v.y) + (n.z*v.z)
	local den = (n.x*d.x) + (n.y*d.y) + (n.z*d.z)
	local a = -num / den

	return rayOrigin + (a * rayDirection), a;
end;

function NeverZen:SetBlur(frame : Frame,NoAutoBackground)
	local Part = Instance.new('Part',workspace.Camera);
	local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
	local SurfaceGui = Instance.new('SurfaceGui',Part);
	local BlockMesh = Instance.new("BlockMesh");

	BlockMesh.Parent = Part;

	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	pcall(function()
		Part.CollisionGroup = NeverZen:RandomString();
	end);
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);

	TweenService:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{
		Transparency = 0.8;
	}):Play()

	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 1;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 500;
	DepthOfField.NearIntensity = 1;

	SurfaceGui.AlwaysOnTop = true;
	SurfaceGui.Adornee = Part;
	SurfaceGui.Active = true;
	SurfaceGui.Face = Enum.NormalId.Front;
	SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	DepthOfField.Name = NeverZen:RandomString();
	Part.Name = NeverZen:RandomString();
	SurfaceGui.Name = NeverZen:RandomString();

	local C4 = {
		Update = nil,
		Collection = SurfaceGui,
		Enabled = true,
		Instances = {
			BlockMesh = BlockMesh,
			Part = Part,
			DepthOfField = DepthOfField,
			SurfaceGui = SurfaceGui,
		},
		Signal = nil
	};

	local Update = function()
		local _,updatec = pcall(function()
			local userSettings = UserSettings():GetService("UserGameSettings")
			local qualityLevel = userSettings.SavedQualityLevel.Value

			if not NoAutoBackground then
				if qualityLevel < 8 then
					TweenService:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
						Transparency = 1;
					}):Play()

					frame.BackgroundTransparency = 0.01
				else
					TweenService:Create(Part,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
						Transparency = 0.8;
					}):Play()

					frame.BackgroundTransparency = 0.075
				end;
			end;
		end)

		local corner0 = frame.AbsolutePosition;
		local corner1 = corner0 + frame.AbsoluteSize;

		local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
		local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

		local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

		local planeNormal = CurrentCamera.CFrame.LookVector;

		local pos0 = Fixed(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
		local pos1 = Fixed(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

		pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
		pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

		local size   = pos1 - pos0;
		local center = (pos0 + pos1) / 2;

		BlockMesh.Offset = center
		BlockMesh.Scale  = size / 0.0101;
		Part.CFrame = CurrentCamera.CFrame;
	end

	C4.Update = Update;
	C4.Signal = RunService.RenderStepped:Connect(Update);

	pcall(function()
		C4.Signal2 = CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(function()
			Part.CFrame = CurrentCamera.CFrame;
		end);
	end)

	C4.Destroy = function()
		C4.Signal:Disconnect();
		C4.Signal2:Disconnect();
		C4.Update = function()

		end;

		TweenService:Create(Part,TweenInfo.new(1),{
			Transparency = 1
		}):Play();

		DepthOfField:Destroy();
		Part:Destroy()
	end;

	return C4;
end;

function NeverZen:GetIcon(name : string) : string
	return NeverZen.Lucide['lucide-'..tostring(name)] or NeverZen.Lucide[name] or NeverZen.Lucide[tostring(name)] or "";
end;

function NeverZen:RandomString() : string
	return string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))
end;

function NeverZen:Rounding(num, numDecimalPlaces) : number
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end;

function NeverZen:CloneConfig(config)
	local out = {};
	for k, v in pairs(config or {}) do
		out[k] = v;
	end
	return out;
end;

function NeverZen.SecureCall(fn, ...)
	local oldIdentity = getidentity();
	setidentity(8);
	local ok, result = pcall(fn, ...);
	setidentity(oldIdentity);
	if not ok then
		warn("[NeverZen] SecureCall error: " .. tostring(result));
	end
	return ok, result;
end;

NeverZen.Windows = {};

local BaseSecureCall = NeverZen.SecureCall;

function NeverZen:NotifyChange()
	for _, window in ipairs(self.Windows or {}) do
		if window and not window.Destroyed then
			if window.RefreshDependencies then
				pcall(function() window:RefreshDependencies() end);
			end
			if window.ScheduleAutoSave then
				pcall(function() window:ScheduleAutoSave() end);
			end
		end
	end
end

function NeverZen.SecureCall(fn, ...)
	local ok, result = BaseSecureCall(fn, ...);
	task.defer(function()
		pcall(function() NeverZen:NotifyChange() end);
	end);
	return ok, result;
end;

local function rgb(r, g, b): Color3
	return Color3.fromRGB(r, g, b)
end;

NeverZen.Palette = {

	Window          = rgb(7, 7, 8),
	WindowDeep      = rgb(4, 4, 5),
	Surface         = rgb(14, 14, 16),
	SurfaceAlt      = rgb(19, 19, 22),
	SurfaceHigh     = rgb(25, 25, 29),
	SurfaceHover    = rgb(31, 31, 36),

	Text            = rgb(245, 245, 247),
	TextSoft        = rgb(206, 206, 212),
	TextDim         = rgb(150, 150, 158),
	TextMuted       = rgb(110, 110, 118),

	Line            = rgb(255, 255, 255),
	LineSoft        = rgb(255, 255, 255),
	White           = rgb(255, 255, 255),
	Black           = rgb(0, 0, 0),
	OnAccent        = rgb(9, 9, 11),

	Accent          = rgb(255, 255, 255),
	AccentDim       = rgb(186, 186, 194),
};

NeverZen.Design = {
	Radius      = { xs = 6, sm = 8, md = 10, lg = 14, xl = 18, pill = 999 },
	HeaderH     = 54,
	SidebarW    = 196,
	RowH        = 34,
	CardPad     = 12,
	CardGap     = 12,
	StrokeAlpha = 0.9,
	Particles   = { Count = 52, Hz = 40, MinSize = 2, MaxSize = 5 },
	FontFamily  = "rbxasset://fonts/families/GothamSSm.json",
};

local function buildTheme(accent : Color3)
	return {
		WindowBackgroundColor = rgb(7, 7, 8),
		HeadText = rgb(245, 245, 247),
		LineColor = rgb(24, 24, 28),
		BackgroundColor = rgb(7, 7, 8),
		SectionColor = rgb(14, 14, 16),
		Hightlight = accent,
		StrokeColor = rgb(34, 34, 40),
		StrokeColor2 = rgb(74, 74, 82),
		BackgroundColor2 = rgb(18, 18, 21),
		IconColor = accent,
	};
end;

NeverZen.Theme = buildTheme(rgb(255, 255, 255));
NeverZen.ThemeRegistry = {};

function NeverZen:Track(inst, prop, resolver)
	table.insert(NeverZen.ThemeRegistry, {Instance = inst, Prop = prop, Resolver = resolver});

	local val = (typeof(resolver) == 'function' and resolver()) or NeverZen.Theme[resolver];
	if val ~= nil then
		pcall(function() inst[prop] = val end);
	end

	return inst;
end;

function NeverZen:ApplyTheme()
	for i = #NeverZen.ThemeRegistry, 1, -1 do
		local v = NeverZen.ThemeRegistry[i];

		if v.Instance and v.Instance.Parent then
			local val = (typeof(v.Resolver) == 'function' and v.Resolver()) or NeverZen.Theme[v.Resolver];

			if val ~= nil then
				pcall(function()
					TweenService:Create(v.Instance, TweenInfo.new(0.25), {[v.Prop] = val}):Play();
				end);
			end
		else
			table.remove(NeverZen.ThemeRegistry, i);
		end;
	end
end;

NeverZen.InstanceKey = "AvernusInstances";

local function instanceEnv()
	local ok, env = pcall(function()
		if typeof(getgenv) == "function" then return getgenv() end;
		return _G;
	end);
	if ok and typeof(env) == "table" then return env end;
	return _G;
end;

local function instanceStore()
	local env = instanceEnv();
	if typeof(env) ~= "table" then
		return { Entries = {} };
	end

	local store = env[NeverZen.InstanceKey];

	if typeof(store) ~= "table" or typeof(store.Entries) ~= "table" then
		store = { Entries = {}, Version = 1 };
		pcall(function() env[NeverZen.InstanceKey] = store end);
	end

	return store;
end;

function NeverZen:RegisterInstance(kind, destroyer)
	if typeof(destroyer) ~= "function" then return end;
	local store = instanceStore();
	table.insert(store.Entries, { Kind = tostring(kind or "Gui"), Destroy = destroyer });
end;

function NeverZen:CloseInstances(quiet, skipKinds)
	local store = instanceStore();
	local closed = 0;
	local skip = {};

	if typeof(skipKinds) == "table" then
		for _, kind in ipairs(skipKinds) do
			skip[tostring(kind)] = true;
		end
	end

	for index = #store.Entries, 1, -1 do
		local entry = store.Entries[index];

		if entry and skip[entry.Kind] then
			continue;
		end

		table.remove(store.Entries, index);
		if entry and typeof(entry.Destroy) == "function" then
			local ok = pcall(entry.Destroy);
			if ok then
				closed += 1;
			end
		end
	end

	if closed > 0 and not quiet then
		print("[Avernus] закрыто предыдущих интерфейсов: " .. tostring(closed));
	end

	return closed;
end;

function NeverZen:UnregisterInstance(kind)
	local store = instanceStore();
	local kind = tostring(kind or "");

	for index = #store.Entries, 1, -1 do
		local entry = store.Entries[index];
		if entry and entry.Kind == kind then
			table.remove(store.Entries, index);
		end
	end
end;

function NeverZen:CountInstances()
	local store = instanceStore();
	return #store.Entries;
end;

NeverZen.ConfigPath = "AvernusLib/Config";
NeverZen.ConfigAutoLoad = true;

function NeverZen:EnsureConfigDir()
	if not (isfolder and makefolder) then return end;
	if not isfolder("AvernusLib") then
		pcall(makefolder, "AvernusLib");
	end;
	if not isfolder(self.ConfigPath) then
		pcall(makefolder, self.ConfigPath);
	end;
end;

function NeverZen:SaveConfig(name, data)
	if not writefile then return false end;
	self:EnsureConfigDir();
	local path = self.ConfigPath .. "/" .. name .. ".json";
	local success, encoded = pcall(function()
		return game:GetService("HttpService"):JSONEncode(data);
	end);
	if success then
		local ok = pcall(writefile, path, encoded);
		return ok;
	end;
	return false;
end;

function NeverZen:LoadConfig(name)
	if not (isfile and readfile) then return nil end;
	local path = self.ConfigPath .. "/" .. name .. ".json";
	if isfile(path) then
		local success, decoded = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(path));
		end);
		if success then
			return decoded;
		end;
	end;
	return nil;
end;

function NeverZen:ListConfigs()
	if not listfiles then return {} end;
	self:EnsureConfigDir();
	local files = listfiles(self.ConfigPath);
	if typeof(files) ~= "table" then return {} end;
	local configs = {};
	for _, file in ipairs(files) do
		if typeof(file) == "string" and file:match("%.json$") then
			local name = file:match("([^/\\]+)%.json$");
			if name and name ~= "autoload" then
				table.insert(configs, name);
			end;
		end;
	end;
	table.sort(configs);
	return configs;
end;

function NeverZen:DeleteConfig(name)
	if not (isfile and delfile) then return false end;
	local path = self.ConfigPath .. "/" .. name .. ".json";
	if isfile(path) then
		pcall(delfile, path);
		return true;
	end;
	return false;
end;



function NeverZen:SetTheme(_name)
	return true;
end;

local UI = {};
NeverZen.UI = UI;

function UI.new(class, props, children)
	local inst = Instance.new(class);
	if props then
		for k, v in pairs(props) do
			if k ~= "Parent" then
				inst[k] = v;
			end
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = inst;
		end
	end
	if props and props.Parent then
		inst.Parent = props.Parent;
	end
	return inst;
end

function UI.corner(parent, radius)
	return UI.new("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent });
end

function UI.pill(parent)
	return UI.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = parent });
end

function UI.gradientStroke(parent, opts)
	opts = opts or {};

	local stroke = UI.stroke(parent, opts.Transparency or 0.25, opts.Thickness or 1, opts.Color);
	local gradient;

	local ok = pcall(function()
		gradient = Instance.new("UIGradient");
		gradient.Name = "StrokeGradient";

		gradient.Color = opts.Sequence or ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(230, 230, 236)),
			ColorSequenceKeypoint.new(0.25, Color3.fromRGB(150, 150, 158)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(86, 86, 92)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(150, 150, 158)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(230, 230, 236)),
		});

		gradient.Transparency = opts.TransparencySequence or NumberSequence.new({
			NumberSequenceKeypoint.new(0.00, 0.25),
			NumberSequenceKeypoint.new(0.25, 0.55),
			NumberSequenceKeypoint.new(0.50, 0.80),
			NumberSequenceKeypoint.new(0.75, 0.55),
			NumberSequenceKeypoint.new(1.00, 0.25),
		});

		gradient.Rotation = opts.Rotation or 45;
		gradient.Parent = stroke;
	end);

	if not ok then
		stroke.Color = opts.Color or NeverZen.Palette.Line;
		gradient = nil;
	end

	if gradient and opts.Animated ~= false then
		pcall(function()
			local baseRotation = opts.Rotation or 45;
			local speed = opts.Speed or 14;
			local spin = nil;

			local entry = {};
			entry.Gradient = gradient;

			entry.Start = function()
				if spin then pcall(function() spin:Cancel() end) end
				spin = TweenService:Create(
					gradient,
					TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
					{ Rotation = baseRotation + 360 }
				);
				spin:Play();
			end

			entry.Stop = function()
				if spin then pcall(function() spin:Cancel() end) end
				spin = nil;
				pcall(function() gradient.Rotation = baseRotation end);
			end

			NeverZen.GradientSpins = NeverZen.GradientSpins or {};
			table.insert(NeverZen.GradientSpins, entry);

			gradient.AncestryChanged:Connect(function()
				if not gradient.Parent then
					entry.Stop();
					for index = #NeverZen.GradientSpins, 1, -1 do
						if NeverZen.GradientSpins[index] == entry then
							table.remove(NeverZen.GradientSpins, index);
						end
					end
				end
			end);

			if NeverZen.AnimationsEnabled ~= false then
				entry.Start();
			end
		end);
	end

	return stroke, gradient;
end

function UI.stroke(parent, transparency, thickness, color)
	return UI.new("UIStroke", {
		Color = color or NeverZen.Palette.Line,
		Transparency = transparency == nil and NeverZen.Design.StrokeAlpha or transparency,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	});
end

function UI.padding(parent, top, right, bottom, left)
	return UI.new("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingRight = UDim.new(0, right or top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		PaddingLeft = UDim.new(0, left or right or top or 0),
		Parent = parent,
	});
end

function UI.list(parent, props)
	props = props or {};
	return UI.new("UIListLayout", {
		FillDirection = props.FillDirection or Enum.FillDirection.Vertical,
		HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Center,
		VerticalAlignment = props.VerticalAlignment or Enum.VerticalAlignment.Top,
		SortOrder = props.SortOrder or Enum.SortOrder.LayoutOrder,
		Padding = props.Padding or UDim.new(0, 0),
		Wraps = props.Wraps,
		Parent = parent,
	});
end

function UI.weight(inst, weight)
	weight = weight or FW.Medium;

	local ok = false;
	if Font and Font.new then
		ok = pcall(function()
			inst.FontFace = Font.new(NeverZen.Design.FontFamily, weight);
		end);
	end

	if not ok then

		local fallback = {
			[FW.Regular] = FONT.Gotham,
			[FW.Medium] = FONT.GothamMedium,
			[FW.SemiBold] = FONT.GothamMedium,
			[FW.Bold] = FONT.GothamBold,
			[FW.Black] = FONT.GothamBlack,
		};
		local chosen = fallback[weight] or FONT.Gotham;
		pcall(function()
			if chosen then inst.Font = chosen end;
			inst.FontFace = nil;
		end);
	end
	return inst;
end

function UI.text(props)
	local label = UI.new("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		RichText = props.RichText or false,
		Text = props.Text or "",
		TextColor3 = props.Color or NeverZen.Palette.Text,
		TextSize = props.TextSize or props.Size_ or 13,
		TextXAlignment = props.XAlign or Enum.TextXAlignment.Left,
		TextYAlignment = props.YAlign or Enum.TextYAlignment.Center,
		TextTruncate = props.Truncate or Enum.TextTruncate.AtEnd,
		TextWrapped = props.Wrapped or false,
		Size = props.Size2 or props.Size or UDim2.new(1, 0, 1, 0),
		Position = props.Position or UDim2.new(0, 0, 0, 0),
		AnchorPoint = props.AnchorPoint or Vector2.new(0, 0),
		Visible = props.Visible ~= false,
		Parent = props.Parent,
	});
	UI.weight(label, props.Weight or FW.Medium);
	return label;
end

function UI.image(props)
	return UI.new("ImageLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = props.Image or "",
		ImageColor3 = props.Color or NeverZen.Palette.TextDim,
		ImageTransparency = props.Transparency or 0,
		ScaleType = props.ScaleType or Enum.ScaleType.Fit,
		Size = props.Size or UDim2.new(0, 16, 0, 16),
		Position = props.Position or UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = props.AnchorPoint or Vector2.new(0, 0.5),
		Parent = props.Parent,
	});
end

function UI.tw(inst, info, props)
	if NeverZen.AnimationsEnabled == false then
		for key, value in pairs(props or {}) do
			pcall(function()
				inst[key] = value;
			end);
		end
		return TweenService:Create(inst, TweenInfo.new(0), {});
	end
	return TweenService:Create(inst, info, props);
end

function UI.tween(inst, duration, props, style, direction)
	if NeverZen.AnimationsEnabled == false then
		for key, value in pairs(props or {}) do
			pcall(function()
				inst[key] = value;
			end);
		end
		return TweenService:Create(inst, TweenInfo.new(0), {});
	end

	local tw = TweenService:Create(inst, TweenInfo.new(
		duration or 0.2,
		style or Enum.EasingStyle.Quad,
		direction or Enum.EasingDirection.Out
	), props);
	tw:Play();
	return tw;
end

function UI.interact(button, opts)
	opts = opts or {};

	local hoverIn = function()
		if opts.Hover then
			local props = opts.Hover;
			UI.tween(button, 0.14, props);
		end
	end

	local hoverOut = function()
		if opts.Idle then
			UI.tween(button, 0.16, opts.Idle);
		end
	end

	button.MouseEnter:Connect(hoverIn);
	button.MouseLeave:Connect(hoverOut);
	button.MouseButton1Down:Connect(function()
		if opts.Press then UI.tween(button, 0.06, opts.Press) end
	end);
	button.MouseButton1Up:Connect(function()
		if opts.Idle then UI.tween(button, 0.12, opts.Idle) end
	end);
end

function UI.press(button, radius)
	local Flash = UI.new("Frame", {
		Name = "PressFlash",
		Parent = button,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = NeverZen.Palette.White,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = button.ZIndex,
	});
	UI.corner(Flash, radius or 8);

	button.MouseButton1Down:Connect(function()
		Flash.BackgroundTransparency = 0.87;
		UI.tween(Flash, 0.34, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
	end);

	return Flash;
end

local function wrap01(v)
	v = v % 1;
	if v < 0 then v = v + 1 end;
	return v;
end

NeverZen.ParticleFields = {};
NeverZen.ParticlesEnabled = true;

function NeverZen:SetAnimations(enabled)
	self.AnimationsEnabled = enabled and true or false;

	for _, entry in ipairs(self.GradientSpins or {}) do
		pcall(function()
			if self.AnimationsEnabled then
				entry.Start();
			else
				entry.Stop();
			end
		end);
	end

	return self.AnimationsEnabled;
end

function NeverZen:SetParticles(enabled)
	self.ParticlesEnabled = enabled and true or false;
	for _, entry in ipairs(self.ParticleFields) do
		pcall(function()
			entry:SetActive(self.ParticlesEnabled);
		end);
		if entry.Frame then
			entry.Frame.Visible = self.ParticlesEnabled;
		end
	end
	return self.ParticlesEnabled;
end

function UI.particles(parent, opts)
	opts = opts or {};

	local field = UI.new("Frame", {
		Name = "ParticleField",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = false,
		Selectable = false,
		Size = opts.Size or UDim2.fromScale(1, 1),
		Position = opts.Position or UDim2.fromOffset(0, 0),
		ZIndex = opts.ZIndex or 2,
		Parent = parent,
	});

	local count = opts.Count or NeverZen.Design.Particles.Count;
	local hz = opts.Hz or NeverZen.Design.Particles.Hz;
	local interval = 1 / hz;

	local particles = table.create(count);

	for i = 1, count do
		local size = math.random(NeverZen.Design.Particles.MinSize, NeverZen.Design.Particles.MaxSize);

		local dot = UI.new("Frame", {
			Name = "p",
			BackgroundColor3 = NeverZen.Palette.White,
			BackgroundTransparency = math.random(35, 88) / 100,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(size, size),
			Position = UDim2.fromScale(math.random(), math.random()),
			ZIndex = field.ZIndex,
			Parent = field,
		});
		UI.pill(dot);

		local speed = 0.0035 + math.random() * 0.0125;

		particles[i] = {
			inst = dot,
			x = math.random(),
			y = math.random(),
			vx = (math.random() < 0.5 and -1 or 1) * speed * (0.5 + math.random()),
			vy = (math.random() < 0.5 and -1 or 1) * speed * (0.5 + math.random()),
			phase = math.random() * math.pi * 2,
			baseTransparency = dot.BackgroundTransparency,
			size = size,
		};
	end

	local accumulated = 0;
	local clock = 0;
	local active = true;
	local twinkleCursor = 1;

	local wrapper = {};

	local connection = RunService.Heartbeat:Connect(function(dt)
		if not active then return end;
		if not field.Parent then return end;

		accumulated += dt;
		if accumulated < interval then return end;

		local step = math.min(accumulated, 0.25);
		accumulated = 0;
		clock += step;

		for i = 1, count do
			local p = particles[i];
			p.x = wrap01(p.x + p.vx * step);
			p.y = wrap01(p.y + p.vy * step);
			p.inst.Position = UDim2.fromScale(p.x, p.y);
		end

		for i = 1, 4 do
			local p = particles[twinkleCursor];
			if p then
				local shimmer = math.sin(clock * 0.9 + p.phase * 3) * 0.10;
				p.inst.BackgroundTransparency = math.clamp(p.baseTransparency + shimmer, 0.15, 0.95);
			end
			twinkleCursor = twinkleCursor % count + 1;
		end
	end);

	wrapper.Frame = field;
	wrapper.Particles = particles;
	wrapper.SetActive = function(self, value)
		active = value and true or false;
		field.Visible = active;
	end;
	wrapper.Destroy = function(self)
		if connection then
			connection:Disconnect();
			connection = nil;
		end
		for index = #NeverZen.ParticleFields, 1, -1 do
			if NeverZen.ParticleFields[index] == self then
				table.remove(NeverZen.ParticleFields, index);
			end
		end
		field:Destroy();
	end;

	table.insert(NeverZen.ParticleFields, wrapper);

	if NeverZen.ParticlesEnabled == false then
		active = false;
		field.Visible = false;
	end

	return wrapper;
end;

-- Animation payload is fetched from a hosted Lua module; no frame Base64 is embedded here.
local ANIME_OVERLAY_FRAMES_RAW_URL = "https://avernushub.vercel.app/tsom.lua"
local ANIME_OVERLAY_FRAME_COUNT = 0
local ANIME_OVERLAY_FRAME_DURATION = 1 / 30
local cachedAnimeOverlayFrames

local function loadAnimeOverlayFrames()
	if cachedAnimeOverlayFrames then return cachedAnimeOverlayFrames end

	local ok, frames = pcall(function()
		return loadstring(game:HttpGet(ANIME_OVERLAY_FRAMES_RAW_URL))()
	end)
	if not ok then
		error("[AvernusLib] Could not download/execute animation module: " .. tostring(frames), 2)
	end
	if type(frames) ~= "table" or #frames < 1 then
		error("[AvernusLib] Animation module must return a non-empty table of Base64 frames", 2)
	end
	local sourceFrameCount = #frames
	for frameIndex = 1, sourceFrameCount do
		if type(frames[frameIndex]) ~= "string" then
			error("[AvernusLib] Missing/invalid animation frame " .. tostring(frameIndex), 2)
		end
	end

	-- The hosted hybrid module returns the complete 180-frame playback timeline.
	ANIME_OVERLAY_FRAME_COUNT = sourceFrameCount
	cachedAnimeOverlayFrames = frames
	return cachedAnimeOverlayFrames
end

local ANIME_OVERLAY_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local ANIME_OVERLAY_LOOKUP = {}
for i = 1, #ANIME_OVERLAY_ALPHABET do
	ANIME_OVERLAY_LOOKUP[string.byte(ANIME_OVERLAY_ALPHABET, i)] = i - 1
end

local function decodeAnimeOverlayBase64(data)
	local chunks = {}
	local chunkCount = 0
	local bytes = table.create(256)
	local byteCount = 0
	local buffer = 0
	local bitCount = 0
	local unpackValues = table.unpack or unpack

	local function flushBytes()
		if byteCount == 0 then return end
		chunkCount += 1
		chunks[chunkCount] = string.char(unpackValues(bytes, 1, byteCount))
		table.clear(bytes)
		byteCount = 0
	end

	for i = 1, #data do
		local value = ANIME_OVERLAY_LOOKUP[string.byte(data, i)]
		if value ~= nil then
			buffer = buffer * 64 + value
			bitCount += 6
			if bitCount >= 8 then
				bitCount -= 8
				byteCount += 1
				bytes[byteCount] = math.floor(buffer / (2 ^ bitCount)) % 256
				buffer = buffer % (2 ^ bitCount)
				if byteCount >= 256 then flushBytes() end
			end
		end
	end
	flushBytes()
	return table.concat(chunks)
end

local cachedAnimeOverlayAssets
local function getAnimeOverlayAssets()
	if cachedAnimeOverlayAssets then return cachedAnimeOverlayAssets end
	if type(writefile) ~= "function" then
		return nil, "writefile is not available in this executor"
	end

	local assetLoaders = {}
	if type(getcustomasset) == "function" then table.insert(assetLoaders, getcustomasset) end
	if type(getsynasset) == "function" and getsynasset ~= getcustomasset then
		table.insert(assetLoaders, getsynasset)
	end
	if #assetLoaders == 0 then
		return nil, "getcustomasset/getsynasset is not available in this executor"
	end
	if type(makefolder) == "function" then pcall(makefolder, "AvernusLib") end

	local assets = {}
	local assetByPayload = {}
	local encodedFrames = loadAnimeOverlayFrames()
	for frameIndex, encodedFrame in ipairs(encodedFrames) do
		local loadedAsset = assetByPayload[encodedFrame]
		if not loadedAsset then
			local imageData = decodeAnimeOverlayBase64(encodedFrame)
			local fileName = string.format("MalfoidAnimation_Original180_v5_Frame_%03d.png", frameIndex)
			local imagePath = "AvernusLib/" .. fileName
			local wrote, writeResult = pcall(writefile, imagePath, imageData)
			if not wrote or writeResult == false then
				imagePath = "AvernusLib_" .. fileName
				wrote, writeResult = pcall(writefile, imagePath, imageData)
			end
			if not wrote or writeResult == false then
				return nil, "could not write animation frame " .. tostring(frameIndex)
			end

			for _, loader in ipairs(assetLoaders) do
				local ok, asset = pcall(loader, imagePath)
				if ok and type(asset) == "string" and asset ~= "" then
					loadedAsset = asset
					break
				end
			end
			if not loadedAsset then
				return nil, "getcustomasset/getsynasset could not load animation frame " .. tostring(frameIndex)
			end
			assetByPayload[encodedFrame] = loadedAsset
		end
		assets[frameIndex] = loadedAsset
	end

	cachedAnimeOverlayAssets = assets
	return assets
end

function NeverZen.new(config)
	config = config or {};
	config.SingleInstance = (config.SingleInstance == nil) and true or config.SingleInstance;

	if config.SingleInstance then
		NeverZen:CloseInstances();
	end

	config.KeySystem = config.KeySystem or false;
	config.KeySystemReturnURL = config.KeySystemReturnURL or nil;

	if config.KeySystem then

		local KeyService = config.KeySystemName or "Avernus Hub"
		local KeyIdentifier = config.KeySystemIdentifier or ""
		local KeyProvider = config.KeySystemProvider or "Mixed"
		local ReturnURL = config.KeySystemReturnURL

		local function validateKey(key)
			if not key or #key == 0 then return false end
			local success, result = pcall(function()
				local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
				Junkie.service = KeyService
				Junkie.identifier = KeyIdentifier
				Junkie.provider = KeyProvider
				return Junkie.check_key and Junkie.check_key(key)
			end)
			return success and result and result.valid
		end

		local savedKey = getgenv().SCRIPT_KEY

		if not savedKey or not validateKey(savedKey) then
			getgenv().SCRIPT_KEY = nil

			if ReturnURL and #ReturnURL > 0 then
				local notifyGui = Instance.new("ScreenGui")
				notifyGui.Name = NeverZen:RandomString()
				NeverZen:SafeParent(notifyGui)
				notifyGui.ResetOnSpawn = false
				NeverZen.ProtectGui(notifyGui)

				local notifyFrame = UI.new("Frame", {
					Parent = notifyGui,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 300, 0, 0),
					BackgroundColor3 = NeverZen.Palette.Window,
					BorderSizePixel = 0,
				})
				UI.corner(notifyFrame, 12);
				UI.stroke(notifyFrame, 0.8);

				local nl = UI.text({
					Parent = notifyFrame,
					Size = UDim2.new(1, -28, 1, -28),
					Position = UDim2.new(0, 14, 0, 14),
					Text = "⚠ Key expired or invalid!\n\nReturning to key system...",
					Color = Color3.fromRGB(240, 240, 240),
					Size2 = UDim2.new(1, -28, 1, -28),
					Wrapped = true,
					YAlign = Enum.TextYAlignment.Top,
					Size_ = 13,
				});
				nl.TextSize = 13;
				UI.weight(nl, FW.Medium);

				UI.tween(notifyFrame, 0.3, { Size = UDim2.new(0, 300, 0, 100) });

				task.delay(2, function()
					notifyGui:Destroy()
					loadstring(game:HttpGet(ReturnURL))()
				end)

				return nil
			else
				return nil
			end
		end
	end

	config.Name = config.Name or "Avernus";
	config.Logo = config.Logo or nil;
	config.LogoSize = config.LogoSize or 24;
	config.LogoGap = config.LogoGap or 14;
	config.LogoX = config.LogoX or 12;
	config.LogoCollapsedSize = config.LogoCollapsedSize or 34;
	config.LogoAnimTime = config.LogoAnimTime or 0.45;
	config.BrandX = config.BrandX or 0;
	config.BrandY = config.BrandY or 0;
	config.PageAnimTime = config.PageAnimTime or 0.26;
	config.CardTransparency = config.CardTransparency or 0.37;
	config.Animations = (config.Animations == nil) and true or config.Animations;
	NeverZen.AnimationsEnabled = config.Animations;
	config.CloseDestroys = (config.CloseDestroys == nil) and true or config.CloseDestroys;
	config.CloseDestroysAll = (config.CloseDestroysAll == nil) and true or config.CloseDestroysAll;
	config.KeybindList = config.KeybindList or false;
	NeverZen.Logo = config.Logo;
	NeverZen.LogoSize = config.LogoSize;
	config.Keybind = config.Keybind or Enum.KeyCode.RightControl;
	config.Scale = config.Scale or UDim2.fromOffset(900, 560);
	config.Resizable = config.Resizable;
	config.Shadow = config.Shadow or false;
	config.LoadSound = config.LoadSound or nil;
	config.Center = config.Center ~= false;

	config.Acrylic = config.Acrylic or false;

	config.Transparency = config.Transparency or 0.18;
	config.Particles = (config.Particles == nil) and true or config.Particles;
	NeverZen.ParticlesEnabled = config.Particles;
	config.ParticleCount = config.ParticleCount or 52;

	local AnimeImageOptions = typeof(config.AnimeImage) == "table" and config.AnimeImage or {};
	local AnimeImageDefault = config.AnimeImage == true or AnimeImageOptions.Default == true or AnimeImageOptions.Enabled == true;
	local AnimeImageAspectRatio = 1327 / 1920;

	local WindowSignal = {};
	WindowSignal.SelectedTab = nil;
	WindowSignal.Tabs = {};
	WindowSignal.Config = config;
	WindowSignal.ConfigValues = {};
	WindowSignal.ConfigCallbacks = {};
	WindowSignal.CurrentConfigName = nil;
	WindowSignal.Toggle = true;
	WindowSignal.AnimeImageVisible = false;

	WindowSignal.BindingKey = false;
	WindowSignal.KeybindEntries = {};
	WindowSignal.KeybindDirty = true;

	WindowSignal.AddKeybindEntry = function(entry)
		if typeof(entry) ~= "table" then return end;
		table.insert(WindowSignal.KeybindEntries, entry);
		WindowSignal.KeybindDirty = true;
	end;

	WindowSignal.Dependencies = {};
	WindowSignal.AutoSave = false;
	WindowSignal.AutoSaveName = nil;

	table.insert(NeverZen.Windows, WindowSignal);

	function WindowSignal:SetAutoSave(enabled, name)
		self.AutoSave = enabled and true or false;
		self.AutoSaveName = name or self.CurrentConfigName;
		return self.AutoSave;
	end;

	function WindowSignal:ScheduleAutoSave()
		if not self.AutoSave then return end;
		local name = self.AutoSaveName or self.CurrentConfigName;
		if not name or #tostring(name) == 0 then return end;

		self._autoSaveToken = (self._autoSaveToken or 0) + 1;
		local token = self._autoSaveToken;

		task.delay(2, function()
			if destroyed then return end;
			if token ~= self._autoSaveToken then return end;
			pcall(function() WindowSignal:SaveConfig(name) end);
		end);
	end;

	function WindowSignal:ExportConfig()
		local ok, encoded = pcall(function()
			return game:GetService("HttpService"):JSONEncode(WindowSignal.ConfigValues);
		end);
		if not ok then return nil end;
		local exported = "NZ1:" .. encoded;
		pcall(function() setclipboard(exported) end);
		return exported;
	end;

	function WindowSignal:ImportConfig(payload)
		if type(payload) ~= "string" or #payload == 0 then return false end;
		local body = payload;
		if string.sub(body, 1, 4) == "NZ1:" then
			body = string.sub(body, 5);
		end

		local ok, data = pcall(function()
			return game:GetService("HttpService"):JSONDecode(body);
		end);
		if not ok or type(data) ~= "table" then return false end;

		for elementName, value in pairs(data) do
			local callback = WindowSignal.ConfigCallbacks[elementName];
			if callback then
				pcall(callback, value);
			end
			WindowSignal.ConfigValues[elementName] = value;
		end

		WindowSignal:RefreshDependencies();
		return true;
	end;

	function WindowSignal:RefreshDependencies()
		if destroyed then return end;

		for _, entry in ipairs(WindowSignal.Dependencies) do
			local frame = entry.Frame;
			local control = entry.Control;
			if frame and frame.Parent then
				local show = true;
				local requirement = entry.Requirement;

				if requirement then
					show = requirement() and true or false;
				end

				if control and control._forcedHidden then
					show = false;
				end

				local searchHidden = false;
				pcall(function()
					searchHidden = frame:GetAttribute("NZSearchHidden") == true;
				end);
				if searchHidden then
					show = false;
				end

				if frame.Visible ~= show then
					frame.Visible = show;
				end
			end
		end
	end;

	function WindowSignal:MakeRequirement(depends)
		if depends == nil then return nil end;
		if typeof(depends) == "string" then
			return function()
				return WindowSignal.ConfigValues[depends] and true or false;
			end
		end
		if typeof(depends) == "table" then
			local name = depends.Name or depends[1];
			local wanted = depends.Value or depends[2];
			local allowed = depends.Values or depends[3];
			return function()
				local value = WindowSignal.ConfigValues[name];
				if allowed then
					for _, candidate in ipairs(allowed) do
						if value == candidate then return true end;
					end
					return false;
				end
				if wanted ~= nil then
					return value == wanted;
				end
				return value and true or false;
			end
		end
		if typeof(depends) == "function" then
			return depends;
		end
		return nil;
	end;

	WindowSignal.FrameMemory = {
		WindowBackgroundColor = {},
		HeadText = {},
		LineColor = {},
	};

	function WindowSignal:SaveConfig(name)
		if not name or #name == 0 then return false end;
		self.CurrentConfigName = name;
		local ok = NeverZen:SaveConfig(name, self.ConfigValues);
		return ok == true;
	end;

	function WindowSignal:LoadConfig(name)
		local data = NeverZen:LoadConfig(name);
		if not data or typeof(data) ~= "table" then return false end;

		self.CurrentConfigName = name;

		for elementName, value in pairs(data) do
			local callback = self.ConfigCallbacks[elementName];
			if callback then
				local ok, err = NeverZen.SecureCall(callback, value);
				if not ok then
					warn("[NeverZen] Ошибка в колбеке при загрузке конфига для '" .. tostring(elementName) .. "': " .. tostring(err));
				end;
			else
				warn("[NeverZen] Для элемента '" .. tostring(elementName) .. "' нет зарегистрированного колбека (элемент не создан или Name отличается)");
			end;
			self.ConfigValues[elementName] = value;
		end;

		return true;
	end;

	function WindowSignal:GetConfigValue(name)
		return self.ConfigValues[name];
	end;

	function WindowSignal:AutoLoadConfig()
		if not (isfile and readfile) then return false end;
		local autoLoadPath = NeverZen.ConfigPath .. "/autoload.json";
		if isfile(autoLoadPath) then
			local success, name = pcall(function()
				return game:GetService("HttpService"):JSONDecode(readfile(autoLoadPath));
			end);
			if success and name and typeof(name) == "string" then
				return self:LoadConfig(name);
			end;
		end;
		return false;
	end;

	function NeverZen:GetConfigAutoLoadPath()
		return self.ConfigPath .. "/autoload.json";
	end;

	function NeverZen:GetAutoLoadName()
		if not (isfile and readfile) then return nil end;
		local autoLoadPath = self:GetConfigAutoLoadPath();
		if not isfile(autoLoadPath) then return nil end;
		local ok, name = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(autoLoadPath));
		end);
		if ok and typeof(name) == "string" and name ~= "none" and name ~= "" then
			return name;
		end
		return nil;
	end;

	function NeverZen:ClearAutoLoad()
		if not (isfile and delfile) then return false end;
		local autoLoadPath = self:GetConfigAutoLoadPath();
		if isfile(autoLoadPath) then
			pcall(delfile, autoLoadPath);
			return true;
		end
		return false;
	end;

	function WindowSignal:SetAutoLoad(name)
		if not writefile then return end;
		NeverZen:EnsureConfigDir();
		local autoLoadPath = NeverZen.ConfigPath .. "/autoload.json";
		pcall(function()
			writefile(autoLoadPath, game:GetService("HttpService"):JSONEncode(name));
		end);
	end;

	local P = NeverZen.Palette;
	local D = NeverZen.Design;

	local destroyed = false;
	local animeImageGui = nil;
	local animeImageLabel = nil;
	local animeDragging = false;
	local animeAnimationAssets = nil;
	local animeAnimationLabels = {};
	local animeAnimationConnection = nil;
	local animeFrameIndex = 1;
	local animeFrameAccumulator = 0;
	local animeImageVisible = false;
	local animeImageBasePosition = AnimeImageOptions.Position or UDim2.new(1, -24, 1, -24);
	local configuredAnimeSize = AnimeImageOptions.Size;
	local animeImageHeight = math.clamp(tonumber(AnimeImageOptions.Height) or (typeof(configuredAnimeSize) == "UDim2" and configuredAnimeSize.Y.Offset > 0 and configuredAnimeSize.Y.Offset or 450), 160, 520);
	local animeImageSize = configuredAnimeSize or UDim2.fromOffset(math.floor(animeImageHeight * AnimeImageAspectRatio + 0.5), animeImageHeight);
	local animeImageDraggable = AnimeImageOptions.Draggable == true;
	local setAnimeImageSwitch = nil;
	local setAnimeDraggableSwitch = nil;
	local setAnimeSizeSlider = nil;
	WindowSignal.AnimeImageVisible = false;
	WindowSignal.AnimeImageHeight = animeImageHeight;
	WindowSignal.AnimeImagePosition = animeImageBasePosition;
	WindowSignal.AnimeImageDraggable = animeImageDraggable;
	local connections = {};
	local dragInteractions = {};
	local popups = {};
	local tabLayouts = {};

	local function bind(signal, fn)
		local connection = signal:Connect(fn);
		table.insert(connections, connection);
		return connection;
	end;

	local function addDrag(handler)
		table.insert(dragInteractions, handler);
	end;

	bind(Services.UserInputService.InputChanged, function(input)
		if #dragInteractions == 0 then return end;
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end;
		for i = #dragInteractions, 1, -1 do
			local handler = dragInteractions[i];
			if handler and handler.update then
				handler.update(input.Position);
			end
		end
	end);

	bind(Services.UserInputService.InputEnded, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
		for i = #dragInteractions, 1, -1 do
			local handler = dragInteractions[i];
			table.remove(dragInteractions, i);
			if handler and handler.release then
				pcall(handler.release);
			end
		end
	end);

	local function closeAllPopups(except)
		for i = #popups, 1, -1 do
			local popup = popups[i];
			if popup ~= except then
				if not popup.persistent then
					table.remove(popups, i);
				end
				if popup.close then pcall(popup.close); end
			end
		end
	end

	local function hardClosePopups()
		for _, popup in ipairs(popups) do
			if popup.close then pcall(popup.close); end
			if popup.panel then
				pcall(function() popup.panel.Visible = false end);
			end
		end
	end

	local function registerPopup(popup)
		table.insert(popups, popup);
	end;

	WindowSignal.ClosePopups = closeAllPopups;

	local Content = UI.new("ScreenGui", {
		Name = NeverZen:RandomString(),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 50,
	});
	NeverZen:SafeParent(Content);
	NeverZen.ProtectGui(Content);

	local function clampAnimeImagePosition(position)
		if typeof(position) ~= "UDim2" or not animeImageLabel then return position end
		local ok, viewport = pcall(function()
			return workspace.CurrentCamera.ViewportSize
		end)
		if not ok or not viewport then return position end
		local size = Vector2.new(
			animeImageSize.X.Scale * viewport.X + animeImageSize.X.Offset,
			animeImageSize.Y.Scale * viewport.Y + animeImageSize.Y.Offset
		)
		if size.X <= 0 or size.Y <= 0 then size = animeImageLabel.AbsoluteSize end
		if size.X <= 0 or size.Y <= 0 then
			size = Vector2.new(math.floor(animeImageHeight * AnimeImageAspectRatio + 0.5), animeImageHeight)
		end
		local anchor = animeImageLabel.AnchorPoint
		local x = position.X.Scale * viewport.X + position.X.Offset
		local y = position.Y.Scale * viewport.Y + position.Y.Offset
		local minX = size.X * anchor.X
		local maxX = viewport.X - size.X * (1 - anchor.X)
		local minY = size.Y * anchor.Y
		local maxY = viewport.Y - size.Y * (1 - anchor.Y)
		if maxX < minX then maxX = minX end
		if maxY < minY then maxY = minY end
		x = math.clamp(x, minX, maxX)
		y = math.clamp(y, minY, maxY)
		return UDim2.new(
			position.X.Scale, x - position.X.Scale * viewport.X,
			position.Y.Scale, y - position.Y.Scale * viewport.Y
		)
	end

	local function setAnimeImagePosition(position)
		if typeof(position) ~= "UDim2" then return false end
		if animeImageLabel then position = clampAnimeImagePosition(position) end
		animeImageBasePosition = position
		WindowSignal.AnimeImagePosition = position
		if animeImageLabel and not animeDragging then animeImageLabel.Position = position end
		return true
	end

	local function setAnimeImageHeight(height, skipSwitchSync)
		local value = math.clamp(math.floor((tonumber(height) or animeImageHeight) + 0.5), 160, 520)
		animeImageHeight = value
		animeImageSize = UDim2.fromOffset(math.floor(value * AnimeImageAspectRatio + 0.5), value)
		WindowSignal.AnimeImageHeight = value
		if animeImageLabel then
			animeImageLabel.Size = animeImageSize
			animeImageBasePosition = clampAnimeImagePosition(animeImageBasePosition)
			animeImageLabel.Position = animeImageBasePosition
			WindowSignal.AnimeImagePosition = animeImageBasePosition
		end
		if not skipSwitchSync and setAnimeSizeSlider then pcall(setAnimeSizeSlider, value) end
		return value
	end

	local function setAnimeImageDraggable(value, skipSwitchSync)
		animeImageDraggable = value and true or false
		WindowSignal.AnimeImageDraggable = animeImageDraggable
		if animeImageLabel then animeImageLabel.Active = animeImageDraggable end
		if not skipSwitchSync and setAnimeDraggableSwitch then pcall(setAnimeDraggableSwitch, animeImageDraggable) end
		return true
	end

	local function stopAnimeImageAnimation()
		if animeAnimationConnection then
			pcall(function() animeAnimationConnection:Disconnect() end)
			animeAnimationConnection = nil
		end
	end

	local function setAnimeAnimationFrame(index)
		if not animeAnimationAssets or not animeAnimationLabels then return false end
		local normalized = ((index - 1) % ANIME_OVERLAY_FRAME_COUNT) + 1
		local nextLabel = animeAnimationLabels[normalized]
		if not nextLabel or not nextLabel.Parent then return false end

		nextLabel.Size = animeImageSize
		nextLabel.Position = animeImageBasePosition
		-- Enforce exactly one visible frame, even if a stale label survived an earlier update.
		for _, frameLabel in ipairs(animeAnimationLabels) do
			if frameLabel ~= nextLabel and (frameLabel.Visible or frameLabel.Active) then
				frameLabel.Visible = false
				frameLabel.Active = false
			end
		end
		nextLabel.Active = animeImageDraggable
		nextLabel.Visible = true
		animeImageLabel = nextLabel
		WindowSignal.AnimeImage = animeImageLabel
		animeFrameIndex = normalized
		WindowSignal.AnimeImageFrame = normalized
		return true
	end

	local function startAnimeImageAnimation()
		if animeAnimationConnection or not animeImageVisible or not animeImageGui or not animeImageGui.Enabled
			or not animeImageLabel or not animeImageLabel.Parent or not animeAnimationAssets then return end
		local ok, connection = pcall(function()
			return RunService.RenderStepped:Connect(function(deltaTime)
				if destroyed or not animeImageVisible or not animeImageGui or not animeImageGui.Enabled
					or not animeImageLabel or not animeImageLabel.Parent then
					stopAnimeImageAnimation()
					return
				end
				animeFrameAccumulator += deltaTime
				local framesToAdvance = math.floor(animeFrameAccumulator / ANIME_OVERLAY_FRAME_DURATION)
				if framesToAdvance <= 0 then return end
				animeFrameAccumulator -= framesToAdvance * ANIME_OVERLAY_FRAME_DURATION
				setAnimeAnimationFrame(animeFrameIndex + framesToAdvance)
			end)
		end)
		if ok then animeAnimationConnection = connection end
	end

	local function createAnimeOverlay()
		local imageAssets, assetError = getAnimeOverlayAssets()
		if not imageAssets then error(assetError or "failed to load linked anime animation") end
		animeAnimationAssets = imageAssets
		animeAnimationLabels = {}

		animeImageGui = UI.new("ScreenGui", {
			Name = "Avernus_AnimeOverlay_" .. NeverZen:RandomString(),
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			DisplayOrder = AnimeImageOptions.DisplayOrder or 51,
		})
		NeverZen:SafeParent(animeImageGui)
		NeverZen.ProtectGui(animeImageGui)

		animeImageBasePosition = clampAnimeImagePosition(animeImageBasePosition)

		local function bindAnimeImageDrag(imageLabel)
			bind(imageLabel.InputBegan, function(input)
				if destroyed or not animeImageVisible or not animeImageDraggable or animeDragging then return end
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
				local startInput = input.Position
				local startPosition = imageLabel.Position
				animeImageLabel = imageLabel
				WindowSignal.AnimeImage = imageLabel
				animeDragging = true
				addDrag({
					update = function(position)
						if not animeDragging or not animeImageLabel or not animeImageLabel.Parent then return end
						local delta = position - startInput
					local nextPosition = UDim2.new(
						startPosition.X.Scale, startPosition.X.Offset + delta.X,
						startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
						)
						animeImageBasePosition = clampAnimeImagePosition(nextPosition)
						if animeImageLabel and animeImageLabel.Parent then animeImageLabel.Position = animeImageBasePosition end
						WindowSignal.AnimeImagePosition = animeImageBasePosition
					end,
					release = function()
						if not animeDragging then return end
						animeDragging = false
						if animeImageLabel and animeImageLabel.Parent then
							animeImageBasePosition = animeImageLabel.Position
							WindowSignal.AnimeImagePosition = animeImageBasePosition
						end
					end,
				})
			end)
		end

		-- Keep one preloaded ImageLabel per frame; only the current frame is visible.
		for frameIndex, asset in ipairs(imageAssets) do
			local imageLabel = UI.new("ImageLabel", {
				Name = "AnimeCharacterFrame_" .. tostring(frameIndex),
				Parent = animeImageGui,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = AnimeImageOptions.AnchorPoint or Vector2.new(1, 1),
				Position = animeImageBasePosition,
				Size = animeImageSize,
				Image = asset,
				ImageTransparency = AnimeImageOptions.Transparency or 0,
				ScaleType = Enum.ScaleType.Fit,
				ClipsDescendants = false,
				ZIndex = 1,
				Active = frameIndex == 1 and animeImageDraggable,
				Visible = frameIndex == 1,
			})
			table.insert(animeAnimationLabels, imageLabel)
			bindAnimeImageDrag(imageLabel)
		end
		animeImageLabel = animeAnimationLabels[1]
		if not animeImageLabel then error("no animation frames were loaded") end
		WindowSignal.AnimeImage = animeImageLabel
		animeFrameIndex = 1
		animeFrameAccumulator = 0

		local preloadFailure = nil
		Services.ContentProvider:PreloadAsync(animeAnimationLabels, function(contentId, status)
			if status ~= Enum.AssetFetchStatus.Success and not preloadFailure then
				preloadFailure = tostring(contentId) .. " (" .. tostring(status) .. ")"
			end
		end)
		if preloadFailure then
			error("could not preload all animation frames: " .. preloadFailure)
		end

		setAnimeAnimationFrame(1)
	end

	local function setAnimeImageVisible(value, skipSwitchSync)
		if destroyed then return false end
		local visible = value and true or false
		if visible then
			if not animeImageGui or not animeImageGui.Parent then
				local ok, err = pcall(createAnimeOverlay)
				if not ok then
					if animeImageGui then pcall(function() animeImageGui:Destroy() end) end
					animeImageGui = nil
					animeImageLabel = nil
					animeAnimationLabels = {}
					animeAnimationAssets = nil
					WindowSignal.AnimeImage = nil
					warn("[AvernusLib] Could not show the linked anime image: " .. tostring(err))
					return false
				end
			end
			animeImageGui.Enabled = true
		else
			animeDragging = false
			if animeImageGui then animeImageGui.Enabled = false end
		end
		animeImageVisible = visible
		WindowSignal.AnimeImageVisible = visible
		if visible then
			animeFrameIndex = 1
			animeFrameAccumulator = 0
			setAnimeAnimationFrame(1)
			startAnimeImageAnimation()
		else
			stopAnimeImageAnimation()
		end
		if not skipSwitchSync and setAnimeImageSwitch then pcall(setAnimeImageSwitch, visible) end
		return true
	end

	function WindowSignal:SetAnimeImageVisible(value)
		return setAnimeImageVisible(value, false)
	end

	function WindowSignal:ToggleAnimeImage()
		return setAnimeImageVisible(not animeImageVisible, false)
	end

	function WindowSignal:SetAnimeImageSize(height)
		return setAnimeImageHeight(height, false)
	end
	WindowSignal.SetAnimeImageHeight = WindowSignal.SetAnimeImageSize

	function WindowSignal:SetAnimeImagePosition(position)
		return setAnimeImagePosition(position)
	end

	function WindowSignal:ResetAnimeImagePosition()
		return setAnimeImagePosition(AnimeImageOptions.Position or UDim2.new(1, -24, 1, -24))
	end

	function WindowSignal:SetAnimeImageDraggable(value)
		return setAnimeImageDraggable(value, false)
	end

	WindowSignal.SetAnimeImage = WindowSignal.SetAnimeImageVisible

	local WindowFrame = UI.new("Frame", {
		Name = NeverZen:RandomString(),
		Parent = Content,
		AnchorPoint = Vector2.new(0, 0),

		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromOffset(0, 0),
		BackgroundColor3 = P.Window,
		BackgroundTransparency = config.Transparency,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = true,
		ZIndex = 1,
	});
	UI.corner(WindowFrame, D.Radius.lg);
	local WindowStroke, WindowStrokeGradient = UI.gradientStroke(WindowFrame, {
		Transparency = 0.55,
		Thickness = 1,
		Rotation = 45,
		Speed = 16,
	});
	WindowSignal.WindowStroke = WindowStroke;
	WindowSignal.WindowStrokeGradient = WindowStrokeGradient;
	table.insert(WindowSignal.FrameMemory.WindowBackgroundColor, WindowFrame);

	WindowSignal.TransparencyCards = {};
	WindowSignal.KeepOpaque = setmetatable({}, { __mode = "k" });
	WindowSignal.TransparencyPanels = {};
	WindowSignal.TransparencyHooks = {};

	do

		local ok, pos = pcall(function()
			local viewport = workspace.CurrentCamera.ViewportSize;
			local w = config.Scale.X.Offset or 900;
			local h = config.Scale.Y.Offset or 560;
			return UDim2.fromOffset(
				math.max(math.floor((viewport.X - w) / 2), 0),
				math.max(math.floor((viewport.Y - h) / 2), 0)
			);
		end);
		if ok and pos then
			WindowFrame.Position = pos;
		else
			WindowFrame.Position = UDim2.fromOffset(177, 177);
		end
		if config.Center == false then
			WindowFrame.Position = UDim2.fromOffset(120, 120);
		end

	end


	local ParticleField = UI.particles(WindowFrame, {
		ZIndex = 2,
		Count = config.ParticleCount or NeverZen.Design.Particles.Count,
	});

	local BackdropGui, BackdropField;

	local HeaderH = D.HeaderH;

	local Header = UI.new("Frame", {
		Name = "Header",
		Parent = WindowFrame,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, HeaderH),
		ZIndex = 20,
		Active = true,
	});

	local BrandOffset = 20;
	local LogoBaseSize = config.LogoSize or 24;
	local LogoAnchor = Vector2.new(0, 0);

	local function logoY(size)
		return math.max((HeaderH - size) / 2, 3);
	end;

	local function paintLogo(image, size)
		image.AnchorPoint = LogoAnchor;
		image.Size = UDim2.fromOffset(size, size);
		image.Position = UDim2.new(0, config.LogoX, 0, logoY(size));
	end;

	Header.ClipsDescendants = false;

	if config.Logo then
		local logoSize = math.max(LogoBaseSize, 8);

		local LogoImage = UI.image({
			Parent = Header,
			Image = config.Logo,
			Color = P.White,
			AnchorPoint = LogoAnchor,
			Position = UDim2.new(0, config.LogoX, 0, logoY(logoSize)),
			Size = UDim2.fromOffset(logoSize, logoSize),
		});
		LogoImage.ZIndex = 25;
		LogoImage.BackgroundTransparency = 1;
		BrandOffset = config.LogoX + logoSize + config.LogoGap;
		WindowSignal.Logo = LogoImage;
		WindowSignal.LogoSize = logoSize;

		if config.LogoRounded then
			UI.corner(LogoImage, config.LogoRounded);
		end

	end

	local BrandText = UI.text({
		Parent = Header,
		Position = UDim2.new(0, BrandOffset + config.BrandX, 0, config.BrandY),
		Size = UDim2.new(0, 0, 1, 0),
		Text = config.Name,
		Color = P.Text,
		Size_ = 17,
		Weight = FW.Black,
	});
	BrandText.TextSize = 17;
	BrandText.AutomaticSize = Enum.AutomaticSize.X;
	BrandText.ZIndex = 21;
	table.insert(WindowSignal.FrameMemory.HeadText, BrandText);

	local BrandDivider = UI.new("Frame", {
		Parent = Header,
		BackgroundColor3 = P.Line,
		BackgroundTransparency = 0.82,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromOffset(1, 14),
		ZIndex = 21,
	});

	local TabSubtitle = UI.text({
		Parent = Header,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 0, 1, 0),
		Text = "Main Menu",
		Color = P.TextDim,
		Size_ = 13,
		Weight = FW.Medium,
	});
	TabSubtitle.TextSize = 13;
	TabSubtitle.AutomaticSize = Enum.AutomaticSize.X;
	TabSubtitle.ZIndex = 21;

	local function layoutBrand()
		local brandWidth = BrandText.AbsoluteSize.X;
		local base = BrandText.Position.X.Offset;
		local y = BrandText.Position.Y.Offset;
		BrandDivider.Position = UDim2.new(0, base + brandWidth + 12, 0.5, y);
		TabSubtitle.Position = UDim2.new(0, base + brandWidth + 25, 0, y);
	end;

	bind(BrandText:GetPropertyChangedSignal("AbsoluteSize"), layoutBrand);
	bind(BrandText:GetPropertyChangedSignal("Position"), layoutBrand);

	if WindowSignal.Logo then
		local logo = WindowSignal.Logo;
		local tweens = {};
		local isCollapsed = false;
		local appliedCollapsed = false;

		local function targetSize(collapsed)
			if collapsed then
				return math.clamp(config.LogoCollapsedSize, 10, HeaderH - 6);
			end

			return math.max(LogoBaseSize, 8);
		end;

		local function targetGap(collapsed)
			return collapsed and 8 or config.LogoGap;
		end;

		local function stopTweens()
			for i = #tweens, 1, -1 do
				local tween = tweens[i];
				table.remove(tweens, i);
				pcall(function() tween:Cancel() end);
			end
		end;

		local function textX(size, gap)
			return config.LogoX + size + gap + config.BrandX;
		end;

		local function applyLogo(size, gap)
			paintLogo(logo, size);
			BrandText.Position = UDim2.new(0, textX(size, gap), 0, config.BrandY);
			layoutBrand();
		end;

		local function animateLogo(size, gap)
			local fromSize = logo.AbsoluteSize.X;
			if fromSize <= 0 then fromSize = WindowSignal.LogoSize or size end;

			stopTweens();

			if math.abs(fromSize - size) < 0.5 then
				applyLogo(size, gap);
				WindowSignal.LogoSize = size;
				return;
			end

			local duration = config.LogoAnimTime or 0.45;
			local info = TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
			local offset = textX(size, gap);
			local centerY = math.max((HeaderH - size) / 2, 3);

			local sizeTween = UI.tw(logo, info, { Size = UDim2.fromOffset(size, size) });
			local posTween = UI.tw(logo, info, { Position = UDim2.new(0, config.LogoX, 0, centerY) });
			local textTween = UI.tw(BrandText, info, { Position = UDim2.new(0, offset, 0, config.BrandY) });

			table.insert(tweens, sizeTween);
			table.insert(tweens, posTween);
			table.insert(tweens, textTween);

			sizeTween:Play();
			posTween:Play();
			textTween:Play();

			WindowSignal.LogoSize = size;
			WindowSignal.LogoAnimating = true;

			task.delay(duration, function()
				WindowSignal.LogoAnimating = false;
			end);
		end;

		local function fitLogo(animate)
			local width = WindowFrame.AbsoluteSize.X;
			if width <= 0 then return end;

			local wanted = isCollapsed or width < 300;
			local size = targetSize(wanted);
			local gap = targetGap(wanted);

			if wanted ~= appliedCollapsed then
				animate = true;
			end

			appliedCollapsed = wanted;

			if animate then
				animateLogo(size, gap);
			else
				applyLogo(size, gap);
			end
		end;

		WindowSignal.SetLogoCollapsed = function(state)
			state = state and true or false;
			if isCollapsed == state then return end;

			isCollapsed = state;
			fitLogo(true);
		end;

		bind(WindowFrame:GetPropertyChangedSignal("AbsoluteSize"), function()
			if WindowSignal.LogoAnimating then return end;

			local width = WindowFrame.AbsoluteSize.X;
			if width <= 0 then return end;

			fitLogo((isCollapsed or width < 300) ~= appliedCollapsed);
		end);

		WindowSignal.SetBrandOffset = function(x, y, animated)
			if x ~= nil then config.BrandX = x end;
			if y ~= nil then config.BrandY = y end;

			local size = logo.AbsoluteSize.X;
			if size <= 0 then size = WindowSignal.LogoSize or LogoBaseSize end;

			local gap = isCollapsed and 8 or config.LogoGap;
			local target = UDim2.new(0, textX(size, gap), 0, config.BrandY);

			if animated == false then
				BrandText.Position = target;
				layoutBrand();
				return;
			end

			stopTweens();

			local textTween = UI.tw(BrandText, TweenInfo.new(config.LogoAnimTime or 0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = target,
			});
			table.insert(tweens, textTween);
			textTween:Play();
		end;

		WindowSignal.FitLogo = fitLogo;
	end

	task.defer(layoutBrand);

	local HeaderRight = UI.new("Frame", {
		Parent = Header,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.new(0, 0, 0, HeaderH),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		ZIndex = 21,
	});
	UI.list(HeaderRight, {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 8),
	});

	local SearchFrame = UI.new("Frame", {
		Parent = HeaderRight,
		BackgroundColor3 = P.SurfaceAlt,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(210, 32),
		ClipsDescendants = true,
		LayoutOrder = 2,
		ZIndex = 22,
	});
	UI.corner(SearchFrame, D.Radius.sm);
	local SearchStroke = UI.stroke(SearchFrame, 0.88);

	local SearchIcon = UI.image({
		Parent = SearchFrame,
		Image = NeverZen:GetIcon("search"),
		Color = P.TextMuted,
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(0, 11, 0.5, 0),
	});
	SearchIcon.ZIndex = 23;

	local SearchBox = UI.new("TextBox", {
		Parent = SearchFrame,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 32, 0, 0),
		Size = UDim2.new(1, -44, 1, 0),
		PlaceholderText = "Search...",
		PlaceholderColor3 = P.TextMuted,
		Text = "",
		TextColor3 = P.TextSoft,
		TextSize = 12.5,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		ZIndex = 23,
	});
	UI.weight(SearchBox, FW.Medium);

	bind(SearchBox:GetPropertyChangedSignal("Text"), function()
		local text = SearchBox.Text;
		local query = (text and text:byte()) and text or nil;
		WindowSignal.LastSearch = query;
		if WindowSignal.SelectedTab and WindowSignal.SelectedTab.Search then
			WindowSignal.SelectedTab.Search(query);
		end
	end);

	local SearchResults = UI.new("Frame", {
		Name = "SearchResults",
		Parent = Content,
		BackgroundColor3 = P.Surface,
		BackgroundTransparency = 0.03,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(260, 0),
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 300,
	});
	UI.corner(SearchResults, D.Radius.sm);
	UI.stroke(SearchResults, 0.82);

	local SearchResultScroll = UI.new("ScrollingFrame", {
		Parent = SearchResults,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(4, 4),
		Size = UDim2.new(1, -8, 1, -8),
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = P.White,
		ScrollBarImageTransparency = 0.85,
		ZIndex = 301,
	});
	UI.list(SearchResultScroll, { Padding = UDim.new(0, 2) });

	local searchOpen = false;

	local function closeSearchResults()
		if not searchOpen then return end;
		searchOpen = false;
		UI.tween(SearchResults, 0.12, { Size = UDim2.fromOffset(260, 0) });
		task.delay(0.14, function()
			if SearchResults.Parent and not searchOpen then SearchResults.Visible = false end;
		end);
	end

	local function positionSearchResults()
		if not searchOpen then return end;
		local abs = SearchFrame.AbsolutePosition;
		local size = SearchFrame.AbsoluteSize;
		local viewport = workspace.CurrentCamera.ViewportSize;
		SearchResults.Position = UDim2.fromOffset(
			math.clamp(abs.X + size.X - 260, 8, math.max(8, viewport.X - 268)),
			abs.Y + size.Y + 6
		);
	end

	registerPopup({
		close = closeSearchResults,
		update = positionSearchResults,
		panel = SearchResults,
	});

	local function collectMatches(query)
		local out = {};
		if not query or #query == 0 then return out end;
		for _, tabEntry in ipairs(WindowSignal.Tabs) do
			if tabEntry.Records and tabEntry.Config then
				for _, record in ipairs(tabEntry.Records) do
					if record.Frame and record.Frame.Parent then
						if string.find(string.lower(record.Name), query, 1, true) then
							table.insert(out, { Tab = tabEntry, Record = record });
						end
					end
				end
			end
		end
		return out;
	end

	local function flashRecord(record)
		local label = record.Label;
		if not label or not label.Parent then return end;
		UI.tween(label, 0.14, { TextColor3 = P.White });
		task.delay(0.45, function()
			if label.Parent then
				UI.tween(label, 0.3, { TextColor3 = P.TextDim });
			end
		end);
	end

	local function scrollToRecord(record)
		local scrolling = record.Frame:FindFirstAncestorOfClass("ScrollingFrame");
		if not scrolling then return end;
		local ok, target = pcall(function()
			return scrolling.CanvasPosition.Y
				+ (record.Frame.AbsolutePosition.Y - scrolling.AbsolutePosition.Y)
				- 40;
		end);
		if ok and typeof(target) == "number" then
			pcall(function()
				scrolling.CanvasPosition = Vector2.new(0, math.max(target, 0));
			end);
		end
	end

	local searchRows = {};
	local searchIndex = 0;

	local function paintSearchRow(row, active)
		UI.tween(row.Frame, 0.14, { BackgroundTransparency = active and 0.9 or 1 });
		if row.NameLabel then
			UI.tween(row.NameLabel, 0.14, { TextColor3 = active and P.Text or P.TextSoft });
		end
	end

	local function setSearchIndex(index)
		if #searchRows == 0 then return end;
		index = math.clamp(index, 1, #searchRows);
		searchIndex = index;
		for position, row in ipairs(searchRows) do
			paintSearchRow(row, position == index);
		end
		local target = searchRows[index];
		if target and SearchResultScroll then
			pcall(function()
				SearchResultScroll.CanvasPosition = Vector2.new(0, math.max((index - 1) * 30 - 30, 0));
			end);
		end
	end

	local function activateSearchIndex()
		local row = searchRows[searchIndex];
		if row and row.Activate then
			row.Activate();
		end
	end

	local function buildSearchResults(query)
		for _, child in ipairs(SearchResultScroll:GetChildren()) do
			if child:IsA("Frame") then child:Destroy() end;
		end
		searchRows = {};
		searchIndex = 0;

		local matches = collectMatches(query);

		if #matches == 0 then
			local Empty = UI.new("Frame", {
				Parent = SearchResultScroll,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 28),
				ZIndex = 302,
			});
			local EmptyLabel = UI.text({
				Parent = Empty,
				Size = UDim2.fromScale(1, 1),
				Text = "Nothing found",
				Color = P.TextMuted,
				Size_ = 11.5,
				XAlign = Enum.TextXAlignment.Center,
				Weight = FW.Medium,
			});
			EmptyLabel.ZIndex = 303;
			return 0;
		end

		for index, match in ipairs(matches) do
			if index > 40 then break end;

			local Row = UI.new("Frame", {
				Parent = SearchResultScroll,
				BackgroundColor3 = P.White,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 30),
				ZIndex = 302,
			});
			UI.corner(Row, D.Radius.xs);

			local loweredName = string.lower(match.Record.Name);
			local s1, e1 = string.find(loweredName, query, 1, true);
			local NameLabel = UI.text({
				Parent = Row,
				RichText = s1 ~= nil,
				Text = s1
					and (string.sub(match.Record.Name, 1, s1 - 1)
						.. '<font color="#FFFFFF">'
						.. string.sub(match.Record.Name, s1, e1)
						.. '</font>'
						.. string.sub(match.Record.Name, e1 + 1))
					or match.Record.Name,
				Position = UDim2.new(0, 9, 0, 5),
				Size = UDim2.new(1, -18, 0, 14),
				Color = P.TextSoft,
				Size_ = 11.5,
				Weight = FW.Medium,
			});
			NameLabel.ZIndex = 303;

			local tabName = match.Tab.Config and match.Tab.Config.Name or "Tab";
			local HintLabel = UI.text({
				Parent = Row,
				Text = tostring(tabName),
				Position = UDim2.new(0, 9, 0, 17),
				Size = UDim2.new(1, -18, 0, 12),
				Color = P.TextMuted,
				Size_ = 10,
				Weight = FW.Medium,
			});
			HintLabel.ZIndex = 303;

			NeverZen:Hover(Row, function()
				UI.tween(Row, 0.12, { BackgroundTransparency = 0.9 });
				UI.tween(NameLabel, 0.12, { TextColor3 = P.Text });
			end, function()
				local active = false;
				for _, entry in ipairs(searchRows) do
					if entry.Frame == Row and searchRows[searchIndex] == entry then active = true end;
				end
				UI.tween(Row, 0.14, { BackgroundTransparency = active and 0.9 or 1 });
				UI.tween(NameLabel, 0.14, { TextColor3 = active and P.Text or P.TextSoft });
			end);

			local function activateMatch()
				if destroyed then return end;
				WindowSignal:SelectTab(match.Tab);
				task.defer(function()
					if WindowSignal.SelectedTab ~= match.Tab then return end;
					pcall(function() match.Tab.Search(SearchBox.Text) end);
					task.delay(0.12, function()
						scrollToRecord(match.Record);
						flashRecord(match.Record);
					end);
				end);
				closeSearchResults();
			end

			local hit = NeverZen:NewInput(Row);
			hit.MouseButton1Click:Connect(activateMatch);

			if index <= 40 then
				table.insert(searchRows, {
					Frame = Row,
					NameLabel = NameLabel,
					Activate = activateMatch,
				});
			end
		end

		return #matches;
	end

	function WindowSignal:UpdateSearchResults(query)
		if destroyed then return end;
		if not query or #query == 0 then
			closeSearchResults();
			return;
		end

		local total = buildSearchResults(query);
		searchOpen = true;
		if #searchRows > 0 then
			setSearchIndex(1);
		end
		SearchResults.Visible = true;
		positionSearchResults();
		local height = math.clamp(total * 32 + 8, 40, 210);
		UI.tween(SearchResults, 0.16, { Size = UDim2.fromOffset(260, height) }, Enum.EasingStyle.Quint);
	end;

	bind(WindowFrame:GetPropertyChangedSignal("AbsolutePosition"), function()
		positionSearchResults();
	end);

	bind(Services.UserInputService.InputBegan, function(input)
		if destroyed or not searchOpen then return end;
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
		if NeverZen:IsMouseOverFrame(SearchResults) or NeverZen:IsMouseOverFrame(SearchFrame) then return end;
		closeSearchResults();
	end);

	bind(Services.UserInputService.InputBegan, function(input)
		if destroyed then return end;
		if WindowSignal.Toggle == false then return end;
		if WindowSignal.BindingKey then return end;

		local key = input.KeyCode;

		if key == Enum.KeyCode.F then
			local controlDown = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
				or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);
			if controlDown then
				pcall(function() SearchBox:CaptureFocus() end);
			end
			return;
		end

		if key == Enum.KeyCode.Escape then
			pcall(function() SearchBox:ReleaseFocus() end);
			return;
		end

		if not searchOpen or #searchRows == 0 then return end;

		if key == Enum.KeyCode.Down then
			setSearchIndex((searchIndex % #searchRows) + 1);
		elseif key == Enum.KeyCode.Up then
			setSearchIndex(searchIndex - 1 < 1 and #searchRows or searchIndex - 1);
		elseif key == Enum.KeyCode.Return or key == Enum.KeyCode.KeypadEnter then
			activateSearchIndex();
		end
	end);

	local function headerButton(icon, tooltip, order)
		local Button = UI.new("TextButton", {
			Parent = HeaderRight,
			BackgroundColor3 = P.White,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(30, 30),
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = order or 3,
			ZIndex = 22,
		});
		UI.corner(Button, D.Radius.sm);

		local Icon = UI.image({
			Parent = Button,
			Image = NeverZen:GetIcon(icon),
			Color = P.TextDim,
			Size = UDim2.fromOffset(15, 15),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
		});
		Icon.ZIndex = 23;

		UI.interact(Button, {
			Hover = { BackgroundTransparency = 0.9, BackgroundColor3 = P.White },
			Idle = { BackgroundTransparency = 1 },
		});

		bind(Button.MouseEnter, function()
			UI.tween(Icon, 0.14, { ImageColor3 = P.Text });
		end);
		bind(Button.MouseLeave, function()
			UI.tween(Icon, 0.16, { ImageColor3 = P.TextDim });
		end);

		return Button, Icon;
	end;

	local MinButton, MinIcon = headerButton("minus", "Minimize", 3);
	local CloseButton, CloseIcon = headerButton("x", "Close", 4);

	local HeaderLine = UI.new("Frame", {
		Parent = WindowFrame,
		BackgroundColor3 = P.Line,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, HeaderH - 1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = 19,
	});
	table.insert(WindowSignal.FrameMemory.LineColor, HeaderLine);

	local SidebarW = D.SidebarW;

	local Body = UI.new("Frame", {
		Name = "Body",
		Parent = WindowFrame,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, HeaderH),
		Size = UDim2.new(1, 0, 1, -HeaderH),
		ZIndex = 10,
	});

	local Sidebar = UI.new("Frame", {
		Name = "Sidebar",
		Parent = Body,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(SidebarW, 0),
		ZIndex = 10,
	});
	Sidebar.Size = UDim2.new(0, SidebarW, 1, 0);

	local SidebarLine = UI.new("Frame", {
		Parent = Sidebar,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = P.Line,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 1, 1, 0),
		ZIndex = 11,
	});
	table.insert(WindowSignal.FrameMemory.LineColor, SidebarLine);

	local TBSFrame = UI.new("ScrollingFrame", {
		Name = "Tabs",
		Parent = Sidebar,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 8),
		Size = UDim2.new(1, 0, 1, -84),
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		ScrollBarImageTransparency = 1,
		ZIndex = 11,
		Active = true,
	});
	UI.padding(TBSFrame, 2, 10, 2, 10);
	local TabListLayout = UI.list(TBSFrame, { Padding = UDim.new(0, 3) });

	local Footer = UI.new("Frame", {
		Name = "Footer",
		Parent = Sidebar,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 64),
		ZIndex = 11,
	});

	local FooterLine = UI.new("Frame", {
		Parent = Footer,
		BackgroundColor3 = P.Line,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -20, 0, 1),
		Position = UDim2.fromOffset(10, 0),
		ZIndex = 12,
	});
	table.insert(WindowSignal.FrameMemory.LineColor, FooterLine);

	local ProfileIcon = UI.new("ImageLabel", {
		Parent = Footer,
		BackgroundColor3 = P.SurfaceAlt,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 12, 0.5, 6),
		Size = UDim2.fromOffset(28, 28),
		Image = "",
		ZIndex = 12,
	});
	UI.pill(ProfileIcon);
	UI.stroke(ProfileIcon, 0.86);
	pcall(function()
		ProfileIcon.Image = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);
	end);

	local UsernameText = UI.text({
		Parent = Footer,
		Position = UDim2.new(0, 48, 0.5, 6),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(1, -60, 0, 28),
		Text = string.sub(LocalPlayer.DisplayName, 1, math.round(#LocalPlayer.DisplayName / 2)) .. string.rep("*", math.round(#LocalPlayer.DisplayName / 2)),
		Color = P.TextSoft,
		Size_ = 12.5,
		Weight = FW.SemiBold,
	});
	UsernameText.TextSize = 12.5;
	UsernameText.ZIndex = 12;

	local SettingsLabeled = config.SettingsLabel ~= false;

	local SettingsButton = UI.new("TextButton", {
		Parent = HeaderRight,
		Name = "SettingsButton",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		LayoutOrder = 1,
		Size = UDim2.fromOffset(SettingsLabeled and 94 or 30, 30),
		BackgroundColor3 = SettingsLabeled and P.SurfaceAlt or P.White,
		BackgroundTransparency = SettingsLabeled and 0.55 or 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 12,
	});
	UI.corner(SettingsButton, D.Radius.sm);
	WindowSignal.KeepOpaque[SettingsButton] = true;

	local SettingsStroke = SettingsLabeled and UI.stroke(SettingsButton, 0.9) or nil;

	local SettingsIcon = UI.image({
		Parent = SettingsButton,
		Image = NeverZen:GetIcon("settings"),
		Color = P.TextDim,
		Size = UDim2.fromOffset(15, 15),
		Position = SettingsLabeled and UDim2.new(0, 11, 0.5, 0) or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = SettingsLabeled and Vector2.new(0, 0.5) or Vector2.new(0.5, 0.5),
	});
	SettingsIcon.ZIndex = 13;

	local SettingsText = nil;
	if SettingsLabeled then
		SettingsText = UI.text({
			Parent = SettingsButton,
			Position = UDim2.new(0, 32, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(1, -38, 1, 0),
			Text = "Settings",
			Color = P.TextDim,
			Size_ = 11.5,
			Weight = FW.SemiBold,
		});
		SettingsText.ZIndex = 13;
	end

	UI.interact(SettingsButton, {
		Hover = SettingsLabeled
			and { BackgroundTransparency = 0.15, BackgroundColor3 = P.SurfaceAlt }
			or { BackgroundTransparency = 0.9, BackgroundColor3 = P.White },
		Idle = SettingsLabeled
			and { BackgroundTransparency = 0.55, BackgroundColor3 = P.SurfaceAlt }
			or { BackgroundTransparency = 1 },
	});
	bind(SettingsButton.MouseEnter, function()
		UI.tween(SettingsIcon, 0.14, { ImageColor3 = P.Text });
		if SettingsText then UI.tween(SettingsText, 0.14, { TextColor3 = P.Text }) end;
		if SettingsStroke then UI.tween(SettingsStroke, 0.14, { Transparency = 0.8 }) end;
	end);
	bind(SettingsButton.MouseLeave, function()
		UI.tween(SettingsIcon, 0.16, { ImageColor3 = P.TextDim });
		if SettingsText then UI.tween(SettingsText, 0.16, { TextColor3 = P.TextDim }) end;
		if SettingsStroke then UI.tween(SettingsStroke, 0.16, { Transparency = 0.9 }) end;
	end);

	SettingsButton.Visible = false;
	SettingsButton.BackgroundTransparency = 1;
	SettingsIcon.ImageTransparency = 1;
	if SettingsText then SettingsText.TextTransparency = 1 end;
	if SettingsStroke then SettingsStroke.Transparency = 1 end;

	local TabWin = UI.new("Frame", {
		Name = "TabWin",
		Parent = Body,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(SidebarW, 0),
		Size = UDim2.new(1, -SidebarW, 1, 0),
		ClipsDescendants = true,
		ZIndex = 10,
	});

	local function makeItemRecord(frame, name, section)
		return { Frame = frame, Name = tostring(name or ""), Section = section };
	end;

	local TabIndex = 0;

	function WindowSignal:AddTab(config)
		config = NeverZen:CloneConfig(config);
		config.Name = config.Name or 'Example';
		config.Icon = config.Icon or "target";
		config.SingleMode = config.SingleMode or false;

		TabIndex += 1;
		local myOrder = TabIndex;

		local TabSignal = {};
		local records = {};
		local pages = {};
		local subtabButtons = {};

		local TabButton = UI.new("Frame", {
			Name = NeverZen:RandomString(),
			Parent = TBSFrame,
			BackgroundColor3 = P.White,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 34),
			ZIndex = 12,
			LayoutOrder = myOrder,
			ClipsDescendants = true,
		});
		UI.corner(TabButton, D.Radius.sm);

		local ActiveBar = UI.new("Frame", {
			Parent = TabButton,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundColor3 = P.White,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(2, 16),
			ZIndex = 14,
		});
		UI.pill(ActiveBar);

		local TabIcon = UI.image({
			Parent = TabButton,
			Image = NeverZen:GetIcon(config.Icon),
			Color = P.TextMuted,
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.new(0, 12, 0.5, 0),
		});
		TabIcon.ZIndex = 13;

		local TabName = UI.text({
			Parent = TabButton,
			Position = UDim2.new(0, 38, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(1, -50, 0, 18),
			Text = config.Name,
			Color = P.TextDim,
			Size_ = 13,
			Weight = FW.Medium,
		});
		TabName.TextSize = 13;
		TabName.ZIndex = 13;

		local TabFrame = UI.new("Frame", {
			Name = NeverZen:RandomString(),
			Parent = TabWin,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 11,
			Visible = false,
		});

		local SubTabBar = UI.new("Frame", {
			Name = "SubTabs",
			Parent = TabFrame,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(14, 12),
			Size = UDim2.new(1, -28, 0, 30),
			Visible = false,
			ZIndex = 12,
		});
		UI.list(SubTabBar, {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 6),
		});

		local function makePage()
			local Page = UI.new("Frame", {
				Name = "Page",
				Parent = TabFrame,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, 0),
				Size = UDim2.fromScale(1, 1),
				ZIndex = 12,
				Visible = false,
			});

			local Scroll = UI.new("ScrollingFrame", {
				Name = "Scroll",
				Parent = Page,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				CanvasSize = UDim2.fromOffset(0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = P.White,
				ScrollBarImageTransparency = 0.82,
				ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
				ScrollingEnabled = true,
				ZIndex = 12,
			});
			UI.padding(Scroll, 14, 12, 14, 14);

			local ScrollLayout = UI.list(Scroll, {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, D.CardGap),
			});

			local function makeColumn(order)
				local Column = UI.new("Frame", {
					Name = "Column",
					Parent = Scroll,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0.5, -6, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					ZIndex = 12,
					LayoutOrder = order,
				});
				UI.list(Column, { Padding = UDim.new(0, D.CardGap) });
				return Column;
			end;

			local LeftFrame = makeColumn(1);
			local RightFrame = makeColumn(2);

			local Veil = UI.new("Frame", {
				Name = "Veil",
				Parent = Page,
				BackgroundColor3 = P.Window,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				Visible = false,
				ZIndex = 30,
			});

			local page = {
				Frame = Page,
				Scroll = Scroll,
				ScrollLayout = ScrollLayout,
				Left = LeftFrame,
				Right = RightFrame,
				Veil = Veil,
				Tweens = {},
			};

			local singleMode = nil;
			local function applyLayout()
				local width = WindowFrame.AbsoluteSize.X;
				local wantSingle = config.SingleMode or (width > 0 and width < NeverZen.MinimumTabSize);

				if wantSingle == singleMode then

					if not singleMode then
						LeftFrame.Size = UDim2.new(0.5, -D.CardGap / 2, 0, 0);
						RightFrame.Size = UDim2.new(0.5, -D.CardGap / 2, 0, 0);
					else
						LeftFrame.Size = UDim2.new(1, 0, 0, 0);
						RightFrame.Size = UDim2.new(1, 0, 0, 0);
					end
					WindowSignal:UpdatePopups();
					return;
				end;
				singleMode = wantSingle;

				if singleMode then
					ScrollLayout.FillDirection = Enum.FillDirection.Vertical;
					LeftFrame.Size = UDim2.new(1, 0, 0, 0);
					RightFrame.Size = UDim2.new(1, 0, 0, 0);
					ScrollLayout.Padding = UDim.new(0, D.CardGap);
				else
					ScrollLayout.FillDirection = Enum.FillDirection.Horizontal;
					LeftFrame.Size = UDim2.new(0.5, -D.CardGap / 2, 0, 0);
					RightFrame.Size = UDim2.new(0.5, -D.CardGap / 2, 0, 0);
					ScrollLayout.Padding = UDim.new(0, D.CardGap);
				end;

				WindowSignal:UpdatePopups();
			end;

			bind(Scroll:GetPropertyChangedSignal("AbsoluteSize"), applyLayout);
			table.insert(tabLayouts, applyLayout);
			page.applyLayout = applyLayout;

			return page;
		end;

		local SUBTAB_BAR_H = 50;

		local function layoutPages()
			local offset = SubTabBar.Visible and SUBTAB_BAR_H or 0;
			for _, entry in ipairs(pages) do
				local frame = entry.page.Frame;
				if frame then
					frame.Position = UDim2.fromOffset(0, offset);
					frame.Size = UDim2.new(1, 0, 1, -offset);
				end
			end
			for _, apply in ipairs(tabLayouts) do apply(); end
		end

		local defaultPage = nil;
		local currentPage = nil;

		local function clearPageTweens(page)
			for i = #page.Tweens, 1, -1 do
				local tween = page.Tweens[i];
				table.remove(page.Tweens, i);
				pcall(function() tween:Cancel() end);
			end
		end;

		local function animatePageIn(page, direction)
			if not page or not page.Veil then return end;
			local wconf = WindowSignal.Config or config;
			if wconf.Animations == false then return end;

			clearPageTweens(page);

			local duration = wconf.PageAnimTime or 0.26;

			local fromX, fromY = 0, 0;
			if direction == "up" then
				fromY = 14;
			elseif direction == "left" then
				fromX = 16;
			elseif direction == "right" then
				fromX = -16;
			end

			if fromX ~= 0 or fromY ~= 0 then
				page.Scroll.Position = UDim2.fromOffset(fromX, fromY);
				local slide = UI.tw(page.Scroll, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					Position = UDim2.fromOffset(0, 0),
				});
				table.insert(page.Tweens, slide);
				slide:Play();
			end

			page.Veil.Visible = false;
			page.Veil.BackgroundTransparency = 1;
		end;

		WindowSignal.AnimatePage = animatePageIn;

		local function animateCardsIn(page)
			if not page or not page.Left or not page.Right then return end;
			local wconf = WindowSignal.Config or config;
			if wconf.Animations == false then return end;

			local base = math.clamp(
				(wconf.Transparency or 0.18) + (wconf.CardTransparency or 0.37),
				0,
				0.95
			);

			local cards = {};
			for _, column in ipairs({ page.Left, page.Right }) do
				for _, child in ipairs(column:GetChildren()) do
					if child:IsA("Frame") then
						table.insert(cards, child);
					end
				end
			end

			for index, card in ipairs(cards) do
				card.BackgroundTransparency = math.min(base + 0.45, 1);
				task.delay((index - 1) * 0.035, function()
					if destroyed or not card.Parent then return end;
					UI.tween(card, 0.34, {
						BackgroundTransparency = base,
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
				end);
			end
		end

		WindowSignal.AnimateCards = animateCardsIn;

		local function setPage(page, visible)
			if not page then return end;
			page.Frame.Visible = visible;
			if visible then
				task.defer(page.applyLayout);
				animateCardsIn(page);
			elseif page.Veil then
				clearPageTweens(page);
				page.Veil.Visible = false;
				page.Veil.BackgroundTransparency = 1;
				page.Scroll.Position = UDim2.fromOffset(0, 0);
			end
		end;

		local function pageIndex(target)
			for index, entry in ipairs(pages) do
				if entry.page == target then
					return index;
				end
			end
			return nil;
		end;

		local function selectPage(page)
			local previous = currentPage;
			currentPage = page;
			for _, p in ipairs(pages) do
				setPage(p.page, p.page == page);
			end

			local from = pageIndex(previous);
			local to = pageIndex(page);
			local direction = "left";
			if from and to then
				direction = (to >= from) and "left" or "right";
			end

			animatePageIn(page, direction);
			for _, entry in ipairs(subtabButtons) do
				local isActive = entry.page == page;
				UI.tween(entry.Button, 0.22, {
					BackgroundTransparency = isActive and 0.9 or 1,
					BackgroundColor3 = P.White,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
				UI.tween(entry.Label, 0.22, {
					TextColor3 = isActive and P.Text or P.TextDim,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
				UI.tween(entry.Indicator, 0.26, {
					BackgroundTransparency = isActive and 0.15 or 1,
					Size = isActive and UDim2.fromOffset(18, 2) or UDim2.fromOffset(10, 2),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
			end
		end

		local SectionOrder = 0;

		local function buildSection(page, Config)
			Config = NeverZen:CloneConfig(Config);
			Config.Name = Config.Name or "Section";
			Config.Position = Config.Position or "left";

			SectionOrder += 1;

			local SectionSignal = {};
			local itemForSearch = records;

			local Section = UI.new("Frame", {
				Name = NeverZen:RandomString(),
				Parent = (string.lower(tostring(Config.Position)) == "left" and page.Left) or page.Right,
				BackgroundColor3 = P.Surface,
				BackgroundTransparency = math.clamp(
					(WindowSignal.Config and WindowSignal.Config.Transparency or 0.18)
					+ (WindowSignal.Config and WindowSignal.Config.CardTransparency or 0.37),
					0,
					0.95
				),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				ClipsDescendants = true,
				ZIndex = 13,
				LayoutOrder = SectionOrder,
			});
			UI.corner(Section, D.Radius.md);
			table.insert(WindowSignal.TransparencyCards, Section);
			local SectionStroke = UI.gradientStroke(Section, {
				Transparency = 0.70,
				Thickness = 1,
				Rotation = 45,
				Speed = 22,
				TransparencySequence = NumberSequence.new({
					NumberSequenceKeypoint.new(0.00, 0.00),
					NumberSequenceKeypoint.new(0.25, 0.38),
					NumberSequenceKeypoint.new(0.50, 0.62),
					NumberSequenceKeypoint.new(0.75, 0.38),
					NumberSequenceKeypoint.new(1.00, 0.00),
				}),
			});

			UI.padding(Section, 12, 12, 10, 12);
			local SectionList = UI.list(Section, { Padding = UDim.new(0, 2) });

			local ActiveParent = Section;

			local head = UI.new("Frame", {
				Name = "head",
				Parent = Section,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 26),
				ZIndex = 14,
				LayoutOrder = -1000,
			});

			local HeadIcon = UI.image({
				Parent = head,
				Image = NeverZen:GetIcon(Config.Icon or "circle"),
				Color = P.TextMuted,
				Size = UDim2.fromOffset(14, 14),
				Position = UDim2.new(0, 0, 0.5, -4),
			});
			HeadIcon.ZIndex = 15;

			local Label = UI.text({
				Parent = head,
				Position = UDim2.new(0, 22, 0.5, -4),
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(1, -22, 0, 18),
				Text = Config.Name,
				Color = P.TextSoft,
				Size_ = 13,
				Weight = FW.SemiBold,
			});
			Label.TextSize = 13;
			Label.ZIndex = 15;

			local HeadLine = UI.new("Frame", {
				Parent = head,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = P.Line,
				BackgroundTransparency = 0.94,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				ZIndex = 15,
			});

			local RowOrder = 0;
			local function nextOrder()
				RowOrder += 1;
				return RowOrder * 10;
			end

			local function makeRow(height, name)
				local Row = UI.new("Frame", {
					Name = NeverZen:RandomString(),
					Parent = ActiveParent,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, height),
					ZIndex = 14,
					LayoutOrder = nextOrder(),
				});
				if name then
					table.insert(itemForSearch, makeItemRecord(Row, name, Section));
				end
				SectionSignal._lastRow = Row;
				return Row;
			end

			local function rowLabel(Row, name, rightPadding)
				return UI.text({
					Parent = Row,
					Position = UDim2.new(0, 2, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(1, -(rightPadding or 90), 0, 18),
					Text = name,
					Color = P.TextDim,
					Size_ = 13,
					Weight = FW.Medium,
				});
			end

			local function attachDescription(Row, description, anchorRightOffset)
				local InfoBtn = UI.new("Frame", {
					Parent = Row,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -(anchorRightOffset or 62), 0.5, 0),
					Size = UDim2.fromOffset(14, 14),
					BackgroundColor3 = P.SurfaceHigh,
					BackgroundTransparency = 0.2,
					BorderSizePixel = 0,
					ZIndex = 16,
				});
				UI.pill(InfoBtn);
				UI.stroke(InfoBtn, 0.8);

				local InfoLabel = UI.text({
					Parent = InfoBtn,
					Size = UDim2.fromScale(1, 1),
					Text = "i",
					Color = P.TextDim,
					Size_ = 10,
					XAlign = Enum.TextXAlignment.Center,
					Weight = FW.Bold,
				});
				InfoLabel.TextSize = 10;
				InfoLabel.ZIndex = 17;

				local Tooltip = UI.new("Frame", {
					Parent = Content,
					BackgroundColor3 = P.SurfaceAlt,
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(220, 0),
					ClipsDescendants = true,
					Visible = false,
					ZIndex = 400,
				});
				UI.corner(Tooltip, D.Radius.sm);
				UI.stroke(Tooltip, 0.82);

				local TooltipLabel = UI.text({
					Parent = Tooltip,
					Position = UDim2.fromOffset(10, 8),
					Size = UDim2.new(1, -20, 1, -16),
					Text = description,
					Color = P.TextSoft,
					Size_ = 11.5,
					Wrapped = true,
					YAlign = Enum.TextYAlignment.Top,
					Weight = FW.Regular,
				});
				TooltipLabel.TextSize = 11.5;
				TooltipLabel.ZIndex = 401;

				local textHeight = TextService:GetTextSize(description, 12, FONT.Gotham, Vector2.new(200, math.huge)).Y + 16;

				local input = NeverZen:NewInput(InfoBtn);
				input.MouseEnter:Connect(function()
					if destroyed then return end;
					local abs = InfoBtn.AbsolutePosition;
					Tooltip.Position = UDim2.fromOffset(
						math.clamp(abs.X - 104, 8, workspace.CurrentCamera.ViewportSize.X - 232),
						abs.Y - textHeight - 8
					);
					Tooltip.Visible = true;
					UI.tween(Tooltip, 0.15, { Size = UDim2.fromOffset(220, textHeight) });
					UI.tween(InfoBtn, 0.12, { BackgroundColor3 = P.White, BackgroundTransparency = 0.1 });
					UI.tween(InfoLabel, 0.12, { TextColor3 = P.OnAccent });
				end);
				input.MouseLeave:Connect(function()
					UI.tween(Tooltip, 0.12, { Size = UDim2.fromOffset(220, 0) });
					task.delay(0.13, function()
						if Tooltip.Parent then Tooltip.Visible = false end;
					end);
					UI.tween(InfoBtn, 0.14, { BackgroundColor3 = P.SurfaceHigh, BackgroundTransparency = 0.2 });
					UI.tween(InfoLabel, 0.14, { TextColor3 = P.TextDim });
				end);

				return InfoBtn;
			end;

			local function makePill(Row, minWidth)
				local Pill = UI.new("Frame", {
					Parent = Row,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(minWidth or 60, 26),
					BackgroundColor3 = P.SurfaceAlt,
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					ZIndex = 15,
				});
				UI.corner(Pill, D.Radius.xs);
				local PillStroke = UI.stroke(Pill, 0.9);

				local PillText = UI.text({
					Parent = Pill,
					Position = UDim2.fromOffset(9, 0),
					Size = UDim2.new(1, -26, 1, 0),
					Text = "",
					Color = P.TextSoft,
					Size_ = 12,
					Weight = FW.Medium,
				});
				PillText.TextSize = 12;
				PillText.ZIndex = 16;

				local Chevron = UI.image({
					Parent = Pill,
					Image = NeverZen:GetIcon("chevron-down"),
					Color = P.TextMuted,
					Size = UDim2.fromOffset(12, 12),
					Position = UDim2.new(1, -8, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
				});
				Chevron.ZIndex = 16;

				return Pill, PillText, Chevron, PillStroke;
			end

			local function sizePill(Pill, PillText, Chevron, extra)
				local textWidth = TextService:GetTextSize(PillText.Text, PillText.TextSize, FONT.GothamMedium, Vector2.new(math.huge, math.huge)).X;
				local width = math.clamp(textWidth + (Chevron.Visible and 32 or 20) + (extra or 0), 50, 150);
				UI.tween(Pill, 0.12, { Size = UDim2.fromOffset(width, 26) });
			end

			function SectionSignal:AddToggle(config)
				local _cfgIn = config or {};
				config = {};
				for k, v in pairs(_cfgIn) do config[k] = v end;

				config.Default = config.Default or false;
				config.Name = config.Name or "Toggle";
				config.Description = config.Description or nil;
				config.Callback = config.Callback or function() end;

				local Toggle = makeRow(34, config.Name);

				local Label = rowLabel(Toggle, config.Name, config.Description and 86 or 66);

				local Switch = UI.new("Frame", {
					Parent = Toggle,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(40, 22),
					BackgroundColor3 = P.White,
					BackgroundTransparency = 0.93,
					BorderSizePixel = 0,
					ZIndex = 15,
				});
				UI.pill(Switch);
				local SwitchStroke = UI.stroke(Switch, 0.88);
				WindowSignal.KeepOpaque[Switch] = true;

				local Knob = UI.new("Frame", {
					Parent = Switch,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 3, 0.5, 0),
					Size = UDim2.fromOffset(16, 16),
					BackgroundColor3 = P.TextDim,
					BorderSizePixel = 0,
					ZIndex = 16,
				});
				UI.pill(Knob);
				WindowSignal.KeepOpaque[Knob] = true;

				if config.Description then
					attachDescription(Toggle, config.Description, 54);
				end

				local KnobScale = Instance.new("UIScale");
				KnobScale.Scale = 1;
				KnobScale.Parent = Knob;

				local enabled = false;
				local function render(value, instant)
					enabled = value and true or false;
					local onPosition = UDim2.new(1, -19, 0.5, 0);
					local offPosition = UDim2.new(0, 3, 0.5, 0);

					if instant then
						Knob.Position = enabled and onPosition or offPosition;
						Switch.BackgroundTransparency = enabled and 0 or 0.93;
						SwitchStroke.Transparency = enabled and 0.5 or 0.88;
						Knob.BackgroundColor3 = enabled and P.OnAccent or P.TextDim;
						Label.TextColor3 = enabled and P.Text or P.TextDim;
						return;
					end

					UI.tween(Knob, 0.3, {
						Position = enabled and onPosition or offPosition,
						BackgroundColor3 = enabled and P.OnAccent or P.TextDim,
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);

					UI.tween(Switch, 0.24, {
						BackgroundTransparency = enabled and 0 or 0.93,
					}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

					UI.tween(SwitchStroke, 0.24, {
						Transparency = enabled and 0.5 or 0.88,
					}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

					UI.tween(Label, 0.28, {
						TextColor3 = enabled and P.Text or P.TextDim,
					}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

					UI.tween(KnobScale, 0.1, { Scale = 0.82 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
					task.delay(0.1, function()
						if destroyed or not Knob.Parent then return end;
						UI.tween(KnobScale, 0.32, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
					end);
				end

				render(config.Default, true);

				WindowSignal.ConfigValues[config.Name] = config.Default;
				WindowSignal.ConfigCallbacks[config.Name] = function(value)
					config.Default = value;
					render(value, false);
					NeverZen.SecureCall(config.Callback, config.Default, config);
				end;

				local input = NeverZen:NewInput(Toggle, function()
					if destroyed then return end;
					config.Default = not config.Default;
					render(config.Default, false);
					NeverZen.SecureCall(config.Callback, config.Default, config);
					WindowSignal.ConfigValues[config.Name] = config.Default;
				end);
				NeverZen:Hover(Toggle, function()
					UI.tween(Label, 0.14, { TextColor3 = P.TextSoft });
					UI.tween(SwitchStroke, 0.18, { Transparency = enabled and 0.36 or 0.76 });
					UI.tween(KnobScale, 0.2, { Scale = 1.1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
				end, function()
					UI.tween(Label, 0.16, { TextColor3 = enabled and P.Text or P.TextDim });
					UI.tween(SwitchStroke, 0.2, { Transparency = enabled and 0.5 or 0.88 });
					UI.tween(KnobScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
				end);

				return {
					SetValue = function(self, newvalue)
						config.Default = newvalue;
						render(newvalue, false);
						NeverZen.SecureCall(config.Callback, config.Default, config);
						WindowSignal.ConfigValues[config.Name] = newvalue;
					end,
					GetValue = function() return config.Default end,
					Visible = function(self, value) Toggle.Visible = value; end,
				}
			end;

			function SectionSignal:AddLabel(name)
				local Label = UI.new("TextLabel", {
					Name = NeverZen:RandomString(),
					Parent = ActiveParent,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 20),
					Text = tostring(name or ""),
					TextColor3 = P.TextMuted,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					ZIndex = 14,
					LayoutOrder = nextOrder(),
				});
				UI.weight(Label, FW.Medium);

				SectionSignal._lastRow = Label;
				table.insert(itemForSearch, makeItemRecord(Label, name, Section));

				return {
					SetValue = function(self, newvalue) Label.Text = tostring(newvalue); end,
					Visible = function(self, value) Label.Visible = value; end,
				}
			end;

			function SectionSignal:AddParagraph(name, text)
				local Paragraph = makeRow(44, name);
				Paragraph.Size = UDim2.new(1, 0, 0, 44);

				local Title = UI.text({
					Parent = Paragraph,
					Position = UDim2.fromOffset(2, 0),
					Size = UDim2.new(1, -4, 0, 18),
					Text = tostring(name or ""),
					Color = P.TextSoft,
					Size_ = 12.5,
					Weight = FW.SemiBold,
				});
				Title.TextSize = 12.5;
				Title.ZIndex = 15;

				local Body = UI.text({
					Parent = Paragraph,
					Position = UDim2.fromOffset(2, 18),
					Size = UDim2.new(1, -4, 0, 24),
					Text = tostring(text or ""),
					Color = P.TextMuted,
					Size_ = 11.5,
					Wrapped = true,
					YAlign = Enum.TextYAlignment.Top,
					Weight = FW.Regular,
				});
				Body.TextSize = 11.5;
				Body.ZIndex = 15;

				return {
					SetValue = function(self, newName, newText)
						Title.Text = tostring(newName or Title.Text);
						Body.Text = tostring(newText or Body.Text);
					end,
					Visible = function(self, value) Paragraph.Visible = value; end,
				}
			end;

			function SectionSignal:AddDivider()
				local Holder = makeRow(9);
				local Line = UI.new("Frame", {
					Parent = Holder,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = P.Line,
					BackgroundTransparency = 0.94,
					BorderSizePixel = 0,
					ZIndex = 14,
				});
				return {
					Visible = function(self, value) Holder.Visible = value; end,
				}
			end;

			function SectionSignal:AddButton(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Button";
				config.Callback = config.Callback or function() end;
				local primary = config.Style == "primary";

				local Button = UI.new("TextButton", {
					Name = NeverZen:RandomString(),
					Parent = ActiveParent,
					BackgroundColor3 = primary and P.White or P.SurfaceAlt,
					BackgroundTransparency = primary and 0 or 0.15,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 32),
					Text = "",
					AutoButtonColor = false,
					ZIndex = 14,
					LayoutOrder = nextOrder(),
				});
				UI.corner(Button, D.Radius.sm);
				local ButtonStroke = UI.stroke(Button, primary and 0.6 or 0.88);
				UI.press(Button, D.Radius.sm);

				local Label = UI.text({
					Parent = Button,
					Size = UDim2.fromScale(1, 1),
					Text = config.Name,
					Color = primary and P.OnAccent or P.TextSoft,
					Size_ = 12.5,
					XAlign = Enum.TextXAlignment.Center,
					Weight = FW.SemiBold,
				});
				Label.TextSize = 12.5;
				Label.ZIndex = 15;

				SectionSignal._lastRow = Button;
				table.insert(itemForSearch, makeItemRecord(Button, config.Name, Section));

				NeverZen:Hover(Button, function()
					UI.tween(Button, 0.14, {
						BackgroundColor3 = primary and P.White or P.SurfaceHigh,
						BackgroundTransparency = primary and 0 or 0,
					});
					UI.tween(ButtonStroke, 0.14, { Transparency = primary and 0.4 or 0.8 });
					UI.tween(Label, 0.14, { TextColor3 = primary and P.OnAccent or P.Text });
				end, function()
					UI.tween(Button, 0.16, {
						BackgroundColor3 = primary and P.White or P.SurfaceAlt,
						BackgroundTransparency = primary and 0 or 0.15,
					});
					UI.tween(ButtonStroke, 0.16, { Transparency = primary and 0.6 or 0.88 });
					UI.tween(Label, 0.16, { TextColor3 = primary and P.OnAccent or P.TextSoft });
				end);
				Button.MouseButton1Down:Connect(function()
					UI.tween(Button, 0.07, { BackgroundTransparency = primary and 0.12 or 0.3 });
				end);

				Button.MouseButton1Click:Connect(function()
					if destroyed then return end;
					NeverZen.SecureCall(config.Callback, config);
				end);

				return {
					SetText = function(self, newvalue) Label.Text = tostring(newvalue); end,
					Fire = config.Callback,
					Visible = function(self, value) Button.Visible = value; end,
				};
			end;

			function SectionSignal:AddSlider(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Slider"
				config.Min = config.Min or 0;
				config.Max = config.Max or 100;
				if config.Max <= config.Min then config.Max = config.Min + 1 end;
				config.Default = config.Default or config.Min;
				config.Round = config.Round or 0;
				config.Type = config.Type or "";
				config.Callback = config.Callback or function() end;

				local Slider = makeRow(46, config.Name);

				local Label = UI.text({
					Parent = Slider,
					Position = UDim2.fromOffset(2, 0),
					Size = UDim2.new(1, -80, 0, 18),
					Text = config.Name,
					Color = P.TextDim,
					Size_ = 13,
					Weight = FW.Medium,
				});
				Label.TextSize = 13;
				Label.ZIndex = 15;

				local LabelValue = UI.text({
					Parent = Slider,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.fromOffset(70, 18),
					Text = tostring(config.Default) .. tostring(config.Type),
					Color = P.TextSoft,
					Size_ = 12,
					XAlign = Enum.TextXAlignment.Right,
					Weight = FW.SemiBold,
				});
				LabelValue.TextSize = 12;
				LabelValue.ZIndex = 15;

				local Track = UI.new("Frame", {
					Parent = Slider,
					Position = UDim2.new(0, 2, 0, 28),
					Size = UDim2.new(1, -4, 0, 4),
					BackgroundColor3 = P.White,
					BackgroundTransparency = 0.9,
					BorderSizePixel = 0,
					ZIndex = 15,
				});
				UI.pill(Track);
				WindowSignal.KeepOpaque[Track] = true;

				local Fill = UI.new("Frame", {
					Parent = Track,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = P.White,
					BackgroundTransparency = 0.05,
					BorderSizePixel = 0,
					ZIndex = 16,
				});
				UI.pill(Fill);
				WindowSignal.KeepOpaque[Fill] = true;

				local Knob = UI.new("Frame", {
					Parent = Track,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.fromOffset(13, 13),
					BackgroundColor3 = P.White,
					BorderSizePixel = 0,
					ZIndex = 17,
				});
				UI.pill(Knob);
				WindowSignal.KeepOpaque[Knob] = true;
				UI.stroke(Knob, 0.55, 1, P.Black);

				local HitFrame = UI.new("Frame", {
					Parent = Slider,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(2, 19),
					Size = UDim2.new(1, -4, 0, 24),
					ZIndex = 16,
				});
				local HitArea = NeverZen:NewInput(HitFrame);
				HitArea.BackgroundTransparency = 1;

				local function normalize(value)
					return math.clamp((value - config.Min) / (config.Max - config.Min), 0, 1);
				end;

				local function paint(normalized, instant)
					if instant then
						Fill.Size = UDim2.new(normalized, 0, 1, 0);
						Knob.Position = UDim2.new(normalized, 0, 0.5, 0);
					else
						UI.tween(Fill, 0.06, { Size = UDim2.new(normalized, 0, 1, 0) });
						UI.tween(Knob, 0.06, { Position = UDim2.new(normalized, 0, 0.5, 0) });
					end
				end

				local function commit(value, fire)
					config.Default = value;
					LabelValue.Text = tostring(value) .. tostring(config.Type);
					paint(normalize(value), false);
					WindowSignal.ConfigValues[config.Name] = value;
					if fire then
						NeverZen.SecureCall(config.Callback, value, config);
					end
				end

				local function updateFromPosition(position)
					local trackAbs = Track.AbsolutePosition;
					local trackSize = Track.AbsoluteSize;
					local ratio = math.clamp((position.X - trackAbs.X) / math.max(trackSize.X, 1), 0, 1);
					local raw = config.Min + (config.Max - config.Min) * ratio;
					commit(NeverZen:Rounding(raw, config.Round), true);
				end

				HitArea.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
					if destroyed then return end;
					UI.tween(Knob, 0.12, { Size = UDim2.fromOffset(16, 16) });
					updateFromPosition(input.Position);
					addDrag({
						update = function(position) updateFromPosition(position) end,
						release = function()
							if Knob.Parent then UI.tween(Knob, 0.14, { Size = UDim2.fromOffset(13, 13) }) end;
						end,
					});
				end);

				HitArea.MouseEnter:Connect(function()
					UI.tween(Label, 0.14, { TextColor3 = P.TextSoft });
					UI.tween(Track, 0.14, { BackgroundTransparency = 0.85 });
				end);
				HitArea.MouseLeave:Connect(function()
					UI.tween(Label, 0.16, { TextColor3 = P.TextDim });
					UI.tween(Track, 0.16, { BackgroundTransparency = 0.9 });
				end);

				paint(normalize(config.Default), true);

				WindowSignal.ConfigValues[config.Name] = config.Default;
				WindowSignal.ConfigCallbacks[config.Name] = function(value)
					config.Default = value;
					LabelValue.Text = tostring(value) .. tostring(config.Type);
					paint(normalize(value), false);
					NeverZen.SecureCall(config.Callback, value, config);
				end;

				return {
					SetValue = function(self, newvalue)
						config.Default = newvalue;
						LabelValue.Text = tostring(newvalue) .. tostring(config.Type);
						paint(normalize(newvalue), false);
						WindowSignal.ConfigValues[config.Name] = newvalue;
					end,
					GetValue = function() return config.Default end,
					Fire = config.Callback,
					Visible = function(self, value) Slider.Visible = value; end,
				};
			end;

			function SectionSignal:AddTextbox(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Textbox";
				config.Default = config.Default or "";
				config.Placeholder = config.Placeholder or config.PlaceholderText or "Type here...";
				config.Callback = config.Callback or function() end;

				local Row = makeRow(34, config.Name);
				rowLabel(Row, config.Name, 150);

				local Box = UI.new("Frame", {
					Parent = Row,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(130, 26),
					BackgroundColor3 = P.SurfaceAlt,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					ZIndex = 15,
				});
				UI.corner(Box, D.Radius.xs);
				local BoxStroke = UI.stroke(Box, 0.9);

				local Input = UI.new("TextBox", {
					Parent = Box,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(9, 0),
					Size = UDim2.new(1, -18, 1, 0),
					Text = tostring(config.Default),
					PlaceholderText = tostring(config.Placeholder),
					PlaceholderColor3 = P.TextMuted,
					TextColor3 = P.TextSoft,
					TextSize = 12,
					ClearTextOnFocus = false,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 16,
				});
				UI.weight(Input, FW.Medium);

				Input.Focused:Connect(function()
					UI.tween(BoxStroke, 0.14, { Transparency = 0.6, Color = P.White });
				end);

				Input.FocusLost:Connect(function(enterPressed)
					UI.tween(BoxStroke, 0.16, { Transparency = 0.9 });
					config.Default = Input.Text;
					WindowSignal.ConfigValues[config.Name] = Input.Text;
					NeverZen.SecureCall(config.Callback, Input.Text, enterPressed and true or false);
				end);

				WindowSignal.ConfigValues[config.Name] = config.Default;
				WindowSignal.ConfigCallbacks[config.Name] = function(value)
					config.Default = value;
					Input.Text = tostring(value);
					NeverZen.SecureCall(config.Callback, Input.Text, false);
				end;

				return {
					SetValue = function(self, newvalue)
						config.Default = newvalue;
						Input.Text = tostring(newvalue);
						WindowSignal.ConfigValues[config.Name] = newvalue;
					end,
					GetValue = function() return Input.Text end,
					Visible = function(self, value) Row.Visible = value; end,
				};
			end

			function SectionSignal:AddSegmented(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Segmented";
				config.Values = config.Values or {};
				config.Default = config.Default or config.Values[1];
				config.Callback = config.Callback or function() end;

				local Row = makeRow(58, config.Name);

				local Head = UI.text({
					Parent = Row,
					Position = UDim2.fromOffset(2, 0),
					Size = UDim2.new(1, -4, 0, 18),
					Text = config.Name,
					Color = P.TextDim,
					Size_ = 13,
					Weight = FW.Medium,
				});
				Head.ZIndex = 15;

				local Track = UI.new("Frame", {
					Parent = Row,
					Position = UDim2.fromOffset(0, 26),
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundColor3 = P.SurfaceAlt,
					BackgroundTransparency = 0.35,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					ZIndex = 15,
				});
				UI.corner(Track, D.Radius.sm);
				UI.stroke(Track, 0.9);
				WindowSignal.KeepOpaque[Track] = true;

				local Indicator = UI.new("Frame", {
					Parent = Track,
					Position = UDim2.fromOffset(1, 1),
					Size = UDim2.new(0, 0, 1, -2),
					BackgroundColor3 = P.White,
					BackgroundTransparency = 0.86,
					BorderSizePixel = 0,
					ZIndex = 16,
				});
				UI.corner(Indicator, D.Radius.xs);
				UI.stroke(Indicator, 0.84);
				WindowSignal.KeepOpaque[Indicator] = true;

				local count = #config.Values;
				local buttons = {};
				local labels = {};
				local current = nil;

				local function indexOf(value)
					for i, v in ipairs(config.Values) do
						if v == value then return i end
					end
					return 1;
				end

				local function paint(index, instant)
					if count <= 0 then return end
					local step = 1 / count;
					local targetSize = UDim2.new(step, -2, 1, -2);
					local targetPos = UDim2.new(step * (index - 1), 1, 0, 1);

					if instant then
						Indicator.Size = targetSize;
						Indicator.Position = targetPos;
					else
						UI.tween(Indicator, 0.18, { Size = targetSize, Position = targetPos });
					end

					for i, item in ipairs(labels) do
						UI.tween(item, 0.16, { TextColor3 = (i == index) and P.Text or P.TextMuted });
					end
				end

				local function commit(value, fire)
					current = value;
					config.Default = value;
					paint(indexOf(value), false);
					WindowSignal.ConfigValues[config.Name] = value;
					if fire then
						NeverZen.SecureCall(config.Callback, value, config);
					end
				end

				for i, value in ipairs(config.Values) do
					local Button = UI.new("TextButton", {
						Parent = Track,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new((i - 1) / count, 0, 0, 0),
						Size = UDim2.new(1 / count, 0, 1, 0),
						Text = "",
						AutoButtonColor = false,
						ZIndex = 17,
					});

					local ItemLabel = UI.text({
						Parent = Button,
						Size = UDim2.fromScale(1, 1),
						Text = tostring(value),
						Color = P.TextMuted,
						Size_ = 11.5,
						Weight = FW.SemiBold,
						XAlign = Enum.TextXAlignment.Center,
					});
					ItemLabel.ZIndex = 18;

					buttons[i] = Button;
					labels[i] = ItemLabel;

					Button.MouseButton1Click:Connect(function()
						if destroyed then return end
						if current ~= value then commit(value, true) end
					end);

					Button.MouseEnter:Connect(function()
						if current ~= value then UI.tween(ItemLabel, 0.14, { TextColor3 = P.TextSoft }) end
					end);
					Button.MouseLeave:Connect(function()
						if current ~= value then UI.tween(ItemLabel, 0.16, { TextColor3 = P.TextMuted }) end
					end);
				end

				if count > 0 then
					commit(config.Default, false);
					paint(indexOf(config.Default), true);
				end

				WindowSignal.ConfigValues[config.Name] = config.Default;
				WindowSignal.ConfigCallbacks[config.Name] = function(value)
					local found = false;
					for _, candidate in ipairs(config.Values) do
						if candidate == value then found = true; break end
					end
					if not found then
						warn("[NeverZen] Segmented '" .. tostring(config.Name) .. "': нет варианта '" .. tostring(value) .. "'");
						return;
					end
					config.Default = value;
					current = value;
					paint(indexOf(value), false);
					NeverZen.SecureCall(config.Callback, value, config);
				end;

				return {
					SetValue = function(self, newvalue)
						commit(newvalue, false);
						WindowSignal.ConfigValues[config.Name] = newvalue;
					end,
					GetValue = function() return config.Default end,
					Fire = config.Callback,
					Visible = function(self, value) Row.Visible = value; end,
				};
			end

			function SectionSignal:AddStepper(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Stepper";
				config.Min = config.Min or 0;
				config.Max = config.Max or 100;
				if config.Max <= config.Min then config.Max = config.Min + 1 end;
				config.Step = config.Step or 1;
				config.Default = config.Default or config.Min;
				config.Round = config.Round or 0;
				config.Type = config.Type or "";
				config.Callback = config.Callback or function() end;

				local Row = makeRow(34, config.Name);
				rowLabel(Row, config.Name, 140);

				local Box = UI.new("Frame", {
					Parent = Row,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(106, 26),
					BackgroundColor3 = P.SurfaceAlt,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					ZIndex = 15,
				});
				UI.corner(Box, D.Radius.xs);
				UI.stroke(Box, 0.9);
				WindowSignal.KeepOpaque[Box] = true;

				local function sideButton(x, icon)
					local Button = UI.new("TextButton", {
						Parent = Box,
						AnchorPoint = Vector2.new(x < 0 and 0 or 1, 0.5),
						Position = UDim2.new(x < 0 and 0 or 1, x < 0 and 3 or -3, 0.5, 0),
						Size = UDim2.fromOffset(20, 20),
						BackgroundColor3 = P.White,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = "",
						AutoButtonColor = false,
						ZIndex = 16,
					});
					UI.corner(Button, D.Radius.xs);

					local Glyph = UI.image({
						Parent = Button,
						Size = UDim2.fromOffset(11, 11),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = NeverZen:GetIcon(icon),
						Color = P.TextMuted,
						ZIndex = 17,
					});
					Glyph.ZIndex = 17;
					return Button, Glyph;
				end

				local Minus, MinusGlyph = sideButton(-1, "minus");
				local Plus, PlusGlyph = sideButton(1, "plus");

				local ValueLabel = UI.text({
					Parent = Box,
					Size = UDim2.new(1, -48, 1, 0),
					Position = UDim2.fromOffset(24, 0),
					Text = tostring(config.Default) .. tostring(config.Type),
					Color = P.TextSoft,
					Size_ = 12,
					Weight = FW.SemiBold,
					XAlign = Enum.TextXAlignment.Center,
				});
				ValueLabel.ZIndex = 17;

				local holding = false;

				local function commit(value, fire)
					value = math.clamp(NeverZen:Rounding(value, config.Round), config.Min, config.Max);
					config.Default = value;
					ValueLabel.Text = tostring(value) .. tostring(config.Type);
					WindowSignal.ConfigValues[config.Name] = value;
					if fire then
						NeverZen.SecureCall(config.Callback, value, config);
					end
				end

				local function step(direction)
					local nextValue = config.Default + config.Step * direction;
					if nextValue > config.Max then nextValue = config.Min end
					if nextValue < config.Min then nextValue = config.Max end
					commit(nextValue, true);
				end

				local function startHold(direction)
					holding = true;
					task.spawn(function()
						task.wait(0.4);
						while holding and not destroyed do
							step(direction);
							task.wait(0.07);
						end
					end);
				end

				Minus.MouseButton1Down:Connect(function()
					holding = false;
					step(-1);
					startHold(-1);
				end);
				Plus.MouseButton1Down:Connect(function()
					holding = false;
					step(1);
					startHold(1);
				end);

				Minus.MouseButton1Up:Connect(function() holding = false end);
				Plus.MouseButton1Up:Connect(function() holding = false end);
				Minus.MouseLeave:Connect(function() holding = false end);
				Plus.MouseLeave:Connect(function() holding = false end);

				Minus.MouseEnter:Connect(function() UI.tween(MinusGlyph, 0.14, { ImageColor3 = P.Text }); end);
				Minus.MouseLeave:Connect(function() UI.tween(MinusGlyph, 0.16, { ImageColor3 = P.TextMuted }); end);
				Plus.MouseEnter:Connect(function() UI.tween(PlusGlyph, 0.14, { ImageColor3 = P.Text }); end);
				Plus.MouseLeave:Connect(function() UI.tween(PlusGlyph, 0.16, { ImageColor3 = P.TextMuted }); end);

				commit(config.Default, false);

				WindowSignal.ConfigCallbacks[config.Name] = function(value)
					commit(value, true);
				end;

				return {
					SetValue = function(self, newvalue)
						commit(newvalue, false);
					end,
					GetValue = function() return config.Default end,
					Fire = config.Callback,
					Visible = function(self, value) Row.Visible = value; end,
				};
			end

			function SectionSignal:AddProgressBar(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Progress";
				config.Min = config.Min or 0;
				config.Max = config.Max or 100;
				config.Default = config.Default or config.Min;
				config.Type = config.Type or "%";

				local Row = makeRow(42, config.Name);

				local Head = UI.text({
					Parent = Row,
					Position = UDim2.fromOffset(2, 0),
					Size = UDim2.new(1, -60, 0, 18),
					Text = config.Name,
					Color = P.TextDim,
					Size_ = 13,
					Weight = FW.Medium,
				});
				Head.ZIndex = 15;

				local ValueText = UI.text({
					Parent = Row,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -2, 0, 0),
					Size = UDim2.fromOffset(60, 18),
					Text = "0" .. tostring(config.Type),
					Color = P.TextSoft,
					Size_ = 12,
					Weight = FW.SemiBold,
					XAlign = Enum.TextXAlignment.Right,
				});
				ValueText.ZIndex = 15;

				local Track = UI.new("Frame", {
					Parent = Row,
					Position = UDim2.fromOffset(2, 26),
					Size = UDim2.new(1, -4, 0, 5),
					BackgroundColor3 = P.White,
					BackgroundTransparency = 0.9,
					BorderSizePixel = 0,
					ZIndex = 15,
				});
				UI.pill(Track);
				WindowSignal.KeepOpaque[Track] = true;

				local Fill = UI.new("Frame", {
					Parent = Track,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = P.White,
					BackgroundTransparency = 0.05,
					BorderSizePixel = 0,
					ZIndex = 16,
				});
				UI.pill(Fill);
				WindowSignal.KeepOpaque[Fill] = true;

				local function normalize(value)
					return math.clamp((value - config.Min) / (config.Max - config.Min), 0, 1);
				end

				local function paint(value, instant)
					local ratio = normalize(value);
					if instant then
						Fill.Size = UDim2.new(ratio, 0, 1, 0);
					else
						UI.tween(Fill, 0.22, { Size = UDim2.new(ratio, 0, 1, 0) });
					end
					ValueText.Text = tostring(NeverZen:Rounding(value, 0)) .. tostring(config.Type);
				end

				paint(config.Default, true);

				return {
					SetValue = function(self, newvalue)
						config.Default = newvalue;
						paint(newvalue, false);
					end,
					SetProgress = function(self, ratio)
						self:SetValue(config.Min + (config.Max - config.Min) * math.clamp(ratio, 0, 1));
					end,
					GetValue = function() return config.Default end,
					Visible = function(self, value) Row.Visible = value; end,
				};
			end

			function SectionSignal:AddTextArea(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Notes";
				config.Default = config.Default or "";
				config.Placeholder = config.Placeholder or "Type here...";
				config.Height = config.Height or 58;
				config.Callback = config.Callback or function() end;

				local Row = makeRow(config.Height + 34, config.Name);

				local Head = UI.text({
					Parent = Row,
					Position = UDim2.fromOffset(2, 0),
					Size = UDim2.new(1, -4, 0, 18),
					Text = config.Name,
					Color = P.TextDim,
					Size_ = 13,
					Weight = FW.Medium,
				});
				Head.ZIndex = 15;

				local Box = UI.new("Frame", {
					Parent = Row,
					Position = UDim2.fromOffset(0, 24),
					Size = UDim2.new(1, 0, 0, config.Height),
					BackgroundColor3 = P.SurfaceAlt,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					ZIndex = 15,
				});
				UI.corner(Box, D.Radius.xs);
				local BoxStroke = UI.stroke(Box, 0.9);
				WindowSignal.KeepOpaque[Box] = true;

				local Input = UI.new("TextBox", {
					Parent = Box,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(10, 8),
					Size = UDim2.new(1, -20, 1, -16),
					Text = tostring(config.Default),
					PlaceholderText = tostring(config.Placeholder),
					PlaceholderColor3 = P.TextMuted,
					TextColor3 = P.TextSoft,
					TextSize = 12,
					ClearTextOnFocus = false,
					TextWrapped = true,
					MultiLine = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					ZIndex = 16,
				});
				UI.weight(Input, FW.Medium);

				Input.Focused:Connect(function()
					UI.tween(BoxStroke, 0.14, { Transparency = 0.6, Color = P.White });
				end);
				Input.FocusLost:Connect(function(enterPressed)
					UI.tween(BoxStroke, 0.16, { Transparency = 0.9 });
					config.Default = Input.Text;
					WindowSignal.ConfigValues[config.Name] = Input.Text;
					NeverZen.SecureCall(config.Callback, Input.Text, enterPressed and true or false);
				end);

				WindowSignal.ConfigValues[config.Name] = config.Default;
				WindowSignal.ConfigCallbacks[config.Name] = function(value)
					config.Default = value;
					Input.Text = tostring(value);
					NeverZen.SecureCall(config.Callback, Input.Text, false);
				end;

				return {
					SetValue = function(self, newvalue)
						config.Default = newvalue;
						Input.Text = tostring(newvalue);
						WindowSignal.ConfigValues[config.Name] = newvalue;
					end,
					GetValue = function() return Input.Text end,
					Visible = function(self, value) Row.Visible = value; end,
				};
			end

			function SectionSignal:AddGraph(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Graph";
				config.Points = math.clamp(config.Points or 28, 4, 80);
				config.Height = config.Height or 34;
				config.Type = config.Type or "";
				config.Default = tonumber(config.Default) or 0;
				config.Callback = config.Callback or function() end;

				local Row = makeRow(config.Height + 26, config.Name);

				local Label = UI.text({
					Parent = Row,
					Position = UDim2.fromOffset(2, 0),
					Size = UDim2.new(1, -80, 0, 16),
					Text = config.Name,
					Color = P.TextDim,
					Size_ = 13,
					Weight = FW.Medium,
				});
				Label.TextSize = 13;
				Label.ZIndex = 15;

				local ValueLabel = UI.text({
					Parent = Row,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -2, 0, 0),
					Size = UDim2.fromOffset(76, 16),
					Text = tostring(config.Default) .. config.Type,
					Color = P.Text,
					Size_ = 12,
					XAlign = Enum.TextXAlignment.Right,
					Weight = FW.SemiBold,
				});
				ValueLabel.TextSize = 12;
				ValueLabel.ZIndex = 15;

				local Track = UI.new("Frame", {
					Parent = Row,
					Position = UDim2.fromOffset(2, 18),
					Size = UDim2.new(1, -4, 0, config.Height),
					BackgroundColor3 = P.SurfaceAlt,
					BackgroundTransparency = 0.55,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					ZIndex = 15,
				});
				UI.corner(Track, D.Radius.xs);
				UI.stroke(Track, 0.92);

				local bars = {};
				for index = 1, config.Points do
					local bar = UI.new("Frame", {
						Parent = Track,
						AnchorPoint = Vector2.new(0, 1),
						Position = UDim2.fromScale((index - 1) / config.Points, 1),
						Size = UDim2.new(1 / config.Points, -2, 0, 1),
						BackgroundColor3 = P.White,
						BackgroundTransparency = 0.8,
						BorderSizePixel = 0,
						ZIndex = 16,
					});
					UI.corner(bar, 1);
					bars[index] = bar;
				end

				local history = {};
				for index = 1, config.Points do
					history[index] = config.Default;
				end

				local function bounds()
					local low, high = config.Min, config.Max;
					if low == nil or high == nil then
						low, high = math.huge, -math.huge;
						for _, value in ipairs(history) do
							low = math.min(low, value);
							high = math.max(high, value);
						end
						if low == math.huge then low, high = 0, 1 end;
						if high - low < 0.0001 then high = low + 1 end;
					end
					return low, high;
				end

				local function render(instant)
					local low, high = bounds();
					for index, bar in ipairs(bars) do
						local fraction = math.clamp((history[index] - low) / (high - low), 0.02, 1);
						local size = UDim2.new(1 / config.Points, -2, fraction, 0);
						local transparency = math.clamp(0.86 - fraction * 0.56, 0.2, 0.9);
						if instant then
							bar.Size = size;
							bar.BackgroundTransparency = transparency;
						else
							UI.tween(bar, 0.2, {
								Size = size,
								BackgroundTransparency = transparency,
							}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
						end
					end
					ValueLabel.Text = tostring(history[#history]) .. config.Type;
				end

				local function push(value, fire)
					value = tonumber(value) or 0;
					config.Default = value;
					table.remove(history, 1);
					history[#history + 1] = value;
					WindowSignal.ConfigValues[config.Name] = value;
					render(false);
					if fire then
						NeverZen.SecureCall(config.Callback, value, config);
					end
				end

				render(true);
				WindowSignal.ConfigValues[config.Name] = config.Default;

				WindowSignal.ConfigCallbacks[config.Name] = function(value)
					push(value, true);
				end;

				return {
					SetValue = function(self, newvalue) push(newvalue, false) end,
					GetValue = function() return history[#history] end,
					Push = function(self, newvalue) push(newvalue, true) end,
					SetHistory = function(self, list)
						if typeof(list) ~= "table" then return end;
						for index = 1, config.Points do
							history[index] = tonumber(list[index]) or config.Default;
						end
						render(true);
					end,
					Visible = function(self, value) Row.Visible = value; end,
				};
			end;

			function SectionSignal:AddStat(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Stat";
				config.Default = config.Default or "-";

				local Row = makeRow(28, config.Name);

				local Head = UI.text({
					Parent = Row,
					Position = UDim2.fromOffset(2, 0),
					Size = UDim2.new(1, -90, 1, 0),
					Text = config.Name,
					Color = P.TextDim,
					Size_ = 12.5,
					Weight = FW.Medium,
				});
				Head.ZIndex = 15;

				local ValueText = UI.text({
					Parent = Row,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -2, 0, 0),
					Size = UDim2.fromOffset(90, 18),
					Text = tostring(config.Default),
					Color = P.TextSoft,
					Size_ = 12,
					Weight = FW.SemiBold,
					XAlign = Enum.TextXAlignment.Right,
				});
				ValueText.ZIndex = 15;

				return {
					SetValue = function(self, value)
						config.Default = value;
						ValueText.Text = tostring(value);
					end,
					GetValue = function() return config.Default end,
					Visible = function(self, value) Row.Visible = value; end,
				};
			end

			function SectionSignal:AddGroup(config)
				config = NeverZen:CloneConfig(config or {});
				config.Name = config.Name or "Group";
				config.Icon = config.Icon or nil;
				config.Collapsed = config.Collapsed or false;

				local GroupSignal = {};
				local expanded = not config.Collapsed;

				local Head = UI.new("TextButton", {
					Parent = ActiveParent,
					BackgroundColor3 = P.Surface,
					BackgroundTransparency = 0.45,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 30),
					Text = "",
					AutoButtonColor = false,
					ZIndex = 14,
					LayoutOrder = nextOrder(),
				});
				UI.corner(Head, D.Radius.xs);
				local HeadStroke = UI.stroke(Head, 0.92);

				local offsetX = 9;
				local HeadIcon = nil;
				if config.Icon then
					HeadIcon = UI.image({
						Parent = Head,
						Image = NeverZen:GetIcon(config.Icon),
						Color = P.TextMuted,
						Size = UDim2.fromOffset(12, 12),
						Position = UDim2.new(0, 9, 0.5, 0),
					});
					HeadIcon.ZIndex = 15;
					offsetX = 27;
				end

				local HeadLabel = UI.text({
					Parent = Head,
					Position = UDim2.new(0, offsetX, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(1, -offsetX - 34, 0, 18),
					Text = config.Name,
					Color = P.TextSoft,
					Size_ = 12.5,
					Weight = FW.SemiBold,
				});
				HeadLabel.ZIndex = 15;

				local HeadChevron = UI.image({
					Parent = Head,
					Image = NeverZen:GetIcon("chevron-down"),
					Color = P.TextMuted,
					Size = UDim2.fromOffset(12, 12),
					Position = UDim2.new(1, -9, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Rotation = expanded and 180 or 0,
				});
				HeadChevron.ZIndex = 15;

				table.insert(itemForSearch, makeItemRecord(Head, config.Name, Section));

				local Body = UI.new("Frame", {
					Parent = ActiveParent,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 0),
					ClipsDescendants = true,
					ZIndex = 14,
					LayoutOrder = nextOrder() + 1,
				});
				local BodyList = UI.list(Body, { Padding = UDim.new(0, 2) });

				local function bodyHeight()
					local ok, size = pcall(function()
						return BodyList.AbsoluteContentSize;
					end);
					if ok and size and typeof(size.Y) == "number" then
						return math.max(math.floor(size.Y), 0);
					end
					return 0;
				end

				local animating = false;

				local function applyHeight(instant)
					local height = expanded and bodyHeight() or 0;
					if instant or not WindowSignal.Config.Animations then
						Body.Size = UDim2.new(1, 0, 0, height);
						return;
					end
					animating = true;
					UI.tween(Body, 0.22, { Size = UDim2.new(1, 0, 0, height) }, Enum.EasingStyle.Quint);
					task.delay(0.24, function()
						animating = false;
					end);
				end

				local function refreshHeight()
					task.defer(function()
						if not Body.Parent then return end;
						if animating then return end;
						applyHeight(true);
					end);
				end

				local function setExpanded(value, instant)
					expanded = value and true or false;
					if not expanded then expanded = false end;
					UI.tween(HeadChevron, 0.2, { Rotation = expanded and 180 or 0 });
					UI.tween(HeadLabel, 0.16, { TextColor3 = expanded and P.Text or P.TextSoft });
					applyHeight(instant);
				end

				Head.MouseEnter:Connect(function()
					UI.tween(Head, 0.12, { BackgroundTransparency = 0.2, BackgroundColor3 = P.SurfaceAlt });
					UI.tween(HeadStroke, 0.12, { Transparency = 0.84 });
					if HeadIcon then UI.tween(HeadIcon, 0.12, { ImageColor3 = P.Text }) end;
				end);
				Head.MouseLeave:Connect(function()
					UI.tween(Head, 0.14, { BackgroundTransparency = 0.45, BackgroundColor3 = P.Surface });
					UI.tween(HeadStroke, 0.14, { Transparency = 0.92 });
					if HeadIcon then UI.tween(HeadIcon, 0.14, { ImageColor3 = P.TextMuted }) end;
				end);

				Head.MouseButton1Click:Connect(function()
					if destroyed then return end;
					setExpanded(not expanded, false);
				end);

				local function runInBody(fn)
					local previousParent = ActiveParent;
					ActiveParent = Body;
					fn();
					ActiveParent = previousParent;
					refreshHeight();
				end

				GroupSignal.SetCollapsed = function(self, value)
					setExpanded(not value, false);
				end;
				GroupSignal.Toggle = function(self)
					setExpanded(not expanded, false);
				end;
				GroupSignal.IsExpanded = function()
					return expanded;
				end;
				GroupSignal.SetVisible = function(self, value)
					Head.Visible = value and true or false;
					Body.Visible = value and true or false;
				end;
				GroupSignal.Body = Body;
				GroupSignal.Head = Head;
				GroupSignal.RefreshHeight = refreshHeight;

				for _, method in ipairs({
					"AddToggle", "AddSlider", "AddDropdown", "AddMultiDropdown", "AddKeybind",
					"AddTextbox", "AddTextArea", "AddButton", "AddLabel", "AddParagraph",
					"AddDivider", "AddColorPicker", "AddSegmented", "AddStepper",
					"AddProgressBar", "AddStat",
				}) do
					GroupSignal[method] = function(_, childConfig)
						local result;
						runInBody(function()
							result = SectionSignal[method](SectionSignal, childConfig);
						end);
						return result;
					end;
				end

				GroupSignal.AddGroup = function(_, childConfig)
					local result;
					runInBody(function()
						result = SectionSignal:AddGroup(childConfig);
					end);
					return result;
				end;

				refreshHeight();

				return GroupSignal;
			end

			function SectionSignal:AddKeybind(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Keybind";
				config.Default = config.Default or nil;
				config.Callback = config.Callback or function() end;

				local function resolveKeycode(value)
					if typeof(value) == "EnumItem" then return value end;
					if typeof(value) == "string" then
						local ok, item = pcall(function()
							return Enum.KeyCode[value];
						end);
						if ok and item then return item end;
					end
					if typeof(value) == "table" and typeof(value.Name) == "string" then
						local ok, item = pcall(function()
							return Enum.KeyCode[value.Name];
						end);
						if ok and item then return item end;
					end
					return nil;
				end

				local Keys = {
					One = '1', Two = '2', Three = '3', Four = '4', Five = '5',
					Six = '6', Seven = '7', Eight = '8', Nine = '9', Zero = '0',
					Minus = "-", Plus = "+", BackSlash = "\\", Slash = "/",
					Period = '.', Semicolon = ';', Colon = ":",
					LeftControl = "LCtrl", RightControl = "RCtrl",
					LeftShift = "LShift", RightShift = "RShift",
				};

				local GetItem = function(item)
					if item then
						if typeof(item) == 'EnumItem' then
							return Keys[item.Name] or item.Name;
						else
							return Keys[tostring(item)] or string.upper(tostring(item))
						end
					else
						return 'NONE';
					end;
				end;

				local Keybind = makeRow(34, config.Name);
				rowLabel(Keybind, config.Name, 100);

				local Pill, PillText = makePill(Keybind, 54);
				PillText.Text = GetItem(config.Default);
				PillText.TextXAlignment = Enum.TextXAlignment.Center;

				local Chevron = Pill:FindFirstChildOfClass("ImageLabel");
				if Chevron then Chevron.Visible = false end;
				PillText.Size = UDim2.fromScale(1, 1);
				PillText.Position = UDim2.fromOffset(0, 0);

				local function updatePillWidth()
					local textWidth = TextService:GetTextSize(PillText.Text, 12, FONT.GothamMedium, Vector2.new(math.huge, math.huge)).X;
					UI.tween(Pill, 0.12, { Size = UDim2.fromOffset(math.clamp(textWidth + 22, 46, 110), 26) });
				end
				updatePillWidth();

				local Button = NeverZen:NewInput(Keybind);
				local isBinding = false;

				Button.MouseButton1Click:Connect(function()
					if destroyed or isBinding then return end;
					isBinding = true;
					WindowSignal.BindingKey = true;
					PillText.Text = "...";
					UI.tween(PillText, 0.12, { TextColor3 = P.Text });

					local Selected = nil;
					while not Selected and not destroyed do
						local Key = Services.UserInputService.InputBegan:Wait();

						if Key.KeyCode == Enum.KeyCode.Escape then
							break;
						end

						if Key.KeyCode ~= Enum.KeyCode.Unknown then
							Selected = Key.KeyCode;
							NeverZen:SinkKey(Selected);
						end;
					end;

					WindowSignal.BindingKey = false;

					if destroyed or not Selected then
						isBinding = false;
						return;
					end

					config.Default = Selected;
					PillText.Text = GetItem(Selected);
					UI.tween(PillText, 0.14, { TextColor3 = P.TextSoft });
					updatePillWidth();

					isBinding = false;

					NeverZen.SecureCall(config.Callback, Selected, config);
					WindowSignal.ConfigValues[config.Name] = tostring(Selected);
				end);

				WindowSignal.ConfigValues[config.Name] = tostring(config.Default);
				WindowSignal.ConfigCallbacks[config.Name] = function(strvalue)
					local keycode = resolveKeycode(strvalue);
					if not keycode then return end;
					config.Default = keycode;
					PillText.Text = GetItem(keycode);
					updatePillWidth();
					NeverZen.SecureCall(config.Callback, keycode, config);
				end;

				pcall(function()
					Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
						if destroyed or gameProcessed then return end;
						if WindowSignal.BindingKey then
							NeverZen:SinkKey(input.KeyCode);
						end
					end);
				end);

				if config.OnPress or config.OnRelease then
					local function fires(keycode)
						if typeof(config.Default) ~= "EnumItem" then return false end;
						return keycode == config.Default;
					end

					bind(Services.UserInputService.InputBegan, function(input, gameProcessed)
						if destroyed or gameProcessed then return end;
						if WindowSignal.BindingKey then return end;
						if not fires(input.KeyCode) then return end;

						if config.OnPress then
							NeverZen.SecureCall(config.OnPress, input.KeyCode, config);
						end
					end);

					bind(Services.UserInputService.InputEnded, function(input, gameProcessed)
						if destroyed then return end;
						if WindowSignal.BindingKey then return end;
						if not fires(input.KeyCode) then return end;

						if config.OnRelease then
							NeverZen.SecureCall(config.OnRelease, input.KeyCode, config);
						end
					end);
				end;

				WindowSignal.AddKeybindEntry({
					Name = config.Name,
					GetKey = function() return config.Default end,
					GetLabel = function() return GetItem(config.Default) end,
				});

				return {
					SetValue = function(self, newvalue)
						local keycode = resolveKeycode(newvalue);
						if not keycode then return end;
						config.Default = keycode;
						PillText.Text = GetItem(keycode);
						updatePillWidth();
						NeverZen.SecureCall(config.Callback, keycode, config);
						WindowSignal.ConfigValues[config.Name] = tostring(keycode);
					end,
					GetValue = function() return config.Default end,
					GetLabel = function() return GetItem(config.Default) end,
					Fire = config.Callback,
					Visible = function(self, value) Keybind.Visible = value; end,
				};
			end;

			function SectionSignal:AddDropdown(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Dropdown";
				config.Values = config.Values or {};
				config.Default = config.Default or {};
				config.Multi = config.Multi or false;
				config.Search = config.Search or false;
				config.Callback = config.Callback or function() end;

				local parse = function(value)
					if not value then return 'NONE' end;

					if typeof(value) == 'table' then
						local out = {};
						for i, v in pairs(value) do
							if typeof(i) == "number" then
								table.insert(out, tostring(v));
							elseif v == true then
								table.insert(out, tostring(i));
							elseif v then
								table.insert(out, tostring(v));
							end
						end
						if #out == 0 then return 'NONE' end;
						return table.concat(out, ', ');
					else
						return tostring(value);
					end;
				end;

				local function normaliseMulti(value)
					local map = {};
					if typeof(value) == 'table' then
						for i, v in pairs(value) do
							if typeof(i) == "number" then
								map[v] = true;
							elseif v then
								map[i] = true;
							end
						end
					elseif value ~= nil then
						map[value] = true;
					end
					return map;
				end

				if config.Multi then
					config.Default = normaliseMulti(config.Default);
				end

				local Dropown = makeRow(34, config.Name);
				rowLabel(Dropown, config.Name, 120);

				local Pill, PillText, Chevron = makePill(Dropown, 64);
				PillText.Text = parse(config.Default);
				local function updatePillWidth()
					sizePill(Pill, PillText, Chevron);
				end
				updatePillWidth();

				local DROP_MIN_W = 168;
				local DROP_HEADER_H = 30;

				local Panel = UI.new("Frame", {
					Name = NeverZen:RandomString(),
					Parent = Content,
					BackgroundColor3 = P.Surface,
					BackgroundTransparency = 0.02,
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(0, 0),
					Size = UDim2.fromOffset(DROP_MIN_W, DROP_HEADER_H),
					ClipsDescendants = true,
					Visible = false,
					ZIndex = 300,
				});
				UI.corner(Panel, D.Radius.sm);
				local PanelStroke = UI.stroke(Panel, 0.82);

				local PanelHeader = UI.new("Frame", {
					Parent = Panel,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, DROP_HEADER_H),
					ZIndex = 302,
				});

				local PanelHeaderText = UI.text({
					Parent = PanelHeader,
					Position = UDim2.new(0, 9, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(1, -34, 1, 0),
					Text = parse(config.Default),
					Color = P.Text,
					Size_ = 12,
					Weight = FW.Medium,
				});
				PanelHeaderText.ZIndex = 303;

				local PanelHeaderChevron = UI.image({
					Parent = PanelHeader,
					Image = NeverZen:GetIcon("chevron-down"),
					Color = P.TextMuted,
					Size = UDim2.fromOffset(12, 12),
					Position = UDim2.new(1, -9, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Rotation = 180,
				});
				PanelHeaderChevron.ZIndex = 303;

				local PanelSearch = nil;
				local PanelSearchIcon = nil;
				if config.Search then
					PanelHeaderText.Text = "";
					PanelHeaderText.Visible = false;

					PanelSearchIcon = UI.image({
						Parent = PanelHeader,
						Image = NeverZen:GetIcon("search"),
						Color = P.TextMuted,
						Size = UDim2.fromOffset(11, 11),
						Position = UDim2.new(0, 9, 0.5, 0),
					});
					PanelSearchIcon.ZIndex = 303;

					PanelSearch = UI.new("TextBox", {
						Parent = PanelHeader,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 26, 0, 0),
						Size = UDim2.new(1, -58, 1, 0),
						Text = "",
						PlaceholderText = "Search...",
						PlaceholderColor3 = P.TextMuted,
						TextColor3 = P.TextSoft,
						TextSize = 11.5,
						ClearTextOnFocus = false,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 303,
					});
					UI.weight(PanelSearch, FW.Medium);
				end

				local PanelDivider = UI.new("Frame", {
					Parent = Panel,
					BackgroundColor3 = P.Line,
					BackgroundTransparency = 0.88,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(8, DROP_HEADER_H),
					Size = UDim2.new(1, -16, 0, 1),
					ZIndex = 302,
				});

				local PanelScroll = UI.new("ScrollingFrame", {
					Parent = Panel,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(4, DROP_HEADER_H + 4),
					Size = UDim2.new(1, -8, 1, -DROP_HEADER_H - 8),
					CanvasSize = UDim2.fromOffset(0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					ScrollBarImageColor3 = P.White,
					ScrollBarImageTransparency = 0.85,
					ZIndex = 301,
				});
				local PanelList = UI.list(PanelScroll, { Padding = UDim.new(0, 2) });

				local isOpen = false;

				local function pillRect()
					local abs = Pill.AbsolutePosition;
					local size = Pill.AbsoluteSize;
					if size.X < 1 or size.Y < 1 then
						size = Vector2.new(96, 26);
					end
					return abs, size;
				end

				local builtCount = 0;

				local function targetSize()
					local pillAbs, pillSize = pillRect();
					local width = math.max(DROP_MIN_W, math.floor(pillSize.X) + 34);
					local rows = (builtCount > 0) and builtCount or #config.Values;
					local contentHeight = math.max(PanelList.AbsoluteContentSize.Y, rows * 26);
					local height = math.clamp(math.floor(contentHeight) + DROP_HEADER_H + 8, DROP_HEADER_H + 34, DROP_HEADER_H + 168);
					return width, height;
				end

				local function expandedPosition()
					local pillAbs, pillSize = pillRect();
					local width = targetSize();
					local viewport = workspace.CurrentCamera.ViewportSize;
					local x = pillAbs.X + pillSize.X - width;
					local y = pillAbs.Y;
					return UDim2.fromOffset(
						math.clamp(x, 8, math.max(8, viewport.X - width - 8)),
						y
					);
				end

				local panelTweenToken = 0;

				local function closePanel()
					if not isOpen then return end;
					isOpen = false;
					panelTweenToken += 1;
					local token = panelTweenToken;

					local pillAbs, pillSize = pillRect();
					UI.tween(PanelHeader, 0.12, { BackgroundTransparency = 1 });
					pcall(function()
						UI.tw(Panel, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
							Position = UDim2.fromOffset(pillAbs.X, pillAbs.Y),
							Size = UDim2.fromOffset(math.floor(pillSize.X), math.floor(pillSize.Y)),
						}):Play();
					end);
					task.delay(0.18, function()
						if token ~= panelTweenToken then return end;
						if Panel.Parent and not isOpen then Panel.Visible = false end;
					end);
					UI.tween(Chevron, 0.16, { Rotation = 0 });
					UI.tween(PanelHeaderChevron, 0.16, { Rotation = 0 });
				end

				local function updatePanelPosition()
					if not Panel.Visible then return end;
					Panel.Position = expandedPosition();
				end

				local popupRef = {
					close = closePanel,
					update = updatePanelPosition,
					panel = Panel,
					persistent = true,
				};
				registerPopup(popupRef);

				local function buildItems()
					for _, child in ipairs(PanelScroll:GetChildren()) do
						if child:IsA("Frame") then child:Destroy() end;
					end;

					local query = "";
					if PanelSearch then
						query = tostring(PanelSearch.Text or ""):lower();
					end

					local source = config.Values;
					if query ~= "" then
						source = {};
						for _, entry in ipairs(config.Values) do
							if tostring(entry):lower():find(query, 1, true) then
								table.insert(source, entry);
							end
						end
					end

					builtCount = #source;

					for index, value in ipairs(source) do
						local Item = UI.new("Frame", {
							Name = NeverZen:RandomString(),
							Parent = PanelScroll,
							BackgroundColor3 = P.White,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 26),
							ZIndex = 302,
							LayoutOrder = index,
						});
						UI.corner(Item, D.Radius.xs);

						local Check = UI.image({
							Parent = Item,
							Image = NeverZen:GetIcon("check"),
							Color = P.Text,
							Size = UDim2.fromOffset(12, 12),
							Position = UDim2.new(0, 8, 0.5, 0),
							Transparency = 1,
						});
						Check.ZIndex = 303;

						local ItemLabel = UI.text({
							Parent = Item,
							Position = UDim2.new(0, 28, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(1, -34, 0, 18),
							Text = tostring(value),
							Color = P.TextDim,
							Size_ = 12,
							Weight = FW.Medium,
						});
						ItemLabel.TextSize = 12;
						ItemLabel.ZIndex = 303;

						local function isSelectedNow()
							if config.Multi then
								return config.Default[value] == true or config.Default[tostring(value)] == true;
							end
							return config.Default == value;
						end

						local selected = isSelectedNow();

						local function paint(isSelected, instant)
							if instant then
								Check.ImageTransparency = isSelected and 0 or 1;
								ItemLabel.TextColor3 = isSelected and P.Text or P.TextDim;
								Item.BackgroundTransparency = isSelected and 0.94 or 1;
							else
								UI.tween(Check, 0.16, { ImageTransparency = isSelected and 0 or 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
								UI.tween(ItemLabel, 0.16, { TextColor3 = isSelected and P.Text or P.TextDim }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
								UI.tween(Item, 0.18, { BackgroundTransparency = isSelected and 0.94 or 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
							end
						end
						paint(selected, true);

						local input = NeverZen:NewInput(Item);
						NeverZen:Hover(Item, function()
							UI.tween(Item, 0.14, { BackgroundTransparency = 0.9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
							UI.tween(ItemLabel, 0.14, { TextColor3 = P.Text });
						end, function()
							local nowSelected = isSelectedNow();
							UI.tween(Item, 0.16, { BackgroundTransparency = nowSelected and 0.94 or 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
							UI.tween(ItemLabel, 0.16, { TextColor3 = nowSelected and P.Text or P.TextDim });
						end);

						input.MouseButton1Click:Connect(function()
							if destroyed then return end;

							if config.Multi then
								local isSelected = config.Default[value] == true;
								config.Default[value] = (not isSelected) or nil;
								paint(not isSelected, false);
							else
								config.Default = value;
								for _, sibling in ipairs(PanelScroll:GetChildren()) do
									if sibling:IsA("Frame") and sibling ~= Item then
										local otherCheck = sibling:FindFirstChildOfClass("ImageLabel");
										local otherLabel = sibling:FindFirstChildOfClass("TextLabel");
										if otherCheck then UI.tween(otherCheck, 0.16, { ImageTransparency = 1 }) end;
										if otherLabel then UI.tween(otherLabel, 0.16, { TextColor3 = P.TextDim }) end;
										UI.tween(sibling, 0.16, { BackgroundTransparency = 1 });
									end
								end
								paint(true, false);
							end

							PillText.Text = parse(config.Default);
							PanelHeaderText.Text = PillText.Text;
							updatePillWidth();

							WindowSignal.ConfigValues[config.Name] = config.Default;
							NeverZen.SecureCall(config.Callback, config.Default, config);

							if not config.Multi then
								closePanel();
							end
						end);
					end
				end

				local function openPanel()
					closeAllPopups(popupRef);
					buildItems();
					isOpen = true;
					panelTweenToken += 1;

					PanelHeaderText.Text = PillText.Text;
					if PanelSearch then PanelSearch.Text = "" end;

					Panel.Visible = true;
					PanelHeader.BackgroundTransparency = 1;
					PanelHeaderText.TextTransparency = 1;
					PanelHeaderChevron.ImageTransparency = 1;

					local pillAbs, pillSize = pillRect();
					Panel.Position = UDim2.fromOffset(pillAbs.X, pillAbs.Y);
					Panel.Size = UDim2.fromOffset(math.floor(pillSize.X), math.floor(pillSize.Y));

					local width, height = targetSize();

					pcall(function()
						UI.tw(Panel, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
							Position = expandedPosition(),
							Size = UDim2.fromOffset(width, height),
						}):Play();
					end);

					task.delay(0.06, function()
						if not isOpen or not Panel.Parent then return end;
						UI.tween(PanelHeaderText, 0.16, { TextTransparency = 0 });
						UI.tween(PanelHeaderChevron, 0.16, { ImageTransparency = 0 });
					end);

					UI.tween(Chevron, 0.2, { Rotation = 180 });
					UI.tween(PanelHeaderChevron, 0.2, { Rotation = 180 });
				end

				if PanelSearch then
					local searchBind = PanelSearch:GetPropertyChangedSignal("Text"):Connect(function()
						if destroyed or not isOpen then return end;
						buildItems();
						local width, height = targetSize();
						pcall(function()
							UI.tw(Panel, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
								Size = UDim2.fromOffset(width, height),
							}):Play();
						end);
					end);
					table.insert(connections, searchBind);
				end

				local toggleInput = NeverZen:NewInput(Pill);
				toggleInput.MouseButton1Click:Connect(function()
					if destroyed then return end;
					if isOpen then
						closePanel();
					else
						openPanel();
					end
				end);
				toggleInput.MouseEnter:Connect(function()
					UI.tween(Pill, 0.14, { BackgroundColor3 = P.SurfaceHigh });
				end);
				toggleInput.MouseLeave:Connect(function()
					UI.tween(Pill, 0.16, { BackgroundColor3 = P.SurfaceAlt });
				end);

				local closeBind = Services.UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
					if not isOpen then return end;
					if NeverZen:IsMouseOverFrame(Panel) or NeverZen:IsMouseOverFrame(Pill) then return end;
					closePanel();
				end);
				table.insert(connections, closeBind);

				WindowSignal.ConfigValues[config.Name] = config.Default;
				local function valueExists(candidate)
					for key, entry in pairs(config.Values) do
						if typeof(key) == "number" then
							if entry == candidate or tostring(entry) == tostring(candidate) then return true end
						else
							if key == candidate or tostring(key) == tostring(candidate) then return true end
							if entry == candidate or (typeof(entry) == "string" and entry == tostring(candidate)) then return true end
						end
					end
					return false;
				end

				WindowSignal.ConfigCallbacks[config.Name] = function(newvalue)
					if config.Multi then
						config.Default = normaliseMulti(newvalue);
					else
						if not valueExists(newvalue) then
							warn("[NeverZen] Dropdown '" .. tostring(config.Name) .. "': нет варианта '" .. tostring(newvalue) .. "'");
							return;
						end
						config.Default = newvalue;
					end
					PillText.Text = parse(config.Default);
					updatePillWidth();
					NeverZen.SecureCall(config.Callback, config.Default, config);
				end;

				return {
					SetValue = function(self, newvalue)
						if config.Multi then
							config.Default = normaliseMulti(newvalue);
						else
							config.Default = newvalue;
						end
						PillText.Text = parse(newvalue);
						updatePillWidth();
						WindowSignal.ConfigValues[config.Name] = config.Default;
					end,
					SetValues = function(self, new)
						config.Values = new;
						if isOpen then buildItems() end;
					end,
					GetValue = function() return config.Default end,
					Fire = config.Callback,
					Visible = function(self, value) Dropown.Visible = value; end,
				};
			end;

			function SectionSignal:AddMultiDropdown(config)
				config = NeverZen:CloneConfig(config or {});
				config.Multi = true;
				return SectionSignal:AddDropdown(config);
			end

			function SectionSignal:AddColorPicker(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Color Picker";
				config.Default = config.Default or Color3.fromRGB(255, 255, 255);
				config.Alpha = config.Alpha or false;
				config.DefaultAlpha = config.DefaultAlpha or 1;
				config.Palette = config.Palette or {};
				config.Callback = config.Callback or function() end;

				local PANEL_W = 210;

				local H, S, V = config.Default:ToHSV();
				local A = math.clamp(config.DefaultAlpha, 0, 1);
				local updateAll;

				local function toHex(color)
					return string.format("%02X%02X%02X",
						math.floor(color.R * 255 + 0.5),
						math.floor(color.G * 255 + 0.5),
						math.floor(color.B * 255 + 0.5)
					);
				end;

				local function fromHex(hex)
					hex = tostring(hex):gsub("#", "");
					if #hex ~= 6 then return nil end;

					local r = tonumber(hex:sub(1, 2), 16);
					local g = tonumber(hex:sub(3, 4), 16);
					local b = tonumber(hex:sub(5, 6), 16);

					if not (r and g and b) then return nil end;

					return Color3.fromRGB(r, g, b);
				end;

				local ColorPicker = makeRow(34, config.Name);
				rowLabel(ColorPicker, config.Name, 80);

				local Swatch = UI.new("Frame", {
					Parent = ColorPicker,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(34, 20),
					BackgroundColor3 = config.Default,
					BorderSizePixel = 0,
					ZIndex = 15,
				});
				UI.corner(Swatch, D.Radius.xs);
				UI.stroke(Swatch, 0.75);
				WindowSignal.KeepOpaque[Swatch] = true;

				local Panel = UI.new("Frame", {
					Name = NeverZen:RandomString(),
					Parent = Content,
					BackgroundColor3 = P.Surface,
					BackgroundTransparency = 0.02,
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(PANEL_W, 0),
					ClipsDescendants = true,
					Visible = false,
					ZIndex = 300,
				});
				UI.corner(Panel, D.Radius.md);
				UI.stroke(Panel, 0.82);

				local InnerW = PANEL_W - 24;

				local Inner = UI.new("Frame", {
					Parent = Panel,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(12, 12),
					Size = UDim2.fromOffset(InnerW, 0),
					ZIndex = 301,
				});

				local SVBox = UI.new("Frame", {
					Parent = Inner,
					BackgroundColor3 = Color3.fromRGB(255, 0, 0),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Size = UDim2.fromOffset(InnerW, 96),
					ZIndex = 302,
				});
				UI.corner(SVBox, D.Radius.xs);
				WindowSignal.KeepOpaque[SVBox] = true;

				local SVWhite = UI.new("Frame", {
					Parent = SVBox,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 302,
				});
				UI.new("UIGradient", {
					Parent = SVWhite,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1),
					}),
				});

				local SVBlack = UI.new("Frame", {
					Parent = SVBox,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 303,
				});
				UI.new("UIGradient", {
					Parent = SVBlack,
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					}),
				});

				local SVCursor = UI.new("Frame", {
					Parent = SVBox,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = P.White,
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(11, 11),
					ZIndex = 304,
				});
				UI.pill(SVCursor);
				UI.stroke(SVCursor, 0.35, 1.5, P.Black);

				local HueBar = UI.new("Frame", {
					Parent = Inner,
					BackgroundColor3 = P.White,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(0, 104),
					Size = UDim2.fromOffset(InnerW, 12),
					ZIndex = 302,
				});
				UI.pill(HueBar);
				UI.new("UIGradient", {
					Parent = HueBar,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0.000, Color3.fromHSV(0 / 6, 1, 1)),
						ColorSequenceKeypoint.new(0.166, Color3.fromHSV(1 / 6, 1, 1)),
						ColorSequenceKeypoint.new(0.333, Color3.fromHSV(2 / 6, 1, 1)),
						ColorSequenceKeypoint.new(0.500, Color3.fromHSV(3 / 6, 1, 1)),
						ColorSequenceKeypoint.new(0.666, Color3.fromHSV(4 / 6, 1, 1)),
						ColorSequenceKeypoint.new(0.833, Color3.fromHSV(5 / 6, 1, 1)),
						ColorSequenceKeypoint.new(1.000, Color3.fromHSV(6 / 6, 1, 1)),
					}),
				});

				local HueCursor = UI.new("Frame", {
					Parent = HueBar,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = P.White,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.fromOffset(6, 16),
					ZIndex = 303,
				});
				UI.pill(HueCursor);
				UI.stroke(HueCursor, 0.35, 1.5, P.Black);

				local cursorY = 124;
				local AlphaBar, AlphaCursor, AlphaOverlay;

				if config.Alpha then
					AlphaBar = UI.new("Frame", {
						Parent = Inner,
						BackgroundColor3 = P.Black,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Position = UDim2.fromOffset(0, cursorY),
						Size = UDim2.fromOffset(InnerW, 12),
						ZIndex = 302,
					});
					UI.pill(AlphaBar);
					WindowSignal.KeepOpaque[AlphaBar] = true;

					for column = 0, 9 do
						for row = 0, 1 do
							UI.new("Frame", {
								Parent = AlphaBar,
								BackgroundColor3 = ((column + row) % 2 == 0) and Color3.fromRGB(96, 96, 96) or Color3.fromRGB(58, 58, 58),
								BorderSizePixel = 0,
								Position = UDim2.new(column / 10, 0, row / 2, 0),
								Size = UDim2.new(1 / 10, 0, 1 / 2, 0),
								ZIndex = 302,
							});
						end
					end

					AlphaOverlay = UI.new("Frame", {
						Parent = AlphaBar,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1),
						ZIndex = 303,
					});
					UI.new("UIGradient", {
						Parent = AlphaOverlay,
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 1),
							NumberSequenceKeypoint.new(1, 0),
						}),
					});

					AlphaCursor = UI.new("Frame", {
						Parent = AlphaBar,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = P.White,
						BorderSizePixel = 0,
						Position = UDim2.new(1, 0, 0.5, 0),
						Size = UDim2.fromOffset(6, 16),
						ZIndex = 304,
					});
					UI.pill(AlphaCursor);
					UI.stroke(AlphaCursor, 0.35, 1.5, P.Black);

					cursorY += 20;
				end

				cursorY += 10;

				local paletteValues = {
					Color3.fromRGB(255, 255, 255),
					Color3.fromRGB(216, 216, 216),
					Color3.fromRGB(176, 176, 176),
					Color3.fromRGB(136, 136, 136),
					Color3.fromRGB(96, 96, 96),
					Color3.fromRGB(64, 64, 64),
					Color3.fromRGB(32, 32, 32),
					Color3.fromRGB(0, 0, 0),
				};

				for _, entry in ipairs(config.Palette) do
					if typeof(entry) == "Color3" then
						table.insert(paletteValues, entry);
					elseif typeof(entry) == "string" then
						local parsed = fromHex(entry);
						if parsed then table.insert(paletteValues, parsed) end;
					end
				end

				local paletteButtons = {};
				local gap = 3;
				local swatchSize = math.floor((InnerW - gap * 7) / 8);

				for index = 1, math.min(#paletteValues, 8) do
					local color = paletteValues[index];
					local Chip = UI.new("TextButton", {
						Parent = Inner,
						BackgroundColor3 = color,
						BorderSizePixel = 0,
						Text = "",
						AutoButtonColor = false,
						Position = UDim2.fromOffset((swatchSize + gap) * (index - 1), cursorY),
						Size = UDim2.fromOffset(swatchSize, 19),
						ZIndex = 302,
					});
					UI.corner(Chip, D.Radius.xs);
					UI.stroke(Chip, 0.82);
					WindowSignal.KeepOpaque[Chip] = true;

					Chip.MouseEnter:Connect(function()
						UI.tween(Chip, 0.12, { Size = UDim2.fromOffset(swatchSize, 22) });
					end);
					Chip.MouseLeave:Connect(function()
						UI.tween(Chip, 0.14, { Size = UDim2.fromOffset(swatchSize, 19) });
					end);

					Chip.MouseButton1Click:Connect(function()
						if destroyed then return end
						H, S, V = color:ToHSV();
						updateAll(true);
					end);

					table.insert(paletteButtons, Chip);
				end

				cursorY += 31;

				local Preview = UI.new("Frame", {
					Parent = Inner,
					BackgroundColor3 = config.Default,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(0, cursorY),
					Size = UDim2.fromOffset(28, 28),
					ZIndex = 302,
				});
				UI.corner(Preview, D.Radius.xs);
				UI.stroke(Preview, 0.75);
				WindowSignal.KeepOpaque[Preview] = true;

				local HexBox = UI.new("TextBox", {
					Parent = Inner,
					BackgroundColor3 = P.SurfaceAlt,
					BorderSizePixel = 0,
					ClearTextOnFocus = false,
					Position = UDim2.fromOffset(36, cursorY),
					Size = UDim2.fromOffset(InnerW - 36 - 26, 28),
					Text = "#" .. toHex(config.Default),
					TextColor3 = P.TextSoft,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Center,
					ZIndex = 302,
				});
				UI.corner(HexBox, D.Radius.xs);
				UI.stroke(HexBox, 0.88);
				UI.weight(HexBox, FW.Medium);

				local CopyButton = UI.new("TextButton", {
					Parent = Inner,
					BackgroundColor3 = P.SurfaceAlt,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					Position = UDim2.fromOffset(InnerW - 22, cursorY),
					Size = UDim2.fromOffset(22, 28),
					ZIndex = 302,
				});
				UI.corner(CopyButton, D.Radius.xs);
				UI.stroke(CopyButton, 0.88);

				local CopyGlyph = UI.image({
					Parent = CopyButton,
					Image = NeverZen:GetIcon("copy"),
					Color = P.TextMuted,
					Size = UDim2.fromOffset(12, 12),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					ZIndex = 303,
				});
				CopyGlyph.ZIndex = 303;

				CopyButton.MouseEnter:Connect(function() UI.tween(CopyGlyph, 0.12, { ImageColor3 = P.Text }) end);
				CopyButton.MouseLeave:Connect(function() UI.tween(CopyGlyph, 0.14, { ImageColor3 = P.TextMuted }) end);
				CopyButton.MouseButton1Click:Connect(function()
					if destroyed then return end
					pcall(function() setclipboard("#" .. toHex(Color3.fromHSV(H, S, V))) end);
				end);

				cursorY += 36;

				local channelBoxes = {};
				local channelWidth = math.floor((InnerW - 12) / 3);

				for index, channel in ipairs({ "R", "G", "B" }) do
					local Box = UI.new("TextBox", {
						Parent = Inner,
						BackgroundColor3 = P.SurfaceAlt,
						BorderSizePixel = 0,
						ClearTextOnFocus = false,
						Position = UDim2.fromOffset((channelWidth + 6) * (index - 1), cursorY),
						Size = UDim2.fromOffset(channelWidth, 24),
						Text = channel,
						TextColor3 = P.TextMuted,
						TextSize = 11.5,
						TextXAlignment = Enum.TextXAlignment.Center,
						ZIndex = 302,
					});
					UI.corner(Box, D.Radius.xs);
					UI.stroke(Box, 0.9);
					UI.weight(Box, FW.SemiBold);

					channelBoxes[channel] = Box;

					Box.FocusLost:Connect(function(enter)
						if not enter then
							local c = Color3.fromHSV(H, S, V);
							Box.Text = tostring(math.floor((channel == "R" and c.R or (channel == "G" and c.G or c.B)) * 255 + 0.5));
							return;
						end
						local value = tonumber(Box.Text);
						if not value then return end;
						value = math.clamp(math.floor(value), 0, 255);

						local current = Color3.fromHSV(H, S, V);
						local r = math.floor(current.R * 255);
						local g = math.floor(current.G * 255);
						local b = math.floor(current.B * 255);

						if channel == "R" then r = value
						elseif channel == "G" then g = value
						else b = value end;

						H, S, V = Color3.fromRGB(r, g, b):ToHSV();
						updateAll(true);
					end);
				end

				cursorY += 24;

				Inner.Size = UDim2.fromOffset(InnerW, cursorY);
				local panelHeight = cursorY + 24;

				local function currentColor()
					return Color3.fromHSV(H, S, V);
				end

				local function applyColor(fireCallback)
					local color = currentColor();

					Swatch.BackgroundColor3 = color;
					Preview.BackgroundColor3 = color;
					SVBox.BackgroundColor3 = Color3.fromHSV(H, 1, 1);
					HexBox.Text = "#" .. toHex(color);

					if AlphaOverlay then
						AlphaOverlay.BackgroundColor3 = color;
					end

					channelBoxes.R.Text = tostring(math.floor(color.R * 255 + 0.5));
					channelBoxes.G.Text = tostring(math.floor(color.G * 255 + 0.5));
					channelBoxes.B.Text = tostring(math.floor(color.B * 255 + 0.5));

					config.Default = color;
					config.DefaultAlpha = A;

					if fireCallback then
						WindowSignal.ConfigValues[config.Name] = {
							R = math.floor(color.R * 255),
							G = math.floor(color.G * 255),
							B = math.floor(color.B * 255),
							A = A,
						};
						NeverZen.SecureCall(config.Callback, color, config, A);
					end;
				end;

				updateAll = function(fireCallback)
					SVCursor.Position = UDim2.new(S, 0, 1 - V, 0);
					HueCursor.Position = UDim2.new(H, 0, 0.5, 0);
					if AlphaCursor then
						AlphaCursor.Position = UDim2.new(A, 0, 0.5, 0);
					end
					applyColor(fireCallback);
				end;

				local function updateSV(position)
					local abs = SVBox.AbsolutePosition;
					local size = SVBox.AbsoluteSize;
					S = math.clamp((position.X - abs.X) / math.max(size.X, 1), 0, 1);
					V = 1 - math.clamp((position.Y - abs.Y) / math.max(size.Y, 1), 0, 1);
					updateAll(true);
				end;

				local function updateHue(position)
					local abs = HueBar.AbsolutePosition;
					local size = HueBar.AbsoluteSize;
					H = math.clamp((position.X - abs.X) / math.max(size.X, 1), 0, 1);
					updateAll(true);
				end;

				local function updateAlpha(position)
					local abs = AlphaBar.AbsolutePosition;
					local size = AlphaBar.AbsoluteSize;
					A = math.clamp((position.X - abs.X) / math.max(size.X, 1), 0, 1);
					updateAll(true);
				end;

				local svHit = NeverZen:NewInput(SVBox);
				svHit.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
					if destroyed then return end;
					updateSV(input.Position);
					addDrag({ update = function(position) updateSV(position) end });
				end);

				local hueHit = NeverZen:NewInput(HueBar);
				hueHit.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
					if destroyed then return end;
					updateHue(input.Position);
					addDrag({ update = function(position) updateHue(position) end });
				end);

				if AlphaBar then
					local alphaHit = NeverZen:NewInput(AlphaBar);
					alphaHit.InputBegan:Connect(function(input)
						if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
						if destroyed then return end;
						updateAlpha(input.Position);
						addDrag({ update = function(position) updateAlpha(position) end });
					end);
				end

				HexBox.FocusLost:Connect(function(enter)
					if enter then
						local parsed = fromHex(HexBox.Text);
						if parsed then
							H, S, V = parsed:ToHSV();
							updateAll(true);
						else
							HexBox.Text = "#" .. toHex(currentColor());
						end
					else
						HexBox.Text = "#" .. toHex(currentColor());
					end
				end);

				local isOpen = false;

				local function closePanel()
					if not isOpen then return end;
					isOpen = false;
					UI.tween(Panel, 0.13, { Size = UDim2.fromOffset(PANEL_W, 0) });
					task.delay(0.14, function()
						if Panel.Parent and not isOpen then Panel.Visible = false end;
					end);
				end;

				local function updatePanelPosition()
					if not Panel.Visible then return end;
					local abs = Swatch.AbsolutePosition;
					local size = Swatch.AbsoluteSize;
					local viewport = workspace.CurrentCamera.ViewportSize;
					local x = abs.X + size.X - PANEL_W;
					local y = abs.Y + size.Y + 8;
					Panel.Position = UDim2.fromOffset(
						math.clamp(x, 8, math.max(8, viewport.X - (PANEL_W + 8))),
						y
					);
				end

				registerPopup({ close = closePanel, update = updatePanelPosition, panel = Panel, persistent = true });

				local swatchInput = NeverZen:NewInput(Swatch);
				swatchInput.MouseButton1Click:Connect(function()
					if destroyed then return end;
					if isOpen then
						closePanel();
						return;
					end
					closeAllPopups(nil);
					updateAll(false);
					isOpen = true;
					Panel.Visible = true;
					updatePanelPosition();
					UI.tween(Panel, 0.18, { Size = UDim2.fromOffset(PANEL_W, panelHeight) }, Enum.EasingStyle.Quint);
				end);

				local outsideBind = Services.UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
					if not isOpen then return end;
					if NeverZen:IsMouseOverFrame(Panel) or NeverZen:IsMouseOverFrame(Swatch) then return end;
					closePanel();
				end);
				table.insert(connections, outsideBind);

				updateAll(false);

				WindowSignal.ConfigValues[config.Name] = {
					R = math.floor(config.Default.R * 255),
					G = math.floor(config.Default.G * 255),
					B = math.floor(config.Default.B * 255),
					A = A,
				};
				WindowSignal.ConfigCallbacks[config.Name] = function(rgbValue)
					if typeof(rgbValue) ~= "table" then return end;
					local newColor = Color3.fromRGB(rgbValue.R or 255, rgbValue.G or 255, rgbValue.B or 255);
					H, S, V = newColor:ToHSV();
					if rgbValue.A ~= nil then A = math.clamp(rgbValue.A, 0, 1) end;
					updateAll(true);
				end;

				return {
					SetValue = function(self, newvalue)
						H, S, V = newvalue:ToHSV();
						updateAll(true);
					end,
					GetValue = function() return config.Default end,
					SetAlpha = function(self, value)
						A = math.clamp(value or 1, 0, 1);
						updateAll(true);
					end,
					GetAlpha = function() return A end,
					SetPalette = function(self, list)
						config.Palette = list or {};
					end,
					Fire = config.Callback,
					Visible = function(self, value) ColorPicker.Visible = value; end,
				};
			end;

			local function applyDisabled(frame, control, state)
				local shield = frame:FindFirstChild("NZShield");

				if not shield then
					shield = UI.new("TextButton", {
						Name = "NZShield",
						Parent = frame,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = "",
						AutoButtonColor = false,
						ZIndex = frame.ZIndex + 50,
						Visible = false,
					});
				end

				shield.Visible = state and true or false;
				shield.Active = state and true or false;

				for _, object in ipairs(frame:GetDescendants()) do
					if object ~= shield then
						if object:IsA("TextLabel") then
							object.TextTransparency = state and 0.55 or 0;
						elseif object:IsA("ImageLabel") then
							object.ImageTransparency = state and 0.6 or 0;
						end
					end
				end
			end

			local function attachControl(control, cfg, frame)
				if typeof(control) ~= "table" then return control end;

				control._frame = frame;
				control._config = cfg;

				control.SetVisible = function(self, value)
					local visible = value and true or false;
					self._forcedHidden = not visible;
					if frame and frame.Parent then
						frame.Visible = visible;
					end
					return visible;
				end;

				control.SetDisabled = function(self, value)
					self._disabled = value and true or false;
					if frame and frame.Parent then
						applyDisabled(frame, self, self._disabled);
					end
					return self._disabled;
				end;

				control.IsDisabled = function(self)
					return self._disabled == true;
				end;

				if cfg then
					local requirement = WindowSignal:MakeRequirement(cfg.DependsOn);
					if requirement and frame then
						table.insert(WindowSignal.Dependencies, {
							Frame = frame,
							Control = control,
							Requirement = requirement,
						});
						pcall(function() WindowSignal:RefreshDependencies() end);
					end

					if cfg.Disabled then
						control:SetDisabled(true);
					end
				end

				return control;
			end

			local wrapped = {};
			for _, methodName in ipairs({
				"AddToggle", "AddSlider", "AddDropdown", "AddMultiDropdown",
				"AddColorPicker", "AddKeybind", "AddTextbox", "AddTextArea",
				"AddButton", "AddLabel", "AddParagraph", "AddDivider",
				"AddProgressBar", "AddSegmented", "AddStat", "AddStepper", "AddGraph",
			}) do
				local original = SectionSignal[methodName];
				if type(original) == "function" then
					wrapped[methodName] = true;
					SectionSignal[methodName] = function(self, ...)
						local before = SectionSignal._lastRow;
						local args = table.pack(...);
						local control = original(self, table.unpack(args, 1, args.n));
						local frame = SectionSignal._lastRow;
						if frame == before then frame = nil end;
						local cfg = args[1];
						if typeof(cfg) ~= "table" then cfg = nil end;
						return attachControl(control, cfg, frame);
					end;
				end
			end

			SectionSignal._Frame = Section;
			SectionSignal._Head = head;
			SectionSignal._Items = itemForSearch;
			SectionSignal.RefreshDependencies = function(self) WindowSignal:RefreshDependencies() end;

			return SectionSignal;
		end;

		local function buildSubTab(name, icon)
			local Button = UI.new("Frame", {
				Name = NeverZen:RandomString(),
				Parent = SubTabBar,
				BackgroundColor3 = P.White,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(0, 30),
				AutomaticSize = Enum.AutomaticSize.X,
				ZIndex = 13,
			});
			UI.corner(Button, D.Radius.sm);

			local Indicator = UI.new("Frame", {
				Parent = Button,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0.5, 0, 1, -1),
				BackgroundColor3 = P.White,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(14, 2),
				ZIndex = 15,
			});
			UI.pill(Indicator);

			local iconImage = nil;
			if icon then
				iconImage = UI.image({
					Parent = Button,
					Image = NeverZen:GetIcon(icon),
					Color = P.TextMuted,
					Size = UDim2.fromOffset(13, 13),
					Position = UDim2.new(0, 12, 0.5, 0),
				});
				iconImage.ZIndex = 14;
			end

			local Label = UI.text({
				Parent = Button,
				Position = UDim2.new(0, icon and 31 or 12, 0, 0),
				Size = UDim2.new(0, 0, 1, 0),
				Text = tostring(name),
				Color = P.TextDim,
				Size_ = 12,
				Weight = FW.SemiBold,
			});
			Label.TextSize = 12;
			Label.AutomaticSize = Enum.AutomaticSize.X;
			Label.ZIndex = 14;

			UI.new("UIPadding", {
				Parent = Button,
				PaddingRight = UDim.new(0, 12),
			});

			return Button, Label, Indicator;
		end

		local PageOrder = 0;

		local function newPageObject()
			PageOrder += 1;
			local page = makePage();
			page.Frame.LayoutOrder = PageOrder;
			page.name = nil;
			return page;
		end;

		defaultPage = newPageObject();
		table.insert(pages, { page = defaultPage, name = nil });

		function TabSignal:AddSubTab(subConfig)
			subConfig = NeverZen:CloneConfig(subConfig or {});
			subConfig.Name = subConfig.Name or "Tab";

			local page;
			if #subtabButtons == 0 then

				page = defaultPage;
				page.name = subConfig.Name;
				pages[1].name = subConfig.Name;
			else
				page = newPageObject();
				page.name = subConfig.Name;
				table.insert(pages, { page = page, name = subConfig.Name });
			end

			local Button, SubLabel, Indicator = buildSubTab(subConfig.Name, subConfig.Icon);
			table.insert(subtabButtons, { Button = Button, Label = SubLabel, Indicator = Indicator, page = page });

			SubTabBar.Visible = true;
			layoutPages();

			local input = NeverZen:NewInput(Button);
			input.MouseButton1Click:Connect(function()
				if destroyed then return end;
				selectPage(page);
			end);
			input.MouseEnter:Connect(function()
				if page.Frame.Visible then return end;
				UI.tween(SubLabel, 0.14, { TextColor3 = P.TextSoft });
			end);
			input.MouseLeave:Connect(function()
				if page.Frame.Visible then return end;
				UI.tween(SubLabel, 0.14, { TextColor3 = P.TextDim });
			end);

			if #subtabButtons == 1 then
				selectPage(page);
			else
				setPage(page, false);
			end

			local SubSignal = {};
			function SubSignal:AddSection(sectionConfig)
				return buildSection(page, sectionConfig);
			end;
			SubSignal.Page = page.Frame;
			function SubSignal:Select()
				selectPage(page);
			end;
			return SubSignal;
		end

		function TabSignal:AddSection(sectionConfig)
			return buildSection(defaultPage, sectionConfig);
		end;

		function TabSignal:Rename(new)
			TabName.Text = tostring(new);
			if WindowSignal.SelectedTab == TabSignal then
				TabSubtitle.Text = tostring(new);
			end
		end;

		function TabSignal:Icon(new)
			TabIcon.Image = NeverZen:GetIcon(new);
		end;

		local function findRecordLabel(record)
			if record.Label and record.Label.Parent then return record.Label end;
			if not record.Frame then return nil end;
			for _, descendant in ipairs(record.Frame:GetDescendants()) do
				if descendant:IsA("TextLabel") and descendant.Text == record.Name then
					record.Label = descendant;
					return descendant;
				end
			end
			return nil;
		end

		local function paintRecord(record, query)
			local label = findRecordLabel(record);
			if not label then return end;

			if not query or #query == 0 then
				if label.RichText then
					label.RichText = false;
					label.Text = record.Name;
				end
				return;
			end

			local loweredName = string.lower(record.Name);
			local startIndex, endIndex = string.find(loweredName, query, 1, true);
			if not startIndex then return end;

			label.RichText = true;
			label.Text = string.sub(record.Name, 1, startIndex - 1)
				.. '<font color="#FFFFFF">'
				.. string.sub(record.Name, startIndex, endIndex)
				.. '</font>'
				.. string.sub(record.Name, endIndex + 1);
		end

		local function searchItem(query)
				if destroyed then return end;

			local lowered = query and string.lower(tostring(query)) or nil;
			local activeQuery = (lowered and #lowered > 0) and lowered or nil;
			local matches = 0;

			for _, record in ipairs(records) do
				if not record.Frame or not record.Frame.Parent then
					continue;
				end
				if activeQuery then
					local hit = string.find(string.lower(record.Name), activeQuery, 1, true) ~= nil;
					record.Frame.Visible = hit;
					pcall(function() record.Frame:SetAttribute("NZSearchHidden", not hit) end);
					if hit then
						matches += 1;
						paintRecord(record, activeQuery);
					else
						paintRecord(record, nil);
					end
				else
					record.Frame.Visible = true;
					pcall(function() record.Frame:SetAttribute("NZSearchHidden", false) end);
					paintRecord(record, nil);
				end
			end

			TabSignal.LastMatchCount = matches;
			TabSignal.LastQuery = activeQuery;

			for _, pageEntry in ipairs(pages) do
				local page = pageEntry.page;
				for _, column in ipairs({ page.Left, page.Right }) do
					for _, section in ipairs(column:GetChildren()) do
						if section:IsA("Frame") then
							local any = false;
							for _, child in ipairs(section:GetChildren()) do
								if child:IsA("GuiObject") and child.Name ~= "head" and child.Visible then
									any = true;
									break;
								end
							end
							section.Visible = any;
						end
					end
				end
			end

			if lowered and #lowered > 0 then
				for _, pageEntry in ipairs(pages) do
					local page = pageEntry.page;
					local hasMatch = false;
					for _, record in ipairs(records) do
						if record.Frame and record.Frame.Parent and record.Frame.Visible then
							local ancestor = record.Frame:FindFirstAncestorOfClass("ScrollingFrame");
							if ancestor and ancestor.Parent == page.Frame then
								hasMatch = true;
								break;
							end
						end
					end
					if hasMatch and not page.Frame.Visible then
						selectPage(page);
						break;
					end
				end
			end

			WindowSignal:UpdatePopups();

			if WindowSignal.UpdateSearchResults then
				WindowSignal:UpdateSearchResults(activeQuery);
			end
		end

		local function setTabActive(value)
			TabFrame.Visible = value;

			UI.tween(TabButton, 0.24, {
				BackgroundTransparency = value and 0.92 or 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
			UI.tween(ActiveBar, 0.28, {
				BackgroundTransparency = value and 0.1 or 1,
				Size = value and UDim2.fromOffset(2, 18) or UDim2.fromOffset(2, 6),
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
			UI.tween(TabIcon, 0.26, {
				ImageColor3 = value and P.Text or P.TextMuted,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
			UI.tween(TabName, 0.24, {
				TextColor3 = value and P.Text or P.TextDim,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);

			if value then
				TabSubtitle.Text = config.Name;

				local target = currentPage or defaultPage;
				for _, p in ipairs(pages) do
					setPage(p.page, p.page == target);
				end

				animatePageIn(target, "up");

				task.defer(function()
					for _, apply in ipairs(tabLayouts) do apply(); end;
				end);
			end
		end;

		local TabIden = {
			call = setTabActive,
			target = TabButton,
			Search = searchItem,
			Frame = TabFrame,
			Config = config,
			Tabs = pages,
			Records = records,
		};

		TabSignal.Search = searchItem;
		TabSignal.Frame = TabFrame;
		TabSignal.Target = TabButton;

		function TabSignal:Select()
			WindowSignal:SelectTab(TabIden);
		end;

		function TabSignal:Show()
			TabSignal:Select();
		end;

		local input = NeverZen:NewInput(TabButton);
		input.MouseButton1Click:Connect(function()
			if destroyed then return end;
			WindowSignal:SelectTab(TabIden);
		end);
		input.MouseEnter:Connect(function()
			if TabFrame.Visible then return end;
			UI.tween(TabName, 0.14, { TextColor3 = P.TextSoft });
			UI.tween(TabButton, 0.14, { BackgroundTransparency = 0.96 });
		end);
		input.MouseLeave:Connect(function()
			if TabFrame.Visible then return end;
			UI.tween(TabName, 0.16, { TextColor3 = P.TextDim });
			UI.tween(TabButton, 0.16, { BackgroundTransparency = 1 });
		end);

		table.insert(WindowSignal.Tabs, TabIden);

		if WindowSignal.SelectedTab == nil then
			WindowSignal.SelectedTab = TabIden;
			setTabActive(true);
		else
			setTabActive(false);
		end

		return TabSignal;
	end;

	function WindowSignal:SelectTab(tab)
		if not tab then return end;
		WindowSignal.SelectedTab = tab;
		for _, entry in ipairs(WindowSignal.Tabs) do
			if entry.call then
				entry.call(entry == tab);
			end
		end
		WindowSignal:ClosePopups();

		if WindowSignal.LastSearch and tab.Search then
			tab.Search(WindowSignal.LastSearch);
		end
	end;

	function WindowSignal:GetTab(name)
		for _, entry in ipairs(WindowSignal.Tabs) do
			if entry.Config and entry.Config.Name == name then
				return entry;
			end
		end
		return nil;
	end;

	function WindowSignal:UpdatePopups()
		for i = #popups, 1, -1 do
			local popup = popups[i];
			if not popup.panel or not popup.panel.Parent then
				table.remove(popups, i);
			elseif popup.update then
				popup.update();
			end
		end
	end;

	bind(WindowFrame:GetPropertyChangedSignal("AbsolutePosition"), function()
		WindowSignal:UpdatePopups();
	end);

	WindowSignal.LabelCount = 0;

	function WindowSignal:AddLabel(name)
		local TBSTitle = UI.new("TextLabel", {
			Name = NeverZen:RandomString(),
			Parent = TBSFrame,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 16),
			Text = tostring(name or ""),
			TextColor3 = P.TextMuted,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 12,
			LayoutOrder = -1,
		});
		UI.weight(TBSTitle, FW.Bold);

		WindowSignal.LabelCount += 1;
		return TBSTitle;
	end;

	local SETTINGS_W = 340;

	local SettingsPanel = UI.new("Frame", {
		Name = NeverZen:RandomString(),
		Parent = Content,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromOffset(0, 0),
		Visible = false,
		ClipsDescendants = true,
		ZIndex = 320,
	});

	local SettingsInner = UI.new("Frame", {
		Parent = SettingsPanel,
		BackgroundColor3 = P.Window,
		BackgroundTransparency = math.min((WindowSignal.Config and WindowSignal.Config.Transparency or 0.18) + 0.06, 0.6),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.fromOffset(SETTINGS_W, 0),
		ClipsDescendants = true,
		ZIndex = 320,
	});
	UI.corner(SettingsInner, D.Radius.md);
	local SettingsStroke = UI.stroke(SettingsInner, 0.84);
	table.insert(WindowSignal.FrameMemory.WindowBackgroundColor, SettingsInner);
	table.insert(WindowSignal.TransparencyPanels, SettingsInner);

	local SettingsScroll = UI.new("ScrollingFrame", {
		Parent = SettingsInner,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = P.White,
		ScrollBarImageTransparency = 0.85,
		ZIndex = 321,
	});
	UI.padding(SettingsScroll, 14, 14, 14, 14);
	local SettingsList = UI.list(SettingsScroll, { Padding = UDim.new(0, 6) });

	local function settingsBlock(iconName, title)
		local Block = UI.new("Frame", {
			Parent = SettingsScroll,
			BackgroundColor3 = P.Surface,
			BackgroundTransparency = 0.62,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 322,
		});
		UI.corner(Block, D.Radius.sm);
		UI.stroke(Block, 0.94);
		UI.padding(Block, 8, 8, 8, 8);
		UI.list(Block, { Padding = UDim.new(0, 6) });

		local Head = UI.new("Frame", {
			Parent = Block,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 18),
			ZIndex = 323,
		});

		local HeadIcon = UI.image({
			Parent = Head,
			Image = NeverZen:GetIcon(iconName or "circle"),
			Color = P.TextMuted,
			Size = UDim2.fromOffset(12, 12),
			Position = UDim2.new(0, 2, 0.5, 0),
		});
		HeadIcon.ZIndex = 324;

		local HeadLabel = UI.text({
			Parent = Head,
			Position = UDim2.new(0, 22, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(1, -24, 0, 16),
			Text = string.upper(tostring(title or "")),
			Color = P.Text,
			Size_ = 10.5,
			Weight = FW.Bold,
		});
		HeadLabel.TextSize = 10.5;
		HeadLabel.ZIndex = 324;

		local HeadLine = UI.new("Frame", {
			Parent = Head,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = P.Line,
			BackgroundTransparency = 0.86,
			BorderSizePixel = 0,
			ZIndex = 324,
		});
		HeadLine.Name = "Line";

		return Block, Head;
	end

	local function settingsRowBase(height, parent)
		local Row = UI.new("Frame", {
			Parent = parent or SettingsScroll,
			BackgroundColor3 = P.Surface,
			BackgroundTransparency = 0.35,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, height or 32),
			ZIndex = 322,
		});
		UI.corner(Row, D.Radius.xs);
		UI.stroke(Row, 0.92);
		return Row;
	end

	local function settingsSliderRow(text, minimum, maximum, initial, onChange, parent)
		local Holder = UI.new("Frame", {
			Parent = parent or SettingsScroll,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 34),
			ZIndex = 322,
		});

		local Label = UI.text({
			Parent = Holder,
			Position = UDim2.new(0, 2, 0, 0),
			Size = UDim2.new(1, -60, 0, 16),
			Text = text,
			Color = P.TextSoft,
			Size_ = 12,
			Weight = FW.Medium,
		});
		Label.TextSize = 12;
		Label.ZIndex = 323;

		local Value = UI.text({
			Parent = Holder,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -2, 0, 0),
			Size = UDim2.fromOffset(56, 16),
			Text = tostring(initial),
			Color = P.Text,
			Size_ = 11.5,
			XAlign = Enum.TextXAlignment.Right,
			Weight = FW.Bold,
		});
		Value.TextSize = 11.5;
		Value.ZIndex = 323;

		local Track = UI.new("TextButton", {
			Parent = Holder,
			Position = UDim2.fromOffset(2, 21),
			Size = UDim2.new(1, -4, 0, 8),
			BackgroundColor3 = P.Surface,
			BackgroundTransparency = 0.4,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 323,
		});
		UI.corner(Track, D.Radius.pill);

		local Fill = UI.new("Frame", {
			Parent = Track,
			BackgroundColor3 = P.White,
			BackgroundTransparency = 0.35,
			BorderSizePixel = 0,
			Size = UDim2.new((initial - minimum) / (maximum - minimum), 0, 1, 0),
			ZIndex = 324,
		});
		UI.corner(Fill, D.Radius.pill);

		local value = initial;

		local function apply(newValue, fire)
			value = math.clamp(newValue, minimum, maximum);
			Fill.Size = UDim2.new((value - minimum) / (maximum - minimum), 0, 1, 0);
			Value.Text = tostring(math.floor(value + 0.5));
			if fire then
				task.spawn(onChange, value);
			end
		end

		local function fromPosition(position)
			local absolute = Track.AbsolutePosition;
			local width = math.max(Track.AbsoluteSize.X, 1);
			apply(minimum + math.clamp((position.X - absolute.X) / width, 0, 1) * (maximum - minimum), true);
		end

		local input = NeverZen:NewInput(Track);
		input.InputBegan:Connect(function(pointer)
			if destroyed then return end;
			if pointer.UserInputType ~= Enum.UserInputType.MouseButton1 and pointer.UserInputType ~= Enum.UserInputType.Touch then return end;
			fromPosition(pointer.Position);
			addDrag({ update = function(position) fromPosition(position) end });
		end);
		input.MouseEnter:Connect(function() UI.tween(Fill, 0.14, { BackgroundTransparency = 0.15 }) end);
		input.MouseLeave:Connect(function() UI.tween(Fill, 0.16, { BackgroundTransparency = 0.35 }) end);

		return Holder, Value, apply;
	end

	local function settingsSwitchRow(iconName, text, initial, onChange, parent)
		local Row = settingsRowBase(34, parent);

		local Icon = UI.image({
			Parent = Row,
			Image = NeverZen:GetIcon(iconName),
			Color = P.TextMuted,
			Size = UDim2.fromOffset(13, 13),
			Position = UDim2.new(0, 10, 0.5, 0),
		});
		Icon.ZIndex = 323;

		local Label = UI.text({
			Parent = Row,
			Position = UDim2.new(0, 30, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(1, -80, 0, 18),
			Text = text,
			Color = P.TextSoft,
			Size_ = 12,
			Weight = FW.Medium,
		});
		Label.TextSize = 12;
		Label.ZIndex = 323;

		local Switch = UI.new("Frame", {
			Parent = Row,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			Size = UDim2.fromOffset(36, 20),
			BackgroundColor3 = P.White,
			BackgroundTransparency = 0.93,
			BorderSizePixel = 0,
			ZIndex = 323,
		});
		UI.pill(Switch);
		local SwitchStroke = UI.stroke(Switch, 0.88);
		WindowSignal.KeepOpaque[Switch] = true;

		local Knob = UI.new("Frame", {
			Parent = Switch,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 3, 0.5, 0),
			Size = UDim2.fromOffset(14, 14),
			BackgroundColor3 = P.TextDim,
			BorderSizePixel = 0,
			ZIndex = 324,
		});
		UI.pill(Knob);
		WindowSignal.KeepOpaque[Knob] = true;

		local value = initial and true or false;

		local KnobScale = Instance.new("UIScale");
		KnobScale.Scale = 1;
		KnobScale.Parent = Knob;

		local function render(newValue)
			value = newValue and true or false;
			UI.tween(Knob, 0.28, {
				Position = value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
				BackgroundColor3 = value and P.OnAccent or P.TextDim,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
			UI.tween(Switch, 0.22, {
				BackgroundTransparency = value and 0 or 0.93,
			}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
			UI.tween(SwitchStroke, 0.22, {
				Transparency = value and 0.5 or 0.88,
			}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
			UI.tween(Label, 0.26, {
				TextColor3 = value and P.Text or P.TextSoft,
			}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
			UI.tween(KnobScale, 0.09, { Scale = 0.82 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
			task.delay(0.09, function()
				if destroyed or not Knob.Parent then return end;
				UI.tween(KnobScale, 0.3, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
			end);
		end;

		render(value);

		local Hit = NeverZen:NewInput(Switch);
		Hit.MouseButton1Click:Connect(function()
			if destroyed then return end;
			render(not value);
			if onChange then pcall(onChange, value) end;
		end);
		NeverZen:Hover(Row, function()
			UI.tween(Row, 0.14, { BackgroundTransparency = 0.15, BackgroundColor3 = P.SurfaceAlt });
			UI.tween(SwitchStroke, 0.18, { Transparency = value and 0.36 or 0.76 });
			UI.tween(KnobScale, 0.2, { Scale = 1.1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
		end, function()
			UI.tween(Row, 0.16, { BackgroundTransparency = 0.35, BackgroundColor3 = P.Surface });
			UI.tween(SwitchStroke, 0.2, { Transparency = value and 0.5 or 0.88 });
			UI.tween(KnobScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
		end);

		return Row, render, function(newValue)
			render(newValue);
		end;
	end;


	local function settingsRow(iconName, text, parent)
		local Row = settingsRowBase(32, parent);

		local Icon = UI.image({
			Parent = Row,
			Image = NeverZen:GetIcon(iconName),
			Color = P.TextMuted,
			Size = UDim2.fromOffset(13, 13),
			Position = UDim2.new(0, 10, 0.5, 0),
		});
		Icon.ZIndex = 323;

		local Label = UI.text({
			Parent = Row,
			Position = UDim2.new(0, 30, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(1, -110, 0, 18),
			Text = text,
			Color = P.TextSoft,
			Size_ = 12,
			Weight = FW.Medium,
		});
		Label.TextSize = 12;
		Label.ZIndex = 323;

		local Value = UI.text({
			Parent = Row,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.fromOffset(90, 18),
			Text = "...",
			Color = P.Text,
			Size_ = 11,
			XAlign = Enum.TextXAlignment.Right,
			Weight = FW.Bold,
		});
		Value.TextSize = 11;
		Value.ZIndex = 323;

		NeverZen:Hover(Row, function()
			UI.tween(Row, 0.12, { BackgroundTransparency = 0.15, BackgroundColor3 = P.SurfaceAlt });
		end, function()
			UI.tween(Row, 0.14, { BackgroundTransparency = 0.35, BackgroundColor3 = P.Surface });
		end);

		local input = NeverZen:NewInput(Row);

		return Row, Value, input;
	end;

	local AppearanceBlock = settingsBlock("palette", "Appearance");

	local TransparencyValue = UI.text({
		Parent = AppearanceBlock,
		Size = UDim2.new(1, 0, 0, 16),
		Text = "Window Transparency  " .. tostring(math.floor(config.Transparency * 100)) .. "%",
		Color = P.TextDim,
		Size_ = 11.5,
		Weight = FW.Medium,
	});
	TransparencyValue.TextSize = 11.5;
	TransparencyValue.ZIndex = 322;

	local TransparencyTrack = UI.new("TextButton", {
		Parent = AppearanceBlock,
		BackgroundColor3 = P.Surface,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 0, 26),
		ZIndex = 322,
	});
	UI.corner(TransparencyTrack, D.Radius.sm);
	UI.padding(TransparencyTrack, 0, 10, 0, 10);

	local TransparencyFill = UI.new("Frame", {
		Parent = TransparencyTrack,
		BackgroundColor3 = P.White,
		BackgroundTransparency = 0.35,
		BorderSizePixel = 0,
		Size = UDim2.new(config.Transparency / 0.6, 0, 1, -10),
		Position = UDim2.fromOffset(0, 5),
		ZIndex = 323,
	});
	UI.corner(TransparencyFill, D.Radius.xs);

	local baseTransparency = config.Transparency;
	local transparencyCache = setmetatable({}, { __mode = "k" });
	local lastApplied = nil;

	local function skipTransparencyRoot(object)
		if object == WindowFrame then return true end;
		if object == WindowSignal.WindowStroke then return true end;
		return false;
	end;

	local function applyTransparency(value)
		if lastApplied and math.abs(lastApplied - value) < 0.004 then return end;

		lastApplied = value;

		WindowFrame.BackgroundTransparency = value;

		local delta = value - baseTransparency;
		local roots = { WindowFrame };

		if Content then
			table.insert(roots, Content);
		end

		for _, root in ipairs(roots) do
			local list = root:GetDescendants();

			for _, object in ipairs(list) do
				if object:IsA("UIStroke") then

				elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then

				elseif object:IsA("GuiObject") then
					if not skipTransparencyRoot(object) and not WindowSignal.KeepOpaque[object] then
						local current = object.BackgroundTransparency;

						if current < 0.985 then
							local cached = transparencyCache[object];
							if cached == nil then
								cached = current;
								transparencyCache[object] = cached;
							end

							object.BackgroundTransparency = math.clamp(cached + delta, 0, 0.97);
						end
					end
				end
			end
		end
	end;

	local function setTransparency(value)
		value = math.clamp(value, 0, 0.6);
		config.Transparency = value;
		pcall(applyTransparency, value);
		for _, hook in ipairs(WindowSignal.TransparencyHooks) do
			pcall(hook, value, baseTransparency);
		end
		TransparencyFill.Size = UDim2.new(value / 0.6, 0, 1, -10);
		TransparencyValue.Text = "Window Transparency  " .. tostring(math.floor(value * 100)) .. "%";
	end

	WindowSignal.SettingsPanel = SettingsPanel;
	WindowSignal.SettingsButton = SettingsButton;

	NeverZen.SetWindowTransparency = setTransparency;

	task.defer(function()
		pcall(applyTransparency, config.Transparency);
	end);
	function WindowSignal:SetTransparency(value)
		setTransparency(value);
	end;

	local function transparencyFromPosition(position)
		local abs = TransparencyTrack.AbsolutePosition;
		local width = math.max(TransparencyTrack.AbsoluteSize.X, 1);
		setTransparency(math.clamp((position.X - abs.X) / width, 0, 1) * 0.6);
	end

	local TransparencyHit = NeverZen:NewInput(TransparencyTrack);
	TransparencyHit.InputBegan:Connect(function(input)
		if destroyed then return end;
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
		transparencyFromPosition(input.Position);
		addDrag({ update = function(position) transparencyFromPosition(position) end });
	end);
	TransparencyHit.MouseEnter:Connect(function()
		UI.tween(TransparencyFill, 0.14, { BackgroundTransparency = 0.15 });
	end);
	TransparencyHit.MouseLeave:Connect(function()
		UI.tween(TransparencyFill, 0.16, { BackgroundTransparency = 0.35 });
	end);

	local function settingsSelectRow(iconName, text, getOptions, onSelect, initialLabel, parent)
		local Row = settingsRowBase(34, parent);

		local Icon = UI.image({
			Parent = Row,
			Image = NeverZen:GetIcon(iconName),
			Color = P.TextMuted,
			Size = UDim2.fromOffset(13, 13),
			Position = UDim2.new(0, 10, 0.5, 0),
		});
		Icon.ZIndex = 323;

		local Label = UI.text({
			Parent = Row,
			Position = UDim2.new(0, 30, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0.45, 0, 0, 18),
			Text = text,
			Color = P.TextSoft,
			Size_ = 12,
			Weight = FW.Medium,
		});
		Label.TextSize = 12;
		Label.ZIndex = 323;

		local Pill = UI.new("TextButton", {
			Parent = Row,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			Size = UDim2.fromOffset(96, 24),
			BackgroundColor3 = P.SurfaceAlt,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ClipsDescendants = true,
			ZIndex = 323,
		});
		UI.corner(Pill, D.Radius.xs);
		UI.stroke(Pill, 0.9);

		local Value = UI.text({
			Parent = Pill,
			Position = UDim2.new(0, 8, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(1, -26, 0, 16),
			Text = initialLabel or "None",
			Color = P.TextSoft,
			Size_ = 11.5,
			Weight = FW.Medium,
		});
		Value.TextSize = 11.5;
		Value.ZIndex = 324;

		local Chevron = UI.image({
			Parent = Pill,
			Image = NeverZen:GetIcon("chevron-down"),
			Color = P.TextMuted,
			Size = UDim2.fromOffset(11, 11),
			Position = UDim2.new(1, -16, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
		});
		Chevron.ZIndex = 324;

		local RowInput = NeverZen:NewInput(Row);
		NeverZen:Hover(Row, function()
			UI.tween(Row, 0.12, { BackgroundTransparency = 0.15, BackgroundColor3 = P.SurfaceAlt });
		end, function()
			UI.tween(Row, 0.14, { BackgroundTransparency = 0.35, BackgroundColor3 = P.Surface });
		end);

		local Panel = UI.new("Frame", {
			Name = "SettingsSelect",
			Parent = Content,
			BackgroundColor3 = P.SurfaceAlt,
			BackgroundTransparency = 0.02,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(150, 0),
			Visible = false,
			ClipsDescendants = true,
			ZIndex = 400,
		});
		UI.corner(Panel, D.Radius.sm);
		UI.stroke(Panel, 0.86);
		local PanelList = UI.list(Panel, { Padding = UDim.new(0, 2) });
		UI.padding(Panel, 4, 4, 4, 4);

		local Options = {};

		local function refresh()
			for _, child in ipairs(Panel:GetChildren()) do
				if child:IsA("TextButton") then
					child:Destroy();
				end
			end

			if Icon then Icon.Image = NeverZen:GetIcon(iconName) end;

			local list = getOptions and getOptions() or {};
			for _, option in ipairs(list) do
				local Btn = UI.new("TextButton", {
					Parent = Panel,
					BackgroundColor3 = P.White,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 22),
					Text = tostring(option),
					TextColor3 = P.TextSoft,
					TextSize = 11.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutoButtonColor = false,
					ZIndex = 401,
				});
				UI.corner(Btn, D.Radius.xs);
				UI.padding(Btn, 0, 8, 0, 8);
				UI.weight(Btn, FW.Medium);

				Btn.MouseEnter:Connect(function()
					UI.tween(Btn, 0.12, { BackgroundTransparency = 0.9 });
				end);
				Btn.MouseLeave:Connect(function()
					UI.tween(Btn, 0.14, { BackgroundTransparency = 1 });
				end);
				Btn.MouseButton1Click:Connect(function()
					if destroyed then return end;
					Value.Text = tostring(option);
					if onSelect then onSelect(option) end;
					Panel.Visible = false;
					Panel.Size = UDim2.fromOffset(150, 0);
				end);
				table.insert(Options, Btn);
			end

			local height = #list * 24 + 8;
			if Panel.Visible then
				UI.tween(Panel, 0.16, { Size = UDim2.fromOffset(150, height) });
			end
			return height;
		end

		local function positionPanel()
			if not Panel.Visible then return end;
			local pos = Pill.AbsolutePosition;
			local size = Pill.AbsoluteSize;
			local vp = workspace.CurrentCamera.ViewportSize;
			local panelHeight = #Options * 24 + 8;
			local x = math.clamp(pos.X + size.X - 150, 8, math.max(vp.X - 158, 8));
			local y = math.clamp(pos.Y + size.Y + 4, 8, math.max(vp.Y - panelHeight - 8, 8));
			Panel.Position = UDim2.fromOffset(x, y);
		end

		Pill.MouseButton1Click:Connect(function()
			if destroyed then return end;
			if Panel.Visible then
				Panel.Visible = false;
				Panel.Size = UDim2.fromOffset(150, 0);
				return;
			end

			for _, child in ipairs(Panel:GetChildren()) do
				if child:IsA("TextButton") then child:Destroy() end
			end
			Options = {};

			local height = refresh();
			Panel.Visible = true;
			positionPanel();
			UI.tween(Panel, 0.18, { Size = UDim2.fromOffset(150, height) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
		end);

		bind(WindowFrame:GetPropertyChangedSignal("AbsolutePosition"), positionPanel);

		table.insert(popups, {
			panel = Panel,
			Close = function()
				Panel.Visible = false;
				Panel.Size = UDim2.fromOffset(150, 0);
			end,
			update = positionPanel,
		});

		return Row, Value, Pill, refresh;
	end;

	local ConfigurationBlock = settingsBlock("save", "Configuration");

	local GetConfigList = function()
		local configs = NeverZen:ListConfigs();
		if #configs == 0 then
			return { "No configs" };
		end
		return configs;
	end;

	local autoLoadRow, autoLoadValue, _, refreshAutoLoad = settingsSelectRow("upload", "Auto Load", GetConfigList, function(option)
		WindowSignal:SetAutoLoad(option);
	end, "None", ConfigurationBlock);

	local SaveRow = settingsRowBase(40, ConfigurationBlock);

	local SaveIcon = UI.image({
		Parent = SaveRow,
		Image = NeverZen:GetIcon("download"),
		Color = P.TextMuted,
		Size = UDim2.fromOffset(13, 13),
		Position = UDim2.new(0, 10, 0.5, 0),
	});
	SaveIcon.ZIndex = 323;

	local SaveLabel = UI.text({
		Parent = SaveRow,
		Position = UDim2.new(0, 30, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0.4, 0, 0, 18),
		Text = "Save Config",
		Color = P.TextSoft,
		Size_ = 12,
		Weight = FW.Medium,
	});
	SaveLabel.TextSize = 12;
	SaveLabel.ZIndex = 323;

	local SaveInputBg = UI.new("Frame", {
		Parent = SaveRow,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(150, 26),
		BackgroundColor3 = P.SurfaceAlt,
		BorderSizePixel = 0,
		ZIndex = 323,
	});
	UI.corner(SaveInputBg, D.Radius.xs);
	UI.stroke(SaveInputBg, 0.9);

	local SaveInput = UI.new("TextBox", {
		Parent = SaveInputBg,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(1, -78, 1, 0),
		PlaceholderText = "Name...",
		PlaceholderColor3 = P.TextMuted,
		Text = "",
		TextColor3 = P.TextSoft,
		TextSize = 11.5,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 324,
	});
	UI.weight(SaveInput, FW.Medium);

	local SaveBtn = UI.new("TextButton", {
		Parent = SaveInputBg,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -4, 0.5, 0),
		Size = UDim2.fromOffset(46, 18),
		BackgroundColor3 = P.White,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = "Save",
		TextColor3 = P.OnAccent,
		TextSize = 10.5,
		AutoButtonColor = false,
		ZIndex = 324,
	});
	UI.corner(SaveBtn, D.Radius.xs);
	UI.weight(SaveBtn, FW.Bold);

	SaveBtn.MouseEnter:Connect(function() UI.tween(SaveBtn, 0.12, { BackgroundTransparency = 0.12 }) end);
	SaveBtn.MouseLeave:Connect(function() UI.tween(SaveBtn, 0.14, { BackgroundTransparency = 0 }) end);

	SaveBtn.MouseButton1Click:Connect(function()
		local name = SaveInput.Text:gsub("%s+", "");
		if #name > 0 then
			local success = WindowSignal:SaveConfig(name);
			if success then
				SaveInput.Text = "";
				WindowSignal:RefreshAutoLoadDropdown();
				WindowSignal:RefreshLoadDropdown();
				local Notif = NeverZen:CreateNotifier();
				Notif:new("Config Saved", "Config '" .. name .. "' saved successfully!", 3);
			end
		else
			SaveInput.PlaceholderText = "Enter name!";
			task.delay(1.2, function()
				if SaveInput.Parent then SaveInput.PlaceholderText = "Name..."; end;
			end);
		end
	end);

	local AutoSaveRow, _, setAutoSaveSwitch = settingsSwitchRow("save", "Auto Save", false, function(value)
		WindowSignal:SetAutoSave(value, WindowSignal.CurrentConfigName or "autosave");
	end, ConfigurationBlock);

	WindowSignal.SetAutoSaveSwitch = setAutoSaveSwitch;

	local ShareRow = settingsRowBase(40, ConfigurationBlock);

	local ShareLabel = UI.text({
		Parent = ShareRow,
		Position = UDim2.new(0, 10, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0.45, 0, 0, 18),
		Text = "Share Config",
		Color = P.TextSoft,
		Size_ = 12,
		Weight = FW.Medium,
	});
	ShareLabel.TextSize = 12;
	ShareLabel.ZIndex = 323;

	local function shareButton(text, x, width, callback)
		local Button = UI.new("TextButton", {
			Parent = ShareRow,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, x, 0.5, 0),
			Size = UDim2.fromOffset(width, 22),
			BackgroundColor3 = P.SurfaceAlt,
			BorderSizePixel = 0,
			Text = text,
			TextColor3 = P.TextSoft,
			TextSize = 10.5,
			AutoButtonColor = false,
			ZIndex = 324,
		});
		UI.corner(Button, D.Radius.xs);
		UI.stroke(Button, 0.9);
		UI.weight(Button, FW.SemiBold);

		Button.MouseEnter:Connect(function()
			UI.tween(Button, 0.12, { BackgroundTransparency = 0.15 });
			UI.tween(Button, 0.12, { TextColor3 = P.Text });
		end);
		Button.MouseLeave:Connect(function()
			UI.tween(Button, 0.14, { BackgroundTransparency = 0 });
			UI.tween(Button, 0.14, { TextColor3 = P.TextSoft });
		end);
		Button.MouseButton1Click:Connect(function()
			if destroyed then return end;
			callback(Button);
		end);

		return Button;
	end

	shareButton("Copy", -6, 52, function()
		local exported = WindowSignal:ExportConfig();
		local notifier = NeverZen:CreateNotifier();
		if exported then
			notifier:new("Config Copied", "Config string is in your clipboard.", 3);
		else
			notifier:new("Error", "Could not export config.", 3);
		end
	end);

	shareButton("Paste", -62, 52, function()
		local payload = nil;
		pcall(function()
			payload = getclipboard();
		end);
		if not payload or #tostring(payload) == 0 then
			NeverZen:CreateNotifier():new("Error", "Clipboard is empty.", 3);
			return;
		end
		local ok = WindowSignal:ImportConfig(tostring(payload));
		NeverZen:CreateNotifier():new(
			ok and "Config Imported" or "Error",
			ok and "Settings applied." or "Clipboard does not contain a config.",
			3
		);
	end);

	local PresetList = UI.new("Frame", {
		Parent = ConfigurationBlock,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 322,
	});
	UI.list(PresetList, { Padding = UDim.new(0, 6) });

	local refreshLoad;

	local function presetButton(parent, iconName, width, color)
		local Button = UI.new("TextButton", {
			Parent = parent,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -6 - width, 0.5, 0),
			Size = UDim2.fromOffset(width, 20),
			BackgroundColor3 = P.White,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 324,
		});
		UI.corner(Button, D.Radius.xs);

		local Glyph = UI.image({
			Parent = Button,
			Image = NeverZen:GetIcon(iconName),
			Color = color or P.TextMuted,
			Size = UDim2.fromOffset(12, 12),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
		});
		Glyph.ZIndex = 325;

		return Button, Glyph;
	end

	local function refreshPresets()
		for _, child in ipairs(PresetList:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy();
			end
		end

		local configs = NeverZen:ListConfigs();
		local autoName = NeverZen:GetAutoLoadName();

		if #configs == 0 then
			local Empty = UI.new("Frame", {
				Parent = PresetList,
				BackgroundColor3 = P.Surface,
				BackgroundTransparency = 0.55,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 30),
				ZIndex = 322,
			});
			UI.corner(Empty, D.Radius.xs);

			local EmptyLabel = UI.text({
				Parent = Empty,
				Size = UDim2.fromScale(1, 1),
				Text = "No saved presets",
				Color = P.TextMuted,
				Size_ = 11.5,
				Weight = FW.Medium,
				XAlign = Enum.TextXAlignment.Center,
			});
			EmptyLabel.ZIndex = 323;
			return;
		end

		for index, name in ipairs(configs) do
			local Row = UI.new("Frame", {
				Parent = PresetList,
				BackgroundColor3 = P.Surface,
				BackgroundTransparency = 0.35,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 30),
				ZIndex = 322,
			});
			UI.corner(Row, D.Radius.xs);
			local RowStroke = UI.stroke(Row, 0.92);

			local RowIcon = UI.image({
				Parent = Row,
				Image = NeverZen:GetIcon("file-text"),
				Color = (autoName == name) and P.Text or P.TextMuted,
				Size = UDim2.fromOffset(12, 12),
				Position = UDim2.new(0, 10, 0.5, 0),
			});
			RowIcon.ZIndex = 323;

			local NameLabel = UI.text({
				Parent = Row,
				Position = UDim2.new(0, 30, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(1, -100, 0, 18),
				Text = name,
				Color = P.TextSoft,
				Size_ = 12,
				Weight = FW.Medium,
			});
			NameLabel.ZIndex = 323;

			local AutoBtn, AutoGlyph = presetButton(Row, "star", 20, (autoName == name) and P.Text or P.TextMuted);
			AutoBtn.Position = UDim2.new(1, -56, 0.5, 0);

			local LoadBtn2, LoadGlyph = presetButton(Row, "upload", 20);
			LoadBtn2.Position = UDim2.new(1, -30, 0.5, 0);

			local DeleteBtn, DeleteGlyph = presetButton(Row, "trash-2", 20);
			DeleteBtn.Position = UDim2.new(1, -6, 0.5, 0);

			AutoBtn.MouseEnter:Connect(function() UI.tween(AutoGlyph, 0.12, { ImageColor3 = P.Text }) end);
			AutoBtn.MouseLeave:Connect(function()
				UI.tween(AutoGlyph, 0.14, { ImageColor3 = (NeverZen:GetAutoLoadName() == name) and P.Text or P.TextMuted });
			end);

			LoadBtn2.MouseEnter:Connect(function() UI.tween(LoadGlyph, 0.12, { ImageColor3 = P.Text }) end);
			LoadBtn2.MouseLeave:Connect(function() UI.tween(LoadGlyph, 0.14, { ImageColor3 = P.TextMuted }) end);

			DeleteBtn.MouseEnter:Connect(function() UI.tween(DeleteGlyph, 0.12, { ImageColor3 = P.Text }) end);
			DeleteBtn.MouseLeave:Connect(function() UI.tween(DeleteGlyph, 0.14, { ImageColor3 = P.TextMuted }) end);

			NeverZen:Hover(Row, function()
				UI.tween(Row, 0.12, { BackgroundTransparency = 0.15, BackgroundColor3 = P.SurfaceAlt });
				UI.tween(RowStroke, 0.12, { Transparency = 0.82 });
				UI.tween(NameLabel, 0.12, { TextColor3 = P.Text });
			end, function()
				UI.tween(Row, 0.14, { BackgroundTransparency = 0.35, BackgroundColor3 = P.Surface });
				UI.tween(RowStroke, 0.14, { Transparency = 0.92 });
				UI.tween(NameLabel, 0.14, { TextColor3 = P.TextSoft });
			end);

			AutoBtn.MouseButton1Click:Connect(function()
				if NeverZen:GetAutoLoadName() == name then
					NeverZen:ClearAutoLoad();
				else
					WindowSignal:SetAutoLoad(name);
				end
				refreshPresets();
			end);

			LoadBtn2.MouseButton1Click:Connect(function()
				local ok = WindowSignal:LoadConfig(name);
				local Notif = NeverZen:CreateNotifier();
				if ok then
					Notif:new("Preset Loaded", "Preset '" .. name .. "' applied.", 3);
				else
					Notif:new("Error", "Could not load preset '" .. name .. "'.", 3);
				end
			end);

			local armed = false;
			DeleteBtn.MouseButton1Click:Connect(function()
				if not armed then
					armed = true;
					DeleteGlyph.Image = NeverZen:GetIcon("check");
					UI.tween(DeleteGlyph, 0.1, { ImageColor3 = P.Text });
					task.delay(2.5, function()
						if armed and DeleteGlyph.Parent then
							armed = false;
							DeleteGlyph.Image = NeverZen:GetIcon("trash-2");
							DeleteGlyph.Color = P.TextMuted;
						end
					end);
					return;
				end

				armed = false;
				NeverZen:DeleteConfig(name);
				if NeverZen:GetAutoLoadName() == name then
					NeverZen:ClearAutoLoad();
				end
				local Notif = NeverZen:CreateNotifier();
				Notif:new("Preset Deleted", "Preset '" .. name .. "' removed.", 3);
				refreshPresets();
			end);
		end
	end

	refreshLoad = refreshPresets;
	refreshPresets();

	function WindowSignal:RefreshAutoLoadDropdown()
		if refreshAutoLoad then refreshAutoLoad() end;
	end;

	function WindowSignal:RefreshLoadDropdown()
		if refreshLoad then refreshLoad() end;
	end;

	local AnimeOverlayBlock = settingsBlock("image", "Anime overlay");
	local _, _, animeImageToggleSetter = settingsSwitchRow(
		"image",
		"Hentai Girl",
		AnimeImageDefault,
		function(value)
			if destroyed then return end
			local ok = setAnimeImageVisible(value, true)
			if value and not ok and setAnimeImageSwitch then
				pcall(setAnimeImageSwitch, false)
			end
		end,
		AnimeOverlayBlock
	);
	setAnimeImageSwitch = animeImageToggleSetter;

	if AnimeImageDefault then
		local ok = setAnimeImageVisible(true, true)
		if not ok and setAnimeImageSwitch then pcall(setAnimeImageSwitch, false) end
	end

	local InterfaceBlock = settingsBlock("layout", "Interface");

	local setKeybindListVisible;

	local KeybindListRow, _, setKeybindListSwitch = settingsSwitchRow("list", "Keybind List", config.KeybindList, function(value)
		if setKeybindListVisible then
			setKeybindListVisible(value);
		end
	end, InterfaceBlock);

	WindowSignal.SetKeybindListSwitch = setKeybindListSwitch;

	function WindowSignal:SetParticles(enabled)
		config.Particles = enabled and true or false;
		NeverZen:SetParticles(config.Particles);
		if WindowSignal.SetParticlesSwitch then
			WindowSignal.SetParticlesSwitch(config.Particles);
		end
		return config.Particles;
	end;

	local _, _, setParticlesSwitch = settingsSwitchRow("activity", "Particles", config.Particles, function(value)
		if WindowSignal.SetParticles then
			WindowSignal:SetParticles(value);
		end
	end, InterfaceBlock);

	WindowSignal.SetParticlesSwitch = setParticlesSwitch;

	function WindowSignal:SetAnimations(enabled)
		config.Animations = enabled and true or false;
		NeverZen:SetAnimations(config.Animations);
		if WindowSignal.SetAnimationsSwitch then
			WindowSignal.SetAnimationsSwitch(config.Animations);
		end
		return config.Animations;
	end;

	local _, _, setAnimationsSwitch = settingsSwitchRow("sliders-horizontal", "Animations", config.Animations, function(value)
		WindowSignal:SetAnimations(value);
	end, InterfaceBlock);

	WindowSignal.SetAnimationsSwitch = setAnimationsSwitch;

	local CenterRow, CenterValue = settingsRow("move", "Center Window", InterfaceBlock);
	CenterValue.Text = "Center";
	NeverZen:NewInput(CenterRow, function()
		if destroyed then return end;
		if WindowSignal.CenterWindow then
			WindowSignal.CenterWindow();
		end
	end);

	local scaleBase = config.Scale;

	settingsSliderRow("Interface Scale", 80, 130, 100, function(value)
		local factor = value / 100;
		WindowSignal:SetScale(UDim2.fromOffset(
			math.floor(scaleBase.X.Offset * factor),
			math.floor(scaleBase.Y.Offset * factor)
		));
	end, InterfaceBlock);

	local KeybindBlock = settingsBlock("keyboard", "Keybinds");

	local KeyRow, KeyValue = settingsRow("keyboard", "Toggle Menu", KeybindBlock);

	local KeyDisplay = function(item)
		local Keys = {
			One = '1', Two = '2', Three = '3', Four = '4', Five = '5',
			Six = '6', Seven = '7', Eight = '8', Nine = '9', Zero = '0',
			LeftControl = "LCtrl", RightControl = "RCtrl",
			LeftShift = "LShift", RightShift = "RShift",
		};
		if not item then return "NONE" end;
		if typeof(item) == 'EnumItem' then
			return Keys[item.Name] or item.Name;
		end
		return Keys[tostring(item)] or string.upper(tostring(item));
	end;

	KeyValue.Text = KeyDisplay(config.Keybind);

	local isBindingKey = false;
	NeverZen:NewInput(KeyRow, function()
		if isBindingKey then return end;
		isBindingKey = true;
		WindowSignal.BindingKey = true;
		KeyValue.Text = "...";

		local selected = nil;
		while not selected and not destroyed do
			local key = Services.UserInputService.InputBegan:Wait();

			if key.KeyCode == Enum.KeyCode.Escape then
				break;
			end

			if key.KeyCode ~= Enum.KeyCode.Unknown then
				selected = key.KeyCode;
			end;
		end;

		if selected then
			config.Keybind = selected;
			KeyValue.Text = KeyDisplay(selected);
		end;
		isBindingKey = false;
		WindowSignal.BindingKey = false;
	end);

	local FooterLabel = UI.text({
		Parent = SettingsScroll,
		Size = UDim2.new(1, 0, 0, 20),
		Text = "Avernus",
		Color = P.TextMuted,
		Size_ = 10,
		XAlign = Enum.TextXAlignment.Center,
		Weight = FW.Medium,
	});
	FooterLabel.TextSize = 10;
	FooterLabel.ZIndex = 322;

	local settingsOpen = false;

	local function updateSettingsPosition()
		if not settingsOpen then return end;
		if not SettingsButton.Parent then return end;
		local viewport = workspace.CurrentCamera.ViewportSize;
		local height = SettingsPanel.AbsoluteSize.Y;
		local anchorX = SettingsButton.AbsolutePosition.X + SettingsButton.AbsoluteSize.X;
		local anchorY = SettingsButton.AbsolutePosition.Y + SettingsButton.AbsoluteSize.Y + 8;
		local clampedX = math.clamp(anchorX, SETTINGS_W + 8, math.max(SETTINGS_W + 8, viewport.X - 8));
		SettingsPanel.Position = UDim2.fromOffset(
			clampedX,
			math.clamp(anchorY, 8, math.max(8, viewport.Y - height - 8))
		);
	end

	local function settingsButtonSize()
		return math.max(math.floor(SettingsButton.AbsoluteSize.X), 94);
	end

	local function settingsTargetHeight()
		return math.clamp(SettingsList.AbsoluteContentSize.Y + 28, 120, 440);
	end

	local function closeSettings()
		if not settingsOpen then return end;
		settingsOpen = false;
		if SettingsButton.Parent then
			UI.tween(SettingsPanel, 0.22, { Size = UDim2.fromOffset(settingsButtonSize(), 30) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In);
		end
		task.delay(0.23, function()
			if SettingsPanel.Parent and not settingsOpen then SettingsPanel.Visible = false end;
		end);
		UI.tween(SettingsIcon, 0.16, { ImageColor3 = P.TextDim });
	end

	local function openSettings()
		settingsOpen = true;
		local targetHeight = settingsTargetHeight();
		SettingsInner.Size = UDim2.fromOffset(SETTINGS_W, targetHeight);
		SettingsPanel.Visible = true;
		SettingsPanel.Size = UDim2.fromOffset(settingsButtonSize(), 30);
		updateSettingsPosition();
		UI.tween(SettingsPanel, 0.3, { Size = UDim2.fromOffset(SETTINGS_W, targetHeight) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
		UI.tween(SettingsIcon, 0.16, { ImageColor3 = P.Text });
	end

	local settingsButtonHidden = true;
	local settingsRevealToken = 0;

	local function setSettingsButtonVisible(visible)
		if settingsButtonHidden == (not visible) then return end;
		settingsButtonHidden = not visible;
		settingsRevealToken += 1;
		if not visible then closeSettings() end;
		if visible then SettingsButton.Visible = true end;

		local baseBg = SettingsLabeled and 0.55 or 1;
		UI.tween(SettingsButton, 0.26, { BackgroundTransparency = visible and baseBg or 1 });
		UI.tween(SettingsIcon, 0.26, { ImageTransparency = visible and 0 or 1 });
		if SettingsText then UI.tween(SettingsText, 0.26, { TextTransparency = visible and 0 or 1 }) end;
		if SettingsStroke then UI.tween(SettingsStroke, 0.26, { Transparency = visible and 0.9 or 1 }) end;

		if not visible then
			task.delay(0.28, function()
				if not settingsButtonHidden then return end;
				SettingsButton.Visible = false;
			end);
		end
	end

	local function revealSettingsButton(delaySeconds)
		settingsRevealToken += 1;
		local token = settingsRevealToken;
		task.delay(delaySeconds or 0, function()
			if destroyed then return end;
			if token ~= settingsRevealToken then return end;
			if not WindowSignal.Toggle then return end;
			if settingsButtonHidden ~= true then return end;
			setSettingsButtonVisible(true);
		end);
	end

	SettingsButton.MouseButton1Click:Connect(function()
		if destroyed then return end;
		if settingsOpen then
			closeSettings();
		else
			closeAllPopups(nil);
			openSettings();
		end
	end);

	bind(WindowFrame:GetPropertyChangedSignal("AbsolutePosition"), function()
		updateSettingsPosition();
	end);

	bind(Services.UserInputService.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
		if not settingsOpen then return end;
		if NeverZen:IsMouseOverFrame(SettingsPanel) or NeverZen:IsMouseOverFrame(SettingsButton) then return end;
		closeSettings();
	end);

	local function markBase(object)
		local ok = pcall(function()
			object:SetAttribute("NZBg", object.BackgroundTransparency);
		end);
		return ok;
	end;

	local KeybindGui = UI.new("ScreenGui", {
		Name = NeverZen:RandomString(),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 56,
	});
	NeverZen:SafeParent(KeybindGui);
	NeverZen.ProtectGui(KeybindGui);
	WindowSignal.KeybindGui = KeybindGui;

	local KeybindPanel = UI.new("Frame", {
		Parent = KeybindGui,
		Name = "KeybindList",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -18, 0.5, 0),
		Size = UDim2.fromOffset(240, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = P.Window,
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		Visible = false,
		ClipsDescendants = true,
		ZIndex = 210,
	});
	UI.corner(KeybindPanel, D.Radius.lg);
	UI.stroke(KeybindPanel, 0.86);
	markBase(KeybindPanel);
	UI.list(KeybindPanel, { Padding = UDim.new(0, 0) });

	local keybindDelta = 0;

	local function keybindObjects()
		local list = { KeybindPanel };
		for _, descendant in ipairs(KeybindPanel:GetDescendants()) do
			if descendant:IsA("GuiObject") then
				table.insert(list, descendant);
			end
		end
		return list;
	end

	local function applyKeybindTransparency()
		if not KeybindPanel.Visible then return end;
		for _, object in ipairs(keybindObjects()) do
			local ok, baseBg = pcall(function()
				return object:GetAttribute("NZBg");
			end);
			if ok and typeof(baseBg) == "number" and baseBg < 0.995 then
				pcall(function()
					object.BackgroundTransparency = math.clamp(baseBg + keybindDelta, 0, 0.97);
				end);
			end
		end
	end

	table.insert(WindowSignal.TransparencyHooks, function(value, base)
		keybindDelta = value - base;
		applyKeybindTransparency();
	end);

	local KeybindHeader = UI.new("Frame", {
		Parent = KeybindPanel,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 44),
		LayoutOrder = 0,
		ZIndex = 211,
	});
	UI.padding(KeybindHeader, 12, 12, 0, 0);

	local headerIconSize = math.clamp(config.KeybindListLogoSize or 22, 12, 30);

	local HeaderIcon = UI.image({
		Parent = KeybindHeader,
		Image = config.Logo or NeverZen.Logo or "",
		Color = Color3.fromRGB(255, 255, 255),
		Size = UDim2.fromOffset(headerIconSize, headerIconSize),
		Position = UDim2.new(0, 12, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
	});
	HeaderIcon.ZIndex = 212;

	local KeybindTitle = UI.text({
		Parent = KeybindHeader,
		Position = UDim2.new(0, 12 + headerIconSize + 10, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(1, -96, 0, 18),
		Text = "Active Keybinds",
		Color = P.Text,
		Size_ = 13,
		Weight = FW.Bold,
		XAlign = Enum.TextXAlignment.Left,
	});
	KeybindTitle.TextSize = 13;
	KeybindTitle.ZIndex = 212;

	markBase(KeybindTitle);

	local CountBadge = UI.new("Frame", {
		Parent = KeybindHeader,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(26, 20),
		BackgroundColor3 = P.SurfaceAlt,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		ZIndex = 212,
	});
	UI.pill(CountBadge);
	UI.stroke(CountBadge, 0.88);
	markBase(CountBadge);

	local CountLabel = UI.text({
		Parent = CountBadge,
		Size = UDim2.fromScale(1, 1),
		Text = "0",
		Color = P.TextSoft,
		Size_ = 11,
		Weight = FW.Bold,
		XAlign = Enum.TextXAlignment.Center,
	});
	CountLabel.TextSize = 11;
	CountLabel.ZIndex = 213;

	local HeaderDivider = UI.new("Frame", {
		Parent = KeybindPanel,
		BackgroundColor3 = P.Line,
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -24, 0, 1),
		LayoutOrder = 1,
		ZIndex = 211,
	});
	markBase(HeaderDivider);

	local KeybindBody = UI.new("Frame", {
		Parent = KeybindPanel,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2,
		ZIndex = 211,
	});
	UI.padding(KeybindBody, 12, 12, 10, 12);
	UI.list(KeybindBody, { Padding = UDim.new(0, 7) });

	local KeybindEmpty = UI.text({
		Parent = KeybindBody,
		Size = UDim2.new(1, 0, 0, 16),
		Text = "No active binds",
		Color = P.TextDim,
		Size_ = 11.5,
		Weight = FW.Medium,
		XAlign = Enum.TextXAlignment.Left,
		LayoutOrder = 1,
	});
	KeybindEmpty.TextSize = 11.5;
	KeybindEmpty.ZIndex = 212;
	KeybindEmpty.Visible = false;
	KeybindEmpty.LayoutOrder = 0;

	local keybindRows = {};

	local function rebuildKeybinds()
		for _, row in ipairs(keybindRows) do
			if row.Row and row.Row.Parent then row.Row:Destroy() end;
		end
		table.clear(keybindRows);

		local entries = WindowSignal.KeybindEntries;
		KeybindEmpty.Visible = #entries == 0;
		CountLabel.Text = tostring(#entries);

		for index, entry in ipairs(entries) do
			local Row = UI.new("Frame", {
				Parent = KeybindBody,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 18),
				LayoutOrder = index + 1,
				ZIndex = 211,
			});

			local Dot = UI.new("Frame", {
				Parent = Row,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(5, 5),
				BackgroundColor3 = P.Line,
				BorderSizePixel = 0,
				ZIndex = 212,
			});
			UI.pill(Dot);

			local Label = UI.text({
				Parent = Row,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 13, 0.5, 0),
				Size = UDim2.new(1, -68, 0, 16),
				Text = tostring(entry.Name),
				Color = P.TextDim,
				Size_ = 11.5,
				Weight = FW.Medium,
			});
			Label.TextSize = 11.5;
			Label.ZIndex = 212;

			local KeyLabel = UI.text({
				Parent = Row,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(58, 16),
				Text = "NONE",
				Color = P.TextSoft,
				Size_ = 10.5,
				XAlign = Enum.TextXAlignment.Right,
				Weight = FW.Bold,
			});
			KeyLabel.TextSize = 10.5;
			KeyLabel.ZIndex = 212;

			markBase(Row);
			markBase(Dot);
			markBase(Label);
			markBase(KeyLabel);

			table.insert(keybindRows, {
				Row = Row,
				Dot = Dot,
				Label = Label,
				Key = KeyLabel,
				Entry = entry,
				Active = false,
			});
		end

		applyKeybindTransparency();
	end;

	WindowSignal.RebuildKeybindList = rebuildKeybinds;

	local pollClock = 0;

	local keybindConn = RunService.Heartbeat:Connect(function()
		if not KeybindPanel.Visible then return end;

		local now = os.clock();
		if now - pollClock < 0.05 then return end;
		pollClock = now;

		if WindowSignal.KeybindDirty then
			WindowSignal.KeybindDirty = false;
			rebuildKeybinds();
		end

		for _, row in ipairs(keybindRows) do
			local key = row.Entry.GetKey and row.Entry.GetKey();

			if row.Entry.GetLabel then
				local label = row.Entry.GetLabel();
				if row.Key.Text ~= label then
					row.Key.Text = tostring(label);
				end
			end

			local down = false;
			if typeof(key) == "EnumItem" then
				local ok, state = pcall(function()
					return Services.UserInputService:IsKeyDown(key);
				end);
				down = ok and state == true;
			end

			if down ~= row.Active then
				row.Active = down;

				if down then
					UI.tween(row.Dot, 0.08, { BackgroundColor3 = P.White });
					UI.tween(row.Label, 0.08, { TextColor3 = P.Text });
					UI.tween(row.Key, 0.08, { TextColor3 = P.White });
				else
					UI.tween(row.Dot, 0.16, { BackgroundColor3 = P.Line });
					UI.tween(row.Label, 0.16, { TextColor3 = P.TextDim });
					UI.tween(row.Key, 0.16, { TextColor3 = P.TextSoft });
				end
			end
		end
	end);

	local panelVisible = false;
	local panelTween = nil;

	local appliedVisible = nil;

	local function fadePanel(visible, speed)
		if speed == nil then speed = 0.22 end;
		if appliedVisible == visible and panelTween == nil then return end;
		appliedVisible = visible;

		if panelTween then
			pcall(function() panelTween:Cancel() end);
			panelTween = nil;
		end

		local info = TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		local list = { KeybindPanel };

		for _, descendant in ipairs(KeybindPanel:GetDescendants()) do
			if descendant:IsA("GuiObject") then
				table.insert(list, descendant);
			end
		end

		for _, object in ipairs(list) do
			local props = {};

			if object:IsA("TextLabel") or object:IsA("TextBox") or object:IsA("TextButton") then
				props.TextTransparency = visible and 0 or 1;
			end

			if object:IsA("ImageLabel") or object:IsA("ImageButton") then
				props.ImageTransparency = visible and 0 or 1;
			end

			local okAttr, baseBg = pcall(function()
				return object:GetAttribute("NZBg");
			end);

			if okAttr and typeof(baseBg) == "number" and baseBg < 0.995 then
				props.BackgroundTransparency = visible and math.clamp(baseBg + keybindDelta, 0, 0.97) or 1;
			end

			if next(props) then
				pcall(function()
					UI.tw(object, info, props):Play();
				end);
			end

			local stroke = object:FindFirstChildOfClass("UIStroke");
			if stroke then
				pcall(function()
					UI.tw(stroke, info, {
						Transparency = visible and 0.84 or 1,
					}):Play();
				end);
			end
		end

		local slide = UI.tw(
			KeybindPanel,
			TweenInfo.new(speed + 0.06, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Position = UDim2.new(1, visible and -18 or -6, 0.5, 0) }
		);

		if visible then
			KeybindPanel.Position = UDim2.new(1, -8, 0.5, 0);
			KeybindPanel.Visible = true;
		end

		slide:Play();
		panelTween = slide;

		task.delay(speed + 0.08, function()
			panelTween = nil;
			if not panelVisible then
				pcall(function()
					if KeybindPanel.Parent then
						KeybindPanel.Visible = false;
					end
				end);
			end
		end);
	end;

	setKeybindListVisible = function(value)
		value = value and true or false;
		config.KeybindList = value;

		if KeybindPanel.Parent then
			if value then
				panelVisible = true;
				rebuildKeybinds();
				fadePanel(true);
			else
				panelVisible = false;
				fadePanel(false);
			end
		end

		if WindowSignal.SetKeybindListSwitch then
			WindowSignal.SetKeybindListSwitch(value);
		end
	end;

	NeverZen:RegisterInstance("KeybindList", function()
		if keybindConn then pcall(function() keybindConn:Disconnect() end) end;
		if KeybindGui and KeybindGui.Parent then
			KeybindGui:Destroy();
		end
	end);

	WindowSignal.SetKeybindListVisible = setKeybindListVisible;
	WindowSignal.ShowKeybindList = function()
		panelVisible = true;
		if KeybindPanel.Parent then
			rebuildKeybinds();
			fadePanel(true);
		end
	end;
	WindowSignal.HideKeybindList = function()
		panelVisible = false;
		if KeybindPanel.Parent then
			fadePanel(false);
		end
	end;

	function WindowSignal:SetKeybindList(value)
		setKeybindListVisible(value);
	end;
	WindowSignal.KeybindPanel = KeybindPanel;

	if config.KeybindList then
		task.defer(function()
			if destroyed then return end;
			setKeybindListVisible(true);
		end);
	end

	local BodyVisible = true;

	local MIN_WIDTH = 210;
	local MIN_HEIGHT = HeaderH;

	local TweenService_ = TweenService;

	local function setParticleVisibility(visible)
		for _, entry in ipairs(NeverZen.ParticleFields) do
			pcall(function()
				entry:SetActive(visible);
			end);
			if entry.Frame then
				entry.Frame.Visible = visible;
			end
		end
	end

	local function syncParticles(state)
		if state == "closed" then
			setParticleVisibility(false);
			return;
		end

		if config.Particles == false or NeverZen.ParticlesEnabled == false then
			setParticleVisibility(false);
			return;
		end

		setParticleVisibility(true);

		local thin = (state == "collapsed");
		for index, particle in ipairs(ParticleField.Particles) do
			particle.inst.Visible = (not thin) or (index % 12 == 0);
		end
	end

	local function ToggleWin(open)
		WindowSignal.Toggle = open;

		if not open then
			closeAllPopups(nil);
			hardClosePopups();
			closeSearchResults();
			setSettingsButtonVisible(false);
			syncParticles("collapsed");
			if WindowSignal.SetLogoCollapsed then WindowSignal.SetLogoCollapsed(true) end;

			BodyVisible = false;
			pcall(function() MinIcon.Image = NeverZen:GetIcon("plus") end);

			UI.tw(Sidebar, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Position = UDim2.new(-1, 0, 0, 0),
			}):Play();

			UI.tw(TabWin, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Position = UDim2.new(1, 0, 0, 0),
			}):Play();

			UI.tw(SearchFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Size = UDim2.fromOffset(0, 32),
			}):Play();

			UI.tw(SearchStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Transparency = 1,
			}):Play();

			UI.tween(BrandDivider, 0.3, { BackgroundTransparency = 1 });
			UI.tween(TabSubtitle, 0.3, { TextTransparency = 1 });

			UI.tw(WindowFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Size = UDim2.fromOffset(MIN_WIDTH, MIN_HEIGHT),
			}):Play();

			task.delay(0.55, function()
				if destroyed or WindowSignal.Toggle then return end;
				Body.Visible = false;
			end);
		else
			revealSettingsButton(0.82);
			syncParticles("open");
			if WindowSignal.SetLogoCollapsed then WindowSignal.SetLogoCollapsed(false) end;

			Body.Visible = true;
			BodyVisible = true;
			pcall(function() MinIcon.Image = NeverZen:GetIcon("minus") end);

			UI.tw(Sidebar, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0, 0, 0, 0),
			}):Play();

			UI.tw(TabWin, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Position = UDim2.fromOffset(SidebarW, 0),
			}):Play();

			UI.tw(SearchFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Size = UDim2.fromOffset(210, 32),
			}):Play();

			UI.tw(SearchStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Transparency = 0.88,
			}):Play();

			UI.tween(BrandDivider, 0.34, { BackgroundTransparency = 0.82 });
			UI.tween(TabSubtitle, 0.34, { TextTransparency = 0 });

			UI.tw(WindowFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				Size = config.Scale,
			}):Play();

			task.delay(0.7, function()
				if destroyed or not WindowSignal.Toggle then return end;
				BodyVisible = true;
				Body.Visible = true;
				for _, apply in ipairs(tabLayouts) do apply(); end;
				WindowSignal:UpdatePopups();
			end);
		end;

		WindowSignal:UpdatePopups();
	end;

	WindowSignal.ToggleWin = ToggleWin;

	local function DestroyWindow()
		if destroyed then return end;

		closeAllPopups(nil);
		closeSettings();
		WindowSignal.Closed = true;
		syncParticles("closed");

		pcall(function() Content.Enabled = false end);

		UI.tween(WindowFrame, 0.2, {
			Size = UDim2.fromOffset(0, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.In);

		task.delay(0.22, function()
			pcall(function() WindowSignal:Destroy() end);
			NeverZen:UnregisterInstance("Window");

			if config.CloseDestroysAll then
				pcall(function() NeverZen:CloseInstances(true, { "KeybindList" }) end);
			end
			pcall(function()
				if ParticleField then ParticleField:SetActive(false) end;
			end);
		end);
	end;

	WindowSignal.DestroyUI = DestroyWindow;

	MinButton.MouseButton1Click:Connect(function()
		if destroyed then return end;
		ToggleWin(not WindowSignal.Toggle);
	end);

	CloseButton.MouseButton1Click:Connect(function()
		if destroyed then return end;

		if not config.CloseDestroys then
			WindowSignal:SetVisible(false);
			return;
		end

		DestroyWindow();
	end);

	bind(Services.UserInputService.InputBegan, function(input, gameProcessed)
		if gameProcessed then return end;
		if destroyed then return end;
		if WindowSignal.BindingKey then return end;
		if input.KeyCode == config.Keybind then
			if WindowSignal.Closed then
				WindowSignal:SetVisible(true);
			else
				ToggleWin(not WindowSignal.Toggle);
			end
		end
	end);

	bind(WindowFrame:GetPropertyChangedSignal("AbsoluteSize"), function()
		for _, apply in ipairs(tabLayouts) do apply(); end;
		WindowSignal:UpdatePopups();
	end);

	if config.Resizable then
		local Resize = UI.new("TextButton", {
			Name = "Resize",
			Parent = WindowFrame,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -4, 1, -4),
			Size = UDim2.fromOffset(18, 18),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 60,
		});

		local Grip = UI.image({
			Parent = Resize,
			Image = NeverZen:GetIcon("move-diagonal-2"),
			Color = P.TextMuted,
			Size = UDim2.fromOffset(13, 13),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Transparency = 0.45,
		});
		Grip.ZIndex = 61;

		Resize.MouseEnter:Connect(function() UI.tween(Grip, 0.14, { ImageTransparency = 0 }) end);
		Resize.MouseLeave:Connect(function() UI.tween(Grip, 0.16, { ImageTransparency = 0.45 }) end);

		Resize.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
			if destroyed then return end;

			local startMouse = input.Position;
			local startSize = WindowFrame.AbsoluteSize;

			addDrag({
				update = function(position)
					local deltaX = position.X - startMouse.X;
					local deltaY = position.Y - startMouse.Y;
					local width = math.max(380, startSize.X + deltaX);
					local height = math.max(300, startSize.Y + deltaY);
					WindowFrame.Size = UDim2.fromOffset(width, height);
					config.Scale = UDim2.fromOffset(width, height);
				end,
				release = function()
						end,
			});
		end);
	end

	local dragToggle = nil;
	local dragSpeed = 0.2;
	local dragStart = nil;
	local startPos = nil;

	local function updateInput(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(
			startPos.X.Scale, math.max(startPos.X.Offset + delta.X, -10),
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		);
		UI.tw(WindowFrame, TweenInfo.new(dragSpeed), { Position = position }):Play();
	end

	local function normalizePos(pos)
		if pos.X.Scale == 0 and pos.Y.Scale == 0 then return pos end;
		local ok, vp = pcall(function() return workspace.CurrentCamera.ViewportSize end);
		if not ok or not vp then return UDim2.fromOffset(pos.X.Offset, pos.Y.Offset) end;
		return UDim2.fromOffset(
			pos.X.Scale * vp.X + pos.X.Offset,
			pos.Y.Scale * vp.Y + pos.Y.Offset
		);
	end

	local function centerWindow()
		local ok, viewport = pcall(function() return workspace.CurrentCamera.ViewportSize end);
		if not ok or not viewport then return end;
		local size = WindowFrame.AbsoluteSize;
		UI.tween(WindowFrame, 0.35, {
			Position = UDim2.fromOffset(
				math.max(math.floor((viewport.X - size.X) / 2), 0),
				math.max(math.floor((viewport.Y - size.Y) / 2), 0)
			),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut);
	end

	WindowSignal.CenterWindow = centerWindow;

	local DockMargin = 8;

	local function dockWindow()
		if config.Dock == false then return end;
		local ok, viewport = pcall(function() return workspace.CurrentCamera.ViewportSize end);
		if not ok or not viewport then return end;
		local size = WindowFrame.AbsoluteSize;
		local position = WindowFrame.AbsolutePosition;
		local x = position.X;
		local y = position.Y;
		if math.abs(x) <= DockMargin then
			x = DockMargin;
		elseif math.abs(viewport.X - (x + size.X)) <= DockMargin then
			x = viewport.X - size.X - DockMargin;
		end
		if math.abs(y) <= DockMargin then
			y = DockMargin;
		elseif math.abs(viewport.Y - (y + size.Y)) <= DockMargin then
			y = viewport.Y - size.Y - DockMargin;
		end
		if x ~= position.X or y ~= position.Y then
			UI.tween(WindowFrame, 0.2, {
				Position = UDim2.fromOffset(math.floor(x), math.floor(y)),
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
		end
	end

	local function blocksWindowDrag()
		if SettingsPanel and SettingsPanel.Parent and SettingsPanel.Visible
			and NeverZen:IsMouseOverFrame(SettingsPanel) then
			return true;
		end

		if SearchResults and SearchResults.Parent and SearchResults.Visible
			and NeverZen:IsMouseOverFrame(SearchResults) then
			return true;
		end

		if SearchFrame and NeverZen:IsMouseOverFrame(SearchFrame) then
			return true;
		end

		if KeybindPanel and KeybindPanel.Parent and KeybindPanel.Visible
			and NeverZen:IsMouseOverFrame(KeybindPanel) then
			return true;
		end

		for _, popup in ipairs(popups) do
			local panel = popup.panel;
			if panel and panel.Parent and panel.Visible and NeverZen:IsMouseOverFrame(panel) then
				return true;
			end
		end

		return false;
	end

	local function startDrag(input)
		dragToggle = true;
		dragStart = input.Position;
		startPos = normalizePos(WindowFrame.Position);
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragToggle = false;
				pcall(dockWindow);
			end
		end);
	end

	local lastHeaderClick = 0;

	bind(Header.InputBegan, function(input)
		if destroyed then return end;
		if blocksWindowDrag() then return end;
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local now = os.clock();
			if now - lastHeaderClick < 0.35 then
				lastHeaderClick = 0;
				centerWindow();
				return;
			end
			lastHeaderClick = now;
			startDrag(input);
		end
	end);

	bind(Services.UserInputService.InputChanged, function(input)
		if destroyed then return end;
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input);
			end
		end
	end);

	bind(Services.UserInputService.InputBegan, function(input, processed)
		if destroyed or dragToggle then return end;
		if processed then return end;
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end;
		if not WindowFrame.Visible then return end;
		if blocksWindowDrag() then return end;
		if NeverZen:IsMouseOverFrame(Header) then
			startDrag(input);
		end
	end);

	function WindowSignal:SetScale(new)
		WindowSignal.Config.Scale = new;
		UI.tween(WindowFrame, 0.4, { Size = new }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut);
	end;

	function WindowSignal:SetVisible(value)
		if value then
			WindowSignal.Closed = false;
			Content.Enabled = true;
			syncParticles("open");

			if not WindowSignal.Toggle then
				ToggleWin(true);
			else
				WindowFrame.Size = UDim2.fromOffset(0, 0);
				UI.tween(WindowFrame, 0.38, { Size = config.Scale }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
				revealSettingsButton(0.42);
			end
		else
			closeAllPopups(nil);
			hardClosePopups();
			closeSettings();
			setSettingsButtonVisible(false);
			syncParticles("closed");
			WindowSignal.Closed = true;

			UI.tween(WindowFrame, 0.22, { Size = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In);
			task.delay(0.26, function()
				if WindowSignal.Closed and Content.Parent then
					Content.Enabled = false;
				end
			end);
		end
	end;

	function WindowSignal:Open() WindowSignal:SetVisible(true) end;
	function WindowSignal:Close() WindowSignal:SetVisible(false) end;

	function WindowSignal:ParticleSettings(opts)
		opts = opts or {};
		if opts.Enabled ~= nil then
			config.Particles = opts.Enabled and true or false;
			NeverZen:SetParticles(config.Particles);
			if WindowSignal.SetParticlesSwitch then
				WindowSignal.SetParticlesSwitch(config.Particles);
			end
		end
		if opts.Size then
			for _, field in ipairs({ ParticleField, BackdropField }) do
				if field then
					for _, particle in ipairs(field.Particles) do
						particle.inst.Size = UDim2.fromOffset(opts.Size, opts.Size);
					end
				end
			end
		end
	end;

	function WindowSignal:Destroy()
		if destroyed then return end;
		destroyed = true;
		WindowSignal.Destroyed = true;

		for index = #NeverZen.Windows, 1, -1 do
			if NeverZen.Windows[index] == WindowSignal then
				table.remove(NeverZen.Windows, index);
			end
		end

		for index = #WindowSignal.Dependencies, 1, -1 do
			WindowSignal.Dependencies[index] = nil;
		end

		for _, connection in ipairs(connections) do
			pcall(function() connection:Disconnect() end);
		end
		table.clear(connections);

		for i = #popups, 1, -1 do
			local popup = popups[i];
			if popup.close then pcall(popup.close) end;
			if popup.panel then popup.panel:Destroy() end;
		end
		table.clear(popups);

		stopAnimeImageAnimation()
		animeDragging = false
		animeAnimationAssets = nil
		animeAnimationLabels = {}
		if animeImageGui then
			pcall(function() animeImageGui:Destroy() end)
			animeImageGui = nil
			animeImageLabel = nil
		end
		animeImageVisible = false
		WindowSignal.AnimeImageVisible = false

		ParticleField:Destroy();
		if BackdropField then BackdropField:Destroy() end;
		if BackdropGui then BackdropGui:Destroy() end;
		Content:Destroy();
	end;

	function WindowSignal:StatusBar()
		local Statusbar = UI.new("Frame", {
			Name = NeverZen:RandomString(),
			Parent = Content,
			AnchorPoint = Vector2.new(1, 0),
			Position = config.StatusBarPosition or UDim2.new(1, -14, 0, 52),
			Size = UDim2.new(0, 0, 0, 26),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			ZIndex = 200,
		});
		UI.list(Statusbar, {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 6),
		});

		return {
			create = function(name)
				local Frame = UI.new("Frame", {
					Parent = Statusbar,
					BackgroundColor3 = P.SurfaceAlt,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(0, 26),
					AutomaticSize = Enum.AutomaticSize.X,
					ZIndex = 201,
				});
				UI.pill(Frame);
				UI.new("UIPadding", { Parent = Frame, PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) });

				local Label = UI.text({
					Parent = Frame,
					Size = UDim2.fromScale(1, 1),
					Text = name or "",
					Color = P.TextSoft,
					Size_ = 11.5,
					XAlign = Enum.TextXAlignment.Center,
					Weight = FW.Medium,
				});
				Label.TextSize = 11.5;
				Label.ZIndex = 202;
				Label.AutomaticSize = Enum.AutomaticSize.X;
				Frame.Size = UDim2.fromOffset(0, 26);

				return {
					Visible = function(self, a)
						Frame.Visible = a and true or false;
					end,
					Text = function(self, value)
						Label.Text = value or "";
					end,
					Destroy = function(self)
						Frame:Destroy();
					end,
				};
			end,
		};
	end;

	local globalEnv = (getgenv and getgenv()) or _G;
	if globalEnv then
		globalEnv.NZ_RESET = function()

			local vp = workspace.CurrentCamera.ViewportSize;
			local size = WindowFrame.AbsoluteSize;
			UI.tween(WindowFrame, 0.35, {
				Position = UDim2.fromOffset(
					math.max(math.floor((vp.X - size.X) / 2), 0),
					math.max(math.floor((vp.Y - size.Y) / 2), 0)
				),
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut);
		end;
	end;

	if NeverZen.ConfigAutoLoad then
		task.delay(1.2, function()
			if destroyed then return end;
			WindowSignal:AutoLoadConfig();
		end);
	end

	if config.Acrylic then
		NeverZen:SetBlur(WindowFrame);
	end

	if config.LoadSound then
		task.delay(0.5, function()
			local sound = Instance.new("Sound");
			sound.SoundId = config.LoadSound;
			sound.Volume = 0.7;
			sound.Parent = game:GetService("SoundService");
			sound:Play();
			task.delay(4, function()
				sound:Destroy();
			end);
		end);
	end

	WindowFrame.Size = UDim2.fromOffset(0, 0);
	task.defer(function()
		pcall(function()
			UI.tween(WindowFrame, 0.45, { Size = config.Scale }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
		end);
	end);

	revealSettingsButton(0.62);

	task.delay(0.8, function()
		if destroyed then return end;
		local ok = pcall(function()
			if WindowFrame.Parent and (WindowFrame.AbsoluteSize.X < 10 or WindowFrame.AbsoluteSize.Y < 10) then
				WindowFrame.Size = config.Scale;
			end
			if Content and Content.Parent then
				Content.Enabled = true;
			end
		end)
	end);

	WindowSignal.Frame = WindowFrame;
	WindowSignal.ContentGui = Content;
	WindowSignal.ScreenGui = Content;

	NeverZen:RegisterInstance("Window", function()
		WindowSignal:Destroy();
	end);

	return WindowSignal;
end;

function NeverZen:CreateNotifier()
	local P = NeverZen.Palette;
	local D = NeverZen.Design;

	local Content = UI.new("ScreenGui", {
		Name = NeverZen:RandomString(),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 60,
	});
	NeverZen:SafeParent(Content);
	NeverZen.ProtectGui(Content);

	local Notification = UI.new("Frame", {
		Name = NeverZen:RandomString(),
		Parent = Content,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -24, 1, -24),
		Size = UDim2.fromOffset(300, 60),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 250,
	});
	UI.list(Notification, {
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, 8),
	});

	local activeNotifs = 0;
	local notifLimit = 5;
	local closers = {};

	NeverZen:RegisterInstance("Notifier", function()
		Content:Destroy();
	end);

	return {
		SetLimit = function(self, limit)
			notifLimit = math.max(1, math.floor(tonumber(limit) or 5));
			return notifLimit;
		end,
		GetLimit = function(self) return notifLimit end,
		Clear = function(self)
			for _, entry in ipairs(closers) do
				pcall(entry.close);
			end
		end,
		new = function(self, head, body, duration)
			duration = duration or 4;

			while #closers >= notifLimit do
				local oldest = table.remove(closers, 1);
				if oldest then pcall(oldest.close) end;
			end

			local isError = tostring(head):lower():find("error") or tostring(head):lower():find("fail");
			local accent = isError and Color3.fromRGB(236, 236, 240) or P.White;

			local Notify = UI.new("Frame", {
				Name = NeverZen:RandomString(),
				Parent = Notification,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 40, 0, 0),
				Size = UDim2.new(0, 300, 0, 0),
				BackgroundColor3 = P.Window,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = 250,
			});
			UI.corner(Notify, D.Radius.md);
			UI.stroke(Notify, 0.84);

			local IconHolder = UI.new("Frame", {
				Parent = Notify,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 16, 0.42, 0),
				Size = UDim2.fromOffset(30, 30),
				BackgroundColor3 = P.SurfaceAlt,
				BorderSizePixel = 0,
				ZIndex = 252,
			});
			UI.pill(IconHolder);
			UI.stroke(IconHolder, 0.86);

			local Icon = UI.image({
				Parent = IconHolder,
				Image = isError and NeverZen:GetIcon("alert-circle") or NeverZen:GetIcon("check-circle-2"),
				Color = accent,
				Size = UDim2.fromOffset(15, 15),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
			});
			Icon.ZIndex = 253;

			local Header = UI.text({
				Parent = Notify,
				Position = UDim2.new(0, 58, 0, 12),
				Size = UDim2.new(1, -74, 0, 17),
				Text = head,
				Color = P.Text,
				Size_ = 12.5,
				Weight = FW.SemiBold,
			});
			Header.TextSize = 12.5;
			Header.ZIndex = 253;

			local Body = UI.text({
				Parent = Notify,
				Position = UDim2.new(0, 58, 0, 30),
				Size = UDim2.new(1, -74, 1, -38),
				Text = body,
				Color = P.TextDim,
				Size_ = 11.5,
				Wrapped = true,
				YAlign = Enum.TextYAlignment.Top,
				Weight = FW.Medium,
			});
			Body.TextSize = 11.5;
			Body.ZIndex = 253;

			local ProgressBg = UI.new("Frame", {
				Parent = Notify,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = P.White,
				BackgroundTransparency = 0.9,
				BorderSizePixel = 0,
				ZIndex = 252,
			});

			local Progress = UI.new("Frame", {
				Parent = ProgressBg,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = P.White,
				BackgroundTransparency = 0.25,
				BorderSizePixel = 0,
				ZIndex = 253,
			});

			local textHeight = TextService:GetTextSize(tostring(body or ""), 12, FONT.Gotham, Vector2.new(210, math.huge)).Y;
			local targetHeight = math.clamp(textHeight + 40, 58, 120);

			activeNotifs += 1;

			UI.tween(Notify, 0.32, {
				Size = UDim2.new(0, 300, 0, targetHeight),
				Position = UDim2.new(1, 0, 0, 0),
			}, Enum.EasingStyle.Quint);

			UI.tween(Progress, duration, { Size = UDim2.new(0, 0, 1, 0) }, Enum.EasingStyle.Linear);

			local closed = false;
			local entry = nil;

			local function close()
				if closed then return end;
				closed = true;
				if entry then
					for index = #closers, 1, -1 do
						if closers[index] == entry then
							table.remove(closers, index);
						end
					end
					entry = nil;
				end
				local closeTween = UI.tween(Notify, 0.24, {
					Position = UDim2.new(1, 40, 0, 0),
					Size = UDim2.new(0, 300, 0, 0),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.In);
				closeTween.Completed:Connect(function()
					activeNotifs = math.max(0, activeNotifs - 1);
					Notify:Destroy();
				end);
			end

			local dismiss = NeverZen:NewInput(Notify);
			dismiss.MouseEnter:Connect(function()
				UI.tween(Notify, 0.15, { BackgroundColor3 = P.SurfaceAlt });
			end);
			dismiss.MouseLeave:Connect(function()
				UI.tween(Notify, 0.15, { BackgroundColor3 = P.Window });
			end);
			dismiss.MouseButton1Click:Connect(function()
				close();
			end);

			entry = { close = close, Frame = Notify };
			table.insert(closers, entry);

			task.delay(duration, function()
				if Notify.Parent then close() end;
			end);

			return Notify;
		end,

		Destroy = function(self)
			Content:Destroy();
		end,
	}
end;

function NeverZen:CreateWatermark(config)
	local P = NeverZen.Palette;
	local D = NeverZen.Design;

	config = config or {};
	config.Name = config.Name or "Avernus";
	config.Server = config.Server or "local";
	config.ShowUser = (config.ShowUser == nil) and true or config.ShowUser;
	config.ShowDebug = (config.ShowDebug == nil) and true or config.ShowDebug;
	config.ShowFPS = (config.ShowFPS == nil) and true or config.ShowFPS;
	config.ShowPing = (config.ShowPing == nil) and true or config.ShowPing;
	config.PillTransparency = (config.PillTransparency == nil) and 0.4 or config.PillTransparency;
	config.ShowClock = (config.ShowClock == nil) and true or config.ShowClock;
	config.ShowHealth = (config.ShowHealth == nil) and true or config.ShowHealth;
	config.Position = config.Position or UDim2.new(1, -14, 0, 14);
	config.Logo = config.Logo or NeverZen.Logo;
	config.LogoSize = config.LogoSize or 16;

	local Content = UI.new("ScreenGui", {
		Name = NeverZen:RandomString(),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 55,
	});
	NeverZen:SafeParent(Content);
	NeverZen.ProtectGui(Content);

	local Pill = UI.new("Frame", {
		Name = NeverZen:RandomString(),
		Parent = Content,
		AnchorPoint = Vector2.new(1, 0),
		Position = config.Position,
		Size = UDim2.new(0, 0, 0, 30),
		BackgroundColor3 = P.Window,
		BackgroundTransparency = math.clamp(config.PillTransparency, 0, 0.9),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X,
		ClipsDescendants = true,
		ZIndex = 50,
	});
	UI.corner(Pill, D.Radius.lg);
	UI.stroke(Pill, 0.84);
	UI.new("UIPadding", { Parent = Pill, PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) });
	UI.list(Pill, {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 10),
	});

	local function addSeparator()
		return UI.new("Frame", {
			Name = NeverZen:RandomString(),
			Parent = Pill,
			BackgroundColor3 = P.Line,
			BackgroundTransparency = 0.88,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(1, 12),
			ZIndex = 51,
		});
	end

	local function addSegment(icon, text, bold, italic, color)
		local Holder = UI.new("Frame", {
			Name = NeverZen:RandomString(),
			Parent = Pill,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			ZIndex = 51,
		});
		UI.list(Holder, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 6),
		});

		local Icon;
		local textColor = color or P.TextSoft;
		local isAsset = typeof(icon) == "string" and (
			string.find(icon, "rbxassetid://", 1, true)
			or string.find(icon, "rbxasset://", 1, true)
			or string.find(icon, "rbxthumb://", 1, true)
			or string.find(icon, "http://", 1, true)
			or string.find(icon, "https://", 1, true)
		);
		local iconSize = isAsset and math.clamp(config.LogoSize or 16, 8, 22) or 13;

		if icon and icon ~= "avatar-slot" then
			Icon = UI.image({
				Parent = Holder,
				Image = isAsset and icon or NeverZen:GetIcon(icon),
				Color = isAsset and Color3.fromRGB(255, 255, 255) or textColor,
				Size = UDim2.fromOffset(iconSize, iconSize),
				Position = UDim2.new(0, 0, 0.5, 0),
			});
			Icon.ZIndex = 51;
			Icon.Size = UDim2.fromOffset(iconSize, iconSize);
			Icon.Position = UDim2.fromOffset(0, 0);
			Icon.AnchorPoint = Vector2.new(0, 0.5);
		end;

		local Label = UI.text({
			Parent = Holder,
			Size = UDim2.new(0, 0, 1, 0),
			Text = text,
			Color = textColor,
			Size_ = 12,
			Weight = bold and FW.Bold or FW.Medium,
		});
		Label.TextSize = 12;
		Label.AutomaticSize = Enum.AutomaticSize.X;
		Label.ZIndex = 51;

		if italic then
			pcall(function()
				Label.FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					FW.Bold,
					Enum.FontStyle.Italic
				);
			end);
		end;

		return Holder, Label, Icon;
	end;

	local avatarIcon = config.Avatar;

	if avatarIcon == nil and config.UseAvatar ~= false then
		avatarIcon = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=48&h=48";
	end

	config.AvatarBesideName = (config.AvatarBesideName == nil) and true or config.AvatarBesideName;

	local imageBesideName = avatarIcon and config.AvatarBesideName;

	local _, NameLabel, NameIcon = addSegment(nil, config.Name, true, true, P.Text);

	local function makeAvatar(parent)
		local size = math.clamp(config.AvatarSize or 18, 12, 24);

		local Icon = UI.image({
			Parent = parent,
			Image = avatarIcon,
			Color = Color3.fromRGB(255, 255, 255),
			Size = UDim2.fromOffset(size, size),
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
		});
		Icon.ZIndex = 51;

		local Corner = Instance.new("UICorner");
		Corner.CornerRadius = UDim.new(1, 0);
		Corner.Parent = Icon;

		local Stroke = Instance.new("UIStroke");
		Stroke.Thickness = 1;
		Stroke.Transparency = 0.75;
		Stroke.Color = Color3.fromRGB(255, 255, 255);
		Stroke.Parent = Icon;

		pcall(function()
			Icon.Image = Services.Players:GetUserThumbnailAsync(
				LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size48x48
			);
		end);

		return Icon;
	end;

	if NameIcon then
		NameIcon.Visible = false;
	end

	if config.ShowDebug then
		addSeparator();
		addSegment("code", "Debug");
	end;

	local function maskName(name, showChars)
		name = tostring(name or "");
		if #name <= 2 then return name end;

		showChars = showChars or math.max(math.floor(#name / 2), 2);
		showChars = math.min(showChars, #name - 1);

		return string.sub(name, 1, showChars) .. string.rep("*", math.min(#name - showChars, 6));
	end;

	config.MaskUser = (config.MaskUser == nil) and true or config.MaskUser;
	config.UserShowChars = config.UserShowChars or nil;

	if config.ShowUser then
		addSeparator();
		local displayName = config.MaskUser and maskName(LocalPlayer.Name, config.UserShowChars) or LocalPlayer.Name;
		local Holder, UserLabel = addSegment(imageBesideName and "avatar-slot" or "user", displayName);

		if imageBesideName then
			local UserAvatar = makeAvatar(Holder);
			UserAvatar.ZIndex = 52;
			UserAvatar.LayoutOrder = 0;
			pcall(function() UserLabel.LayoutOrder = 1 end);
		end
	end;

	config.ShowServer = (config.ShowServer == nil) and true or config.ShowServer;

	local ServerLabel;
	if config.ShowServer then
		addSeparator();
		local _, srv = addSegment("database", config.Server);
		ServerLabel = srv;
	end;

	local PingLabel;
	if config.ShowPing then
		addSeparator();
		local _, ping = addSegment("wifi", "0ms");
		PingLabel = ping;
	end;

	local Stats = nil;
	pcall(function()
		Stats = cloneref(game:GetService("Stats"));
	end);

	local function readPing()
		if not Stats then return 0 end;

		local ok, value = pcall(function()
			return Stats.Network.ServerStatsItem["Data Ping"]:GetValue();
		end);

		if ok and typeof(value) == "number" then
			return math.floor(value);
		end

		return 0;
	end;

	local FPSLabel;
	if config.ShowFPS then
		addSeparator();
		local _, fps = addSegment("cpu", "0fps");
		FPSLabel = fps;
	end;

	local ClockLabel;
	if config.ShowClock then
		addSeparator();
		local _, clock = addSegment("clock", os.date("%H:%M"));
		ClockLabel = clock;
	end;

	local HealthLabel;
	if config.ShowHealth then
		addSeparator();
		local _, hp = addSegment("heart-pulse", "100/100");
		HealthLabel = hp;
	end;

	local frames, lastUpdate = 0, os.clock();

	local heartbeat;
	if config.ShowFPS or config.ShowClock or config.ShowPing then
		heartbeat = RunService.Heartbeat:Connect(function()
			frames += 1;

			local now = os.clock();
			if now - lastUpdate >= 1 then
				if FPSLabel then
					FPSLabel.Text = tostring(frames) .. "fps";
				end;

				if ClockLabel then
					ClockLabel.Text = os.date("%H:%M");
				end;

				if PingLabel then
					PingLabel.Text = tostring(readPing()) .. "ms";
				end;

				frames = 0;
				lastUpdate = now;
			end;
		end);
	end;

	local healthConn;
	local characterConn;
	if config.ShowHealth then
		local function bindHumanoid(char)
			if healthConn then healthConn:Disconnect(); healthConn = nil end
			local hum = char:WaitForChild("Humanoid", 5)
			if not hum then return end

			local function updateHealth()
				if HealthLabel then
					HealthLabel.Text = string.format("%d/%d", math.max(0, math.floor(hum.Health)), math.floor(hum.MaxHealth))
				end
			end

			updateHealth()
			healthConn = hum:GetPropertyChangedSignal("Health"):Connect(updateHealth)
		end

		if LocalPlayer.Character then
			bindHumanoid(LocalPlayer.Character)
		end

		characterConn = LocalPlayer.CharacterAdded:Connect(function(char)
			task.wait(0.2)
			bindHumanoid(char)
		end)
	end;

	NeverZen:RegisterInstance("Watermark", function()
		Content:Destroy();
	end);

	return {
		SetName = function(self, newname)
			NameLabel.Text = newname;
		end,

		SetLogo = function(self, url)
			if not NameIcon then return end;
			if url then
				NameIcon.Image = url;
				config.Logo = url;
			end
			NameIcon.Visible = url ~= nil and url ~= "";
		end,

		SetTransparency = function(self, value)
			value = math.clamp(value or 0, 0, 0.9);
			config.PillTransparency = value;
			Pill.BackgroundTransparency = value;
		end,

		SetServer = function(self, newserver)
			if ServerLabel then ServerLabel.Text = newserver end
		end,

		Visible = function(self, value)
			Content.Enabled = value;
		end,

		Destroy = function(self)
			if heartbeat then
				heartbeat:Disconnect();
			end;
			if healthConn then healthConn:Disconnect() end;
			if characterConn then characterConn:Disconnect() end;
			Content:Destroy();
		end,
	};
end;

function NeverZen:CreateKeySystem(config)
	local P = NeverZen.Palette;
	local D = NeverZen.Design;

	config = config or {}
	config.Service = config.Service or "Avernus Hub"
	config.Identifier = config.Identifier or ""
	config.Provider = config.Provider or "Mixed"
	config.OnSuccess = config.OnSuccess or function() end
	config.OnFail = config.OnFail or function() end

	local JunkieSDK = nil
	local Validated = false
	local CurrentKey = nil

	local function loadJunkie()
		if JunkieSDK then return true end
		local success, result = pcall(function()
			return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
		end)
		if success and result then
			JunkieSDK = result
			JunkieSDK.service = config.Service
			JunkieSDK.identifier = config.Identifier
			JunkieSDK.provider = config.Provider
			return true
		end
		return false
	end

	local function getKeyLink()
		if not loadJunkie() then return nil end
		return JunkieSDK.get_key_link and JunkieSDK.get_key_link()
	end

	local function checkKey(key)
		if not loadJunkie() then return { valid = false, error = "SDK load failed" } end
		return JunkieSDK.check_key and JunkieSDK.check_key(key) or { valid = false, error = "Check failed" }
	end

	local screenGui = UI.new("ScreenGui", {
		Name = NeverZen:RandomString(),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 70,
	});
	NeverZen:SafeParent(screenGui);
	NeverZen.ProtectGui(screenGui);

	screenGui.Enabled = false;

	local panel = UI.new("Frame", {
		Name = NeverZen:RandomString(),
		Parent = screenGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.fromOffset(380, 0),
		BackgroundColor3 = P.Window,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 101,
	});
	UI.corner(panel, D.Radius.lg);
	UI.stroke(panel, 0.84);

	local Particles = UI.particles(panel, { ZIndex = 1, Count = 34 });

	local titleIcon = UI.image({
		Parent = panel,
		Image = NeverZen:GetIcon("lock"),
		Color = P.Text,
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.fromOffset(22, 26),
		AnchorPoint = Vector2.new(0, 0),
	});
	titleIcon.ZIndex = 102;
	titleIcon.Position = UDim2.fromOffset(22, 24);
	titleIcon.AnchorPoint = Vector2.new(0, 0.5);

	local title = UI.text({
		Parent = panel,
		Position = UDim2.fromOffset(48, 14),
		Size = UDim2.new(1, -70, 0, 24),
		Text = config.Service,
		Color = P.Text,
		Size_ = 16,
		Weight = FW.Bold,
	});
	title.TextSize = 16;
	title.ZIndex = 102;

	local subtitle = UI.text({
		Parent = panel,
		Position = UDim2.fromOffset(48, 34),
		Size = UDim2.new(1, -70, 0, 16),
		Text = "Authentication required",
		Color = P.TextMuted,
		Size_ = 11,
		Weight = FW.Medium,
	});
	subtitle.TextSize = 11;
	subtitle.ZIndex = 102;

	local line = UI.new("Frame", {
		Parent = panel,
		BackgroundColor3 = P.Line,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(22, 58),
		Size = UDim2.new(1, -44, 0, 1),
		ZIndex = 102,
	});

	local desc = UI.text({
		Parent = panel,
		Position = UDim2.fromOffset(22, 72),
		Size = UDim2.new(1, -44, 0, 34),
		Text = "Complete the key system to access the script.\nClick 'Get Key' to start.",
		Color = P.TextDim,
		Size_ = 11.5,
		Wrapped = true,
		YAlign = Enum.TextYAlignment.Top,
		Weight = FW.Medium,
	});
	desc.TextSize = 11.5;
	desc.ZIndex = 102;

	local inputBg = UI.new("Frame", {
		Parent = panel,
		BackgroundColor3 = P.Surface,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(22, 118),
		Size = UDim2.new(1, -44, 0, 38),
		ZIndex = 102,
	});
	UI.corner(inputBg, D.Radius.sm);
	local inputStroke = UI.stroke(inputBg, 0.86);

	local keyIcon = UI.image({
		Parent = inputBg,
		Image = NeverZen:GetIcon("key"),
		Color = P.TextMuted,
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(0, 12, 0.5, 0),
	});
	keyIcon.ZIndex = 103;

	local textBox = UI.new("TextBox", {
		Parent = inputBg,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(34, 0),
		Size = UDim2.new(1, -46, 1, 0),
		PlaceholderText = "Enter your key here...",
		PlaceholderColor3 = P.TextMuted,
		Text = "",
		TextColor3 = P.TextSoft,
		TextSize = 12.5,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 103,
	});
	UI.weight(textBox, FW.Medium);

	textBox.Focused:Connect(function()
		UI.tween(inputStroke, 0.14, { Transparency = 0.55, Color = P.White });
	end);

	local getKeyBtn = UI.new("TextButton", {
		Parent = panel,
		BackgroundColor3 = P.Surface,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(22, 168),
		Size = UDim2.new(0.5, -28, 0, 36),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 102,
	});
	UI.corner(getKeyBtn, D.Radius.sm);
	UI.stroke(getKeyBtn, 0.88);

	local getKeyIcon = UI.image({
		Parent = getKeyBtn,
		Image = NeverZen:GetIcon("link"),
		Color = P.TextDim,
		Size = UDim2.fromOffset(13, 13),
		Position = UDim2.new(0.5, -32, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
	});
	getKeyIcon.ZIndex = 103;

	local getKeyLabel = UI.text({
		Parent = getKeyBtn,
		Size = UDim2.new(1, 14, 1, 0),
		Text = "Get Key",
		Color = P.TextSoft,
		Size_ = 12,
		XAlign = Enum.TextXAlignment.Center,
		Weight = FW.SemiBold,
	});
	getKeyLabel.TextSize = 12;
	getKeyLabel.ZIndex = 103;

	local submitBtn = UI.new("TextButton", {
		Parent = panel,
		BackgroundColor3 = P.White,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 6, 0, 168),
		Size = UDim2.new(0.5, -28, 0, 36),
		Text = "Submit",
		Font = FONT.GothamBold,
		TextColor3 = P.OnAccent,
		TextSize = 12,
		AutoButtonColor = false,
		ZIndex = 102,
	});
	UI.corner(submitBtn, D.Radius.sm);
	UI.weight(submitBtn, FW.Bold);

	local statusLabel = UI.text({
		Parent = panel,
		Position = UDim2.fromOffset(22, 214),
		Size = UDim2.new(1, -44, 0, 18),
		Text = "",
		Color = P.TextDim,
		Size_ = 11,
		XAlign = Enum.TextXAlignment.Left,
		Weight = FW.Medium,
	});
	statusLabel.TextSize = 11;
	statusLabel.ZIndex = 102;

	screenGui.Enabled = true;

	UI.tween(panel, 0.42, { Size = UDim2.fromOffset(380, 248) }, Enum.EasingStyle.Quint);

	local attempts = 0
	local finished = false

	local function closeUI()
		if finished then return end
		finished = true
		Particles:SetActive(false);
		UI.tween(panel, 0.28, { Size = UDim2.fromOffset(380, 0) }, Enum.EasingStyle.Quint);
		task.delay(0.35, function()
			screenGui:Destroy()
		end)
	end

	local function onSuccess(key)
		Validated = true
		CurrentKey = key
		getgenv().SCRIPT_KEY = key

		pcall(function()
			if isfolder and makefolder and not isfolder("AvernusLib") then
				makefolder("AvernusLib");
			end;
			if writefile then
				local dateStr = os.date("%d-%m-%y-%H");
				writefile("AvernusLib/key-" .. dateStr .. ".txt", key);
			end;
		end);

		statusLabel.TextColor3 = P.Text;
		statusLabel.Text = "Valid! Loading...";
		closeUI()
		task.delay(0.5, function()
			pcall(config.OnSuccess, key)
		end)
	end

	local function onFail(err)
		closeUI()
		task.delay(0.5, function()
			pcall(config.OnFail, err)
		end)
	end

	getKeyBtn.MouseButton1Click:Connect(function()
		local link = getKeyLink()
		if not link then
			statusLabel.TextColor3 = P.TextDim
			statusLabel.Text = "Please wait before requesting a new key"
			return
		end
		pcall(function() setclipboard(link) end)
		statusLabel.TextColor3 = P.Text
		statusLabel.Text = "Link copied! Complete it to get your key."
	end)

	getKeyBtn.MouseEnter:Connect(function()
		UI.tween(getKeyBtn, 0.12, { BackgroundColor3 = P.SurfaceHigh });
		UI.tween(getKeyLabel, 0.12, { TextColor3 = P.Text });
		UI.tween(getKeyIcon, 0.12, { ImageColor3 = P.Text });
	end)
	getKeyBtn.MouseLeave:Connect(function()
		UI.tween(getKeyBtn, 0.14, { BackgroundColor3 = P.Surface });
		UI.tween(getKeyLabel, 0.14, { TextColor3 = P.TextSoft });
		UI.tween(getKeyIcon, 0.14, { ImageColor3 = P.TextDim });
	end)

	submitBtn.MouseEnter:Connect(function()
		UI.tween(submitBtn, 0.12, { BackgroundTransparency = 0.12 });
	end)
	submitBtn.MouseLeave:Connect(function()
		UI.tween(submitBtn, 0.14, { BackgroundTransparency = 0 });
	end)

	local function tryValidate()
		if finished then return end
		local key = textBox.Text:gsub("%s+", "")
		if #key == 0 then
			statusLabel.TextColor3 = P.TextDim
			statusLabel.Text = "Enter a key first"
			return
		end

		statusLabel.TextColor3 = P.TextSoft
		statusLabel.Text = "Validating..."

		attempts = attempts + 1

		local validation = checkKey(key)

		if validation and validation.valid then
			onSuccess(key)
		else
			local errorMsg = validation and validation.message or validation and validation.error or "Invalid key"
			statusLabel.TextColor3 = P.TextDim

			local remaining = 3 - attempts
			if remaining <= 0 then
				statusLabel.Text = "Max attempts reached!"
				if errorMsg == "HWID_BANNED" then
					task.wait(0.5)
					game.Players.LocalPlayer:Kick("Hardware banned from this service.")
					return
				end
				task.wait(1)
				onFail("Max attempts reached: " .. errorMsg)
			else
				statusLabel.Text = "✗ " .. errorMsg .. " (" .. remaining .. " left)"
				local originalPos = panel.Position
				for i = 1, 5 do
					panel.Position = UDim2.new(0.5, math.random(-8, 8), 0.5, 0)
					task.wait(0.03)
				end
				panel.Position = originalPos
			end
		end
	end

	submitBtn.MouseButton1Click:Connect(tryValidate)
	textBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then tryValidate() end
	end)

	Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape then
			onFail("User cancelled")
		end
	end)

	return {
		IsValid = function() return Validated end,
		GetKey = function() return CurrentKey end,
		Destroy = function()
			onFail("Manually destroyed")
		end
	}
end

return NeverZen;
