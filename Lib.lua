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

local NeverZen = {
	Version = 'Ыебаны кфезилом ы акуай'
};

NeverZen.Services = {
	UserInputService = cloneref(game:GetService('UserInputService')),
	Players = cloneref(game:GetService('Players')),
	ContentProvider = cloneref(game:GetService('ContentProvider')),
	CoreGui = cloneref(game:FindFirstChild('CoreGui')),
};

local TextService = cloneref(game:GetService('TextService'));
local TweenService = cloneref(game:GetService('TweenService'));
local CurrentCamera = workspace.CurrentCamera;
local RunService = cloneref(game:GetService('RunService'));

local LocalPlayer : Player = NeverZen.Services.Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

NeverZen.ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end;
NeverZen.Services.CoreGui = (gethui and gethui()) or NeverZen.Services.CoreGui or LocalPlayer.PlayerGui;
NeverZen.MinimumTabSize = 600;

local Services : Services = NeverZen.Services;
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

function NeverZen:IsMouseOverFrame(Frame)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end;

function NeverZen:Hook()
	if hookfunc then
		local hooking = hookfunc or hookfunction or function() end;
		local newCclosure = newcclosure or function() end;
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

function NeverZen:NewInput(frame : Frame , call) : TextButton
	local Bth = Instance.new('TextButton',frame);

	Bth.ZIndex = frame.ZIndex + 10;
	Bth.Size = UDim2.fromScale(1,1);
	Bth.BackgroundTransparency = 1;
	Bth.TextTransparency = 1;

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
	end;
	return out;
end;

function NeverZen.SecureCall(fn, ...)
	local oldIdentity = getidentity();
	setidentity(8);
	local ok, result = pcall(fn, ...);
	setidentity(oldIdentity);
	if not ok then
		warn("[NeverZen] SecureCall error: " .. tostring(result));
	end;
	return ok, result;
end;


NeverZen.Theme = {
	WindowBackgroundColor = Color3.fromRGB(6,8,5),
	HeadText = Color3.fromRGB(233,239,237),
	LineColor = Color3.fromRGB(18,20,19),
	BackgroundColor = Color3.fromRGB(6,8,5),
	SectionColor = Color3.fromRGB(9,11,10),
	Hightlight = Color3.fromRGB(0,169,239),
	StrokeColor = Color3.fromRGB(18,20,19),
	StrokeColor2 = Color3.fromRGB(77,90,92),
	BackgroundColor2 = Color3.fromRGB(10,14,13),
	IconColor = Color3.fromRGB(5,164,233),
}
NeverZen.ThemeRegistry = {};
function NeverZen:Track(inst, prop, resolver)
	table.insert(NeverZen.ThemeRegistry, {Instance = inst, Prop = prop, Resolver = resolver});
 
	local val = (typeof(resolver) == 'function' and resolver()) or NeverZen.Theme[resolver];
	inst[prop] = val;
 
	return inst;
end;
function NeverZen:ApplyTheme()
	for i = #NeverZen.ThemeRegistry, 1, -1 do
		local v = NeverZen.ThemeRegistry[i];
 
		if v.Instance and v.Instance.Parent then
			local val = (typeof(v.Resolver) == 'function' and v.Resolver()) or NeverZen.Theme[v.Resolver];
 
			pcall(function()
				TweenService:Create(v.Instance, TweenInfo.new(0.25), {[v.Prop] = val}):Play();
			end);
		else
			table.remove(NeverZen.ThemeRegistry, i);
		end;
	end;
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
            if name then
                table.insert(configs, name);
            end;
        end;
    end;
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

function NeverZen:SetTheme(name)
    if name == "Default" or name == "Gamesense" or name == "Skeet" then
        NeverZen.Theme = {
            WindowBackgroundColor = Color3.fromRGB(6,8,5),
            HeadText = Color3.fromRGB(233,239,237),
            LineColor = Color3.fromRGB(18,20,19),
            BackgroundColor = Color3.fromRGB(6,8,5),
            SectionColor = Color3.fromRGB(9,11,10),
            Hightlight = Color3.fromRGB(0,169,239),
            StrokeColor = Color3.fromRGB(18,20,19),
            StrokeColor2 = Color3.fromRGB(77,90,92),
            BackgroundColor2 = Color3.fromRGB(10,14,13),
            IconColor = Color3.fromRGB(5,164,233),
        }
    elseif name == "Neverlose" then
        NeverZen.Theme = {
            WindowBackgroundColor = Color3.fromRGB(6,8,5),
            HeadText = Color3.fromRGB(233,239,237),
            LineColor = Color3.fromRGB(18,20,19),
            BackgroundColor = Color3.fromRGB(6,8,5),
            SectionColor = Color3.fromRGB(9,11,10),
            Hightlight = Color3.fromRGB(0,169,239),
            StrokeColor = Color3.fromRGB(18,20,19),
            StrokeColor2 = Color3.fromRGB(77,90,92),
            BackgroundColor2 = Color3.fromRGB(10,14,13),
            IconColor = Color3.fromRGB(5,164,233),
        }
    elseif name == "Fatality" then
        NeverZen.Theme = {
            WindowBackgroundColor = Color3.fromRGB(6,8,5),
            HeadText = Color3.fromRGB(233,239,237),
            LineColor = Color3.fromRGB(18,20,19),
            BackgroundColor = Color3.fromRGB(6,8,5),
            SectionColor = Color3.fromRGB(9,11,10),
            Hightlight = Color3.fromRGB(198, 9, 85),
            StrokeColor = Color3.fromRGB(18,20,19),
            StrokeColor2 = Color3.fromRGB(77,90,92),
            BackgroundColor2 = Color3.fromRGB(10,14,13),
            IconColor = Color3.fromRGB(198, 9, 85),
        }
    elseif name == "Anyx" then
        NeverZen.Theme = {
            WindowBackgroundColor = Color3.fromRGB(6,8,5),
            HeadText = Color3.fromRGB(233,239,237),
            LineColor = Color3.fromRGB(18,20,19),
            BackgroundColor = Color3.fromRGB(6,8,5),
            SectionColor = Color3.fromRGB(9,11,10),
            Hightlight = Color3.fromRGB(81, 195, 206),
            StrokeColor = Color3.fromRGB(18,20,19),
            StrokeColor2 = Color3.fromRGB(77,90,92),
            BackgroundColor2 = Color3.fromRGB(10,14,13),
            IconColor = Color3.fromRGB(81, 195, 206),
        }
    elseif name == "Hyperion" then
        NeverZen.Theme = {
            WindowBackgroundColor = Color3.fromRGB(6,8,5),
            HeadText = Color3.fromRGB(233,239,237),
            LineColor = Color3.fromRGB(18,20,19),
            BackgroundColor = Color3.fromRGB(6,8,5),
            SectionColor = Color3.fromRGB(9,11,10),
            Hightlight = Color3.fromRGB(197, 29, 29),
            StrokeColor = Color3.fromRGB(18,20,19),
            StrokeColor2 = Color3.fromRGB(77,90,92),
            BackgroundColor2 = Color3.fromRGB(10,14,13),
            IconColor = Color3.fromRGB(197, 29, 29),
        }
    elseif name == "Airflow" then
        NeverZen.Theme = {
            WindowBackgroundColor = Color3.fromRGB(6,8,5),
            HeadText = Color3.fromRGB(233,239,237),
            LineColor = Color3.fromRGB(18,20,19),
            BackgroundColor = Color3.fromRGB(6,8,5),
            SectionColor = Color3.fromRGB(9,11,10),
            Hightlight = Color3.fromRGB(143, 107, 190),
            StrokeColor = Color3.fromRGB(18,20,19),
            StrokeColor2 = Color3.fromRGB(77,90,92),
            BackgroundColor2 = Color3.fromRGB(10,14,13),
            IconColor = Color3.fromRGB(143, 107, 190),
        }
    end;
    NeverZen:ApplyTheme();
end;

function NeverZen.new(config)
	config = config or {};
	config.KeySystem = config.KeySystem or false;
	config.KeySystemReturnURL = config.KeySystemReturnURL or nil;

	if config.KeySystem then
		local KeyService = config.KeySystemName or "NeverZen Hub"
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
				
				local notifyFrame = Instance.new("Frame")
				notifyFrame.Parent = notifyGui
				notifyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				notifyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
				notifyFrame.Size = UDim2.new(0, 300, 0, 0)
				notifyFrame.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
				notifyFrame.BorderSizePixel = 0
				
				local nc = Instance.new("UICorner")
				nc.CornerRadius = UDim.new(0, 8)
				nc.Parent = notifyFrame
				
				local ns = Instance.new("UIStroke")
				ns.Color = NeverZen.Theme.StrokeColor
				ns.Parent = notifyFrame
				
				local nl = Instance.new("TextLabel")
				nl.Parent = notifyFrame
				nl.BackgroundTransparency = 1
				nl.Size = UDim2.new(1, -20, 1, -20)
				nl.Position = UDim2.new(0, 10, 0, 10)
				nl.Font = Enum.Font.GothamBold
				nl.Text = "⚠ Key expired or invalid!\n\nReturning to key system..."
				nl.TextColor3 = Color3.fromRGB(255, 80, 80)
				nl.TextSize = 14
				nl.TextWrapped = true
				
				TweenService:Create(notifyFrame, TweenInfo.new(0.3), {
					Size = UDim2.new(0, 300, 0, 100)
				}):Play()
				
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
	

	config.Name = config.Name or "NEVERZEN";
	config.Keybind = config.Keybind or Enum.KeyCode.LeftControl;
	config.Scale = config.Scale or UDim2.new(0, 611, 0, 396);
	config.Resizable = config.Resizable;
	config.Shadow = config.Shadow or false;
  config.LoadSound = config.LoadSound or nil;

	local WindowSignal = {};

	WindowSignal.SelectedTab = nil;
	WindowSignal.Tabs = {};
	WindowSignal.Config = config;
  WindowSignal.ConfigValues = {};
  WindowSignal.ConfigCallbacks = {};
  WindowSignal.CurrentConfigName = nil;
  function WindowSignal:SaveConfig(name)
      if not name or #name == 0 then return false end;
      if not NeverZen.SaveConfig then return false end;
      self.CurrentConfigName = name;
      local ok = NeverZen:SaveConfig(name, self.ConfigValues);
      return ok == true;
  end;
  
  function WindowSignal:LoadConfig(name)
      if not NeverZen.LoadConfig then return false end;
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
  
  function WindowSignal:SetAutoLoad(name)
      if not writefile then return end;
      local autoLoadPath = NeverZen.ConfigPath .. "/autoload.json";
      pcall(function()
          writefile(autoLoadPath, game:GetService("HttpService"):JSONEncode(name));
      end);
  end;
	WindowSignal.Toggle = true;
	WindowSignal.FrameMemory = {
		WindowBackgroundColor = {},
		HeadText = {},
		LineColor = {},
	};

	local Content = Instance.new("ScreenGui")
	local WindowFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local Header = Instance.new("Frame")
	local HeaderText = Instance.new("TextLabel")
	local Line = Instance.new("Frame")
	local Frame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local SearchFrame = Instance.new("Frame")
	local SearchButton = Instance.new("ImageButton")
	local UIStroke_2 = Instance.new("UIStroke")
	local UICorner_2 = Instance.new("UICorner")
	local TextBox = Instance.new("TextBox")
	local SettingsButton = Instance.new("ImageButton")
	local MinButton = Instance.new("ImageButton")
	local Line_2 = Instance.new("Frame")
	local BthFrames = Instance.new("Frame")
	local InformationFrame = Instance.new("Frame")
	local ProfileIcon = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke_3 = Instance.new("UIStroke")
	local UsernameText = Instance.new("TextLabel")
	local UIGradient = Instance.new("UIGradient")
	local TabButtons = Instance.new("Frame")
	local TBSFrame = Instance.new("ScrollingFrame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local Line_3 = Instance.new("Frame")
	local TabWin = Instance.new("Frame")

	Content.Name = NeverZen:RandomString()
	NeverZen:SafeParent(Content);
	Content.ResetOnSpawn = false
	Content.IgnoreGuiInset = true
	Content.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	NeverZen.ProtectGui(Content);

	WindowFrame.Name = NeverZen:RandomString()
	WindowFrame.Parent = Content
	WindowFrame.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
	WindowFrame.BackgroundTransparency = 0.1
	WindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowFrame.BorderSizePixel = 0
	WindowFrame.ClipsDescendants = true
	WindowFrame.Position = UDim2.new(0, 177, 0, 177)
	WindowFrame.Size = UDim2.new(0,0,0,0)
	WindowFrame.Active = true

	table.insert(WindowSignal.FrameMemory.WindowBackgroundColor , WindowFrame)


	if config.Shadow then
		local DropShadow = Instance.new("ImageLabel")

		DropShadow.Name = NeverZen:RandomString()
		DropShadow.Parent = WindowFrame
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1.000
		DropShadow.BorderSizePixel = 0
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Rotation = 0.01
		DropShadow.Size = UDim2.new(1, 47, 1, 47)
		DropShadow.ZIndex = -1
		DropShadow.Image = "rbxassetid://6015897843"
		DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShadow.ImageTransparency = 1
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

		task.delay(1,function()
			TweenService:Create(DropShadow,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				ImageTransparency = 0.75
			}):Play()
		end)
	end

	TweenService:Create(WindowFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
		Size = config.Scale,
		Position = UDim2.new(0, 75, 0, 75)
	}):Play()

	if config.Acrylic == nil then
		config.Acrylic = true
	end

	if config.Acrylic then
		NeverZen:SetBlur(WindowFrame)
	end;
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
  end;

	function WindowSignal:SetScale(new)
		WindowSignal.Config.Scale = new;
		TweenService:Create(WindowFrame,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Size = new,
		}):Play()
	end;

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = WindowFrame

	UIStroke.Transparency = 0.850
	UIStroke.Color = Color3.fromRGB(0, 25, 34)
	UIStroke.Parent = WindowFrame

	Header.Name = NeverZen:RandomString()
	Header.Parent = WindowFrame
	Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Header.BackgroundTransparency = 1.000
	Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Header.BorderSizePixel = 0
	Header.ClipsDescendants = true
	Header.Size = UDim2.new(1, 0, 0, 45)
	Header.Position = UDim2.new(0,0,0,-50)
	Header.Active = true

	task.delay(0.2,function()
		TweenService:Create(Header,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(0,0,0,0)
		}):Play()
	end)

	HeaderText.Name = NeverZen:RandomString()
	HeaderText.Parent = Header
	HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeaderText.BackgroundTransparency = 1.000
	HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderText.BorderSizePixel = 0
	HeaderText.Position = UDim2.new(0, 10, 0, -55)
	HeaderText.Size = UDim2.new(0, 150, 1, -10)
	HeaderText.Font = Enum.Font.GothamBold
	HeaderText.Text = config.Name;
	HeaderText.TextColor3 = NeverZen.Theme.HeadText
	HeaderText.TextScaled = true
	HeaderText.TextSize = 14.000
	HeaderText.TextWrapped = true

	table.insert(WindowSignal.FrameMemory.HeadText , HeaderText)

	task.delay(0.4,function()
		TweenService:Create(HeaderText,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(0, 10, 0, 5)
		}):Play()
	end)

	Line.Name = NeverZen:RandomString()
	Line.Parent = Header
	Line.AnchorPoint = Vector2.new(0, 1)
	Line.BackgroundColor3 =NeverZen.Theme.LineColor
	Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0, 170, 1, 0)
	Line.Size = UDim2.new(1, -170, 0, 1)

	Frame.Parent = Header
	Frame.AnchorPoint = Vector2.new(1, 0.5)
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BackgroundTransparency = 1.000
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(1, -10, -0.5, 0)
	Frame.Size = UDim2.new(0, 150, 0.5, 0)
	Frame.ZIndex = 5

	task.delay(0.6,function()
		TweenService:Create(Frame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(1, -10, 0.5, 0)
		}):Play()
	end)

	UIListLayout.Parent = Frame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 5)

	SearchFrame.Name = NeverZen:RandomString()
	SearchFrame.Parent = Frame
	SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchFrame.BackgroundTransparency = 1.000
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.ClipsDescendants = true
	SearchFrame.Size = UDim2.new(0, 140, 0, 22)

	SearchButton.Name = NeverZen:RandomString()
	SearchButton.Parent = SearchFrame
	SearchButton.AnchorPoint = Vector2.new(1, 0.5)
	SearchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchButton.BackgroundTransparency = 1.000
	SearchButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchButton.BorderSizePixel = 0
	SearchButton.Position = UDim2.new(1, -2, 0.5, 0)
	SearchButton.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
	SearchButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	SearchButton.Image = "rbxassetid://10734943674"
	SearchButton.ImageTransparency = 0.200

	UIStroke_2.Color = NeverZen.Theme.LineColor;
	UIStroke_2.Parent = SearchFrame

	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = SearchFrame

	TextBox.Parent = SearchFrame
	TextBox.AnchorPoint = Vector2.new(0, 0.5)
	TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.BackgroundTransparency = 1.000
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0, 5, 0.5, 0)
	TextBox.Size = UDim2.new(1, -27, 0.649999976, 0)
	TextBox.ClearTextOnFocus = false
	TextBox.Font = Enum.Font.GothamMedium
	TextBox.PlaceholderText = "Search"
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 14.000
	TextBox.TextTransparency = 0.200
	TextBox.TextXAlignment = Enum.TextXAlignment.Left

	TextBox:GetPropertyChangedSignal('Text'):Connect(function()

		if WindowSignal.SelectedTab then
			if TextBox.Text:byte() then
				WindowSignal.SelectedTab.Search(TextBox.Text);
			else
				WindowSignal.SelectedTab.Search(nil);
			end
		end;
	end)

	SettingsButton.Name = NeverZen:RandomString()
	SettingsButton.Parent = Frame
	SettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SettingsButton.BackgroundTransparency = 1.000
	SettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SettingsButton.BorderSizePixel = 0
	SettingsButton.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
	SettingsButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	SettingsButton.Image = "rbxassetid://10734950309"
	SettingsButton.ImageTransparency = 0.200

	MinButton.Name = NeverZen:RandomString()
	MinButton.Parent = Frame
	MinButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MinButton.BackgroundTransparency = 1.000
	MinButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MinButton.BorderSizePixel = 0
	MinButton.Size = UDim2.new(1, 0, 1, 0)
	MinButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	MinButton.Image = "rbxassetid://9886659001"
	MinButton.ImageTransparency = 0.200

	Line_2.Name = NeverZen:RandomString()
	Line_2.Parent = WindowFrame
	Line_2.BackgroundColor3 =NeverZen.Theme.LineColor
	Line_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line_2.BorderSizePixel = 0
	Line_2.Position = UDim2.new(0, 170, 0, 0)
	Line_2.Size = UDim2.new(0, 1, 1, 0)

	BthFrames.Name = NeverZen:RandomString()
	BthFrames.Parent = WindowFrame
	BthFrames.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BthFrames.BackgroundTransparency = 1.000
	BthFrames.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BthFrames.BorderSizePixel = 0
	BthFrames.Position = UDim2.new(-1, 0, 0, 45)
	BthFrames.Size = UDim2.new(0, 170, 1, -45)

	task.delay(0.3,function()
		TweenService:Create(BthFrames,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(0, 0, 0, 45)
		}):Play()
	end)

	InformationFrame.Name = NeverZen:RandomString()
	InformationFrame.Parent = BthFrames
	InformationFrame.AnchorPoint = Vector2.new(0, 1)
	InformationFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	InformationFrame.BackgroundTransparency = 1.000
	InformationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	InformationFrame.BorderSizePixel = 0
	InformationFrame.Position = UDim2.new(0, 0, 1, 55)
	InformationFrame.Size = UDim2.new(1, 0, 0, 45)

	task.delay(0.3,function()
		TweenService:Create(InformationFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(0, 0, 1, 0)
		}):Play()
	end)

	ProfileIcon.Name = NeverZen:RandomString()
	ProfileIcon.Parent = InformationFrame
	ProfileIcon.Active = true
	ProfileIcon.AnchorPoint = Vector2.new(0, 0.5)
	ProfileIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ProfileIcon.BackgroundTransparency = 1.000
	ProfileIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ProfileIcon.BorderSizePixel = 0
	ProfileIcon.Position = UDim2.new(0, 5, 1.3, 0)
	ProfileIcon.Size = UDim2.new(0, 35, 0, 35)
	pcall(function()
		ProfileIcon.Image = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
	end)
	task.delay(0.45,function()
		TweenService:Create(ProfileIcon,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(0, 5, 0.5, 0)
		}):Play()
	end)

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = ProfileIcon

	UIStroke_3.Thickness = 2.000
	UIStroke_3.Color =NeverZen.Theme.LineColor
	UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke_3.Parent = ProfileIcon

	UsernameText.Name = NeverZen:RandomString()
	UsernameText.Parent = InformationFrame
	UsernameText.AnchorPoint = Vector2.new(0, 0.5)
	UsernameText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UsernameText.BackgroundTransparency = 1.000
	UsernameText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UsernameText.BorderSizePixel = 0
	UsernameText.Position = UDim2.new(0, 47, 1.4, 0)
	UsernameText.Size = UDim2.new(1, -35, 0, -25)
	UsernameText.Font = Enum.Font.GothamBold
	UsernameText.Text = string.sub(LocalPlayer.DisplayName , 0, math.round(#LocalPlayer.DisplayName / 2))..string.rep("*",math.round(#LocalPlayer.DisplayName / 2));
	UsernameText.TextColor3 = Color3.fromRGB(206, 206, 206)
	UsernameText.TextSize = 14.000
	UsernameText.TextXAlignment = Enum.TextXAlignment.Left

	task.delay(0.5,function()
		TweenService:Create(UsernameText,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(0, 47, 0.5, 0)
		}):Play()
	end)

	UIGradient.Rotation = 90
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.20, 0.24), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(0.80, 0.24), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient.Parent = UsernameText

	TabButtons.Name = NeverZen:RandomString()
	TabButtons.Parent = BthFrames
	TabButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabButtons.BackgroundTransparency = 1.000
	TabButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabButtons.BorderSizePixel = 0
	TabButtons.ClipsDescendants = true
	TabButtons.Size = UDim2.new(0, 170, 1.13661206, -100)

	TBSFrame.Name = NeverZen:RandomString()
	TBSFrame.Parent = TabButtons
	TBSFrame.Active = true
	TBSFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	TBSFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TBSFrame.BackgroundTransparency = 1.000
	TBSFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TBSFrame.BorderSizePixel = 0
	TBSFrame.ClipsDescendants = false
	TBSFrame.Position = UDim2.new(-0.4, 0, 0.5, 0)
	TBSFrame.Size = UDim2.new(1, -5, 1, -5)
	TBSFrame.ZIndex = 2
	TBSFrame.BottomImage = ""
	TBSFrame.ScrollBarThickness = 0
	TBSFrame.TopImage = ""

	task.delay(0.3,function()
		TweenService:Create(TBSFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}):Play()
	end)

	UIListLayout_2.Parent = TBSFrame
	UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.Padding = UDim.new(0, 3)

	UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		TBSFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y + 5)
	end)

	Line_3.Name = NeverZen:RandomString()
	Line_3.Parent = BthFrames
	Line_3.AnchorPoint = Vector2.new(0, 1)
	Line_3.BackgroundColor3 =NeverZen.Theme.LineColor
	Line_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line_3.BorderSizePixel = 0
	Line_3.Position = UDim2.new(0, 0, 1, -45)
	Line_3.Size = UDim2.new(0, 170, 0, 1)

	TabWin.Name = NeverZen:RandomString()
	TabWin.Parent = WindowFrame
	TabWin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabWin.BackgroundTransparency = 1.000
	TabWin.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabWin.BorderSizePixel = 0
	TabWin.Position = UDim2.new(0, 170, 1, 45)
	TabWin.Size = UDim2.new(1, -170, 1, -45)
	TabWin.ZIndex = 2

	task.delay(0.3,function()
		TweenService:Create(TabWin,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.new(0, 170, 0, 45)
		}):Play()
	end);

	function WindowSignal:StatusBar()

		local Statusbar = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")

		Statusbar.Name = NeverZen:RandomString();
		Statusbar.Parent = Content;
		Statusbar.AnchorPoint = Vector2.new(1, 0)
		Statusbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Statusbar.BackgroundTransparency = 1.000
		Statusbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Statusbar.BorderSizePixel = 0
		Statusbar.Position = UDim2.new(1, -5, 0, 5)
		Statusbar.Size = UDim2.new(0, 150, 0, 1)

		UIListLayout.Parent = Statusbar
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 3);

		return {
			create = function(name)
				local Frame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local Label = Instance.new("TextLabel")

				Frame.Parent = Statusbar
				Frame.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
				Frame.BackgroundTransparency = 0.100
				Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Frame.BorderSizePixel = 0
				Frame.Size = UDim2.new(0, 250, 0, 20)

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Frame

				Label.Name = NeverZen:RandomString()
				Label.Parent = Frame
				Label.AnchorPoint = Vector2.new(0.5, 0.5)
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BackgroundTransparency = 1.000
				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0.5, 0, 0.5, 0)
				Label.Size = UDim2.new(1, -10, 0.699999988, 0)
				Label.Font = Enum.Font.GothamMedium
				Label.Text = name or ""
				Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				Label.TextSize = 14.000
				Label.TextXAlignment = Enum.TextXAlignment.Left

				return {
					Visible = function(self,a)
						if a then
							Frame.Visible = true
						else
							Frame.Visible = false
						end
					end,

					Text = function(self , name)
						Label.Text = name or ""
					end,
				}
			end,
		};
	end;

	WindowSignal.LabelCount = 0;

	function WindowSignal:AddLabel(name)
		local TBSTitle = Instance.new("TextLabel")

		TBSTitle.Name = NeverZen:RandomString()
		TBSTitle.Parent = TBSFrame
		TBSTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TBSTitle.BackgroundTransparency = 1.000
		TBSTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TBSTitle.BorderSizePixel = 0
		TBSTitle.Size = UDim2.new(1, -17, 0, 15)
		TBSTitle.ZIndex = 5
		TBSTitle.Font = Enum.Font.GothamBold
		TBSTitle.Text = name
		TBSTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		TBSTitle.TextSize = 14.000
		TBSTitle.TextTransparency = 1
		TBSTitle.TextXAlignment = Enum.TextXAlignment.Left

	WindowSignal.LabelCount += 1;

		task.delay(WindowSignal.LabelCount / 5,function()
			TweenService:Create(TBSTitle,TweenInfo.new(0.45),{
				TextTransparency = 0.75
			}):Play()
		end)
	end;

	function WindowSignal:AddTab(config)
		config = NeverZen:CloneConfig(config);
		config.Name = config.Name or 'Example';
		config.Icon = config.Icon or "target";
		config.SingleMode = config.SingleMode or false;

		local TabSignal = {};
		local TabButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local TabIcon = Instance.new("ImageLabel")
		local TabName = Instance.new("TextLabel")

		TabButton.Name = NeverZen:RandomString()
		TabButton.Parent = TBSFrame
		TabButton.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(0, 0, 0, 35)
		TabButton.ZIndex = 5

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = TabButton

		TabIcon.Name = NeverZen:RandomString()
		TabIcon.Parent = TabButton
		TabIcon.AnchorPoint = Vector2.new(0, 0.5)
		TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabIcon.BorderSizePixel = 0
		TabIcon.Position = UDim2.new(0, 7, 0.5, 0)
		TabIcon.Size = UDim2.new(0, 20, 0, 20)
		TabIcon.ZIndex = 5
		TabIcon.Image = NeverZen:GetIcon(config.Icon);
		TabIcon.ImageTransparency = 1

		NeverZen:Track(TabIcon, 'ImageColor3', 'IconColor')

		TabName.Name = NeverZen:RandomString()
		TabName.Parent = TabButton
		TabName.AnchorPoint = Vector2.new(0, 0.5)
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1.000
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Position = UDim2.new(0, 37, 0.5, 0)
		TabName.Size = UDim2.new(1, -45, 0, 15)
		TabName.ZIndex = 5
		TabName.Font = Enum.Font.GothamMedium
		TabName.Text = config.Name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextScaled = true
		TabName.TextSize = 14.000
		TabName.TextTransparency = 1
		TabName.TextWrapped = true
		TabName.TextXAlignment = Enum.TextXAlignment.Left


		local TabFrame = Instance.new("Frame")
		local LeftFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local RightFrame = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local CTFrame = Instance.new("ScrollingFrame")
		local UIListLayoutAF = Instance.new("UIListLayout")

		TabFrame.Name = NeverZen:RandomString()
		TabFrame.Parent = TabWin
		TabFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabFrame.BackgroundTransparency = 1.000
		TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabFrame.BorderSizePixel = 0
		TabFrame.ClipsDescendants = true
		TabFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabFrame.Size = UDim2.new(1, -2, 1, -2)
		TabFrame.ZIndex = 4

		CTFrame.Name = NeverZen:RandomString()
		CTFrame.Parent = TabFrame
		CTFrame.Active = true
		CTFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		CTFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CTFrame.BackgroundTransparency = 1.000
		CTFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CTFrame.BorderSizePixel = 0
		CTFrame.ClipsDescendants = false
		CTFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		CTFrame.Size = UDim2.new(1, -1, 1, -3)
		CTFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
		CTFrame.ScrollBarThickness = 0
		CTFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

		UIListLayoutAF.Parent = CTFrame
		UIListLayoutAF.FillDirection = Enum.FillDirection.Horizontal
		UIListLayoutAF.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayoutAF.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayoutAF.Padding = UDim.new(0, 2)


		LeftFrame.Name = NeverZen:RandomString()
		LeftFrame.Parent = CTFrame
		LeftFrame.Active = true
		LeftFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		LeftFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LeftFrame.BackgroundTransparency = 1.000
		LeftFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LeftFrame.BorderSizePixel = 0
		LeftFrame.ClipsDescendants = false
		LeftFrame.Position = UDim2.new(0.25, 0, 0.5, 0)
		LeftFrame.Size = UDim2.new(0.5, -5, 1, -3)
		LeftFrame.ScrollBarThickness = 0
		LeftFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

		UIListLayout.Parent = LeftFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			LeftFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 5)
		end)

		RightFrame.Name = NeverZen:RandomString()
		RightFrame.Parent = CTFrame
		RightFrame.Active = true
		RightFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		RightFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		RightFrame.BackgroundTransparency = 1.000
		RightFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		RightFrame.BorderSizePixel = 0
		RightFrame.ClipsDescendants = false
		RightFrame.Position = UDim2.new(0.75, 0, 0.5, 0)
		RightFrame.Size = UDim2.new(0.5, -5, 1, -3)
		RightFrame.ScrollBarThickness = 0

		UIListLayout_2.Parent = RightFrame
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 5)

		UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			RightFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y + 5)
		end)

		task.spawn(function()
			while true do task.wait(0.1)
				if WindowSignal.Config.Scale.X.Offset <= NeverZen.MinimumTabSize or config.SingleMode then
					UIListLayoutAF.FillDirection = Enum.FillDirection.Vertical
					UIListLayoutAF.HorizontalAlignment = Enum.HorizontalAlignment.Center
					UIListLayoutAF.SortOrder = Enum.SortOrder.LayoutOrder
					CTFrame.ScrollingEnabled = true

					TweenService:Create(RightFrame,TweenInfo.new(0.2),{
						Size = UDim2.new(1,-5,0,UIListLayout_2.AbsoluteContentSize.Y + 2)
					}):Play()

					TweenService:Create(LeftFrame,TweenInfo.new(0.2),{
						Size = UDim2.new(1, -5, 0,UIListLayout.AbsoluteContentSize.Y + 3)
					}):Play()

					TweenService:Create(UIListLayoutAF,TweenInfo.new(0.2),{
						Padding = UDim.new(0, 2)
					}):Play()

					RightFrame.ScrollingEnabled = false
					LeftFrame.ScrollingEnabled = false
					RightFrame.CanvasPosition = Vector2.new(0,0)
					LeftFrame.CanvasPosition = Vector2.new(0,0)
					CTFrame.CanvasSize = UDim2.fromOffset(0,UIListLayoutAF.AbsoluteContentSize.Y)
				else
					CTFrame.CanvasSize = UDim2.fromOffset(0,0)

					TweenService:Create(UIListLayoutAF,TweenInfo.new(0.2),{
						Padding = UDim.new(0, 5)
					}):Play()

					TweenService:Create(RightFrame,TweenInfo.new(0.2),{
						Size = UDim2.new(0.5, -5, 1, -3)
					}):Play()

					TweenService:Create(LeftFrame,TweenInfo.new(0.2),{
						Size = UDim2.new(0.5, -5, 1, -3)
					}):Play()

					CTFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
					UIListLayoutAF.FillDirection = Enum.FillDirection.Horizontal
					UIListLayoutAF.HorizontalAlignment = Enum.HorizontalAlignment.Center
					UIListLayoutAF.SortOrder = Enum.SortOrder.LayoutOrder
					CTFrame.ScrollingEnabled = false
					RightFrame.ScrollingEnabled = true
					LeftFrame.ScrollingEnabled = true
					CTFrame.CanvasPosition = Vector2.new(0,0)
				end;
			end;
		end);

		local ToggleFunc = function(value)
			if value then
				TabFrame.Visible = true;

				TweenService:Create(TabButton,TweenInfo.new(0.2),{
					BackgroundTransparency = 0.1
				}):Play()

				TweenService:Create(TabIcon,TweenInfo.new(0.3),{
					ImageTransparency = 0.25,
					Size = UDim2.new(0, 25, 0, 25),
					Position = UDim2.new(0, 4, 0.5, 0)
				}):Play()

				TweenService:Create(TabName,TweenInfo.new(0.1),{
					TextTransparency = 0.1,
					Position = UDim2.new(0, 37, 0.5, 0)
				}):Play()
			else
				TabFrame.Visible = false;

				TweenService:Create(TabButton,TweenInfo.new(0.2),{
					BackgroundTransparency = 1
				}):Play()

				TweenService:Create(TabIcon,TweenInfo.new(0.3),{
					ImageTransparency = 0.5,
					Position = UDim2.new(0, 7, 0.5, 0),
					Size = UDim2.new(0, 20, 0, 20)
				}):Play()

				TweenService:Create(TabName,TweenInfo.new(0.1),{
					TextTransparency = 0.2,
					Position = UDim2.new(0, 33, 0.5, 0)
				}):Play()
			end;
		end;

		local itemForSearch = {};

		local searchItem = function(q : string)
			if q and q:byte() then
				for i,v in next , itemForSearch do
					if (i % 25) == 1 then
						task.wait()
					end

					if string.find(string.lower(v.Name) , string.lower(q) , 1, true) then
						v.Frame.Visible = true;
						task.wait()
					else
						v.Frame.Visible = false;
					end;
				end;
			else
				for i,v in next , itemForSearch do
					if (i % 25) == 1 then
						task.wait()
					end
					v.Frame.Visible = true;
				end;
			end;
		end;

		local TabIden = {
			call = ToggleFunc,
			target = TabButton,
			Search = searchItem,
		};


		task.delay(#WindowSignal.Tabs / 8,function()
			TweenService:Create(TabButton,TweenInfo.new(0.35),{
				Size = UDim2.new(1, 0, 0, 35)
			}):Play()
		end)

		ToggleFunc(WindowSignal.SelectedTab == nil and true)

		table.insert(WindowSignal.Tabs,TabIden);

		WindowSignal.SelectedTab = TabIden;

		task.delay(0.1,function()
			WindowSignal.SelectedTab = TabIden;
		end)

		NeverZen:NewInput(TabButton,function()
			if not Content.Enabled or not Content.Parent then
				return;
			end;

			WindowSignal.SelectedTab = TabIden;

			for i,v in next , WindowSignal.Tabs do
				if v.target == TabButton then
					ToggleFunc(true)
				else
					if v.call then
						v.call(false)
					end
				end;
			end;
		end);

		function TabSignal:AddSection(Config)
			Config = NeverZen:CloneConfig(Config);

			Config.Name = Config.Name or "Section";
			Config.Position = Config.Position or "left";

			local SectionSignal = {};

			local Section = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local head = Instance.new("Frame")
			local Label = Instance.new("TextLabel")
			local Frame = Instance.new("Frame")
			local UIListLayout = Instance.new("UIListLayout")

			Section.Name = NeverZen:RandomString()
			Section.Parent = (string.lower(Config.Position) == "left" and LeftFrame) or RightFrame;
			NeverZen:Track(Section, 'BackgroundColor3', 'SectionColor')
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(1, 0, 0, 25)

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Section

			NeverZen:Track(UIStroke, 'Color', 'BackgroundColor')
            UIStroke.Parent = Section

			head.Name = "head"
			head.Parent = Section
			head.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			head.BackgroundTransparency = 1.000
			head.BorderColor3 = Color3.fromRGB(0, 0, 0)
			head.BorderSizePixel = 0
			head.Size = UDim2.new(1, 0, 0, 24)

			Label.Name = "Label"
			Label.Parent = head
			Label.AnchorPoint = Vector2.new(0.5, 0)
			Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label.BackgroundTransparency = 1.000
			Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label.BorderSizePixel = 0
			Label.Position = UDim2.new(0.5, 0, 0, 2)
			Label.Size = UDim2.new(1, -10, 0, 20)
			Label.Font = Enum.Font.GothamMedium
			Label.Text = Config.Name
			Label.TextColor3 = Color3.fromRGB(254, 254, 254)
			Label.TextSize = 14.000
			Label.TextTransparency = 0.200
			Label.TextXAlignment = Enum.TextXAlignment.Left

			Frame.Parent = head
			Frame.AnchorPoint = Vector2.new(0, 1)
			NeverZen:Track(Frame, 'BackgroundColor3', 'BackgroundColor')
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0, 0, 1, 0)
			Frame.Size = UDim2.new(1, 0, 0, 1)
			Frame.ZIndex = 6

			UIListLayout.Parent = Section
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 3)

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				TweenService:Create(Section,TweenInfo.new(0.3,Enum.EasingStyle.Quint),{
					Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 3)
				}):Play()
			end)

			function SectionSignal:AddToggle(config)
    local _cfgIn = config or {};
    config = {};
    for k, v in pairs(_cfgIn) do config[k] = v end;

    config.Default = config.Default or false;
    config.Name = config.Name or "Toggle";
    config.Description = config.Description or nil;
    config.Callback = config.Callback or function() end;

    local Toggle = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local sys = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local color = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")

    table.insert(itemForSearch,{
        Frame = Toggle,
        Name = config.Name
    })

    Toggle.Name = NeverZen:RandomString()
    Toggle.Parent = Section
    Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.BackgroundTransparency = 1.000
    Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Toggle.BorderSizePixel = 0
    Toggle.Size = UDim2.new(1, -5, 0, 25)

    Label.Name = "Label"
    Label.Parent = Toggle
    Label.AnchorPoint = Vector2.new(0, 0.5)
    Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1.000
    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Label.BorderSizePixel = 0
    Label.Position = UDim2.new(0, 5, 0.5, 0)
    Label.Size = UDim2.new(1, -25, 0.649999976, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = config.Name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14.000
    Label.TextTransparency = 0.100
    Label.TextXAlignment = Enum.TextXAlignment.Left

    sys.Name = "sys"
    sys.Parent = Toggle
    sys.AnchorPoint = Vector2.new(1, 0.5)
    NeverZen:Track(sys, 'BackgroundColor3', 'BackgroundColor')
    sys.BorderColor3 = Color3.fromRGB(0, 0, 0)
    sys.BorderSizePixel = 0
    sys.Position = UDim2.new(1, -3, 0.5, 0)
    sys.Size = UDim2.new(0, 25, 0, 15)

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = sys

    NeverZen:Track(UIStroke, 'Color', 'StrokeColor')
    UIStroke.Parent = sys

    color.Name = "color"
    color.Parent = sys
    color.AnchorPoint = Vector2.new(0.5, 0.5)
    color.BackgroundColor3 = NeverZen.Theme.Hightlight
    color.BorderColor3 = Color3.fromRGB(0, 0, 0)
    color.BorderSizePixel = 0
    color.Position = config.Default and UDim2.new(0.75, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
    color.Size = UDim2.new(1, 0, 1, 0)
    color.SizeConstraint = Enum.SizeConstraint.RelativeYY

    UICorner_2.CornerRadius = UDim.new(1, 0)
    UICorner_2.Parent = color

    UIStroke.Color = NeverZen.Theme.StrokeColor
    UIStroke.Parent = sys

    if config.Description then
        local InfoBtn = Instance.new("Frame")
        local InfoBtnCorner = Instance.new("UICorner")
        local InfoBtnStroke = Instance.new("UIStroke")
        local InfoBtnLabel = Instance.new("TextLabel")

        InfoBtn.Name = NeverZen:RandomString()
        InfoBtn.Parent = Toggle
        InfoBtn.AnchorPoint = Vector2.new(1, 0.5)
        InfoBtn.BorderSizePixel = 0
        InfoBtn.Position = UDim2.new(1, -32, 0.5, 0)
        InfoBtn.Size = UDim2.new(0, 14, 0, 14)
        InfoBtn.ZIndex = 10

        NeverZen:Track(InfoBtn, 'BackgroundColor3', 'BackgroundColor')

        InfoBtnCorner.CornerRadius = UDim.new(1, 0)
        InfoBtnCorner.Parent = InfoBtn

        InfoBtnStroke.Thickness = 1
        InfoBtnStroke.Parent = InfoBtn

        NeverZen:Track(InfoBtnStroke, 'Color', 'StrokeColor2')

        InfoBtnLabel.Parent = InfoBtn
        InfoBtnLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        InfoBtnLabel.BackgroundTransparency = 1
        InfoBtnLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        InfoBtnLabel.Size = UDim2.new(1, 0, 1, 0)
        InfoBtnLabel.Font = Enum.Font.GothamBold
        InfoBtnLabel.Text = "i"
        InfoBtnLabel.TextSize = 10
        InfoBtnLabel.ZIndex = 11

        NeverZen:Track(InfoBtnLabel, 'TextColor3', 'Hightlight')

        local Tooltip = Instance.new("Frame")
        local TooltipCorner = Instance.new("UICorner")
        local TooltipStroke = Instance.new("UIStroke")
        local TooltipLabel = Instance.new("TextLabel")

        Tooltip.Name = NeverZen:RandomString()
        Tooltip.Parent = Content
        Tooltip.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
        Tooltip.BackgroundTransparency = 0.05
        Tooltip.BorderSizePixel = 0
        Tooltip.Size = UDim2.new(0, 280, 0, 0)
        Tooltip.ZIndex = 200
        Tooltip.Visible = false
        Tooltip.ClipsDescendants = true

        TooltipCorner.CornerRadius = UDim.new(0, 4)
        TooltipCorner.Parent = Tooltip

        TooltipStroke.Color = NeverZen.Theme.StrokeColor
        TooltipStroke.Parent = Tooltip

        TooltipLabel.Parent = Tooltip
        TooltipLabel.AnchorPoint = Vector2.new(0, 0)
        TooltipLabel.BackgroundTransparency = 1
        TooltipLabel.Position = UDim2.new(0, 8, 0, 6)
        TooltipLabel.Size = UDim2.new(1, -16, 1, -12)
        TooltipLabel.Font = Enum.Font.GothamMedium
        TooltipLabel.Text = config.Description
        TooltipLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
        TooltipLabel.TextSize = 12
        TooltipLabel.TextWrapped = true
        TooltipLabel.TextXAlignment = Enum.TextXAlignment.Left
        TooltipLabel.TextYAlignment = Enum.TextYAlignment.Top
        TooltipLabel.ZIndex = 201

        local TextService = game:GetService("TextService")
        local textSize = TextService:GetTextSize(
            config.Description, 12, Enum.Font.GothamMedium, Vector2.new(184, math.huge)
        )
        local tooltipH = textSize.Y + 12

        local InfoInput = NeverZen:NewInput(InfoBtn)

        InfoInput.MouseEnter:Connect(function()
            local absPos = InfoBtn.AbsolutePosition
            local absSize = InfoBtn.AbsoluteSize

            Tooltip.Position = UDim2.fromOffset(
                math.clamp(absPos.X - 90, 5, 9999),
                absPos.Y - tooltipH - 6
            )
            Tooltip.Size = UDim2.fromOffset(200, 0)
            Tooltip.Visible = true

            TweenService:Create(Tooltip, TweenInfo.new(0.15), {
                Size = UDim2.fromOffset(200, tooltipH)
            }):Play()

            TweenService:Create(InfoBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = NeverZen.Theme.Hightlight
            }):Play()
            TweenService:Create(InfoBtnLabel, TweenInfo.new(0.1), {
                TextColor3 = Color3.fromRGB(0, 0, 0)
            }):Play()
        end)

        InfoInput.MouseLeave:Connect(function()
            TweenService:Create(Tooltip, TweenInfo.new(0.1), {
                Size = UDim2.fromOffset(200, 0)
            }):Play()
            task.delay(0.1, function()
                Tooltip.Visible = false
            end)

            TweenService:Create(InfoBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = NeverZen.Theme.BackgroundColor
            }):Play()
            TweenService:Create(InfoBtnLabel, TweenInfo.new(0.1), {
                TextColor3 = NeverZen.Theme.Hightlight
            }):Play()
        end)

        sys.Position = UDim2.new(1, -3, 0.5, 0)
        Label.Size = UDim2.new(1, -50, 0.649999976, 0)
    end

    local setValue = function(value)
        if value then
            TweenService:Create(color,TweenInfo.new(0.2),{
                Position = UDim2.new(0.75, 0, 0.5, 0),
                BackgroundColor3 = NeverZen.Theme.Hightlight
            }):Play()
            TweenService:Create(Label,TweenInfo.new(0.4),{
                TextTransparency = 0.1
            }):Play()
        else
            TweenService:Create(Label,TweenInfo.new(0.4),{
                TextTransparency = 0.4
            }):Play()
            TweenService:Create(color,TweenInfo.new(0.2),{
                Position = UDim2.new(0.25, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(152, 152, 152)
            }):Play()
        end;
    end;

    NeverZen:Track(color, 'BackgroundColor3', function()
            return config.Default and NeverZen.Theme.Hightlight or Color3.fromRGB(152, 152, 152)
        end)

    WindowSignal.ConfigValues[config.Name] = config.Default;
    WindowSignal.ConfigCallbacks[config.Name] = function(value)
        config.Default = value
        setValue(config.Default)
        NeverZen.SecureCall(config.Callback, config.Default, config)
    end;

    NeverZen:NewInput(Toggle,function()
        if not Content.Enabled or not Content.Parent then return end
        config.Default = not config.Default
        setValue(config.Default)
        NeverZen.SecureCall(config.Callback, config.Default, config)
        WindowSignal.ConfigValues[config.Name] = config.Default;
    end);

    return {
        SetValue = function(self, newvalue)
          config.Default = newvalue
          setValue(config.Default)
          NeverZen.SecureCall(config.Callback, config.Default, config)
          WindowSignal.ConfigValues[config.Name] = newvalue;
    end;
        Visible = function(self, value)
            Toggle.Visible = value;
        end,
    }
end;
			function SectionSignal:AddLabel(name)
				local Label = Instance.new("TextLabel")

				table.insert(itemForSearch,{
					Frame = Label,
					Name = name
				})

				Label.Name = NeverZen:RandomString()
				Label.Parent = Section
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BackgroundTransparency = 1.000
				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Label.BorderSizePixel = 0
				Label.Size = UDim2.new(1, -10, 0, 20)
				Label.ZIndex = 5
				Label.Font = Enum.Font.GothamBold
				Label.Text = name
				Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				Label.TextSize = 13.000
				Label.TextTransparency = 0.200
				Label.TextXAlignment = Enum.TextXAlignment.Left

				return {
					SetValue = function(self,newvalue)
						Label.Text = newvalue
					end,

					Visible = function(self,value)
						Label.Visible = value;
					end,
				}
			end;

			function SectionSignal:AddButton(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Button";
				config.Callback = config.Callback or function() end;

				local Button = Instance.new("Frame")
				local Label = Instance.new("TextLabel")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")

				table.insert(itemForSearch,{
					Frame = Button,
					Name = config.Name
				})

				Button.Name = NeverZen:RandomString()
				Button.Parent = Section
				NeverZen:Track(Button, 'BackgroundColor3', 'BackgroundColor')
				Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Button.BorderSizePixel = 0
				Button.Size = UDim2.new(1, -10, 0, 25)

				Label.Name = "Label"
				Label.Parent = Button
				Label.AnchorPoint = Vector2.new(0.5, 0.5)
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BackgroundTransparency = 1.000
				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0.5, 0, 0.5, 0)
				Label.Size = UDim2.new(1, -25, 0.649999976, 0)
				Label.Font = Enum.Font.GothamMedium
				Label.Text = config.Name
				Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				Label.TextSize = 14.000
				Label.TextTransparency = 0.100

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Button

				NeverZen:Track(UIStroke, 'Color', 'StrokeColor')
                UIStroke.Parent = Button

				local button = NeverZen:NewInput(Button,function()
					if not Content.Enabled or not Content.Parent then
						return;
					end;

					NeverZen.SecureCall(config.Callback, config);
				end)

				button.MouseEnter:Connect(function()
					TweenService:Create(Button,TweenInfo.new(0.1),{
						BackgroundColor3 = NeverZen.Theme.Hightlight
					}):Play()
				end)

				button.MouseLeave:Connect(function()
					TweenService:Create(Button,TweenInfo.new(0.1),{
						BackgroundColor3 = NeverZen.Theme.BackgroundColor
					}):Play()
				end)

				return {
					SetText = function(self,newvalue)
						Label.Text = newvalue
					end,
					Fire = config.Callback,
					Visible = function(self,value)
						Button.Visible = value;
					end,
				};
			end;

			function SectionSignal:AddSlider(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Slider"
				config.Min = config.Min or 0;
				config.Max = config.Max or 100;
				config.Default = config.Default or config.Min;
				config.Round = config.Round or 0;
				config.Type = config.Type or "";
				config.Callback = config.Callback or function() end;


				local Slider = Instance.new("Frame")
				local value = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local LabelValue = Instance.new("TextLabel")
				local UIStroke = Instance.new("UIStroke")
				local Label = Instance.new("TextLabel")
				local con = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local UIStroke_2 = Instance.new("UIStroke")
				local block = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local move = Instance.new("Frame")
				local UICorner_4 = Instance.new("UICorner")

				table.insert(itemForSearch,{
					Frame = Slider,
					Name = config.Name
				})

				Slider.Name = NeverZen:RandomString()
				Slider.Parent = Section
				Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Slider.BackgroundTransparency = 1.000
				Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Slider.BorderSizePixel = 0
				Slider.Size = UDim2.new(1, -5, 0, 25)

				value.Name = "value"
				value.Parent = Slider
				value.AnchorPoint = Vector2.new(1, 0.5)
				NeverZen:Track(value, 'BackgroundColor3', 'BackgroundColor')
				value.BorderColor3 = Color3.fromRGB(0, 0, 0)
				value.BorderSizePixel = 0
				value.Position = UDim2.new(1, -3, 0.5, 0)
				value.Size = UDim2.new(0, 25, 0, 15)

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = value

				LabelValue.Name = "LabelValue"
				LabelValue.Parent = value
				LabelValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				LabelValue.BackgroundTransparency = 1.000
				LabelValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				LabelValue.BorderSizePixel = 0
				LabelValue.Size = UDim2.new(1, 0, 1, 0)
				LabelValue.Font = Enum.Font.GothamMedium
				LabelValue.Text = tostring(config.Default)..tostring(config.Type)
				LabelValue.TextColor3 = Color3.fromRGB(255, 255, 255)
				LabelValue.TextSize = 10.000
				LabelValue.TextTransparency = 0.250

				NeverZen:Track(UIStroke, 'Color', 'StrokeColor')
                UIStroke.Parent = value

				Label.Name = "Label"
				Label.Parent = Slider
				Label.AnchorPoint = Vector2.new(0, 0.5)
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BackgroundTransparency = 1.000
				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0, 5, 0.5, 0)
				Label.Size = UDim2.new(1, -25, 0.649999976, 0)
				Label.Font = Enum.Font.GothamMedium
				Label.Text = config.Name
				Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				Label.TextSize = 14.000
				Label.TextTransparency = 0.250
				Label.TextXAlignment = Enum.TextXAlignment.Left

				con.Name = "con"
				con.Parent = Slider
				con.AnchorPoint = Vector2.new(1, 0.5)
				NeverZen:Track(con, 'BackgroundColor3', 'BackgroundColor')
				con.BorderColor3 = Color3.fromRGB(0, 0, 0)
				con.BorderSizePixel = 0
				con.Position = UDim2.new(1, -32, 0.5, 0)
				con.Size = UDim2.new(1, -125, 0.200000003, 0)

				UICorner_2.CornerRadius = UDim.new(1, 0)
				UICorner_2.Parent = con

				NeverZen:Track(UIStroke_2, 'Color', 'StrokeColor')
                UIStroke_2.Parent = con

				block.Name = "block"
				block.Parent = con
				NeverZen:Track(block, 'BackgroundColor3', 'Hightlight')
				block.BorderColor3 = Color3.fromRGB(0, 0, 0)
				block.BorderSizePixel = 0
				block.Size = UDim2.new(((config.Default - config.Min) / (config.Max - config.Min)), 0, 1, 0)
				block.ZIndex = 15
				block.Active = true

				UICorner_3.CornerRadius = UDim.new(1, 0)
				UICorner_3.Parent = block

				move.Name = "move"
				move.Parent = block
				move.AnchorPoint = Vector2.new(0.5, 0.5)
				NeverZen:Track(move, 'BackgroundColor3', 'Hightlight')
				move.BorderColor3 = Color3.fromRGB(0, 0, 0)
				move.BorderSizePixel = 0
				move.Position = UDim2.new(1, 0, 0.5, 0)
				move.Size = UDim2.new(2, 0, 2, 0)
				move.SizeConstraint = Enum.SizeConstraint.RelativeYY

				UICorner_4.CornerRadius = UDim.new(1, 0)
				UICorner_4.Parent = move

				local IsHold = false;

				local updateSIZE = function()
					local test = "2."..string.rep("4",(config.Round or 0) + 1)..tostring(config.Type);

					local scale = TextService:GetTextSize(test,LabelValue.TextSize,LabelValue.Font,Vector2.new(math.huge,math.huge));
					local scalelab = TextService:GetTextSize(Label.Text,Label.TextSize,Label.Font,Vector2.new(math.huge,math.huge));

					con.Position = UDim2.new(1, -(scale.X + 11), 0.5, 0)
					con.Size = UDim2.new(1, -(scalelab.X + 55), 0.200000003, 0)
				end;

				updateSIZE()

				local function update(Input)
					local SizeScale = math.clamp((((Input.Position.X) - con.AbsolutePosition.X) / con.AbsoluteSize.X), 0, 1);
					local Main = ((config.Max - config.Min) * SizeScale) + config.Min;
					local Value = NeverZen:Rounding(Main,config.Round);
					local PositionX = UDim2.fromScale(SizeScale, 1);
					local normalized = (Value - config.Min) / (config.Max - config.Min);

					TweenService:Create(block , TweenInfo.new(0.04),{
						Size = UDim2.new(normalized, 0, 1, 0)
					}):Play();

					LabelValue.Text = tostring(Value)..tostring(config.Type)

					local scale = TextService:GetTextSize(LabelValue.Text,LabelValue.TextSize,LabelValue.Font,Vector2.new(math.huge,math.huge));
					value.Size = UDim2.new(0, scale.X + 5, 0, 15)
					updateSIZE()

					NeverZen.SecureCall(config.Callback, Value,config)
          WindowSignal.ConfigValues[config.Name] = Value;
				end;

				con.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						IsHold = true
						update(Input)
					end
				end)

				con.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						IsHold = false
					end
				end)

				Services.UserInputService.InputChanged:Connect(function(Input)
					if IsHold then
						if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
							update(Input)
						end

						if Services.UserInputService.TouchEnabled then
							if not NeverZen:IsMouseOverFrame(Slider) then
								IsHold = false
							end;
						end;
					end
				end);

				WindowSignal.ConfigValues[config.Name] = config.Default;
				WindowSignal.ConfigCallbacks[config.Name] = function(value)
					config.Default = value;
					block.Size = UDim2.new(((config.Default - config.Min) / (config.Max - config.Min)), 0, 1, 0)
					LabelValue.Text = tostring(config.Default)..tostring(config.Type)
					NeverZen.SecureCall(config.Callback, config.Default, config)
				end;

				return {
					SetValue = function(self,newvalue)
              config.Default = newvalue;
              block.Size = UDim2.new(((config.Default - config.Min) / (config.Max - config.Min)), 0, 1, 0)
              LabelValue.Text = tostring(config.Default)..tostring(config.Type)
              WindowSignal.ConfigValues[config.Name] = newvalue;
          end,
					Fire = config.Callback,
					Visible = function(self,value)
						Slider.Visible = value;
					end,
				};
			end;

			function SectionSignal:AddKeybind(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Keybind";
				config.Default = config.Default or nil;
				config.Callback = config.Callback or function() end;

				local Keys = {
					One = '1',
					Two = '2',
					Three = '3',
					Four = '4',
					Five = '5',
					Six = '6',
					Seven = '7',
					Eight = '8',
					Nine = '9',
					Zero = '0',
					['Minus'] = "-",
					['Plus'] = "+",
					BackSlash = "\\",
					Slash = "/",
					Period = '.',
					Semicolon = ';',
					Colon = ":",
					LeftControl = "LCtrl",
					RightControl = "RCtrl",
					LeftShift = "LShift",
					RightShift = "RShift",
				};

				local GetItem = function(item)
					if item then
						if typeof(item) == 'EnumItem' then
							return Keys[item.Name] or item.Name;
						else
							return Keys[tostring(item)] or string.upper(tostring(item))
						end;
					else
						return 'NONE';
					end;
				end;

				local Keybind = Instance.new("Frame")
				local sys = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local value = Instance.new("TextLabel")
				local UIStroke = Instance.new("UIStroke")
				local Label = Instance.new("TextLabel")

				table.insert(itemForSearch,{
					Frame = Keybind,
					Name = config.Name
				})

				Keybind.Name = NeverZen:RandomString()
				Keybind.Parent = Section
				Keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Keybind.BackgroundTransparency = 1.000
				Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Keybind.BorderSizePixel = 0
				Keybind.Size = UDim2.new(1, -5, 0, 25)

				sys.Name = "sys"
				sys.Parent = Keybind
				sys.AnchorPoint = Vector2.new(1, 0.5)
				sys.BackgroundColor3 = NeverZen.Theme.BackgroundColor
				sys.BorderColor3 = Color3.fromRGB(0, 0, 0)
				sys.BorderSizePixel = 0
				sys.Position = UDim2.new(1, -3, 0.5, 0)
				sys.Size = UDim2.new(0, 25, 0, 15)

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = sys

				value.Name = "value"
				value.Parent = sys
				value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				value.BackgroundTransparency = 1.000
				value.BorderColor3 = Color3.fromRGB(0, 0, 0)
				value.BorderSizePixel = 0
				value.Size = UDim2.new(1, 0, 1, 0)
				value.Font = Enum.Font.GothamMedium
				value.Text = GetItem(config.Default)
				value.TextColor3 = NeverZen.Theme.Hightlight;
				value.TextSize = 12.000
				value.TextTransparency = 0.250

				UIStroke.Color = NeverZen.Theme.StrokeColor
				UIStroke.Parent = sys

				Label.Name = "Label"
				Label.Parent = Keybind
				Label.AnchorPoint = Vector2.new(0, 0.5)
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BackgroundTransparency = 1.000
				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0, 5, 0.5, 0)
				Label.Size = UDim2.new(1, -25, 0.649999976, 0)
				Label.Font = Enum.Font.GothamMedium
				Label.Text = config.Name
				Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				Label.TextSize = 14.000
				Label.TextTransparency = 0.250
				Label.TextXAlignment = Enum.TextXAlignment.Left

				local UpdateScale = function()
					local BindLabelScale = TextService:GetTextSize(value.Text,value.TextSize,value.Font,Vector2.new(math.huge,math.huge));

					TweenService:Create(sys,TweenInfo.new(0.1),{
						Size = UDim2.new(0, BindLabelScale.X + 10, 0, 15)
					}):Play();
				end;

				UpdateScale();

				local Button = NeverZen:NewInput(Keybind);
				local IsBinding = false;

				Button.MouseButton1Click:Connect(function()
					if not Content.Enabled or not Content.Parent then
						return;
					end;

					if IsBinding then return; end;

					IsBinding = true;

					value.Text = "...";

					UpdateScale();

					local Selected = nil;
					while not Selected do
						local Key = Services.UserInputService.InputBegan:Wait();

						if Key.KeyCode ~= Enum.KeyCode.Unknown then
							Selected = Key.KeyCode;
						end;
					end;

					config.Default = Selected;

					value.Text = GetItem(Selected);

					UpdateScale();

					IsBinding = false;

					NeverZen.SecureCall(config.Callback, Selected,config);
          WindowSignal.ConfigValues[config.Name] = tostring(Selected);
				end)

				WindowSignal.ConfigValues[config.Name] = tostring(config.Default);
				WindowSignal.ConfigCallbacks[config.Name] = function(strvalue)
					local keycode = strvalue and Enum.KeyCode[tostring(strvalue):gsub("Enum%.KeyCode%.", "")];
					if not keycode then return end;
					config.Default = keycode;
					value.Text = GetItem(keycode);
					UpdateScale();
					NeverZen.SecureCall(config.Callback, keycode, config);
				end;

				return {
					SetValue = function(self,newvalue)
              config.Default = newvalue;
              value.Text = GetItem(newvalue);
              UpdateScale();
              NeverZen.SecureCall(config.Callback, newvalue,config);
              WindowSignal.ConfigValues[config.Name] = tostring(newvalue);
          end,
					Fire = config.Callback,
					Visible = function(self,value)
						Keybind.Visible = value;
					end,
				};
			end;

			function SectionSignal:AddDropdown(config)
				config = NeverZen:CloneConfig(config);
				config.Name = config.Name or "Dropdown";
				config.Values = config.Values or {};
				config.Default = config.Default or {};
				config.Multi = config.Multi or false;
				config.Callback = config.Callback or function() end;

				local parse = function(value)
					if not value then return 'NONE' end;

					if typeof(value) == 'table' then
						if #value > 0 then
							local x = {};

							for i,v in next , value do
								table.insert(x , tostring(v))
							end;

							return table.concat(x,' , ')
						else
							local x = {};

							for i,v in next , value do
								if v == true then

									table.insert(x , tostring(i))
								end			
							end;

							return table.concat(x,' , ')
						end;
					else
						return tostring(value);
					end;
				end;

				local Dropown = Instance.new("Frame")
				local sys = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local value = Instance.new("TextLabel")
				local UIStroke = Instance.new("UIStroke")
				local Label = Instance.new("TextLabel")

				table.insert(itemForSearch,{
					Frame = Dropown,
					Name = config.Name
				})

				Dropown.Name = NeverZen:RandomString()
				Dropown.Parent = Section
				Dropown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Dropown.BackgroundTransparency = 1.000
				Dropown.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Dropown.BorderSizePixel = 0
				Dropown.Size = UDim2.new(1, -5, 0, 25)

				sys.Name = NeverZen:RandomString()
				sys.Parent = Dropown
				sys.AnchorPoint = Vector2.new(1, 0.5)
				NeverZen:Track(sys, 'BackgroundColor3', 'BackgroundColor')
				sys.BorderColor3 = Color3.fromRGB(0, 0, 0)
				sys.BorderSizePixel = 0
				sys.Position = UDim2.new(1, -3, 0.5, 0)
				sys.Size = UDim2.new(0, 55, 0, 15)

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = sys

				value.Name = NeverZen:RandomString()
				value.Parent = sys
				value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				value.BackgroundTransparency = 1.000
				value.BorderColor3 = Color3.fromRGB(0, 0, 0)
				value.BorderSizePixel = 0
				value.Size = UDim2.new(1, 0, 1, 0)
				value.Font = Enum.Font.GothamMedium
				value.Text = parse(config.Default)
				value.TextColor3 = Color3.fromRGB(255, 255, 255)
				value.TextSize = 12.000
				value.TextTransparency = 0.250

				NeverZen:Track(UIStroke, 'Color', 'StrokeColor')
                UIStroke.Parent = sys

				Label.Name = NeverZen:RandomString()
				Label.Parent = Dropown
				Label.AnchorPoint = Vector2.new(0, 0.5)
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BackgroundTransparency = 1.000
				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0, 5, 0.5, 0)
				Label.Size = UDim2.new(1, -25, 0.649999976, 0)
				Label.Font = Enum.Font.GothamMedium
				Label.Text = config.Name
				Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				Label.TextSize = 14.000
				Label.TextTransparency = 0.250
				Label.TextXAlignment = Enum.TextXAlignment.Left

				local DropdownItems = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")
				local Scroll = Instance.new("ScrollingFrame")
				local UIListLayout = Instance.new("UIListLayout")
				local DropShadow = Instance.new("ImageLabel")

				DropdownItems.Name = NeverZen:RandomString()
				DropdownItems.Parent = Content
				DropdownItems.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
				DropdownItems.BackgroundTransparency = 0.050
				DropdownItems.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownItems.BorderSizePixel = 0
				DropdownItems.ClipsDescendants = true
				DropdownItems.Position = UDim2.new(0.518932879, 0, 0.54108721, 0)
				DropdownItems.Size = UDim2.new(0, 165, 0, 0)
				DropdownItems.ZIndex = 100
				DropdownItems.Visible = false

				table.insert(WindowSignal.FrameMemory.WindowBackgroundColor , DropdownItems)

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = DropdownItems

				NeverZen:Track(UIStroke, 'Color', 'BackgroundColor')
                UIStroke.Parent = DropdownItems

				Scroll.Name = NeverZen:RandomString()
				Scroll.Parent = DropdownItems
				Scroll.Active = true
				Scroll.AnchorPoint = Vector2.new(0.5, 0.5)
				Scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Scroll.BackgroundTransparency = 1.000
				Scroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Scroll.BorderSizePixel = 0
				Scroll.ClipsDescendants = false
				Scroll.Position = UDim2.new(0.5, 0, 0.5, 0)
				Scroll.Size = UDim2.new(1, -5, 1, -5)
				Scroll.ZIndex = 101
				Scroll.ScrollBarThickness = 0

				UIListLayout.Parent = Scroll
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 5)

				UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function(...: any) 
					Scroll.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 2)
				end)

				DropShadow.Name = NeverZen:RandomString()
				DropShadow.Parent = DropdownItems
				DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
				DropShadow.BackgroundTransparency = 1.000
				DropShadow.BorderSizePixel = 0
				DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropShadow.Rotation = 0.000
				DropShadow.Size = UDim2.new(1, 47, 1, 47)
				DropShadow.ZIndex = 99
				DropShadow.Image = "rbxassetid://6015897843"
				DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
				DropShadow.ImageTransparency = 0.500
				DropShadow.ScaleType = Enum.ScaleType.Slice
				DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

				DropdownItems:GetPropertyChangedSignal('Size'):Connect(function()
					if DropdownItems.Size.Y.Offset < 5 then
						DropdownItems.Visible = false
					else
						DropdownItems.Visible = true
					end
				end);

				local Icons = {
					Selected = "rbxassetid://10734923868",
					Normal = "rbxassetid://10734895856"
				}

				local update = function()
					local scale = TextService:GetTextSize(value.Text,value.TextSize,value.Font,Vector2.new(math.huge,math.huge));

					TweenService:Create(sys , TweenInfo.new(0.1),{
						Size = UDim2.new(0, scale.X + 10, 0, 15)
					}):Play()
				end;

				update()

				Services.UserInputService.InputBegan:Connect(function(input)
				    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				        if not NeverZen:IsMouseOverFrame(DropdownItems) then
				            TweenService:Create(DropdownItems,TweenInfo.new(0.1),{
				                Size = UDim2.new(0, 165, 0, 0)
				            }):Play()
				            DropdownItems:SetAttribute('OPENED',false)
				        end;
				    end;
				end)

				RunService.Stepped:Connect(function()
					if DropdownItems:GetAttribute('OPENED') then
						TweenService:Create(DropdownItems,TweenInfo.new(0.1),{
							Position = UDim2.fromOffset(sys.AbsolutePosition.X - (DropdownItems.AbsoluteSize.X / 2),sys.AbsolutePosition.Y),
							Size = UDim2.new(0, 165, 0, math.clamp(UIListLayout.AbsoluteContentSize.Y + 5, 15 , 150))
						}):Play()
					else
						DropdownItems.Position = UDim2.fromOffset(sys.AbsolutePosition.X - (DropdownItems.AbsoluteSize.X / 2),sys.AbsolutePosition.Y)
					end;
				end);

				local CreateButton = function(name,val)
					local Selected = Instance.new("Frame")
					local Icon = Instance.new("ImageLabel")
					local Label = Instance.new("TextLabel")
					local UIStroke = Instance.new("UIStroke")
					local UICorner = Instance.new("UICorner")

					Selected.Name = NeverZen:RandomString()
					Selected.Parent = Scroll
					NeverZen:Track(Selected, 'BackgroundColor3', 'BackgroundColor2')
					Selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Selected.BorderSizePixel = 0
					Selected.Size = UDim2.new(1, 0, 0, 25)
					Selected.ZIndex = 102

					Icon.Name = NeverZen:RandomString()
					Icon.Parent = Selected
					Icon.AnchorPoint = Vector2.new(0, 0.5)
					Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Icon.BackgroundTransparency = 1.000
					Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Icon.BorderSizePixel = 0
					Icon.Position = UDim2.new(0, 2, 0.5, 0)
					Icon.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
					Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
					Icon.ZIndex = 102
					Icon.ImageTransparency = 0.500

					Label.Name = NeverZen:RandomString()
					Label.Parent = Selected
					Label.AnchorPoint = Vector2.new(0, 0.5)
					Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Label.BackgroundTransparency = 1.000
					Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Label.BorderSizePixel = 0
					Label.Position = UDim2.new(0, 25, 0.5, 0)
					Label.Size = UDim2.new(1, -25, 0.649999976, 0)
					Label.ZIndex = 102
					Label.Font = Enum.Font.GothamMedium
					Label.Text = tostring(name)
					Label.TextColor3 = Color3.fromRGB(255, 255, 255)
					Label.TextSize = 12.000
					Label.TextTransparency = 0.500
					Label.TextXAlignment = Enum.TextXAlignment.Left

					UIStroke.Transparency = 0.850
					NeverZen:Track(UIStroke, 'Color', 'StrokeColor2')
                    UIStroke.Parent = Selected

					UICorner.CornerRadius = UDim.new(0, 4)
					UICorner.Parent = Selected

					return Selected , Icon
				end;

				local refresh = function()
					for i,v in next , Scroll:GetChildren() do
						if v:IsA('Frame') then
							v:Destroy()
						end;
					end;

					local valueBl = (typeof(config.Default) == 'table' and table.clone(config.Default)) or config.Default;
					local old_call;

					if config.Multi then
						if typeof(valueBl) == 'table' and #valueBl > 0 then
							local fake = {};

							for i,v in next , valueBl do
								fake[v] = true;
							end;

							table.clear(valueBl)

							valueBl = {};

							valueBl = fake;
						end;
					end;

					config.Default = valueBl;

					for i,v in next,config.Values do
						local IsDefault = config.Default == v or (typeof(valueBl) == 'table' and (config.Default[v] or table.find(config.Default,v)));
						local Selected , Icon = CreateButton(v,IsDefault);

						local effect = function(val)
							local x = TweenService:Create(Icon,TweenInfo.new(0.4),{
								Rotation = (val and 180) or -180
							});

							x:Play()

							x.Completed:Connect(function()
								Icon.Rotation = 0
							end)
						end;

						local call = function(v)
							if v then
								if Icon.Image ~= Icons.Selected then
									effect(true)
								end

								Icon.Image = Icons.Selected
								Icon.ImageTransparency = 0.1
								Icon.ImageColor3 = NeverZen.Theme.Hightlight;
							else
								if Icon.Image ~= Icons.Normal then
									effect(false)
								end

								Icon.Image = Icons.Normal
								Icon.ImageTransparency = 0.5
								Icon.ImageColor3 = Color3.fromRGB(255, 255, 255);
							end;
						end;

						if IsDefault then
							old_call = call;
							call(true)
						else
							call(false)
						end;

						NeverZen:NewInput(Selected,function()
							if not Content.Enabled or not Content.Parent then
								return;
							end;

							if config.Multi then
								config.Default[v] = not (config.Default[v] or table.find(config.Default,v));

								call(config.Default[v])

								if #config.Default > 0 then
									table.clear(config.Default)
								end;

								value.Text = parse(config.Default)
								update()

								NeverZen.SecureCall(config.Callback, config.Default)
                WindowSignal.ConfigValues[config.Name] = config.Default;
							else
								config.Default = v;

								if old_call then
									old_call(false)
								end;

								call(true)
								old_call = call;

								value.Text = parse(config.Default)
								update()

								NeverZen.SecureCall(config.Callback, config.Default)
                WindowSignal.ConfigValues[config.Name] = config.Default;
							end;
						end);
					end;
				end;

				local upd = NeverZen:NewInput(Dropown);

				DropdownItems:SetAttribute('OPENED',false)

				upd.MouseButton1Click:Connect(function()
					if not Content.Enabled or not Content.Parent then
						return;
					end;

					DropdownItems:SetAttribute('OPENED',true)

					TweenService:Create(DropdownItems,TweenInfo.new(0.1),{
						Size = UDim2.new(0, 165, 0, math.clamp(UIListLayout.AbsoluteContentSize.Y , 15 , 150))
					}):Play()

					refresh()
				end);

				WindowSignal.ConfigValues[config.Name] = config.Default;
				WindowSignal.ConfigCallbacks[config.Name] = function(newvalue)
					config.Default = newvalue;
					value.Text = parse(newvalue)
					update();
					NeverZen.SecureCall(config.Callback, config.Default)
				end;

				return {
					SetValue = function(self,newvalue)
              config.Default = newvalue;
              value.Text = parse(newvalue)
              update();
              WindowSignal.ConfigValues[config.Name] = newvalue;
          end,
					SetValues = function(self , new)
						config.Values = new
					end,
					Fire = config.Callback,
					Visible = function(self,value)
						Dropown.Visible = value;
					end,
				};
			end;

            function SectionSignal:AddColorPicker(config)
	config = NeverZen:CloneConfig(config);
	config.Name = config.Name or "Color Picker";
	config.Default = config.Default or Color3.fromRGB(255, 255, 255);
	config.Callback = config.Callback or function() end;

	local function toHex(color)
		return string.format("%02X%02X%02X",
			math.floor(color.R * 255 + 0.5),
			math.floor(color.G * 255 + 0.5),
			math.floor(color.B * 255 + 0.5)
		);
	end;

	local function fromHex(hex)
		hex = hex:gsub("#", "");
		if #hex ~= 6 then return nil end;

		local r = tonumber(hex:sub(1,2), 16);
		local g = tonumber(hex:sub(3,4), 16);
		local b = tonumber(hex:sub(5,6), 16);

		if not (r and g and b) then return nil end;

		return Color3.fromRGB(r, g, b);
	end;

	local ColorPicker = Instance.new("Frame")
	local Label = Instance.new("TextLabel")
	local sys = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")

	table.insert(itemForSearch, {
		Frame = ColorPicker,
		Name = config.Name
	})

	ColorPicker.Name = NeverZen:RandomString()
	ColorPicker.Parent = Section
	ColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorPicker.BackgroundTransparency = 1.000
	ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPicker.BorderSizePixel = 0
	ColorPicker.Size = UDim2.new(1, -5, 0, 25)

	Label.Name = "Label"
	Label.Parent = ColorPicker
	Label.AnchorPoint = Vector2.new(0, 0.5)
	Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label.BackgroundTransparency = 1.000
	Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Label.BorderSizePixel = 0
	Label.Position = UDim2.new(0, 5, 0.5, 0)
	Label.Size = UDim2.new(1, -35, 0.649999976, 0)
	Label.Font = Enum.Font.GothamMedium
	Label.Text = config.Name
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 14.000
	Label.TextTransparency = 0.100
	Label.TextXAlignment = Enum.TextXAlignment.Left

	sys.Name = "sys"
	sys.Parent = ColorPicker
	sys.AnchorPoint = Vector2.new(1, 0.5)
	sys.BackgroundColor3 = config.Default
	sys.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sys.BorderSizePixel = 0
	sys.Position = UDim2.new(1, -3, 0.5, 0)
	sys.Size = UDim2.new(0, 25, 0, 15)

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = sys

	UIStroke.Color = NeverZen.Theme.StrokeColor
	UIStroke.Parent = sys


	local Panel = Instance.new("Frame")
	local PanelCorner = Instance.new("UICorner")
	local PanelStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")

	Panel.Name = NeverZen:RandomString()
	Panel.Parent = Content
	Panel.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
	Panel.BackgroundTransparency = 0.050
	Panel.BorderSizePixel = 0
	Panel.ClipsDescendants = true
	Panel.Size = UDim2.new(0, 170, 0, 0)
	Panel.ZIndex = 100
	Panel.Visible = false

	table.insert(WindowSignal.FrameMemory.WindowBackgroundColor, Panel)

	PanelCorner.CornerRadius = UDim.new(0, 4)
	PanelCorner.Parent = Panel

	PanelStroke.Color = NeverZen.Theme.BackgroundColor
	PanelStroke.Parent = Panel

	DropShadow.Name = NeverZen:RandomString()
	DropShadow.Parent = Panel
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 99
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.500
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	local Inner = Instance.new("Frame")
	Inner.Name = NeverZen:RandomString()
	Inner.Parent = Panel
	Inner.BackgroundTransparency = 1
	Inner.Position = UDim2.new(0, 10, 0, 10)
	Inner.Size = UDim2.new(1, -20, 1, -20)
	Inner.ZIndex = 101

	local SVBox = Instance.new("Frame")
	local SVWhite = Instance.new("Frame")
	local SVWhiteGrad = Instance.new("UIGradient")
	local SVBlack = Instance.new("Frame")
	local SVBlackGrad = Instance.new("UIGradient")
	local SVCorner = Instance.new("UICorner")
	local SVCursor = Instance.new("Frame")
	local SVCursorCorner = Instance.new("UICorner")
	local SVCursorStroke = Instance.new("UIStroke")

	SVBox.Name = NeverZen:RandomString()
	SVBox.Parent = Inner
	SVBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	SVBox.BorderSizePixel = 0
	SVBox.ClipsDescendants = true
	SVBox.Position = UDim2.new(0, 0, 0, 0)
	SVBox.Size = UDim2.new(1, 0, 0, 100)
	SVBox.ZIndex = 101

	SVCorner.CornerRadius = UDim.new(0, 4)
	SVCorner.Parent = SVBox

	SVWhite.Name = "White"
	SVWhite.Parent = SVBox
	SVWhite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SVWhite.BorderSizePixel = 0
	SVWhite.Size = UDim2.new(1, 0, 1, 0)
	SVWhite.ZIndex = 101

	SVWhiteGrad.Parent = SVWhite
	SVWhiteGrad.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	}

	SVBlack.Name = "Black"
	SVBlack.Parent = SVBox
	SVBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	SVBlack.BackgroundTransparency = 1
	SVBlack.BorderSizePixel = 0
	SVBlack.Size = UDim2.new(1, 0, 1, 0)
	SVBlack.ZIndex = 102

	SVBlackGrad.Parent = SVBlack
	SVBlackGrad.Rotation = 90
	SVBlackGrad.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0),
	}

	SVCursor.Name = NeverZen:RandomString()
	SVCursor.Parent = SVBox
	SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SVCursor.BorderSizePixel = 0
	SVCursor.Position = UDim2.new(1, 0, 0, 0)
	SVCursor.Size = UDim2.new(0, 10, 0, 10)
	SVCursor.ZIndex = 103

	SVCursorCorner.CornerRadius = UDim.new(1, 0)
	SVCursorCorner.Parent = SVCursor

	SVCursorStroke.Thickness = 1.5
	SVCursorStroke.Color = Color3.fromRGB(20, 20, 20)
	SVCursorStroke.Parent = SVCursor

	local HueBar = Instance.new("Frame")
	local HueCorner = Instance.new("UICorner")
	local HueGrad = Instance.new("UIGradient")
	local HueCursor = Instance.new("Frame")
	local HueCursorCorner = Instance.new("UICorner")
	local HueCursorStroke = Instance.new("UIStroke")

	HueBar.Name = NeverZen:RandomString()
	HueBar.Parent = Inner
	HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HueBar.BorderSizePixel = 0
	HueBar.Position = UDim2.new(0, 0, 0, 110)
	HueBar.Size = UDim2.new(1, 0, 0, 12)
	HueBar.ZIndex = 101

	HueCorner.CornerRadius = UDim.new(1, 0)
	HueCorner.Parent = HueBar

	HueGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.000, Color3.fromHSV(0/6, 1, 1)),
		ColorSequenceKeypoint.new(0.166, Color3.fromHSV(1/6, 1, 1)),
		ColorSequenceKeypoint.new(0.333, Color3.fromHSV(2/6, 1, 1)),
		ColorSequenceKeypoint.new(0.500, Color3.fromHSV(3/6, 1, 1)),
		ColorSequenceKeypoint.new(0.666, Color3.fromHSV(4/6, 1, 1)),
		ColorSequenceKeypoint.new(0.833, Color3.fromHSV(5/6, 1, 1)),
		ColorSequenceKeypoint.new(1.000, Color3.fromHSV(6/6, 1, 1)),
	}
	HueGrad.Parent = HueBar

	HueCursor.Name = NeverZen:RandomString()
	HueCursor.Parent = HueBar
	HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HueCursor.BorderSizePixel = 0
	HueCursor.Position = UDim2.new(0, 0, 0.5, 0)
	HueCursor.Size = UDim2.new(0, 4, 1, 4)
	HueCursor.ZIndex = 102

	HueCursorCorner.CornerRadius = UDim.new(1, 0)
	HueCursorCorner.Parent = HueCursor

	HueCursorStroke.Thickness = 1.5
	HueCursorStroke.Color = Color3.fromRGB(20, 20, 20)
	HueCursorStroke.Parent = HueCursor

	local Preview = Instance.new("Frame")
	local PreviewCorner = Instance.new("UICorner")
	local PreviewStroke = Instance.new("UIStroke")
	local HexBox = Instance.new("TextBox")
	local HexCorner = Instance.new("UICorner")
	local HexStroke = Instance.new("UIStroke")

	Preview.Name = NeverZen:RandomString()
	Preview.Parent = Inner
	Preview.BackgroundColor3 = config.Default
	Preview.BorderSizePixel = 0
	Preview.Position = UDim2.new(0, 0, 0, 132)
	Preview.Size = UDim2.new(0, 22, 0, 22)
	Preview.ZIndex = 101

	PreviewCorner.CornerRadius = UDim.new(0, 4)
	PreviewCorner.Parent = Preview

	PreviewStroke.Color = NeverZen.Theme.StrokeColor
	PreviewStroke.Parent = Preview

	HexBox.Name = NeverZen:RandomString()
	HexBox.Parent = Inner
	HexBox.BackgroundColor3 = NeverZen.Theme.BackgroundColor
	HexBox.BorderSizePixel = 0
	HexBox.ClearTextOnFocus = false
	HexBox.Position = UDim2.new(0, 30, 0, 132)
	HexBox.Size = UDim2.new(1, -30, 0, 22)
	HexBox.ZIndex = 101
	HexBox.Font = Enum.Font.GothamMedium
	HexBox.Text = "#" .. toHex(config.Default)
	HexBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	HexBox.TextSize = 13.000
	HexBox.TextXAlignment = Enum.TextXAlignment.Center

	HexCorner.CornerRadius = UDim.new(0, 4)
	HexCorner.Parent = HexBox

	HexStroke.Color = NeverZen.Theme.StrokeColor
	HexStroke.Parent = HexBox

	Panel:SetAttribute('OPENED', false)


	local H, S, V = config.Default:ToHSV();

	local updateAll;

	local applyColor = function(fireCallback)
		local color = Color3.fromHSV(H, S, V);

		sys.BackgroundColor3 = color;
		Preview.BackgroundColor3 = color;
		SVBox.BackgroundColor3 = Color3.fromHSV(H, 1, 1);
		HexBox.Text = "#" .. toHex(color);

		config.Default = color;
    if fireCallback then
        WindowSignal.ConfigValues[config.Name] = {
            R = math.floor(color.R * 255),
            G = math.floor(color.G * 255),
            B = math.floor(color.B * 255)
        };
        NeverZen.SecureCall(config.Callback, color, config);
    end;
	end;

	updateAll = function(fireCallback)
		SVCursor.Position = UDim2.new(S, 0, 1 - V, 0);
		HueCursor.Position = UDim2.new(H, 0, 0.5, 0);
		applyColor(fireCallback);
	end;

	local svHold, hueHold = false, false;

	local updateSV = function(inputPos)
		local rel = Vector2.new(
			math.clamp((inputPos.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1),
			math.clamp((inputPos.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
		);

		S = rel.X;
		V = 1 - rel.Y;

		updateAll(true);
	end;

	local updateHue = function(inputPos)
		local rel = math.clamp((inputPos.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1);

		H = rel;

		updateAll(true);
	end;

	SVBox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			svHold = true;
			updateSV(input.Position);
		end;
	end);

	SVBox.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			svHold = false;
		end;
	end);

	HueBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			hueHold = true;
			updateHue(input.Position);
		end;
	end);

	HueBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			hueHold = false;
		end;
	end);

	Services.UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if svHold then
				updateSV(input.Position);
			elseif hueHold then
				updateHue(input.Position);
			end;
		end;
	end);

	HexBox.FocusLost:Connect(function(enter)
		if enter then
			local parsed = fromHex(HexBox.Text);

			if parsed then
				H, S, V = parsed:ToHSV();
				updateAll(true);
			else
				HexBox.Text = "#" .. toHex(config.Default);
			end;
		end;
	end);

	Services.UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if not NeverZen:IsMouseOverFrame(Panel) and not NeverZen:IsMouseOverFrame(sys) then
				local closeTween = TweenService:Create(Panel, TweenInfo.new(0.15), {
					Size = UDim2.new(0, 170, 0, 0)
				});
				closeTween:Play();
				closeTween.Completed:Connect(function()
					Panel.Visible = false;
				end);

				Panel:SetAttribute('OPENED', false);
			end;
		end;
	end);

	RunService.Stepped:Connect(function()
		if Panel:GetAttribute('OPENED') then
			Panel.Position = UDim2.fromOffset(
				math.clamp(sys.AbsolutePosition.X - Panel.AbsoluteSize.X + sys.AbsoluteSize.X, 5, 9999),
				sys.AbsolutePosition.Y + sys.AbsoluteSize.Y + 6
			);
		end;
	end);

	local upd = NeverZen:NewInput(sys);

	upd.MouseButton1Click:Connect(function()
		if not Content.Enabled or not Content.Parent then
			return;
		end;

		if Panel:GetAttribute('OPENED') then
			local closeTween = TweenService:Create(Panel, TweenInfo.new(0.15), {
				Size = UDim2.new(0, 170, 0, 0)
			});
			closeTween:Play();
			closeTween.Completed:Connect(function()
				Panel.Visible = false;
			end);

			Panel:SetAttribute('OPENED', false);

			return;
		end;

		Panel.Visible = true;
		Panel:SetAttribute('OPENED', true);

		updateAll(false);

		TweenService:Create(Panel, TweenInfo.new(0.15), {
			Size = UDim2.new(0, 170, 0, 176)
		}):Play();
	end);

	updateAll(false);

	WindowSignal.ConfigValues[config.Name] = {
		R = math.floor(config.Default.R * 255),
		G = math.floor(config.Default.G * 255),
		B = math.floor(config.Default.B * 255)
	};
	WindowSignal.ConfigCallbacks[config.Name] = function(rgb)
		if typeof(rgb) ~= "table" then return end;
		local newColor = Color3.fromRGB(rgb.R or 255, rgb.G or 255, rgb.B or 255);
		H, S, V = newColor:ToHSV();
		updateAll(true);
	end;

	return {
    SetValue = function(self, newvalue)
        H, S, V = newvalue:ToHSV();
        updateAll(true);
        WindowSignal.ConfigValues[config.Name] = {
            R = math.floor(newvalue.R * 255),
            G = math.floor(newvalue.G * 255),
            B = math.floor(newvalue.B * 255)
        };
    end,
		Fire = config.Callback,
		Visible = function(self, value)
			ColorPicker.Visible = value;
		end,
	};
end;

			return SectionSignal;
		end;

		function TabSignal:Rename(new)
			TabName.Text = new;
		end;

		function TabSignal:Icon(new)
			TabIcon.Image = NeverZen:GetIcon(new);
		end;

		return TabSignal;
	end;

	local llk;
	local ToggleWin = function(v)

	    if not v then

	        if AutoLoadPanel and AutoLoadPanel.Parent then
	            TweenService:Create(AutoLoadPanel, TweenInfo.new(0.1), {
	                Size = UDim2.new(0, 120, 0, 0)
	            }):Play()
	            task.delay(0.1, function()
	                if AutoLoadPanel then AutoLoadPanel.Visible = false end
	            end)
	        end
	 
	        if LoadPanel and LoadPanel.Parent then
	            TweenService:Create(LoadPanel, TweenInfo.new(0.1), {
	                Size = UDim2.new(0, 120, 0, 0)
	            }):Play()
	            task.delay(0.1, function()
	                if LoadPanel then LoadPanel.Visible = false end
	            end)
	        end

	        if SettingsPanel and SettingsPanel.Parent and SettingsPanel:GetAttribute('OPENED') then
	            SettingsPanel:SetAttribute('OPENED', false)
	            TweenService:Create(SettingsPanel, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
	                Size = UDim2.new(0, 280, 0, 0)
	            }):Play()
	            task.delay(0.15, function()
	                if SettingsPanel then SettingsPanel.Visible = false end
	            end)
	        end
	    end
	
	    if llk then
	        llk.Visible = (v and true) or false;	
	    end;

		if not v then
			TweenService:Create(WindowFrame,TweenInfo.new(0.7,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Size = UDim2.fromOffset(210,44)
			}):Play()

			TweenService:Create(BthFrames,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Position = UDim2.new(-1, 0, 0, 45)
			}):Play()

			TweenService:Create(InformationFrame,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Position = UDim2.new(0, 0, 1, 55)
			}):Play()

			TweenService:Create(TabWin,TweenInfo.new(0.45,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Position = UDim2.new(1, 170, 0, 45)
			}):Play()

			TweenService:Create(SearchFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Size = UDim2.new(0, 0, 0, 22)
			}):Play()

			TweenService:Create(UIStroke_2,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Transparency = 1
			}):Play()

			TweenService:Create(SettingsButton,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Size = UDim2.new(0, 0, 0, 0)
			}):Play()

		else
			TweenService:Create(SettingsButton,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
			}):Play()

			TweenService:Create(UIStroke_2,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Transparency = 0
			}):Play()

			TweenService:Create(SearchFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Size = UDim2.new(0, 140, 0, 22)
			}):Play()

			TweenService:Create(InformationFrame,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Position = UDim2.new(0, 0, 1, 0)
			}):Play()

			TweenService:Create(BthFrames,TweenInfo.new(0.7,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Position = UDim2.new(0, 0, 0, 45)
			}):Play()

			TweenService:Create(TabWin,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Position = UDim2.new(0, 170, 0, 45)
			}):Play()

			TweenService:Create(WindowFrame,TweenInfo.new(0.6,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Size = WindowSignal.Config.Scale
			}):Play()
		end;
	end;

	MinButton.MouseButton1Click:Connect(function()
		WindowSignal.Toggle = not WindowSignal.Toggle;

		ToggleWin(WindowSignal.Toggle)
	end)


local SettingsPanel = Instance.new("Frame")
local SettingsCorner = Instance.new("UICorner")
local SettingsStroke = Instance.new("UIStroke")
local SettingsDropShadow = Instance.new("ImageLabel")
local SettingsInner = Instance.new("ScrollingFrame")
local SettingsList = Instance.new("UIListLayout")
local SettingsPadding = Instance.new("UIPadding")

SettingsPanel.Name = NeverZen:RandomString()
SettingsPanel.Parent = Content
SettingsPanel.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
SettingsPanel.BackgroundTransparency = 0.05
SettingsPanel.BorderSizePixel = 0
SettingsPanel.ClipsDescendants = true
SettingsPanel.Size = UDim2.new(0, 280, 0, 0)
SettingsPanel.ZIndex = 200
SettingsPanel.Visible = false

table.insert(WindowSignal.FrameMemory.WindowBackgroundColor, SettingsPanel)

SettingsCorner.CornerRadius = UDim.new(0, 6)
SettingsCorner.Parent = SettingsPanel

SettingsStroke.Transparency = 0.4
SettingsStroke.Color = NeverZen.Theme.BackgroundColor
SettingsStroke.Parent = SettingsPanel

SettingsDropShadow.Name = NeverZen:RandomString()
SettingsDropShadow.Parent = SettingsPanel
SettingsDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsDropShadow.BackgroundTransparency = 1
SettingsDropShadow.BorderSizePixel = 0
SettingsDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
SettingsDropShadow.Size = UDim2.new(1, 47, 1, 47)
SettingsDropShadow.ZIndex = 149
SettingsDropShadow.Image = "rbxassetid://6015897843"
SettingsDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
SettingsDropShadow.ImageTransparency = 0.45
SettingsDropShadow.ScaleType = Enum.ScaleType.Slice
SettingsDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

SettingsInner.Name = NeverZen:RandomString()
SettingsInner.Parent = SettingsPanel
SettingsInner.Active = true
SettingsInner.BackgroundTransparency = 1
SettingsInner.BorderSizePixel = 0
SettingsInner.Size = UDim2.new(1, 0, 1, 0)
SettingsInner.ZIndex = 201
SettingsInner.ScrollBarThickness = 3
SettingsInner.ScrollBarImageColor3 = NeverZen.Theme.Hightlight
SettingsInner.ScrollBarImageTransparency = 0.3
SettingsInner.ScrollingDirection = Enum.ScrollingDirection.Y
SettingsInner.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsInner.AutomaticCanvasSize = Enum.AutomaticSize.Y

SettingsPadding.PaddingTop = UDim.new(0, 10)
SettingsPadding.PaddingBottom = UDim.new(0, 10)
SettingsPadding.PaddingLeft = UDim.new(0, 10)
SettingsPadding.PaddingRight = UDim.new(0, 10)
SettingsPadding.Parent = SettingsInner

SettingsList.Parent = SettingsInner
SettingsList.SortOrder = Enum.SortOrder.LayoutOrder
SettingsList.Padding = UDim.new(0, 8)

SettingsList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if SettingsPanel:GetAttribute('OPENED') then
		TweenService:Create(SettingsPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 280, 0, math.min(SettingsList.AbsoluteContentSize.Y + 20, 300))
		}):Play()
	end
end)

local SettingsPanelConn = nil
local function UpdateSettingsPosition()
    if not SettingsButton or not SettingsButton.Parent then return end
    if not SettingsPanel:GetAttribute('OPENED') then return end

    local viewportSize = workspace.CurrentCamera.ViewportSize
    local panelWidth = SettingsPanel.AbsoluteSize.X
    local targetX = SettingsButton.AbsolutePosition.X + SettingsButton.AbsoluteSize.X - panelWidth
    local targetY = SettingsButton.AbsolutePosition.Y + SettingsButton.AbsoluteSize.Y + 8

    SettingsPanel.Position = UDim2.fromOffset(
        math.clamp(targetX, 5, viewportSize.X - panelWidth - 5),
        targetY
    )
end

if SettingsPanelConn then SettingsPanelConn:Disconnect() end
SettingsPanelConn = RunService.Heartbeat:Connect(UpdateSettingsPosition)

local TitleHolder = Instance.new("Frame")
TitleHolder.Name = NeverZen:RandomString()
TitleHolder.Parent = SettingsInner
TitleHolder.BackgroundTransparency = 1
TitleHolder.Size = UDim2.new(1, 0, 0, 26)
TitleHolder.ZIndex = 151

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Name = NeverZen:RandomString()
TitleIcon.Parent = TitleHolder
TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Position = UDim2.new(0, 0, 0, 8)
TitleIcon.Size = UDim2.new(0, 15, 0, 15)
TitleIcon.Image = NeverZen:GetIcon("settings")
TitleIcon.ImageColor3 = NeverZen.Theme.Hightlight
TitleIcon.ZIndex = 152

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = NeverZen:RandomString()
TitleLabel.Parent = TitleHolder
TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 22, 0, 8)
TitleLabel.Size = UDim2.new(1, -22, 0, 16)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Settings"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 152

local TitleDivider = Instance.new("Frame")
TitleDivider.Name = NeverZen:RandomString()
TitleDivider.Parent = TitleHolder
TitleDivider.AnchorPoint = Vector2.new(0, 1)
TitleDivider.BackgroundColor3 = NeverZen.Theme.LineColor
TitleDivider.BorderSizePixel = 0
TitleDivider.Position = UDim2.new(0, 0, 1, 0)
TitleDivider.Size = UDim2.new(1, 0, 0, 1)
TitleDivider.ZIndex = 152

table.insert(WindowSignal.FrameMemory.LineColor, TitleDivider)


local function settingsHeader(text)
	local Lbl = Instance.new("TextLabel")
	Lbl.Name = NeverZen:RandomString()
	Lbl.Parent = SettingsInner
	Lbl.BackgroundTransparency = 1
	Lbl.Size = UDim2.new(1, 0, 0, 14)
	Lbl.Font = Enum.Font.GothamBold
	Lbl.Text = string.upper(text)
	Lbl.TextColor3 = NeverZen.Theme.HeadText
	Lbl.TextSize = 10.5
	Lbl.TextTransparency = 0.45
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
	Lbl.ZIndex = 151
	return Lbl
end

local ThemeSwatches = {}
local ThemeColors = {
	Neverlose = Color3.fromRGB(0, 169, 239),
	Fatality  = Color3.fromRGB(198, 9, 85),
	Anyx      = Color3.fromRGB(81, 195, 206),
	Hyperion  = Color3.fromRGB(197, 29, 29),
	Airflow   = Color3.fromRGB(143, 107, 190),
}

local function settingsThemeButton(themeName, callback)
	local Row = Instance.new("Frame")
	local RowCorner = Instance.new("UICorner")
	local RowStroke = Instance.new("UIStroke")
	local Swatch = Instance.new("Frame")
	local SwatchCorner = Instance.new("UICorner")
	local SwatchStroke = Instance.new("UIStroke")
	local Label = Instance.new("TextLabel")
	local Check = Instance.new("ImageLabel")

	Row.Name = NeverZen:RandomString()
	Row.Parent = SettingsInner
	Row.BackgroundTransparency = 0
	Row.BorderSizePixel = 0
	Row.Size = UDim2.new(1, 0, 0, 28)
	Row.ZIndex = 151

	NeverZen:Track(Row, 'BackgroundColor3', 'BackgroundColor')

	RowCorner.CornerRadius = UDim.new(0, 5)
	RowCorner.Parent = Row

	RowStroke.Transparency = 0.7
	RowStroke.Parent = Row

	NeverZen:Track(RowStroke, 'Color', 'StrokeColor2')

	Swatch.Name = NeverZen:RandomString()
	Swatch.Parent = Row
	Swatch.AnchorPoint = Vector2.new(0, 0.5)
	Swatch.BackgroundColor3 = ThemeColors[themeName] or Color3.fromRGB(255, 255, 255)
	Swatch.BorderSizePixel = 0
	Swatch.Position = UDim2.new(0, 8, 0.5, 0)
	Swatch.Size = UDim2.new(0, 12, 0, 12)
	Swatch.ZIndex = 152

	SwatchCorner.CornerRadius = UDim.new(1, 0)
	SwatchCorner.Parent = Swatch

	SwatchStroke.Thickness = 1
	SwatchStroke.Transparency = 0.3
	SwatchStroke.Color = Color3.fromRGB(0, 0, 0)
	SwatchStroke.Parent = Swatch

	Label.Name = NeverZen:RandomString()
	Label.Parent = Row
	Label.AnchorPoint = Vector2.new(0, 0.5)
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0, 28, 0.5, 0)
	Label.Size = UDim2.new(1, -50, 1, 0)
	Label.Font = Enum.Font.GothamMedium
	Label.Text = themeName
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 13
	Label.TextTransparency = 0.15
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 152

	Check.Name = NeverZen:RandomString()
	Check.Parent = Row
	Check.AnchorPoint = Vector2.new(1, 0.5)
	Check.BackgroundTransparency = 1
	Check.Position = UDim2.new(1, -8, 0.5, 0)
	Check.Size = UDim2.new(0, 14, 0, 14)
	Check.Image = NeverZen:GetIcon("check")
	Check.ImageColor3 = NeverZen.Theme.Hightlight
	Check.ImageTransparency = 1
	Check.ZIndex = 152

	local input = NeverZen:NewInput(Row, callback)

	input.MouseEnter:Connect(function()
		TweenService:Create(Row, TweenInfo.new(0.12), {
			BackgroundColor3 = NeverZen.Theme.SectionColor
		}):Play()
		TweenService:Create(RowStroke, TweenInfo.new(0.12), {
			Transparency = 0.3
		}):Play()
	end)

	input.MouseLeave:Connect(function()
		TweenService:Create(Row, TweenInfo.new(0.12), {
			BackgroundColor3 = NeverZen.Theme.BackgroundColor
		}):Play()
		TweenService:Create(RowStroke, TweenInfo.new(0.12), {
			Transparency = 0.7
		}):Play()
	end)

	ThemeSwatches[themeName] = { Row = Row, Check = Check }

	return Row
end

local function refreshThemeChecks(activeName)
	for name, data in pairs(ThemeSwatches) do
		TweenService:Create(data.Check, TweenInfo.new(0.15), {
			ImageTransparency = (name == activeName) and 0 or 1
		}):Play()
	end
end

local function settingsRow(iconName, text)
	local Row = Instance.new("Frame")
	local RowCorner = Instance.new("UICorner")
	local RowStroke = Instance.new("UIStroke")
	local Icon = Instance.new("ImageLabel")
	local Label = Instance.new("TextLabel")
	local sys = Instance.new("Frame")
	local sysCorner = Instance.new("UICorner")
	local sysStroke = Instance.new("UIStroke")
	local Value = Instance.new("TextLabel")

	Row.Name = NeverZen:RandomString()
	Row.Parent = SettingsInner
	Row.BackgroundColor3 = NeverZen.Theme.BackgroundColor
	Row.BorderSizePixel = 0
	Row.Size = UDim2.new(1, 0, 0, 28)
	Row.ZIndex = 151

	RowCorner.CornerRadius = UDim.new(0, 5)
	RowCorner.Parent = Row

	RowStroke.Transparency = 0.7
	RowStroke.Color = NeverZen.Theme.StrokeColor2
	RowStroke.Parent = Row

	Icon.Name = NeverZen:RandomString()
	Icon.Parent = Row
	Icon.AnchorPoint = Vector2.new(0, 0.5)
	Icon.BackgroundTransparency = 1
	Icon.Position = UDim2.new(0, 8, 0.5, 0)
	Icon.Size = UDim2.new(0, 14, 0, 14)
	Icon.Image = NeverZen:GetIcon(iconName)
	Icon.ImageColor3 = NeverZen.Theme.IconColor
	Icon.ImageTransparency = 0.2
	Icon.ZIndex = 152

	Label.Name = NeverZen:RandomString()
	Label.Parent = Row
	Label.AnchorPoint = Vector2.new(0, 0.5)
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0, 28, 0.5, 0)
	Label.Size = UDim2.new(1, -85, 1, 0)
	Label.Font = Enum.Font.GothamMedium
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 13
	Label.TextTransparency = 0.15
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 152

	sys.Name = "sys"
	sys.Parent = Row
	sys.AnchorPoint = Vector2.new(1, 0.5)
	sys.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
	sys.BorderSizePixel = 0
	sys.Position = UDim2.new(1, -8, 0.5, 0)
	sys.Size = UDim2.new(0, 45, 0, 16)
	sys.ZIndex = 152

	sysCorner.CornerRadius = UDim.new(0, 4)
	sysCorner.Parent = sys

	sysStroke.Color = NeverZen.Theme.StrokeColor
	sysStroke.Parent = sys

	Value.Name = NeverZen:RandomString()
	Value.Parent = sys
	Value.BackgroundTransparency = 1
	Value.Size = UDim2.new(1, 0, 1, 0)
	Value.Font = Enum.Font.GothamBold
	Value.Text = "..."
	Value.TextColor3 = NeverZen.Theme.Hightlight
	Value.TextSize = 11
	Value.ZIndex = 153

	local input = NeverZen:NewInput(Row)

	input.MouseEnter:Connect(function()
		TweenService:Create(Row, TweenInfo.new(0.12), {
			BackgroundColor3 = NeverZen.Theme.SectionColor
		}):Play()
	end)

	input.MouseLeave:Connect(function()
		TweenService:Create(Row, TweenInfo.new(0.12), {
			BackgroundColor3 = NeverZen.Theme.BackgroundColor
		}):Play()
	end)

	return Row, Value, input
end

settingsHeader("Theme")

local ThemeNames = { "Neverlose", "Fatality", "Anyx", "Hyperion", "Airflow"}

for i = 1, #ThemeNames do
	local themeName = ThemeNames[i]
	settingsThemeButton(themeName, function()
		NeverZen:SetTheme(themeName)
		applyThemeLive()
		refreshThemeChecks(themeName)
	end)
end

refreshThemeChecks("Neverlose")

local ConfigDivider = Instance.new("Frame")
ConfigDivider.Name = NeverZen:RandomString()
ConfigDivider.Parent = SettingsInner
ConfigDivider.BackgroundColor3 = NeverZen.Theme.LineColor
ConfigDivider.BorderSizePixel = 0
ConfigDivider.Size = UDim2.new(1, 0, 0, 1)
ConfigDivider.ZIndex = 151
ConfigDivider.LayoutOrder = 100
table.insert(WindowSignal.FrameMemory.LineColor, ConfigDivider)

settingsHeader("Config")
local function GetConfigList()
    local configs = NeverZen:ListConfigs()
    if #configs == 0 then
        return {"No configs"}
    end
    return configs
end

local AutoLoadRow = Instance.new("Frame")
local AutoLoadCorner = Instance.new("UICorner")
local AutoLoadStroke = Instance.new("UIStroke")
local AutoLoadIcon = Instance.new("ImageLabel")
local AutoLoadLabel = Instance.new("TextLabel")
local AutoLoadDropdown = Instance.new("Frame")
local AutoLoadDropdownCorner = Instance.new("UICorner")
local AutoLoadDropdownStroke = Instance.new("UIStroke")
local AutoLoadValue = Instance.new("TextLabel")
local AutoLoadArrow = Instance.new("ImageLabel")

AutoLoadRow.Name = NeverZen:RandomString()
AutoLoadRow.Parent = SettingsInner
AutoLoadRow.BackgroundColor3 = NeverZen.Theme.BackgroundColor
AutoLoadRow.BorderSizePixel = 0
AutoLoadRow.Size = UDim2.new(1, 0, 0, 38)
AutoLoadRow.ZIndex = 151
AutoLoadRow.Active = true

NeverZen:Track(AutoLoadRow, 'BackgroundColor3', 'BackgroundColor')

AutoLoadCorner.CornerRadius = UDim.new(0, 5)
AutoLoadCorner.Parent = AutoLoadRow

AutoLoadStroke.Transparency = 0.7
AutoLoadStroke.Parent = AutoLoadRow
NeverZen:Track(AutoLoadStroke, 'Color', 'StrokeColor2')

AutoLoadIcon.Name = NeverZen:RandomString()
AutoLoadIcon.Parent = AutoLoadRow
AutoLoadIcon.AnchorPoint = Vector2.new(0, 0.5)
AutoLoadIcon.BackgroundTransparency = 1
AutoLoadIcon.Position = UDim2.new(0, 8, 0.5, 0)
AutoLoadIcon.Size = UDim2.new(0, 14, 0, 14)
AutoLoadIcon.Image = NeverZen:GetIcon("save")
AutoLoadIcon.ImageColor3 = NeverZen.Theme.IconColor
AutoLoadIcon.ImageTransparency = 0.2
AutoLoadIcon.ZIndex = 152

AutoLoadLabel.Name = NeverZen:RandomString()
AutoLoadLabel.Parent = AutoLoadRow
AutoLoadLabel.AnchorPoint = Vector2.new(0, 0.5)
AutoLoadLabel.BackgroundTransparency = 1
AutoLoadLabel.Position = UDim2.new(0, 28, 0.5, 0)
AutoLoadLabel.Size = UDim2.new(0.22, 0, 1, 0)
AutoLoadLabel.Font = Enum.Font.GothamMedium
AutoLoadLabel.Text = "Auto Load"
AutoLoadLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoLoadLabel.TextSize = 13
AutoLoadLabel.TextTransparency = 0.15
AutoLoadLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoLoadLabel.ZIndex = 152

AutoLoadDropdown.Name = NeverZen:RandomString()
AutoLoadDropdown.Parent = AutoLoadRow
AutoLoadDropdown.AnchorPoint = Vector2.new(1, 0.5)
AutoLoadDropdown.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
AutoLoadDropdown.BorderSizePixel = 0
AutoLoadDropdown.Position = UDim2.new(1, -8, 0.5, 0)
AutoLoadDropdown.Size = UDim2.new(0, 90, 0, 22)
AutoLoadDropdown.ZIndex = 170
AutoLoadDropdown.Active = true

AutoLoadDropdownCorner.CornerRadius = UDim.new(0, 4)
AutoLoadDropdownCorner.Parent = AutoLoadDropdown

AutoLoadDropdownStroke.Color = NeverZen.Theme.StrokeColor
AutoLoadDropdownStroke.Parent = AutoLoadDropdown

AutoLoadValue.Name = NeverZen:RandomString()
AutoLoadValue.Parent = AutoLoadDropdown
AutoLoadValue.BackgroundTransparency = 1
AutoLoadValue.Size = UDim2.new(1, -20, 1, 0)
AutoLoadValue.Position = UDim2.new(0, 6, 0, 0)
AutoLoadValue.Font = Enum.Font.GothamBold
AutoLoadValue.Text = "None"
AutoLoadValue.TextColor3 = NeverZen.Theme.Hightlight
AutoLoadValue.TextSize = 11
AutoLoadValue.TextXAlignment = Enum.TextXAlignment.Left
AutoLoadValue.ZIndex = 171

AutoLoadArrow.Name = NeverZen:RandomString()
AutoLoadArrow.Parent = AutoLoadDropdown
AutoLoadArrow.AnchorPoint = Vector2.new(1, 0.5)
AutoLoadArrow.BackgroundTransparency = 1
AutoLoadArrow.Position = UDim2.new(1, -4, 0.5, 0)
AutoLoadArrow.Size = UDim2.new(0, 10, 0, 10)
AutoLoadArrow.Image = NeverZen:GetIcon("chevron-down")
AutoLoadArrow.ImageColor3 = Color3.fromRGB(200, 200, 200)
AutoLoadArrow.ZIndex = 171

AutoLoadDropdown.MouseEnter:Connect(function()
    TweenService:Create(AutoLoadRow, TweenInfo.new(0.12), {
        BackgroundColor3 = NeverZen.Theme.SectionColor
    }):Play()
end)
AutoLoadDropdown.MouseLeave:Connect(function()
    TweenService:Create(AutoLoadRow, TweenInfo.new(0.12), {
        BackgroundColor3 = NeverZen.Theme.BackgroundColor
    }):Play()
end)


local AutoLoadPanel = Instance.new("Frame")
local AutoLoadPanelCorner = Instance.new("UICorner")
local AutoLoadPanelStroke = Instance.new("UIStroke")
local AutoLoadPanelScroll = Instance.new("ScrollingFrame")
local AutoLoadPanelList = Instance.new("UIListLayout")

AutoLoadPanel.Name = NeverZen:RandomString()
AutoLoadPanel.Parent = Content
AutoLoadPanel.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
AutoLoadPanel.BackgroundTransparency = 0.05
AutoLoadPanel.BorderSizePixel = 0
AutoLoadPanel.Size = UDim2.new(0, 120, 0, 0)
AutoLoadPanel.ZIndex = 210
AutoLoadPanel.Visible = false
AutoLoadPanel.ClipsDescendants = true

AutoLoadPanelCorner.CornerRadius = UDim.new(0, 4)
AutoLoadPanelCorner.Parent = AutoLoadPanel

AutoLoadPanelStroke.Color = NeverZen.Theme.StrokeColor
AutoLoadPanelStroke.Parent = AutoLoadPanel

AutoLoadPanelScroll.Name = NeverZen:RandomString()
AutoLoadPanelScroll.Parent = AutoLoadPanel
AutoLoadPanelScroll.BackgroundTransparency = 1
AutoLoadPanelScroll.Size = UDim2.new(1, -8, 1, -8)
AutoLoadPanelScroll.Position = UDim2.new(0, 4, 0, 4)
AutoLoadPanelScroll.ScrollBarThickness = 0
AutoLoadPanelScroll.ZIndex = 211

AutoLoadPanelList.Parent = AutoLoadPanelScroll
AutoLoadPanelList.SortOrder = Enum.SortOrder.LayoutOrder
AutoLoadPanelList.Padding = UDim.new(0, 2)

AutoLoadPanelList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
    AutoLoadPanelScroll.CanvasSize = UDim2.fromOffset(0, AutoLoadPanelList.AbsoluteContentSize.Y + 4)
end)

function WindowSignal:RefreshAutoLoadDropdown()
    for _, child in ipairs(AutoLoadPanelScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local configs = GetConfigList()
    for _, cfgName in ipairs(configs) do
        local Item = Instance.new("Frame")
        local ItemCorner = Instance.new("UICorner")
        local ItemLabel = Instance.new("TextLabel")
        local ItemInput = NeverZen:NewInput(Item)

        Item.Name = NeverZen:RandomString()
        Item.Parent = AutoLoadPanelScroll
        Item.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
        Item.BorderSizePixel = 0
        Item.Size = UDim2.new(1, 0, 0, 22)
        Item.ZIndex = 212

        ItemCorner.CornerRadius = UDim.new(0, 3)
        ItemCorner.Parent = Item

        ItemLabel.Parent = Item
        ItemLabel.BackgroundTransparency = 1
        ItemLabel.Size = UDim2.new(1, -8, 1, 0)
        ItemLabel.Position = UDim2.new(0, 4, 0, 0)
        ItemLabel.Font = Enum.Font.GothamMedium
        ItemLabel.Text = cfgName
        ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ItemLabel.TextSize = 11
        ItemLabel.ZIndex = 213

        ItemInput.MouseButton1Click:Connect(function()
            AutoLoadValue.Text = cfgName
            WindowSignal:SetAutoLoad(cfgName)
            TweenService:Create(AutoLoadPanel, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 120, 0, 0)
            }):Play()
            AutoLoadPanel.Visible = false
        end)

        ItemInput.MouseEnter:Connect(function()
            TweenService:Create(Item, TweenInfo.new(0.1), {
                BackgroundColor3 = NeverZen.Theme.SectionColor
            }):Play()
        end)
        ItemInput.MouseLeave:Connect(function()
            TweenService:Create(Item, TweenInfo.new(0.1), {
                BackgroundColor3 = NeverZen.Theme.BackgroundColor2
            }):Play()
        end)
    end
end

local AutoLoadOpen = false
NeverZen:NewInput(AutoLoadDropdown).MouseButton1Click:Connect(function()
    AutoLoadOpen = not AutoLoadOpen
    if AutoLoadOpen then
        WindowSignal:RefreshAutoLoadDropdown()
        AutoLoadPanel.Visible = true
        AutoLoadPanel.Position = UDim2.fromOffset(
            AutoLoadDropdown.AbsolutePosition.X,
            AutoLoadDropdown.AbsolutePosition.Y + AutoLoadDropdown.AbsoluteSize.Y + 4
        )
        local height = math.min(AutoLoadPanelList.AbsoluteContentSize.Y + 12, 150)
        AutoLoadPanel.Size = UDim2.new(0, 120, 0, height)
        TweenService:Create(AutoLoadArrow, TweenInfo.new(0.15), {Rotation = 180}):Play()
    else
        TweenService:Create(AutoLoadPanel, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 120, 0, 0)
        }):Play()
        TweenService:Create(AutoLoadArrow, TweenInfo.new(0.1), {Rotation = 0}):Play()
        task.delay(0.1, function() AutoLoadPanel.Visible = false end)
    end
end)


local SaveRow = Instance.new("Frame")
local SaveCorner = Instance.new("UICorner")
local SaveStroke = Instance.new("UIStroke")
local SaveIcon = Instance.new("ImageLabel")
local SaveLabel = Instance.new("TextLabel")
local SaveInput = Instance.new("TextBox")
local SaveInputBg = Instance.new("Frame")
local SaveInputCorner = Instance.new("UICorner")
local SaveInputStroke = Instance.new("UIStroke")
local SaveBtn = Instance.new("TextButton")
local SaveBtnCorner = Instance.new("UICorner")

SaveRow.Name = NeverZen:RandomString()
SaveRow.Parent = SettingsInner
SaveRow.BackgroundColor3 = NeverZen.Theme.BackgroundColor
SaveRow.BorderSizePixel = 0
SaveRow.Size = UDim2.new(1, 0, 0, 38)
SaveRow.ZIndex = 151
SaveRow.Active = true

NeverZen:Track(SaveRow, 'BackgroundColor3', 'BackgroundColor')

SaveCorner.CornerRadius = UDim.new(0, 5)
SaveCorner.Parent = SaveRow

SaveStroke.Transparency = 0.7
SaveStroke.Parent = SaveRow
NeverZen:Track(SaveStroke, 'Color', 'StrokeColor2')

SaveIcon.Name = NeverZen:RandomString()
SaveIcon.Parent = SaveRow
SaveIcon.AnchorPoint = Vector2.new(0, 0.5)
SaveIcon.BackgroundTransparency = 1
SaveIcon.Position = UDim2.new(0, 8, 0.5, 0)
SaveIcon.Size = UDim2.new(0, 14, 0, 14)
SaveIcon.Image = NeverZen:GetIcon("download")
SaveIcon.ImageColor3 = NeverZen.Theme.IconColor
SaveIcon.ImageTransparency = 0.2
SaveIcon.ZIndex = 152

SaveLabel.Name = NeverZen:RandomString()
SaveLabel.Parent = SaveRow
SaveLabel.AnchorPoint = Vector2.new(0, 0.5)
SaveLabel.BackgroundTransparency = 1
SaveLabel.Position = UDim2.new(0, 28, 0.5, 0)
SaveLabel.Size = UDim2.new(0.22, 0, 1, 0)
SaveLabel.Font = Enum.Font.GothamMedium
SaveLabel.Text = "Save Config"
SaveLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveLabel.TextSize = 13
SaveLabel.TextTransparency = 0.15
SaveLabel.TextXAlignment = Enum.TextXAlignment.Left
SaveLabel.ZIndex = 152


SaveInputBg.Name = NeverZen:RandomString()
SaveInputBg.Parent = SaveRow
SaveInputBg.AnchorPoint = Vector2.new(1, 0.5)
SaveInputBg.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
SaveInputBg.BorderSizePixel = 0
SaveInputBg.Position = UDim2.new(1, -50, 0.5, 0)
SaveInputBg.Size = UDim2.new(0, 75, 0, 22)
SaveInputBg.ZIndex = 170

SaveInputCorner.CornerRadius = UDim.new(0, 4)
SaveInputCorner.Parent = SaveInputBg

SaveInputStroke.Color = NeverZen.Theme.StrokeColor
SaveInputStroke.Parent = SaveInputBg

SaveInput.Name = NeverZen:RandomString()
SaveInput.Parent = SaveInputBg
SaveInput.BackgroundTransparency = 1
SaveInput.Position = UDim2.new(0, 6, 0, 0)
SaveInput.Size = UDim2.new(1, -12, 1, 0)
SaveInput.Font = Enum.Font.GothamMedium
SaveInput.PlaceholderText = "Name..."
SaveInput.Text = ""
SaveInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveInput.TextSize = 11
SaveInput.ClearTextOnFocus = false
SaveInput.ZIndex = 171

SaveBtn.Name = NeverZen:RandomString()
SaveBtn.Parent = SaveRow
SaveBtn.AnchorPoint = Vector2.new(1, 0.5)
SaveBtn.BackgroundColor3 = NeverZen.Theme.Hightlight
SaveBtn.BorderSizePixel = 0
SaveBtn.Position = UDim2.new(1, -8, 0.5, 0)
SaveBtn.Size = UDim2.new(0, 36, 0, 22)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.Text = "Save"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.TextSize = 10
SaveBtn.ZIndex = 170

SaveBtnCorner.CornerRadius = UDim.new(0, 4)
SaveBtnCorner.Parent = SaveBtn

SaveBtn.MouseButton1Click:Connect(function()
    local name = SaveInput.Text:gsub("%s+", "")
    if #name > 0 then
        local success = WindowSignal:SaveConfig(name)
        if success then
            SaveInput.Text = ""
            WindowSignal:RefreshAutoLoadDropdown()
            WindowSignal:RefreshLoadDropdown()
            local Notif = NeverZen:CreateNotifier()
            Notif:new("Config Saved", "Config '" .. name .. "' saved successfully!", 3)
        end
    else
        SaveInput.PlaceholderText = "Enter name!"
        task.delay(1, function()
            SaveInput.PlaceholderText = "Name..."
        end)
    end
end)

SaveBtn.MouseEnter:Connect(function()
    TweenService:Create(SaveBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(
            math.min(NeverZen.Theme.Hightlight.R * 255 + 30, 255),
            math.min(NeverZen.Theme.Hightlight.G * 255 + 30, 255),
            math.min(NeverZen.Theme.Hightlight.B * 255 + 30, 255)
        )
    }):Play()
end)
SaveBtn.MouseLeave:Connect(function()
    TweenService:Create(SaveBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = NeverZen.Theme.Hightlight
    }):Play()
end)


local LoadRow = Instance.new("Frame")
local LoadCorner = Instance.new("UICorner")
local LoadStroke = Instance.new("UIStroke")
local LoadIcon = Instance.new("ImageLabel")
local LoadLabel = Instance.new("TextLabel")
local LoadDropdown = Instance.new("Frame")
local LoadDropdownCorner = Instance.new("UICorner")
local LoadDropdownStroke = Instance.new("UIStroke")
local LoadValue = Instance.new("TextLabel")
local LoadArrow = Instance.new("ImageLabel")
local LoadBtn = Instance.new("TextButton")
local LoadBtnCorner = Instance.new("UICorner")

LoadRow.Name = NeverZen:RandomString()
LoadRow.Parent = SettingsInner
LoadRow.BackgroundColor3 = NeverZen.Theme.BackgroundColor
LoadRow.BorderSizePixel = 0
LoadRow.Size = UDim2.new(1, 0, 0, 38)
LoadRow.ZIndex = 151
LoadRow.Active = true

NeverZen:Track(LoadRow, 'BackgroundColor3', 'BackgroundColor')

LoadCorner.CornerRadius = UDim.new(0, 5)
LoadCorner.Parent = LoadRow

LoadStroke.Transparency = 0.7
LoadStroke.Parent = LoadRow
NeverZen:Track(LoadStroke, 'Color', 'StrokeColor2')

LoadIcon.Name = NeverZen:RandomString()
LoadIcon.Parent = LoadRow
LoadIcon.AnchorPoint = Vector2.new(0, 0.5)
LoadIcon.BackgroundTransparency = 1
LoadIcon.Position = UDim2.new(0, 8, 0.5, 0)
LoadIcon.Size = UDim2.new(0, 14, 0, 14)
LoadIcon.Image = NeverZen:GetIcon("upload")
LoadIcon.ImageColor3 = NeverZen.Theme.IconColor
LoadIcon.ImageTransparency = 0.2
LoadIcon.ZIndex = 152

LoadLabel.Name = NeverZen:RandomString()
LoadLabel.Parent = LoadRow
LoadLabel.AnchorPoint = Vector2.new(0, 0.5)
LoadLabel.BackgroundTransparency = 1
LoadLabel.Position = UDim2.new(0, 28, 0.5, 0)
LoadLabel.Size = UDim2.new(0.22, 0, 1, 0)
LoadLabel.Font = Enum.Font.GothamMedium
LoadLabel.Text = "Load Config"
LoadLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadLabel.TextSize = 13
LoadLabel.TextTransparency = 0.15
LoadLabel.TextXAlignment = Enum.TextXAlignment.Left
LoadLabel.ZIndex = 152

LoadDropdown.Name = NeverZen:RandomString()
LoadDropdown.Parent = LoadRow
LoadDropdown.AnchorPoint = Vector2.new(1, 0.5)
LoadDropdown.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
LoadDropdown.BorderSizePixel = 0
LoadDropdown.Position = UDim2.new(1, -50, 0.5, 0)
LoadDropdown.Size = UDim2.new(0, 75, 0, 22)
LoadDropdown.ZIndex = 170
LoadDropdown.Active = true

LoadDropdownCorner.CornerRadius = UDim.new(0, 4)
LoadDropdownCorner.Parent = LoadDropdown

LoadDropdownStroke.Color = NeverZen.Theme.StrokeColor
LoadDropdownStroke.Parent = LoadDropdown

LoadValue.Name = NeverZen:RandomString()
LoadValue.Parent = LoadDropdown
LoadValue.BackgroundTransparency = 1
LoadValue.Size = UDim2.new(1, -20, 1, 0)
LoadValue.Position = UDim2.new(0, 6, 0, 0)
LoadValue.Font = Enum.Font.GothamBold
LoadValue.Text = "Select..."
LoadValue.TextColor3 = NeverZen.Theme.Hightlight
LoadValue.TextSize = 11
LoadValue.TextXAlignment = Enum.TextXAlignment.Left
LoadValue.ZIndex = 171

LoadArrow.Name = NeverZen:RandomString()
LoadArrow.Parent = LoadDropdown
LoadArrow.AnchorPoint = Vector2.new(1, 0.5)
LoadArrow.BackgroundTransparency = 1
LoadArrow.Position = UDim2.new(1, -4, 0.5, 0)
LoadArrow.Size = UDim2.new(0, 10, 0, 10)
LoadArrow.Image = NeverZen:GetIcon("chevron-down")
LoadArrow.ImageColor3 = Color3.fromRGB(200, 200, 200)
LoadArrow.ZIndex = 171
LoadBtn.Name = NeverZen:RandomString()
LoadBtn.Parent = LoadRow
LoadBtn.AnchorPoint = Vector2.new(1, 0.5)
LoadBtn.BackgroundColor3 = NeverZen.Theme.Hightlight
LoadBtn.BorderSizePixel = 0
LoadBtn.Position = UDim2.new(1, -8, 0.5, 0)
LoadBtn.Size = UDim2.new(0, 36, 0, 22)
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.Text = "Load"
LoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadBtn.TextSize = 10
LoadBtn.ZIndex = 170

LoadBtnCorner.CornerRadius = UDim.new(0, 4)
LoadBtnCorner.Parent = LoadBtn
LoadBtn.MouseEnter:Connect(function()
    TweenService:Create(LoadBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(
            math.min(NeverZen.Theme.Hightlight.R * 255 + 30, 255),
            math.min(NeverZen.Theme.Hightlight.G * 255 + 30, 255),
            math.min(NeverZen.Theme.Hightlight.B * 255 + 30, 255)
        )
    }):Play()
end)
LoadBtn.MouseLeave:Connect(function()
    TweenService:Create(LoadBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = NeverZen.Theme.Hightlight
    }):Play()
end)
local LoadPanel = Instance.new("Frame")
local LoadPanelCorner = Instance.new("UICorner")
local LoadPanelStroke = Instance.new("UIStroke")
local LoadPanelScroll = Instance.new("ScrollingFrame")
local LoadPanelList = Instance.new("UIListLayout")

LoadPanel.Name = NeverZen:RandomString()
LoadPanel.Parent = Content
LoadPanel.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
LoadPanel.BackgroundTransparency = 0.05
LoadPanel.BorderSizePixel = 0
LoadPanel.Size = UDim2.new(0, 120, 0, 0)
LoadPanel.ZIndex = 210
LoadPanel.Visible = false
LoadPanel.ClipsDescendants = true

LoadPanelCorner.CornerRadius = UDim.new(0, 4)
LoadPanelCorner.Parent = LoadPanel

LoadPanelStroke.Color = NeverZen.Theme.StrokeColor
LoadPanelStroke.Parent = LoadPanel

LoadPanelScroll.Name = NeverZen:RandomString()
LoadPanelScroll.Parent = LoadPanel
LoadPanelScroll.BackgroundTransparency = 1
LoadPanelScroll.Size = UDim2.new(1, -8, 1, -8)
LoadPanelScroll.Position = UDim2.new(0, 4, 0, 4)
LoadPanelScroll.ScrollBarThickness = 0
LoadPanelScroll.ZIndex = 211

LoadPanelList.Parent = LoadPanelScroll
LoadPanelList.SortOrder = Enum.SortOrder.LayoutOrder
LoadPanelList.Padding = UDim.new(0, 2)

LoadPanelList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
    LoadPanelScroll.CanvasSize = UDim2.fromOffset(0, LoadPanelList.AbsoluteContentSize.Y + 4)
end)

local SelectedLoadConfig = nil

function WindowSignal:RefreshLoadDropdown()
    for _, child in ipairs(LoadPanelScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local configs = GetConfigList()
    for _, cfgName in ipairs(configs) do
        local Item = Instance.new("Frame")
        local ItemCorner = Instance.new("UICorner")
        local ItemLabel = Instance.new("TextLabel")
        local ItemInput = NeverZen:NewInput(Item)

        Item.Name = NeverZen:RandomString()
        Item.Parent = LoadPanelScroll
        Item.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
        Item.BorderSizePixel = 0
        Item.Size = UDim2.new(1, 0, 0, 22)
        Item.ZIndex = 212

        ItemCorner.CornerRadius = UDim.new(0, 3)
        ItemCorner.Parent = Item

        ItemLabel.Parent = Item
        ItemLabel.BackgroundTransparency = 1
        ItemLabel.Size = UDim2.new(1, -8, 1, 0)
        ItemLabel.Position = UDim2.new(0, 4, 0, 0)
        ItemLabel.Font = Enum.Font.GothamMedium
        ItemLabel.Text = cfgName
        ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ItemLabel.TextSize = 11
        ItemLabel.ZIndex = 213

        ItemInput.MouseButton1Click:Connect(function()
            LoadValue.Text = cfgName
            SelectedLoadConfig = cfgName
            TweenService:Create(LoadPanel, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 120, 0, 0)
            }):Play()
            LoadPanel.Visible = false
        end)

        ItemInput.MouseEnter:Connect(function()
            TweenService:Create(Item, TweenInfo.new(0.1), {
                BackgroundColor3 = NeverZen.Theme.SectionColor
            }):Play()
        end)
        ItemInput.MouseLeave:Connect(function()
            TweenService:Create(Item, TweenInfo.new(0.1), {
                BackgroundColor3 = NeverZen.Theme.BackgroundColor2
            }):Play()
        end)
    end
end

local LoadOpen = false
NeverZen:NewInput(LoadDropdown).MouseButton1Click:Connect(function()
    LoadOpen = not LoadOpen
    if LoadOpen then
        WindowSignal:RefreshLoadDropdown()
        LoadPanel.Visible = true
        LoadPanel.Position = UDim2.fromOffset(
            LoadDropdown.AbsolutePosition.X,
            LoadDropdown.AbsolutePosition.Y + LoadDropdown.AbsoluteSize.Y + 4
        )
        local height = math.min(LoadPanelList.AbsoluteContentSize.Y + 12, 150)
        LoadPanel.Size = UDim2.new(0, 120, 0, height)
        TweenService:Create(LoadArrow, TweenInfo.new(0.15), {Rotation = 180}):Play()
    else
        TweenService:Create(LoadPanel, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 120, 0, 0)
        }):Play()
        TweenService:Create(LoadArrow, TweenInfo.new(0.1), {Rotation = 0}):Play()
        task.delay(0.1, function() LoadPanel.Visible = false end)
    end
end)

LoadBtn.MouseButton1Click:Connect(function()
    if SelectedLoadConfig and SelectedLoadConfig ~= "No configs" then
        local success = WindowSignal:LoadConfig(SelectedLoadConfig)
        if success then
            local Notif = NeverZen:CreateNotifier()
            Notif:new("Config Loaded", "Config '" .. SelectedLoadConfig .. "' loaded!", 3)
        else
            local Notif = NeverZen:CreateNotifier()
            Notif:new("Error", "Failed to load config!", 3)
        end
    else
        LoadValue.Text = "Select first!"
        task.delay(1, function()
            LoadValue.Text = "Select..."
        end)
    end
end)
Services.UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if AutoLoadOpen and not NeverZen:IsMouseOverFrame(AutoLoadPanel) and not NeverZen:IsMouseOverFrame(AutoLoadDropdown) then
            AutoLoadOpen = false
            TweenService:Create(AutoLoadPanel, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 120, 0, 0)
            }):Play()
            TweenService:Create(AutoLoadArrow, TweenInfo.new(0.1), {Rotation = 0}):Play()
            task.delay(0.1, function() AutoLoadPanel.Visible = false end)
        end
        if LoadOpen and not NeverZen:IsMouseOverFrame(LoadPanel) and not NeverZen:IsMouseOverFrame(LoadDropdown) then
            LoadOpen = false
            TweenService:Create(LoadPanel, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 120, 0, 0)
            }):Play()
            TweenService:Create(LoadArrow, TweenInfo.new(0.1), {Rotation = 0}):Play()
            task.delay(0.1, function() LoadPanel.Visible = false end)
        end
    end
end)

local function applyThemeLive()
	for _, inst in ipairs(WindowSignal.FrameMemory.WindowBackgroundColor) do
		if inst and inst.Parent then
			TweenService:Create(inst, TweenInfo.new(0.25), {
				BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
			}):Play()
		end
	end

	for _, inst in ipairs(WindowSignal.FrameMemory.HeadText) do
		if inst and inst.Parent then
			TweenService:Create(inst, TweenInfo.new(0.25), {
				TextColor3 = NeverZen.Theme.HeadText
			}):Play()
		end
	end

	for _, inst in ipairs(WindowSignal.FrameMemory.LineColor) do
		if inst and inst.Parent then
			TweenService:Create(inst, TweenInfo.new(0.25), {
				BackgroundColor3 = NeverZen.Theme.LineColor
			}):Play()
		end
	end

	SettingsStroke.Color = NeverZen.Theme.BackgroundColor
	TitleIcon.ImageColor3 = NeverZen.Theme.Hightlight
end

settingsHeader("Toggle Keybind")

local KeyRow, KeyValue = settingsRow("keyboard", "Toggle Menu")

local Keys = {
	One = '1', Two = '2', Three = '3', Four = '4', Five = '5',
	Six = '6', Seven = '7', Eight = '8', Nine = '9', Zero = '0',
	LeftControl = "LCtrl", RightControl = "RCtrl",
	LeftShift = "LShift", RightShift = "RShift",
}

local function keyDisplay(item)
	if not item then return "NONE" end
	if typeof(item) == 'EnumItem' then
		return Keys[item.Name] or item.Name
	end
	return Keys[tostring(item)] or string.upper(tostring(item))
end

KeyValue.Text = keyDisplay(WindowSignal.Config.Keybind)

local isBindingKey = false

NeverZen:NewInput(KeyRow, function()
	if isBindingKey then return end
	isBindingKey = true

	KeyValue.Text = "..."

	local Selected = nil
	while not Selected do
		local Key = Services.UserInputService.InputBegan:Wait()
		if Key.KeyCode ~= Enum.KeyCode.Unknown then
			Selected = Key.KeyCode
		end
	end

	WindowSignal.Config.Keybind = Selected
	KeyValue.Text = keyDisplay(Selected)

	isBindingKey = false
end)

local FooterDivider = Instance.new("Frame")
FooterDivider.Name = NeverZen:RandomString()
FooterDivider.Parent = SettingsInner
FooterDivider.BackgroundColor3 = NeverZen.Theme.LineColor
FooterDivider.BorderSizePixel = 0
FooterDivider.Size = UDim2.new(1, 0, 0, 1)
FooterDivider.ZIndex = 151

table.insert(WindowSignal.FrameMemory.LineColor, FooterDivider)

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Name = NeverZen:RandomString()
FooterLabel.Parent = SettingsInner
FooterLabel.BackgroundTransparency = 1
FooterLabel.Size = UDim2.new(1, 0, 0, 14)
FooterLabel.Font = Enum.Font.GothamMedium
FooterLabel.Text = "NeverZen v" .. tostring(NeverZen.Version)
FooterLabel.TextColor3 = NeverZen.Theme.HeadText
FooterLabel.TextSize = 10.5
FooterLabel.TextTransparency = 0.5
FooterLabel.TextXAlignment = Enum.TextXAlignment.Center
FooterLabel.ZIndex = 151

local function FixZIndex(parent, zindex)
    for _, child in ipairs(parent:GetDescendants()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child.ZIndex = zindex
        end
    end
end

task.delay(0.1, function()
    FixZIndex(SettingsInner, 201)
end)


SettingsPanel:SetAttribute('OPENED', false)

SettingsButton.MouseButton1Click:Connect(function()
	if not Content.Enabled or not Content.Parent then
		return;
	end;

	if SettingsPanel:GetAttribute('OPENED') then
		local closeTween = TweenService:Create(SettingsPanel, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 280, 0, 0)
		})
		closeTween:Play()
		closeTween.Completed:Connect(function()
			SettingsPanel.Visible = false
		end)

		SettingsPanel:SetAttribute('OPENED', false)
		return
	end

	SettingsPanel.Visible = true
	SettingsPanel:SetAttribute('OPENED', true)

	TweenService:Create(SettingsPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
		Size = UDim2.new(0, 280, 0, math.min(SettingsList.AbsoluteContentSize.Y + 20, 300))
	}):Play()
end)

local function IsOverSettingsOrChildren()
    if NeverZen:IsMouseOverFrame(SettingsPanel) then return true end
    if NeverZen:IsMouseOverFrame(SettingsButton) then return true end
    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("Frame") and child:GetAttribute("OPENED") then
            if NeverZen:IsMouseOverFrame(child) then return true end
        end
    end
    return false
end

Services.UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if SettingsPanel:GetAttribute('OPENED') and not IsOverSettingsOrChildren() then
            local closeTween = TweenService:Create(SettingsPanel, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {
                Size = UDim2.new(0, 280, 0, 0)
            })
            closeTween:Play()
            closeTween.Completed:Connect(function()
                SettingsPanel.Visible = false
            end)
            SettingsPanel:SetAttribute('OPENED', false)
        end
    end
end)

	_G.NZ_RESET = function(msg)
		TweenService:Create(WindowFrame,TweenInfo.new(0.7,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
			Position = UDim2.fromOffset(115,155)
		}):Play()
	end;

	Services.UserInputService.InputBegan:Connect(function(input , ty)
		if not ty then
			if input.KeyCode == WindowSignal.Config.Keybind then
				WindowSignal.Toggle = not WindowSignal.Toggle;

				ToggleWin(WindowSignal.Toggle)
			end;
		end
	end)

	if config.Resizable then
		local Resize = Instance.new("TextButton")
		local IsHold = false;

		Resize.Name = NeverZen:RandomString();
		Resize.Parent = WindowFrame
		Resize.AnchorPoint = Vector2.new(0.5, 0.5)
		Resize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Resize.BackgroundTransparency = 1.000
		Resize.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Resize.BorderSizePixel = 0
		Resize.Position = UDim2.new(1, 0, 1, 0)
		Resize.Rotation = 0.010
		Resize.Size = UDim2.new(0.075000003, 0, 0.075000003, 0)
		Resize.SizeConstraint = Enum.SizeConstraint.RelativeYY
		Resize.ZIndex = 100
		Resize.Font = Enum.Font.SourceSans
		Resize.Text = ""
		Resize.TextColor3 = Color3.fromRGB(0, 0, 0)
		Resize.TextSize = 14.000
		Resize.Active = true
		llk = Resize;

		local label = Instance.new('ImageLabel',Resize)

		label.BackgroundTransparency = 1
		label.Size = UDim2.fromOffset(10,10)
		label.ZIndex = Resize.ZIndex + 1
		label.Image = NeverZen:GetIcon('minimize-2')
		label.Position = UDim2.fromScale(0.5,0.5)
		label.AnchorPoint = Vector2.new(0.5,0.5)

		Resize.InputBegan:Connect(function(std)
			if std.UserInputType == Enum.UserInputType.MouseButton1 or std.UserInputType == Enum.UserInputType.Touch then
				IsHold = true
				if Services.UserInputService.TouchEnabled then
					Resize.Size = UDim2.new(0.15000003, 85, 0.15000003, 85)
				end
			end
		end)

		Resize.InputEnded:Connect(function(std)
			if std.UserInputType == Enum.UserInputType.MouseButton1 or std.UserInputType == Enum.UserInputType.Touch then
				IsHold = false
				Resize.Size = UDim2.new(0.075000003, 0, 0.075000003, 0)
			end
		end)

		Services.UserInputService.InputChanged:Connect(function(input)
			if IsHold and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and WindowSignal.Toggle then
				local pios = input.Position;
				local x = (pios.X - WindowFrame.AbsolutePosition.X) 

				local y = (pios.Y - WindowFrame.AbsolutePosition.Y) 

				if x < 390 then x = 390 end
				if y < 240 then y = 240 end

				local Offset = UDim2.new(0,x,0,y)
				local plus = UDim2.fromOffset(-(WindowFrame.AbsoluteSize.X - x) / 2, -(WindowFrame.AbsoluteSize.Y - y) / 2);

				TweenService:Create(WindowFrame , TweenInfo.new(0.05),{
					Size = Offset,
				}):Play();

				WindowSignal.Config.Scale = Offset
			end;
		end);
	end;

	local dragToggle = nil
	local dragSpeed = 0.2
	local dragStart = nil
	local startPos = nil

	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, math.max(startPos.X.Offset + delta.X , -10),
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)

		game:GetService('TweenService'):Create(WindowFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
	end

	Header.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = WindowFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	Services.UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)
  if NeverZen.ConfigAutoLoad then
      task.delay(1.5, function()
          WindowSignal:AutoLoadConfig();
      end);
  end;
	return WindowSignal;
end;

function NeverZen:CreateNotifier()
	local Content = Instance.new("ScreenGui")
	local Notification = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Content.Name = NeverZen:RandomString()
	NeverZen:SafeParent(Content);
	Content.ResetOnSpawn = false
	Content.IgnoreGuiInset = true
	Content.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	NeverZen.ProtectGui(Content)

	Notification.Name = NeverZen:RandomString()
	Notification.Parent = Content
	Notification.AnchorPoint = Vector2.new(1, 1)
	Notification.BackgroundTransparency = 1.000
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(1, -14, 1, -14)
	Notification.Size = UDim2.new(0, 260, 0, 65)
	Notification.ZIndex = 250

	UIListLayout.Parent = Notification
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.Padding = UDim.new(0,8)

	return {
		new = function(self, head , body , duration)
			duration = duration or 4;

			local isError = tostring(head):lower():find("error") or tostring(head):lower():find("fail");
			local accentColor = isError and Color3.fromRGB(235, 90, 90) or NeverZen.Theme.Hightlight;

			local Notify = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local Shadow = Instance.new("ImageLabel")
			local Accent = Instance.new("Frame")
			local AccentCorner = Instance.new("UICorner")
			local IconHolder = Instance.new("Frame")
			local IconHolderCorner = Instance.new("UICorner")
			local Icon = Instance.new("ImageLabel")
			local TextHolder = Instance.new("Frame")
			local Header = Instance.new("TextLabel")
			local Body = Instance.new("TextLabel")
			local ProgressBg = Instance.new("Frame")
			local ProgressBgCorner = Instance.new("UICorner")
			local Progress = Instance.new("Frame")
			local ProgressCorner = Instance.new("UICorner")

			Notify.Name = NeverZen:RandomString()
			Notify.Parent = Notification
			Notify.AnchorPoint = Vector2.new(1, 0)
			Notify.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
			Notify.BackgroundTransparency = 0.05
			Notify.BorderSizePixel = 0
			Notify.Position = UDim2.new(1, 40, 0, 0)
			Notify.Size = UDim2.new(0, 260, 0, 0)
			Notify.ClipsDescendants = true
			Notify.ZIndex = 250

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = Notify

			UIStroke.Color = NeverZen.Theme.StrokeColor or Color3.fromRGB(255,255,255)
			UIStroke.Transparency = 0.85
			UIStroke.Parent = Notify

			Shadow.Name = "Shadow"
			Shadow.Parent = Notify
			Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
			Shadow.BackgroundTransparency = 1
			Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
			Shadow.Size = UDim2.new(1, 40, 1, 40)
			Shadow.ZIndex = 249
			Shadow.Image = "rbxassetid://6014261993"
			Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
			Shadow.ImageTransparency = 0.6
			Shadow.ScaleType = Enum.ScaleType.Slice
			Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

			Accent.Name = "Accent"
			Accent.Parent = Notify
			Accent.AnchorPoint = Vector2.new(0, 0.5)
			Accent.BackgroundColor3 = accentColor
			Accent.BorderSizePixel = 0
			Accent.Position = UDim2.new(0, 6, 0.5, 0)
			Accent.Size = UDim2.new(0, 3, 1, -14)
			Accent.ZIndex = 252

			AccentCorner.CornerRadius = UDim.new(1, 0)
			AccentCorner.Parent = Accent

			IconHolder.Name = "IconHolder"
			IconHolder.Parent = Notify
			IconHolder.AnchorPoint = Vector2.new(0, 0.5)
			IconHolder.BackgroundColor3 = accentColor
			IconHolder.BackgroundTransparency = 0.85
			IconHolder.BorderSizePixel = 0
			IconHolder.Position = UDim2.new(0, 16, 0.5, 0)
			IconHolder.Size = UDim2.new(0, 30, 0, 30)
			IconHolder.ZIndex = 252

			IconHolderCorner.CornerRadius = UDim.new(1, 0)
			IconHolderCorner.Parent = IconHolder

			Icon.Name = "Icon"
			Icon.Parent = IconHolder
			Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Icon.BackgroundTransparency = 1
			Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
			Icon.Size = UDim2.new(0, 16, 0, 16)
			Icon.ZIndex = 253
			Icon.Image = isError and "rbxassetid://10747384394" or "rbxassetid://10709790948"
			Icon.ImageColor3 = accentColor

			TextHolder.Name = "TextHolder"
			TextHolder.Parent = Notify
			TextHolder.BackgroundTransparency = 1
			TextHolder.Position = UDim2.new(0, 56, 0, 8)
			TextHolder.Size = UDim2.new(1, -70, 1, -20)
			TextHolder.ZIndex = 252

			Header.Name = "Header"
			Header.Parent = TextHolder
			Header.BackgroundTransparency = 1
			Header.Position = UDim2.new(0, 0, 0, 0)
			Header.Size = UDim2.new(1, 0, 0, 18)
			Header.Font = Enum.Font.GothamBold
			Header.Text = head
			Header.TextColor3 = Color3.fromRGB(255, 255, 255)
			Header.TextSize = 13.000
			Header.TextTransparency = 0
			Header.TextXAlignment = Enum.TextXAlignment.Left
			Header.TextYAlignment = Enum.TextYAlignment.Top
			Header.ZIndex = 253

			Body.Name = "Body"
			Body.Parent = TextHolder
			Body.BackgroundTransparency = 1
			Body.Position = UDim2.new(0, 0, 0, 19)
			Body.Size = UDim2.new(1, 0, 1, -19)
			Body.Font = Enum.Font.GothamMedium
			Body.Text = body
			Body.TextColor3 = Color3.fromRGB(220, 220, 220)
			Body.TextSize = 11.000
			Body.TextTransparency = 0.1
			Body.TextWrapped = true
			Body.TextXAlignment = Enum.TextXAlignment.Left
			Body.TextYAlignment = Enum.TextYAlignment.Top
			Body.ZIndex = 253

			ProgressBg.Name = "ProgressBg"
			ProgressBg.Parent = Notify
			ProgressBg.AnchorPoint = Vector2.new(0, 1)
			ProgressBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ProgressBg.BackgroundTransparency = 0.9
			ProgressBg.BorderSizePixel = 0
			ProgressBg.Position = UDim2.new(0, 0, 1, 0)
			ProgressBg.Size = UDim2.new(1, 0, 0, 3)
			ProgressBg.ZIndex = 252

			ProgressBgCorner.CornerRadius = UDim.new(1, 0)
			ProgressBgCorner.Parent = ProgressBg

			Progress.Name = "Progress"
			Progress.Parent = ProgressBg
			Progress.BackgroundColor3 = accentColor
			Progress.BorderSizePixel = 0
			Progress.Size = UDim2.new(1, 0, 1, 0)
			Progress.ZIndex = 253

			ProgressCorner.CornerRadius = UDim.new(1, 0)
			ProgressCorner.Parent = Progress

			local Min = TextService:GetTextSize(Header.Text,Header.TextSize,Header.Font,Vector2.new(200,math.huge));
			local scale = TextService:GetTextSize(Body.Text,Body.TextSize,Body.Font,Vector2.new(184,math.huge));

			local targetHeight = math.clamp(scale.Y + 38, 52, 120);

			TweenService:Create(Notify,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
				Size = UDim2.new(0, 260, 0, targetHeight),
				Position = UDim2.new(1, 0, 0, 0),
			}):Play()

			TweenService:Create(Progress,TweenInfo.new(duration, Enum.EasingStyle.Linear),{
				Size = UDim2.new(0, 0, 1, 0)
			}):Play()

			task.delay(duration, function()
				if not Notify or not Notify.Parent then return end;
				local closeTween = TweenService:Create(Notify,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{
					Position = UDim2.new(1, 40, 0, 0),
					Size = UDim2.new(0, 260, 0, 0),
				});
				closeTween:Play();
				closeTween.Completed:Connect(function()
					Notify:Destroy();
				end);
			end);
		end,
	}
end;


function NeverZen:CreateWatermark(config)
	config = config or {};
	config.Name = config.Name or "avernus";
	config.Server = config.Server or "local";
	config.ShowUser = (config.ShowUser == nil) and true or config.ShowUser;
	config.ShowDebug = (config.ShowDebug == nil) and true or config.ShowDebug;
	config.ShowFPS = (config.ShowFPS == nil) and true or config.ShowFPS;
	config.ShowClock = (config.ShowClock == nil) and true or config.ShowClock;
    config.ShowHealth = (config.ShowHealth == nil) and true or config.ShowHealth;
	config.Position = config.Position or UDim2.new(1, -12, 0, 12);

	local Content = Instance.new("ScreenGui")
	local Pill = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local UIListLayout = Instance.new("UIListLayout")
	local UIPadding = Instance.new("UIPadding")

	Content.Name = NeverZen:RandomString()
	NeverZen:SafeParent(Content);
	Content.ResetOnSpawn = false
	Content.IgnoreGuiInset = true
	Content.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	NeverZen.ProtectGui(Content);

	Pill.Name = NeverZen:RandomString()
	Pill.Parent = Content
	Pill.AnchorPoint = Vector2.new(1, 0)
	Pill.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
	Pill.BackgroundTransparency = 0
	Pill.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Pill.BorderSizePixel = 0
	Pill.Position = config.Position
	Pill.Size = UDim2.new(0, 0, 0, 30)
	Pill.AutomaticSize = Enum.AutomaticSize.X
	Pill.ClipsDescendants = true
	Pill.ZIndex = 50

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Pill

	UIStroke.Color = NeverZen.Theme.StrokeColor2
	UIStroke.Transparency = 0.5
	UIStroke.Parent = Pill

	UIPadding.PaddingLeft = UDim.new(0, 16)
	UIPadding.PaddingRight = UDim.new(0, 16)
	UIPadding.Parent = Pill

	UIListLayout.Parent = Pill
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 12)


	local addSeparator = function()
		local Sep = Instance.new("Frame")

		Sep.Name = NeverZen:RandomString()
		Sep.Parent = Pill
		Sep.BackgroundColor3 = NeverZen.Theme.LineColor
		Sep.BackgroundTransparency = 0
		Sep.BorderSizePixel = 0
		Sep.Size = UDim2.new(0, 1, 0, 14)
		Sep.ZIndex = 51

		return Sep;
	end;

	local addSegment = function(icon, text, bold, italic, color)
		local Holder = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")

		Holder.Name = NeverZen:RandomString()
		Holder.Parent = Pill
		Holder.BackgroundTransparency = 1
		Holder.Size = UDim2.new(0, 0, 1, 0)
		Holder.AutomaticSize = Enum.AutomaticSize.X
		Holder.ZIndex = 51

		UIListLayout.Parent = Holder
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 6)

		local Icon;
		local textColor = color or NeverZen.Theme.HeadText;

		if icon then
			Icon = Instance.new("ImageLabel")
			Icon.Name = NeverZen:RandomString()
			Icon.Parent = Holder
			Icon.BackgroundTransparency = 1
			Icon.Size = UDim2.new(0, 14, 0, 14)
			Icon.Image = NeverZen:GetIcon(icon)
			Icon.ImageColor3 = textColor
			Icon.ImageTransparency = 0
			Icon.ZIndex = 51
		end;

		local Label = Instance.new("TextLabel")

		Label.Name = NeverZen:RandomString()
		Label.Parent = Holder
		Label.BackgroundTransparency = 1
		Label.Size = UDim2.new(0, 0, 1, 0)
		Label.AutomaticSize = Enum.AutomaticSize.X
		Label.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
		Label.Text = text
		Label.TextColor3 = textColor
		Label.TextSize = 13
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.ZIndex = 51

		if italic then
			pcall(function()
				Label.FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Italic
				);
			end);
		end;

		return Holder, Label, Icon;
	end;
	local _, NameLabel = addSegment(nil, config.Name, true, true, NeverZen.Theme.Hightlight);

	if config.ShowDebug then
		addSeparator();
		addSegment("code", "Debug");
	end;

	if config.ShowUser then
		addSeparator();
		addSegment("user", LocalPlayer.Name);
	end;

	config.ShowServer = (config.ShowServer == nil) and true or config.ShowServer;

	local ServerLabel;
	if config.ShowServer then
		addSeparator();
		local _, srv = addSegment("database", config.Server);
		ServerLabel = srv;
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
	if config.ShowFPS or config.ShowClock then
		heartbeat = RunService.Heartbeat:Connect(function()
			frames += 1;

			local now = os.clock();
			if now - lastUpdate >= 1 then
				if FPSLabel then
					FPSLabel.Text = tostring(frames).."fps";
				end;

				if ClockLabel then
					ClockLabel.Text = os.date("%H:%M");
				end;

				frames = 0;
				lastUpdate = now;
			end;
		end);
	end;

	local healthConn;
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

		LocalPlayer.CharacterAdded:Connect(function(char)
			task.wait(0.2)
			bindHumanoid(char)
		end)
	end;


addSeparator();

local ArrowHolder = Instance.new("Frame")
ArrowHolder.Name = NeverZen:RandomString()
ArrowHolder.Parent = Pill
ArrowHolder.BackgroundTransparency = 1
ArrowHolder.Size = UDim2.new(0, 14, 1, 0)
ArrowHolder.ZIndex = 51

local ArrowBtn = Instance.new("ImageButton")
ArrowBtn.Name = NeverZen:RandomString()
ArrowBtn.Parent = ArrowHolder
ArrowBtn.AnchorPoint = Vector2.new(0.5, 0.5)
ArrowBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
ArrowBtn.BackgroundTransparency = 1
ArrowBtn.Size = UDim2.new(0, 14, 0, 14)
ArrowBtn.Image = NeverZen:GetIcon("chevron-down")
ArrowBtn.ImageColor3 = NeverZen.Theme.HeadText
ArrowBtn.ZIndex = 51



local DashPanel = Instance.new("Frame")
local DashCorner = Instance.new("UICorner")
local DashStroke = Instance.new("UIStroke")
local DashPadding = Instance.new("UIPadding")
local DashList = Instance.new("UIListLayout")
local DashDropShadow = Instance.new("ImageLabel")

DashPanel.Name = NeverZen:RandomString()
DashPanel.Parent = Content
DashPanel.AnchorPoint = Vector2.new(0, 0)
DashPanel.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
DashPanel.BackgroundTransparency = 0
DashPanel.BorderSizePixel = 0
DashPanel.ClipsDescendants = true
DashPanel.Size = UDim2.new(0, 170, 0, 0)
DashPanel.ZIndex = 49
DashPanel.Visible = false

DashCorner.CornerRadius = UDim.new(0, 10)
DashCorner.Parent = DashPanel

DashStroke.Color = NeverZen.Theme.StrokeColor2
DashStroke.Transparency = 0.5
DashStroke.Parent = DashPanel

DashDropShadow.Name = NeverZen:RandomString()
DashDropShadow.Parent = DashPanel
DashDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DashDropShadow.BackgroundTransparency = 1
DashDropShadow.BorderSizePixel = 0
DashDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DashDropShadow.Size = UDim2.new(1, 47, 1, 47)
DashDropShadow.ZIndex = 48
DashDropShadow.Image = "rbxassetid://6015897843"
DashDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DashDropShadow.ImageTransparency = 0.5
DashDropShadow.ScaleType = Enum.ScaleType.Slice
DashDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
DashPadding.PaddingTop = UDim.new(0, 10)
DashPadding.PaddingBottom = UDim.new(0, 10)
DashPadding.PaddingLeft = UDim.new(0, 12)
DashPadding.PaddingRight = UDim.new(0, 12)
DashPadding.Parent = DashPanel

DashList.Parent = DashPanel
DashList.SortOrder = Enum.SortOrder.LayoutOrder
DashList.Padding = UDim.new(0, 10)


RunService.Stepped:Connect(function()
	local viewportSize = workspace.CurrentCamera.ViewportSize
	local panelWidth = DashPanel.AbsoluteSize.X
	local panelHeight = DashPanel.AbsoluteSize.Y

	local targetX = Pill.AbsolutePosition.X + Pill.AbsoluteSize.X - panelWidth
	local targetY = Pill.AbsolutePosition.Y + Pill.AbsoluteSize.Y + 60


	targetY = math.clamp(targetY, 5, viewportSize.Y - panelHeight - 5)

	DashPanel.Position = UDim2.fromOffset(
		math.clamp(targetX, 5, viewportSize.X - panelWidth - 5),
		targetY
	)
end)



local DashRows = {}

local function createDashRow(name)
	local Row = Instance.new("Frame")
	local Label = Instance.new("TextLabel")
	local TimeLabel = Instance.new("TextLabel")
	local Track = Instance.new("Frame")
	local TrackCorner = Instance.new("UICorner")
	local Fill = Instance.new("Frame")
	local FillCorner = Instance.new("UICorner")

	Row.Name = NeverZen:RandomString()
	Row.Parent = DashPanel
	Row.BackgroundTransparency = 1
	Row.Size = UDim2.new(1, 0, 0, 28)
    Row.ZIndex = 50

	Label.Name = NeverZen:RandomString()
	Label.Parent = Row
	Label.BackgroundTransparency = 1
	Label.Size = UDim2.new(1, -45, 0, 14)
	Label.Font = Enum.Font.GothamMedium
	Label.Text = name
	Label.TextColor3 = NeverZen.Theme.HeadText
	Label.TextSize = 12
	Label.TextTransparency = 0.1
	Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 50

	TimeLabel.Name = NeverZen:RandomString()
	TimeLabel.Parent = Row
	TimeLabel.BackgroundTransparency = 1
	TimeLabel.AnchorPoint = Vector2.new(1, 0)
	TimeLabel.Position = UDim2.new(1, 0, 0, 0)
	TimeLabel.Size = UDim2.new(0, 45, 0, 14)
	TimeLabel.Font = Enum.Font.GothamBold
	TimeLabel.Text = "READY"
	TimeLabel.TextColor3 = NeverZen.Theme.Hightlight
	TimeLabel.TextSize = 12
	TimeLabel.TextXAlignment = Enum.TextXAlignment.Right
    TimeLabel.ZIndex = 50

	Track.Name = NeverZen:RandomString()
	Track.Parent = Row
	Track.Position = UDim2.new(0, 0, 0, 18)
	Track.Size = UDim2.new(1, 0, 0, 6)
	Track.BackgroundColor3 = NeverZen.Theme.BackgroundColor
	Track.BorderSizePixel = 0
    Track.ZIndex = 50

	TrackCorner.CornerRadius = UDim.new(1, 0)
	TrackCorner.Parent = Track

	Fill.Name = NeverZen:RandomString()
	Fill.Parent = Track
	Fill.Size = UDim2.new(1, 0, 1, 0)
	Fill.BackgroundColor3 = NeverZen.Theme.Hightlight
	Fill.BorderSizePixel = 0
    Fill.ZIndex = 50

	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = Fill

	return {
		Fill = Fill,
		TimeLabel = TimeLabel,
	}
end

DashRows.Front = createDashRow("Front Dash")
DashRows.Side = createDashRow("Side Dash")
DashRows.Back = createDashRow("Back Dash")
DashRows.Evasive = createDashRow("Evasive Dash")



local function setDash(self, name, remaining, max)
	local row = DashRows[name]
	if not row then 
		return 
	end

	max = (max and max > 0) and max or 1
	remaining = math.clamp(remaining or 0, 0, max)

	local ratio = 1 - (remaining / max)

	TweenService:Create(row.Fill, TweenInfo.new(0.15), {
		Size = UDim2.new(ratio, 0, 1, 0)
	}):Play()

	if remaining <= 0.05 then
		row.TimeLabel.Text = "READY"
		row.TimeLabel.TextColor3 = NeverZen.Theme.Hightlight
	else
		row.TimeLabel.Text = string.format("%.1fs", remaining)
		row.TimeLabel.TextColor3 = NeverZen.Theme.HeadText
	end
end


local DashOpen = false

ArrowBtn.MouseButton1Click:Connect(function()
	DashOpen = not DashOpen

	if DashOpen then
		DashPanel.Visible = true

        local targetHeight = math.min(DashList.AbsoluteContentSize.Y + 20, 200)

        TweenService:Create(DashPanel, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 170, 0, targetHeight)
        }):Play()
		TweenService:Create(ArrowBtn, TweenInfo.new(0.2), {
			Rotation = 180
		}):Play()
	else
		TweenService:Create(DashPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 170, 0, 0)
		}):Play()

		TweenService:Create(ArrowBtn, TweenInfo.new(0.2), {
			Rotation = 0
		}):Play()
	end
end)


	return {
		SetName = function(self, newname)
			NameLabel.Text = newname;
		end,

		SetServer = function(self, newserver)
			ServerLabel.Text = newserver;
		end,

        SetDash = setDash,

		Visible = function(self, value)
			Content.Enabled = value;
		end,

		Destroy = function(self)
			if heartbeat then
				heartbeat:Disconnect();
			end;
			Content:Destroy();
		end,
	};
end;



function NeverZen:CreateKeySystem(config)
    config = config or {}
    config.Service = config.Service or "NeverZen Hub"
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
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = NeverZen:RandomString()
    NeverZen:SafeParent(screenGui)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    NeverZen.ProtectGui(screenGui)
    
    local panel = Instance.new("Frame")
    panel.Name = NeverZen:RandomString()
    panel.Parent = screenGui
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = NeverZen.Theme.WindowBackgroundColor
    panel.BorderSizePixel = 0
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Size = UDim2.new(0, 360, 0, 0)
    panel.ClipsDescendants = true
    panel.ZIndex = 101
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = panel
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = NeverZen.Theme.StrokeColor
    stroke.Thickness = 1.5
    stroke.Parent = panel
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = NeverZen:RandomString()
    shadow.Parent = panel
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = 100
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    
    local title = Instance.new("TextLabel")
    title.Name = NeverZen:RandomString()
    title.Parent = panel
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 0, 0, 15)
    title.Size = UDim2.new(1, 0, 0, 28)
    title.Font = Enum.Font.GothamBold
    title.Text = "  " .. config.Service
    title.TextColor3 = NeverZen.Theme.HeadText
    title.TextSize = 18
    title.ZIndex = 102

    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Name = NeverZen:RandomString()
    titleIcon.Parent = panel
    titleIcon.BackgroundTransparency = 1
    titleIcon.Position = UDim2.new(0, 20, 0, 18)
    titleIcon.Size = UDim2.new(0, 20, 0, 20)
    titleIcon.Image = NeverZen:GetIcon("lock")
    titleIcon.ImageColor3 = NeverZen.Theme.HeadText
    titleIcon.ZIndex = 102
    
    local line = Instance.new("Frame")
    line.Name = NeverZen:RandomString()
    line.Parent = panel
    line.BackgroundColor3 = NeverZen.Theme.LineColor
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 20, 0, 50)
    line.Size = UDim2.new(1, -40, 0, 1)
    line.ZIndex = 102
    
    local desc = Instance.new("TextLabel")
    desc.Name = NeverZen:RandomString()
    desc.Parent = panel
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.new(0, 20, 0, 60)
    desc.Size = UDim2.new(1, -40, 0, 50)
    desc.Font = Enum.Font.GothamMedium
    desc.Text = "Complete the key system to access the script.\nClick 'Get Key' to start."
    desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    desc.TextSize = 13
    desc.TextWrapped = true
    desc.ZIndex = 102
    
    local inputBg = Instance.new("Frame")
    inputBg.Name = NeverZen:RandomString()
    inputBg.Parent = panel
    inputBg.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
    inputBg.BorderSizePixel = 0
    inputBg.Position = UDim2.new(0, 20, 0, 120)
    inputBg.Size = UDim2.new(1, -40, 0, 38)
    inputBg.ZIndex = 102
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputBg
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = NeverZen.Theme.StrokeColor2
    inputStroke.Transparency = 0.5
    inputStroke.Parent = inputBg
    
    local textBox = Instance.new("TextBox")
    textBox.Name = NeverZen:RandomString()
    textBox.Parent = inputBg
    textBox.BackgroundTransparency = 1
    textBox.Position = UDim2.new(0, 12, 0, 0)
    textBox.Size = UDim2.new(1, -24, 1, 0)
    textBox.Font = Enum.Font.GothamMedium
    textBox.PlaceholderText = "Enter your key here..."
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 14
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = 103
    
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Name = NeverZen:RandomString()
    getKeyBtn.Parent = panel
    getKeyBtn.BackgroundColor3 = NeverZen.Theme.BackgroundColor2
    getKeyBtn.BorderSizePixel = 0
    getKeyBtn.Position = UDim2.new(0, 20, 0, 170)
    getKeyBtn.Size = UDim2.new(0.5, -25, 0, 34)
    getKeyBtn.Font = Enum.Font.GothamMedium
    getKeyBtn.Text = "Get Key"
    getKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    getKeyBtn.TextSize = 13
    getKeyBtn.ZIndex = 102
    local getKeyIcon = Instance.new("ImageLabel")
    getKeyIcon.Parent = getKeyBtn
    getKeyIcon.BackgroundTransparency = 1
    getKeyIcon.AnchorPoint = Vector2.new(0, 0.5)
    getKeyIcon.Position = UDim2.new(0, 10, 0.5, 0)
    getKeyIcon.Size = UDim2.new(0, 14, 0, 14)
    getKeyIcon.Image = NeverZen:GetIcon("link")
    getKeyIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    getKeyIcon.ZIndex = 103
    
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 6)
    getKeyCorner.Parent = getKeyBtn
    
    local submitBtn = Instance.new("TextButton")
    submitBtn.Name = NeverZen:RandomString()
    submitBtn.Parent = panel
    submitBtn.BackgroundColor3 = NeverZen.Theme.Hightlight
    submitBtn.BorderSizePixel = 0
    submitBtn.Position = UDim2.new(0.5, 5, 0, 170)
    submitBtn.Size = UDim2.new(0.5, -25, 0, 34)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.Text = "Submit"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.TextSize = 13
    submitBtn.ZIndex = 102
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 6)
    submitCorner.Parent = submitBtn
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = NeverZen:RandomString()
    statusLabel.Parent = panel
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 20, 0, 215)
    statusLabel.Size = UDim2.new(1, -40, 0, 20)
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    statusLabel.TextSize = 12
    statusLabel.ZIndex = 102
    
    TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
        Size = UDim2.new(0, 360, 0, 250)
    }):Play()
    
    local attempts = 0
    local finished = false
    
    local function closeUI()
        if finished then return end
        finished = true
        TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 360, 0, 0)
        }):Play()
        task.delay(0.4, function()
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
        
        statusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
        statusLabel.Text = "Valid! Loading..."
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
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
            statusLabel.Text = "Please wait before requesting a new key"
            return
        end
        pcall(function() setclipboard(link) end)
        statusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
        statusLabel.Text = "Link copied! Complete it to get your key."
    end)
    
    getKeyBtn.MouseEnter:Connect(function()
        TweenService:Create(getKeyBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = NeverZen.Theme.SectionColor
        }):Play()
    end)
    getKeyBtn.MouseLeave:Connect(function()
        TweenService:Create(getKeyBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = NeverZen.Theme.BackgroundColor2
        }):Play()
    end)
    
    submitBtn.MouseEnter:Connect(function()
        TweenService:Create(submitBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(
                math.min(NeverZen.Theme.Hightlight.R * 255 + 30, 255),
                math.min(NeverZen.Theme.Hightlight.G * 255 + 30, 255),
                math.min(NeverZen.Theme.Hightlight.B * 255 + 30, 255)
            )
        }):Play()
    end)
    submitBtn.MouseLeave:Connect(function()
        TweenService:Create(submitBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = NeverZen.Theme.Hightlight
        }):Play()
    end)
    
    local function tryValidate()
        if finished then return end
        local key = textBox.Text:gsub("%s+", "")
        if #key == 0 then
            statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            statusLabel.Text = "Enter a key first"
            return
        end
        
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
        statusLabel.Text = "Validating..."
        
        attempts = attempts + 1
        
        local validation = checkKey(key)
        
        if validation and validation.valid then
            onSuccess(key)
        else
            local errorMsg = validation and validation.message or validation and validation.error or "Invalid key"
            statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            
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
