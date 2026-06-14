--[[
    跳转中心 v1.0 正式版

    全功能集成版本。
]]

--"" UI源码完全公开，你们随便抄，反正碰不到核心。UI送给你们了，就当是做慈善了😂

-- ===== CLEANUP + RELOAD DETECTION =====
do
    local _cg = game:GetService("CoreGui")
    local _m = _cg:FindFirstChild("_BFH_Marker")
    if _m then _G._BFH_IS_RELOAD = true; _m:Destroy() end
    Instance.new("Folder", _cg).Name = "_BFH_Marker"

    -- 销毁旧 UI
    local _guis = {"BanFengHeUIFramework","AimbotFOV","CavalryChargeUI","ZapperEffectUI","SkinHUB","JumpCenterFramework"}
    for _, _n in ipairs(_guis) do
        local _g = _cg:FindFirstChild(_n)
        if _g then pcall(_g.Destroy, _g) end
    end
    local _pg = game:GetService("Players").LocalPlayer
    if _pg and _pg:FindFirstChild("PlayerGui") then
        _pg = _pg:FindFirstChild("PlayerGui")
        for _, _n in ipairs(_guis) do
            local _g = _pg:FindFirstChild(_n)
            if _g then pcall(_g.Destroy, _g) end
        end
    end

    -- 清理角色残留物理对象（坐标加速/飞行/speed 等残留）
    local function _cleanChar(ch)
        if not ch then return end
        for _, _c in ipairs(ch:GetDescendants()) do
            pcall(function()
                if _c:IsA("BodyVelocity") or _c:IsA("BodyGyro") or _c:IsA("BodyPosition") or _c:IsA("BodyAngularVelocity") or _c:IsA("RocketPropulsion") or _c:IsA("BodyThrust") then
                    _c:Destroy()
                end
            end)
        end
    end
    if _G._BFH_IS_RELOAD then
        local _lp = game:GetService("Players").LocalPlayer
        if _lp and _lp.Character then _cleanChar(_lp.Character) end
    end

    -- 清理 workspace 视觉残留
    local function _wipe(container)
        for _, _d in ipairs(container:GetDescendants()) do
            pcall(function()
                -- Highlight 清理已移除，避免误删游戏对象（ESP 自行清理）
                if _d:IsA("BasePart") and (_d.Name == "ZombieHitbox_Outer" or _d.Name == "ZombieHitbox_Head") then _d:Destroy(); return end
                if _d:IsA("BillboardGui") and _d:FindFirstChildOfClass("TextLabel") then
                    local _t = _d:FindFirstChildOfClass("TextLabel").Text or ""
                    if _t:match("^%d+$") then _d:Destroy(); return end
                end
                if _d:IsA("ParticleEmitter") and _d.Parent and _d.Parent:IsA("BasePart") and _d.Parent.Parent and _d.Parent.Parent:IsA("Model") then
                    _d:Destroy(); return
                end
                if _d:IsA("Attachment") and _d:FindFirstChildOfClass("ParticleEmitter") then _d:Destroy(); return end
                if _d:IsA("SpecialMesh") and _d.MeshId == "rbxassetid://101851696" then _d:Destroy(); return end
            end)
        end
    end
    _wipe(workspace)
    for _, _p in ipairs(game:GetService("Players"):GetPlayers()) do
        if _p.Character then _wipe(_p.Character) end
    end
    _G.AP = nil
end

-- ===== 全局关闭注册表（重载时强制停止所有功能） =====
_G._BFH_STOP_ALL = _G._BFH_STOP_ALL or {}
if _G._BFH_IS_RELOAD then
    for _, _fn in ipairs(_G._BFH_STOP_ALL) do
        pcall(_fn)
    end
    _G._BFH_STOP_ALL = {}
end

do
    local AppConfig = {
        Name = "跳转中心",
        Version = "1.0.1",
        Author = "青木作者",
        GuiName = "JumpCenterFramework",
        ShellMode = true,
        DefaultPage = "about",
        MarqueeText = "当前正在脚本中心。请选择合适的服务器进行跳转。",
        AnnouncementTitle = "",
        AnnouncementText = "",
        WindowPresets = {
            { label = "迷你", value = "mini", size = Vector2.new(620, 420) },
            { label = "标准", value = "standard", size = Vector2.new(760, 500) },
            { label = "宽屏", value = "wide", size = Vector2.new(900, 560) },
            { label = "大型", value = "large", size = Vector2.new(1020, 640) },
        },
        MinimumDpi = 65,
        MaximumDpi = 140,
        ToggleKey = Enum.KeyCode.RightShift,
        MaxRecent = 18,
    }

    local Theme = {
        Colors = {
            Background = Color3.fromRGB(10, 10, 10),
            Window = Color3.fromRGB(15, 15, 15),
            Panel = Color3.fromRGB(18, 18, 18),
            PanelDeep = Color3.fromRGB(8, 8, 8),
            Card = Color3.fromRGB(20, 20, 20),
            CardHover = Color3.fromRGB(26, 26, 26),
            Control = Color3.fromRGB(24, 24, 24),
            ControlHover = Color3.fromRGB(32, 32, 32),
            Stroke = Color3.fromRGB(34, 34, 34),
            StrokeStrong = Color3.fromRGB(48, 48, 48),
            Text = Color3.fromRGB(242, 242, 242),
            TextMuted = Color3.fromRGB(156, 156, 156),
            TextDim = Color3.fromRGB(112, 112, 112),
            Accent = Color3.fromRGB(60, 140, 255),
            AccentSoft = Color3.fromRGB(32, 72, 132),
            AccentDim = Color3.fromRGB(22, 44, 76),
            Success = Color3.fromRGB(82, 180, 126),
            Warning = Color3.fromRGB(226, 176, 74),
            Danger = Color3.fromRGB(235, 92, 92),
            ToggleOff = Color3.fromRGB(52, 52, 52),
            Overlay = Color3.fromRGB(0, 0, 0),
            Transparent = Color3.fromRGB(255, 255, 255),
        },

        Radius = {
            Window = 8,
            Panel = 6,
            Control = 5,
            Pill = 999,
        },

        Font = Enum.Font.SourceSans,
        FontBold = Enum.Font.SourceSansBold,

        Animation = {
            Press = 0.08,
            Fast = 0.12,
            Normal = 0.18,
            Slow = 0.26,
            TooltipDelay = 0,
            TouchTooltipDelay = 0.42,
            ToastDuration = 2.6,
            Style = Enum.EasingStyle.Quad,
            EmphasisStyle = Enum.EasingStyle.Back,
            Direction = Enum.EasingDirection.Out,
        },
    }

    local UI = {
        RootGui = nil,
        Main = nil,
        ShowButton = nil,
        Content = nil,
        ContentLayout = nil,
        Sidebar = nil,
        SidebarCollapsed = false,
        SidebarButtons = {},
        ShowButtonDragged = false,
        LogList = nil,
        ToastRoot = nil,
        ToastId = 0,
        ToastThrottle = {},
        Tooltip = nil,
        TooltipSource = nil,
        TooltipToken = 0,
        VisibleToken = 0,
        ModalRoot = nil,
        MarqueeToken = 0,
        Scale = nil,
        ToastScale = nil,
        TooltipScale = nil,
        ModalScale = nil,
        ShowScale = nil,
        Connections = {},
        PageConnections = {},
        LogConnections = {},
    }

    local Components = {}
    local Registry = {
        Callbacks = {},
        Meta = {},
    }
    local Pages = {
        List = {},
        ById = {},
    }
    local State = {
        CurrentPage = AppConfig.DefaultPage,
        SearchText = "",
        Toggles = {},
        Sliders = {},
        Inputs = {},
        Dropdowns = {},
        Segments = {},
        Collapsed = {},
        SubPages = {},
        Logs = {},
        Controls = {},
        VisibleControlKeys = {},
        Favorites = {},
        Recent = {},
        Keybinds = {},
        Colors = {},
        Numbers = {},
        MultiDropdowns = {},
        ConfirmEnabled = true,
        SearchScope = "current",
        SearchReturnPage = AppConfig.DefaultPage,
        WindowPreset = "mini",
        WindowTransparency = 0,
        DpiScale = 0.75,

        }

    local ESP = {}

    local Services = {
        TweenService = game:GetService("TweenService"),
        UserInputService = game:GetService("UserInputService"),
        TextService = game:GetService("TextService"),
        Players = game:GetService("Players"),
        CoreGui = game:GetService("CoreGui"),
    }

    local DefaultProperties = {
        Frame = {
            BorderSizePixel = 0,
        },
        ScrollingFrame = {
            BorderSizePixel = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Colors.StrokeStrong,
            ScrollingDirection = Enum.ScrollingDirection.Y,
        },
        TextLabel = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Font = Theme.Font,
            TextColor3 = Theme.Colors.Text,
            TextSize = 15,
            TextWrapped = false,
        },
        TextButton = {
            AutoButtonColor = false,
            BorderSizePixel = 0,
            Font = Theme.Font,
            TextColor3 = Theme.Colors.Text,
            TextSize = 15,
            Text = "",
        },
        TextBox = {
            BorderSizePixel = 0,
            ClearTextOnFocus = false,
            Font = Theme.Font,
            TextColor3 = Theme.Colors.Text,
            TextSize = 15,
            PlaceholderColor3 = Theme.Colors.TextDim,
        },
        ImageButton = {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        },
        ImageLabel = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        },
        UIListLayout = {
            SortOrder = Enum.SortOrder.LayoutOrder,
        },
    }

    local function New(className, properties)
        local object = Instance.new(className)

        for key, value in pairs(DefaultProperties[className] or {}) do
            object[key] = value
        end

        for key, value in pairs(properties or {}) do
            object[key] = value
        end

        return object
    end

    local function Tween(object, properties, duration, easingStyle, easingDirection)
        if not object then
            return nil
        end

        local tweenInfo = TweenInfo.new(
            duration or Theme.Animation.Normal,
            easingStyle or Theme.Animation.Style,
            easingDirection or Theme.Animation.Direction
        )
        local tween = Services.TweenService:Create(object, tweenInfo, properties)
        tween:Play()
        return tween
    end

    local function IsPointerInput(input)
        return input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
    end

    local function AddCorner(parent, radius)
        return New("UICorner", {
            CornerRadius = UDim.new(0, radius or Theme.Radius.Control),
            Parent = parent,
        })
    end

    local function AddStroke(parent, color, thickness)
        local s = New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = color or Theme.Colors.Stroke,
            Transparency = 1,
            Parent = parent,
        })
        if thickness then s.Thickness = thickness end
        return s
    end

    local function AddPadding(parent, left, right, top, bottom)
        return New("UIPadding", {
            PaddingLeft = UDim.new(0, left or 0),
            PaddingRight = UDim.new(0, right or left or 0),
            PaddingTop = UDim.new(0, top or 0),
            PaddingBottom = UDim.new(0, bottom or top or 0),
            Parent = parent,
        })
    end

    local function UpdateScrollCanvas(scroller, layout, extra)
        if scroller and scroller.Parent and layout and layout.Parent then
            local contentHeight = layout.AbsoluteContentSize.Y + (extra or 48)
            local viewportHeight = scroller.AbsoluteWindowSize and scroller.AbsoluteWindowSize.Y or scroller.AbsoluteSize.Y
            scroller.CanvasSize = UDim2.new(0, 0, 0, math.max(contentHeight, viewportHeight + 1))
        end
    end

    local function SetScrollCanvas(scroller, layout, extra, scope)
        local function update()
            UpdateScrollCanvas(scroller, layout, extra)
        end

        local connection = layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
        if UI.Track then
            UI.Track(connection, scope or "page")
        end

        local sizeConnection = scroller:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
        if UI.Track then
            UI.Track(sizeConnection, scope or "page")
        end

        update()
        task.defer(update)
        task.delay(0.15, update)
    end

    local function DisconnectConnections(connections)
        for _, connection in ipairs(connections) do
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end

        table.clear(connections)
    end

    local function ContainsText(value, query)
        if query == "" then
            return true
        end

        if value == nil then
            return false
        end

        return string.find(string.lower(tostring(value)), query, 1, true) ~= nil
    end

    local function ShallowCopy(source)
        local copy = {}
        for key, value in pairs(source or {}) do
            copy[key] = value
        end
        return copy
    end

    local function ColorToHex(color)
        local r = math.floor(color.R * 255 + 0.5)
        local g = math.floor(color.G * 255 + 0.5)
        local b = math.floor(color.B * 255 + 0.5)
        return string.format("#%02X%02X%02X", r, g, b)
    end

    local function RefreshContentCanvas()
        if UI.Content and UI.ContentLayout then
            UpdateScrollCanvas(UI.Content, UI.ContentLayout, 20)
            task.defer(function()
                UpdateScrollCanvas(UI.Content, UI.ContentLayout, 20)
            end)
            task.delay(Theme.Animation.Normal + 0.04, function()
                UpdateScrollCanvas(UI.Content, UI.ContentLayout, 20)
            end)
        end
    end

    local function ResolveOptionValue(option)
        if type(option) == "table" then
            return option.value
        end
        return option
    end

    local function ResolveOptionLabel(option)
        if type(option) == "table" then
            return option.label or tostring(option.value)
        end
        return tostring(option)
    end

    local function ClampFrameToScreen(frame, position)
        if not frame or not UI.RootGui then
            return position
        end

        local container = frame.Parent or UI.RootGui
        local rootSize = container.AbsoluteSize
        local frameSize = frame.AbsoluteSize
        local anchor = frame.AnchorPoint
        local minX = math.floor(frameSize.X * anchor.X)
        local minY = math.floor(frameSize.Y * anchor.Y)
        local maxX = math.max(minX, rootSize.X - math.floor(frameSize.X * (1 - anchor.X)))
        local maxY = math.max(minY, rootSize.Y - math.floor(frameSize.Y * (1 - anchor.Y)))
        local scaledX = rootSize.X * position.X.Scale
        local scaledY = rootSize.Y * position.Y.Scale
        local absoluteX = math.clamp(scaledX + position.X.Offset, minX, maxX)
        local absoluteY = math.clamp(scaledY + position.Y.Offset, minY, maxY)
        local x = absoluteX - scaledX
        local y = absoluteY - scaledY

        return UDim2.new(position.X.Scale, x, position.Y.Scale, y)
    end

    function State:GetBucket(kind)
        if kind == "toggle" then
            return self.Toggles
        elseif kind == "slider" then
            return self.Sliders
        elseif kind == "input" then
            return self.Inputs
        elseif kind == "dropdown" then
            return self.Dropdowns
        elseif kind == "segment" then
            return self.Segments
        elseif kind == "number" then
            return self.Numbers
        elseif kind == "color" then
            return self.Colors
        elseif kind == "multi-dropdown" then
            return self.MultiDropdowns
        end

        return self.Inputs
    end

    function State:Get(kind, key, defaultValue)
        local bucket = self:GetBucket(kind)
        if bucket[key] == nil then
            bucket[key] = defaultValue
        end

        return bucket[key]
    end

    function State:Set(kind, key, value)
        if type(value) == "string" and value:find("^table: 0") then return end
        local strOnly = { input = true, dropdown = true, segment = true, color = true }
        if strOnly[kind] and type(value) == "table" then return end
        self:GetBucket(kind)[key] = value
    end

    function State:IsFavorite(key)
        return self.Favorites[key] == true
    end

    function State:SetFavorite(key, enabled)
        if enabled then
            self.Favorites[key] = true
        else
            self.Favorites[key] = nil
        end
    end

    function State:TouchRecent(key, title, page)
        if not key or key == "" then
            return
        end

        for index = #self.Recent, 1, -1 do
            if self.Recent[index].key == key then
                table.remove(self.Recent, index)
            end
        end

        table.insert(self.Recent, 1, {
            key = key,
            title = title or key,
            page = page or "",
            time = os.date("%H:%M:%S"),
        })

        while #self.Recent > AppConfig.MaxRecent do
            table.remove(self.Recent)
        end
    end

    function State:ResetControls()
        self.Toggles = {}
        self.Sliders = {}
        self.Inputs = {}
        self.Dropdowns = {}
        self.Segments = {}
        self.Numbers = {}
        self.Colors = {}
        self.MultiDropdowns = {}
        self.Collapsed = {}
        self.SubPages = {}
        self.SearchText = ""
        self.SearchScope = "current"
        self.SearchReturnPage = AppConfig.DefaultPage
        self.WindowPreset = "mini"
        self.WindowTransparency = 0
        self.DpiScale = 0.75
        self.Controls = {}
        self.VisibleControlKeys = {}
    end

    function State:CountFavorites()
        local count = 0
        for _ in pairs(self.Favorites) do
            count += 1
        end
        return count
    end

    function State:AddLog(level, message, key)
        if type(message) ~= "string" then
            message = type(message) == "table" and "操作返回了无效值" or tostring(message or "")
        end
        table.insert(self.Logs, 1, {
            Time = os.date("%H:%M:%S"),
            Level = level or "INFO",
            Message = message or "",
            Key = key or "",
        })

        while #self.Logs > 120 do
            table.remove(self.Logs)
        end

        if UI.RefreshLogs then
            UI.RefreshLogs()
        end

        if UI.Notify then
            UI.Notify(level or "INFO", message or "", key or "")
        end
    end

    function State:ClearLogs()
        self.Logs = {}

        if UI.RefreshLogs then
            UI.RefreshLogs()
        end
    end

    function State:RegisterControl(key, control)
        if not key or key == "" or not control then
            return
        end

        self.Controls[key] = control
        self.VisibleControlKeys[key] = true
    end

    function State:ClearVisibleControls()
        for key in pairs(self.VisibleControlKeys) do
            self.Controls[key] = nil
        end
        self.VisibleControlKeys = {}
    end

    function Registry.Noop()
    end

    function Registry.Ensure(key, meta)
        if not key or key == "" then
            return
        end

        if Registry.Meta[key] then
            Registry.Callbacks[key] = Registry.Callbacks[key] or Registry.Noop
            return
        end

        Registry.Meta[key] = meta or {}
        Registry.Callbacks[key] = Registry.Callbacks[key] or Registry.Noop
    end

    function Registry.Bind(key, callback)
        assert(type(key) == "string" and key ~= "", "Registry.Bind 需要非空 key")
        assert(type(callback) == "function", "Registry.Bind 需要 function 回调")
        Registry.Callbacks[key] = callback
    end

    function Registry.IsBound(key)
        return Registry.Callbacks[key] ~= nil and Registry.Callbacks[key] ~= Registry.Noop
    end

    function Registry.GetAll()
        local items = {}
        for key, meta in pairs(Registry.Meta) do
            local row = ShallowCopy(meta)
            row.Key = key
            row.Bound = Registry.IsBound(key)
            table.insert(items, row)
        end

        table.sort(items, function(a, b)
            return tostring(a.Key) < tostring(b.Key)
        end)

        return items
    end

    function Registry.Invoke(key, payload)
        local callback = Registry.Callbacks[key] or Registry.Noop
        local ok, err = pcall(callback, payload or {})

        if not ok then
            State:AddLog("ERROR", tostring(err), key)
        end
    end

    function Components.Hover(object, normalColor, hoverColor)
        object.MouseEnter:Connect(function()
            Tween(object, { BackgroundColor3 = hoverColor }, Theme.Animation.Fast)
        end)

        object.MouseLeave:Connect(function()
            Tween(object, { BackgroundColor3 = normalColor }, Theme.Animation.Fast)
        end)
    end

    function Components.Interaction(object, normalColor, hoverColor, pressedColor)
        if not object then
            return
        end

        local function resolve(value)
            if type(value) == "function" then
                return value()
            end
            return value
        end

        local isHovering = false
        local isPressed = false

        object.MouseEnter:Connect(function()
            isHovering = true
            local color = resolve(hoverColor)
            if not isPressed and color then
                Tween(object, { BackgroundColor3 = color }, Theme.Animation.Fast)
            end
        end)

        object.MouseLeave:Connect(function()
            isHovering = false
            local color = resolve(normalColor)
            if not isPressed and color then
                Tween(object, { BackgroundColor3 = color }, Theme.Animation.Fast)
            end
        end)

        object.InputBegan:Connect(function(input)
            if not IsPointerInput(input) then
                return
            end

            isPressed = true
            local color = resolve(pressedColor) or resolve(hoverColor)
            if color then
                Tween(object, { BackgroundColor3 = color }, Theme.Animation.Press)
            end
        end)

        object.InputEnded:Connect(function(input)
            if not IsPointerInput(input) then
                return
            end

            isPressed = false
            local color = isHovering and (resolve(hoverColor) or resolve(normalColor)) or resolve(normalColor)
            if color then
                Tween(object, { BackgroundColor3 = color }, Theme.Animation.Fast)
            end
        end)
    end

    function Components.Tooltip(object, text)
        if not text or text == "" then
            return
        end

        local touchToken = 0
        local touchStart = nil

        object.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and UI.ShowTooltip then
                touchToken += 1
                local token = touchToken
                touchStart = input.Position
                task.delay(Theme.Animation.TouchTooltipDelay, function()
                    if token == touchToken and touchStart and UI.ShowTooltip then
                        UI.ShowTooltip(text, object)
                    end
                end)
            end
        end)

        object.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and touchStart then
                local delta = input.Position - touchStart
                if math.abs(delta.X) > 8 or math.abs(delta.Y) > 8 then
                    touchToken += 1
                    touchStart = nil
                    if UI.HideTooltip then
                        UI.HideTooltip(object)
                    end
                end
            end
        end)

        object.MouseLeave:Connect(function()
            if UI.HideTooltip then
                UI.HideTooltip()
            end
        end)

        object.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                touchToken += 1
                touchStart = nil
                if UI.HideTooltip then
                    UI.HideTooltip(object)
                end
            end

            if IsPointerInput(input) and UI.HideTooltip then
                UI.HideTooltip(object)
            end
        end)

        object.SelectionGained:Connect(function()
            if UI.ShowTooltip then
                UI.ShowTooltip(text, object)
            end
        end)

        object.SelectionLost:Connect(function()
            if UI.HideTooltip then
                UI.HideTooltip(object)
            end
        end)
    end

    function Components.Label(parent, text, size, color, bold)
        return New("TextLabel", {
            Font = bold and Theme.FontBold or Theme.Font,
            Text = text or "",
            TextColor3 = color or Theme.Colors.Text,
            TextSize = size or 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            Parent = parent,
        })
    end

    function Components.IconButton(parent, key, iconText, tooltipText, onClick)
        Registry.Ensure(key, {
            Type = "icon-button",
            Title = tooltipText,
            Internal = true,
        })

        local button = New("TextButton", {
            Name = key,
            BackgroundColor3 = Theme.Colors.Control,
            Size = UDim2.fromOffset(28, 28),
            Text = iconText or "?",
            TextSize = 14,
            TextColor3 = Theme.Colors.TextMuted,
            Parent = parent,
        })
        AddCorner(button, Theme.Radius.Control)
        AddStroke(button)
        Components.Interaction(button, Theme.Colors.Control, Theme.Colors.ControlHover, Theme.Colors.AccentDim)
        Components.Tooltip(button, tooltipText or key)
        local icnScale = New("UIScale", { Scale = 1, Parent = button })

        button.MouseButton1Click:Connect(function()
            Tween(icnScale, { Scale = 0.92 }, Theme.Animation.Press)
            task.delay(Theme.Animation.Press + 0.04, function()
                Tween(icnScale, { Scale = 1 }, Theme.Animation.Fast)
            end)
            if onClick then
                onClick()
            end
        end)

        return button
    end

    function Components.Section(parent, title, subtitle)
        local section = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = parent,
        })

        local layout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = section,
        })

        local header = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, subtitle and 42 or 24),
            Parent = section,
        })

        local titleLabel = Components.Label(header, title, 18, Theme.Colors.Text, true)
        titleLabel.Size = UDim2.new(1, 0, 0, 20)
        titleLabel.Position = UDim2.fromOffset(0, 0)

        if subtitle then
            local subtitleLabel = Components.Label(header, subtitle, 14, Theme.Colors.TextDim, false)
            subtitleLabel.Size = UDim2.new(1, 0, 0, 18)
            subtitleLabel.Position = UDim2.fromOffset(0, 22)
        end

        return section, layout
    end

    function Components.ControlFrame(parent, height)
        local frame = New("Frame", {
            BackgroundColor3 = Theme.Colors.Card,
            Size = UDim2.new(1, 0, 0, height or 48),
            Parent = parent,
        })
        AddCorner(frame, Theme.Radius.Panel)
        AddStroke(frame)
        return frame
    end

    function Components.TitleBlock(parent, item, rightWidth)
        local title = Components.Label(parent, item.title or item.key, 16, Theme.Colors.Text, false)
        title.Position = UDim2.fromOffset(8, item.desc and 4 or 0)
        title.Size = UDim2.new(1, -(rightWidth or 110) - 24, 0, item.desc and 19 or 1)
        title.TextTruncate = Enum.TextTruncate.AtEnd

        if not item.desc then
            title.Size = UDim2.new(1, -(rightWidth or 110) - 24, 1, 0)
        end

        if item.desc then
            local desc = Components.Label(parent, item.desc, 15, Theme.Colors.TextDim, false)
            desc.Position = UDim2.fromOffset(8, 23)
            desc.Size = UDim2.new(1, -(rightWidth or 110) - 24, 0, 16)
            desc.TextTruncate = Enum.TextTruncate.AtEnd
        end

        Components.Tooltip(parent, (item.desc or item.title or item.key) .. "\nkey: " .. tostring(item.key or "无"))

        return title
    end

    function Components.InvokeItem(item, payload)
        payload = payload or {}
        payload.key = item.key
        payload.item = item
        payload.state = State
        State:TouchRecent(item.key, item.title, item.page)

        if item.onChanged then
            local ok, err = pcall(item.onChanged, payload.value, payload)
            if not ok then
                State:AddLog("ERROR", tostring(err), item.key)
            end
        end

        if not item.internal then
            Registry.Invoke(item.key, payload)
        end
    end

    function Components.Button(parent, item)
        Registry.Ensure(item.key, {
            Type = "button",
            Title = item.title,
            Page = item.page,
        })

        local button = New("TextButton", {
            Name = item.key,
            BackgroundColor3 = Theme.Colors.Card,
            Size = UDim2.new(1, 0, 0, 46),
            Text = "",
            Parent = parent,
        })
        AddCorner(button, Theme.Radius.Panel)
        AddStroke(button)
        Components.Interaction(button, Theme.Colors.Card, Theme.Colors.CardHover, Theme.Colors.ControlHover)
        local btnScale = New("UIScale", { Scale = 1, Parent = button })

        Components.TitleBlock(button, item, 88)

        local action = Components.Label(button, item.actionText or "执行", 13, Theme.Colors.TextMuted, true)
        action.AnchorPoint = Vector2.new(1, 0.5)
        action.BackgroundColor3 = Theme.Colors.Control
        action.BackgroundTransparency = 0
        action.Position = UDim2.new(1, -10, 0.5, 0)
        action.Size = UDim2.fromOffset(62, 24)
        action.TextXAlignment = Enum.TextXAlignment.Center
        AddCorner(action, Theme.Radius.Control)
        AddStroke(action)

        local function runButton()
            Tween(btnScale, { Scale = 0.96 }, Theme.Animation.Press)
            task.delay(Theme.Animation.Press + 0.04, function()
                Tween(btnScale, { Scale = 1 }, Theme.Animation.Normal)
            end)
            if not item.internal then
                State:AddLog("ACTION", item.title or "按钮触发", item.key)
            end
            Components.InvokeItem(item, {
                type = "button",
            })
        end

        button.MouseButton1Click:Connect(function()
            if item.confirm and UI.Confirm then
                UI.Confirm(item.confirmTitle or item.title or "确认操作", item.confirmText or item.desc or "确认执行这个 UI 操作？", runButton)
            else
                runButton()
            end
        end)

        return button
    end

    function Components.Toggle(parent, item)
        Registry.Ensure(item.key, {
            Type = "toggle",
            Title = item.title,
            Page = item.page,
        })

        local row = New("TextButton", {
            Name = item.key,
            BackgroundColor3 = Theme.Colors.Card,
            Size = UDim2.new(1, 0, 0, 48),
            Text = "",
            Parent = parent,
        })
        AddCorner(row, Theme.Radius.Panel)
        AddStroke(row)
        Components.Interaction(row, Theme.Colors.Card, Theme.Colors.CardHover, Theme.Colors.ControlHover)

        Components.TitleBlock(row, item, 72)

        local track = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.ToggleOff,
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.fromOffset(42, 22),
            Parent = row,
        })
        AddCorner(track, Theme.Radius.Pill)

        local knob = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Colors.Text,
            Size = UDim2.fromOffset(18, 18),
            Parent = track,
        })
        AddCorner(knob, Theme.Radius.Pill)

        local value = State:Get("toggle", item.key, item.default == true)

        local function paint(instant)
            local targetColor = value and Theme.Colors.Accent or Theme.Colors.ToggleOff
            local targetPosition = value and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0)
            local targetSize = value and UDim2.fromOffset(19, 19) or UDim2.fromOffset(18, 18)
            local stroke = row:FindFirstChildOfClass("UIStroke")
            local strokeColor = value and Theme.Colors.AccentSoft or Theme.Colors.Stroke

            if instant then
                track.BackgroundColor3 = targetColor
                knob.Position = targetPosition
                knob.Size = targetSize
                if stroke then
                    stroke.Color = strokeColor
                end
            else
                Tween(track, { BackgroundColor3 = targetColor }, Theme.Animation.Normal)
                Tween(knob, { Position = targetPosition, Size = targetSize }, Theme.Animation.Normal)
                if stroke then
                    Tween(stroke, { Color = strokeColor }, Theme.Animation.Normal)
                end
            end
        end

        local function setValue(newValue, silent)
            value = newValue == true
            State:Set("toggle", item.key, value)
            paint(false)

            if not silent then
                local logMsg = (item.title or item.key) .. " 已" .. (value and "开启" or "关闭")
                State:AddLog("TOGGLE", logMsg, item.key)
                Components.InvokeItem(item, {
                    type = "toggle",
                    value = value,
                })
            end
        end

        row.MouseButton1Click:Connect(function()
            setValue(not value, false)
        end)

        State:RegisterControl(item.key, {
            Type = "toggle",
            SetValue = setValue,
            GetValue = function()
                return value
            end,
        })
        if item.onChanged then
            State.OnLoad = State.OnLoad or {}
            State.OnLoad[item.key] = item.onChanged
        end

        paint(true)
        return row
    end

    function Components.Slider(parent, item)
        Registry.Ensure(item.key, {
            Type = "slider",
            Title = item.title,
            Page = item.page,
        })

        local minValue = item.min or 0
        local maxValue = item.max or 100
        if maxValue < minValue then
            minValue, maxValue = maxValue, minValue
        end
        local step = tonumber(item.step) or 1
        if step <= 0 then
            step = 1
        end

        local row = Components.ControlFrame(parent, 64)
        Components.TitleBlock(row, item, 132)

        local valueLabel = Components.Label(row, "", 13, Theme.Colors.TextMuted, true)
        valueLabel.AnchorPoint = Vector2.new(1, 0)
        valueLabel.Position = UDim2.new(1, -12, 0, 9)
        valueLabel.Size = UDim2.fromOffset(90, 18)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local bar = New("TextButton", {
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.new(0, 12, 1, -20),
            Size = UDim2.new(1, -24, 0, 5),
            Text = "",
            Parent = row,
        })
        AddCorner(bar, Theme.Radius.Pill)

        local fill = New("Frame", {
            BackgroundColor3 = Theme.Colors.Accent,
            Size = UDim2.new(0, 0, 1, 0),
            Parent = bar,
        })
        AddCorner(fill, Theme.Radius.Pill)

        local knob = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Colors.Text,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(10, 10),
            Parent = bar,
        })
        AddCorner(knob, Theme.Radius.Pill)

        local dragging = false
        local changedWhileDragging = false
        local value = State:Get("slider", item.key, item.default or minValue)

        local function normalize(raw)
            raw = math.clamp(raw, minValue, maxValue)
            local stepped = math.floor(((raw - minValue) / step) + 0.5) * step + minValue
            return math.clamp(stepped, minValue, maxValue)
        end

        local function formatValue(nextValue)
            if item.format then
                return string.format(item.format, nextValue)
            end

            if math.floor(nextValue) == nextValue then
                return tostring(nextValue)
            end

            return string.format("%.2f", nextValue)
        end

        local function paint(instant)
            local percent = 0
            if maxValue ~= minValue then
                percent = (value - minValue) / (maxValue - minValue)
            end
            percent = math.clamp(percent, 0, 1)
            valueLabel.Text = formatValue(value)

            local fillSize = UDim2.new(percent, 0, 1, 0)
            local knobPosition = UDim2.new(percent, 0, 0.5, 0)

            if instant then
                fill.Size = fillSize
                knob.Position = knobPosition
                valueLabel.TextColor3 = Theme.Colors.TextMuted
            else
                Tween(fill, { Size = fillSize }, Theme.Animation.Fast)
                Tween(knob, { Position = knobPosition }, Theme.Animation.Fast)
                Tween(valueLabel, { TextColor3 = Theme.Colors.Text }, Theme.Animation.Fast)
            end
        end

        local function setValue(nextValue, silent, instant)
            value = normalize(nextValue)
            State:Set("slider", item.key, value)
            paint(instant == true)

            if not silent then
                State:AddLog("SLIDER", (item.title or item.key) .. " = " .. formatValue(value), item.key)
                Components.InvokeItem(item, {
                    type = "slider",
                    value = value,
                })
            end
            task.delay(Theme.Animation.Slow, function()
                if valueLabel and valueLabel.Parent then
                    Tween(valueLabel, { TextColor3 = Theme.Colors.TextMuted }, Theme.Animation.Fast)
                end
            end)
        end

        local function setFromInput(input)
            local x = input.Position.X - bar.AbsolutePosition.X
            local percent = math.clamp(x / math.max(bar.AbsoluteSize.X, 1), 0, 1)
            setValue(minValue + (maxValue - minValue) * percent, true)
            if item.onChanged then pcall(item.onChanged, value) end
            changedWhileDragging = true
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromInput(input)
            end
        end)

        UI.Track(Services.UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                setFromInput(input)
            end
        end), "page")

        UI.Track(Services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging and changedWhileDragging then
                    setValue(value, false)
                end
                dragging = false
                changedWhileDragging = false
            end
        end), "page")

        State:RegisterControl(item.key, {
            Type = "slider",
            SetValue = setValue,
            GetValue = function()
                return value
            end,
        })
        if item.onChanged then
            State.OnLoad = State.OnLoad or {}
            State.OnLoad[item.key] = item.onChanged
        end

        value = normalize(value)
        paint(true)
        return row
    end

    function Components.TextInput(parent, item)
        Registry.Ensure(item.key, {
            Type = "input",
            Title = item.title,
            Page = item.page,
        })

        local row = Components.ControlFrame(parent, 50)
        Components.TitleBlock(row, item, 220)

        local input = New("TextBox", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.PanelDeep,
            PlaceholderText = item.placeholder or "",
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.fromOffset(item.width or 190, 28),
            Text = State:Get("input", item.key, item.default or ""),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        AddCorner(input, Theme.Radius.Control)
        local inputStroke = AddStroke(input)
        AddPadding(input, 8, 8, 0, 0)

        input.Focused:Connect(function()
            Tween(inputStroke, { Color = Theme.Colors.AccentSoft }, Theme.Animation.Fast)
        end)

        input.FocusLost:Connect(function()
            Tween(inputStroke, { Color = Theme.Colors.Stroke }, Theme.Animation.Fast)
            State:Set("input", item.key, input.Text)
            State:AddLog("INPUT", (item.title or item.key) .. " = " .. input.Text, item.key)
            Components.InvokeItem(item, {
                type = "input",
                value = input.Text,
            })
        end)

        State:RegisterControl(item.key, {
            Type = "input",
            SetValue = function(value)
                if type(value) == "table" then return end
                input.Text = tostring(value or "")
                State:Set("input", item.key, input.Text)
            end,
            GetValue = function()
                return input.Text
            end,
        })

        return row
    end

    function Components.Dropdown(parent, item)
        Registry.Ensure(item.key, {
            Type = "dropdown",
            Title = item.title,
            Page = item.page,
        })

        local options = item.options or {}

        local root = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 50),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = parent,
        })

        local layout = New("UIListLayout", {
            Padding = UDim.new(0, 6),
            Parent = root,
        })

        local row = Components.ControlFrame(root, 50)
        Components.TitleBlock(row, item, 190)

        local display = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.fromOffset(170, 28),
            Text = "",
            Parent = row,
        })
        AddCorner(display, Theme.Radius.Control)
        local displayStroke = AddStroke(display)
        Components.Interaction(display, Theme.Colors.PanelDeep, Theme.Colors.Control, Theme.Colors.ControlHover)

        local displayLabel = Components.Label(display, "", 14, Theme.Colors.TextMuted, false)
        displayLabel.Position = UDim2.fromOffset(8, 0)
        displayLabel.Size = UDim2.new(1, -28, 1, 0)
        displayLabel.TextTruncate = Enum.TextTruncate.AtEnd

        local arrow = Components.Label(display, "v", 13, Theme.Colors.TextDim, true)
        arrow.AnchorPoint = Vector2.new(1, 0.5)
        arrow.Position = UDim2.new(1, -8, 0.5, 0)
        arrow.Size = UDim2.fromOffset(14, 16)
        arrow.TextXAlignment = Enum.TextXAlignment.Center

        local optionsFrame = New("ScrollingFrame", {
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Size = UDim2.new(1, 0, 0, 0),
            Visible = false,
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarThickness = 3,
            Parent = root,
        })
        AddCorner(optionsFrame, Theme.Radius.Panel)
        AddStroke(optionsFrame)
        AddPadding(optionsFrame, 8, 8, 8, 8)

        local optionsLayout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = optionsFrame,
        })
        SetScrollCanvas(optionsFrame, optionsLayout, 16, "page")

        local function optionText(option)
            if type(option) == "table" then
                return option.label or tostring(option.value)
            end
            return tostring(option)
        end

        local function optionValue(option)
            if type(option) == "table" then
                return option.value
            end
            return option
        end

        local value = State:Get("dropdown", item.key, item.default or optionValue(options[1]) or "")
        local openToken = 0
        local optionButtons = {}

        local function findLabel(nextValue)
            if type(nextValue) == "table" then return "(无效)" end
            for _, option in ipairs(options) do
                if optionValue(option) == nextValue then
                    return optionText(option)
                end
            end

            return tostring(nextValue or "")
        end

        local function setOpen(open)
            openToken += 1
            local token = openToken
            local itemH = 34; local gap = 8; local count = #options
            local contentH = count * itemH + (count > 0 and (count - 1) * gap or 0) + 16
            local height = contentH
            if open then
                optionsFrame.Visible = true
                optionsFrame.BackgroundTransparency = 1
                optionsFrame.CanvasPosition = Vector2.zero
                optionsFrame.Size = UDim2.new(1, 0, 0, 0)
                Tween(optionsFrame, {
                    BackgroundTransparency = 0,
                    Size = UDim2.new(1, 0, 0, height),
                }, Theme.Animation.Normal)
                Tween(root, { Size = UDim2.new(1, 0, 0, 56 + height) }, Theme.Animation.Normal)
                arrow.Text = "^"
            else
                Tween(optionsFrame, {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                }, Theme.Animation.Fast)
                Tween(root, { Size = UDim2.new(1, 0, 0, 50) }, Theme.Animation.Fast)
                task.delay(Theme.Animation.Fast + 0.02, function()
                    if optionsFrame and optionsFrame.Parent and token == openToken and not open then
                        optionsFrame.Visible = false
                    end
                end)
                arrow.Text = "v"
            end
            RefreshContentCanvas()
        end

        local function setValue(nextValue, silent)
            if type(nextValue) == "table" then return end
            value = nextValue
            State:Set("dropdown", item.key, value)
            displayLabel.Text = findLabel(value)
            Tween(displayLabel, { TextColor3 = Theme.Colors.Text }, Theme.Animation.Fast)
            Tween(arrow, { TextColor3 = Theme.Colors.Accent }, Theme.Animation.Fast)
            Tween(displayStroke, { Color = Theme.Colors.AccentSoft }, Theme.Animation.Fast)
            for nextOptionValue, data in pairs(optionButtons) do
                local active = nextOptionValue == value
                Tween(data.Button, { BackgroundColor3 = active and Theme.Colors.AccentDim or Theme.Colors.Control }, Theme.Animation.Fast)
                Tween(data.Label, { TextColor3 = active and Theme.Colors.Text or Theme.Colors.TextMuted }, Theme.Animation.Fast)
                if data.Stroke then
                    Tween(data.Stroke, { Color = active and Theme.Colors.AccentSoft or Theme.Colors.Stroke }, Theme.Animation.Fast)
                end
            end
            setOpen(false)

            if not silent then
                State:AddLog("DROPDOWN", (item.title or item.key) .. " = " .. displayLabel.Text, item.key)
                Components.InvokeItem(item, {
                    type = "dropdown",
                    value = value,
                    label = displayLabel.Text,
                })
            end
        end

        for _, option in ipairs(options) do
            local nextOptionValue = optionValue(option)
            local optionButton = New("TextButton", {
                BackgroundColor3 = Theme.Colors.Control,
                Size = UDim2.new(1, 0, 0, 34),
                Text = "",
                Parent = optionsFrame,
            })
            AddCorner(optionButton, Theme.Radius.Control)
            local optionStroke = AddStroke(optionButton)
            Components.Interaction(
                optionButton,
                function()
                    return nextOptionValue == value and Theme.Colors.AccentDim or Theme.Colors.Control
                end,
                function()
                    return nextOptionValue == value and Theme.Colors.AccentDim or Theme.Colors.ControlHover
                end,
                Theme.Colors.AccentDim
            )

            local optionLabel = Components.Label(optionButton, optionText(option), 14, Theme.Colors.TextMuted, false)
            optionLabel.Position = UDim2.fromOffset(8, 0)
            optionLabel.Size = UDim2.new(1, -16, 1, 0)
            optionLabel.TextTruncate = Enum.TextTruncate.AtEnd
            optionButtons[nextOptionValue] = {
                Button = optionButton,
                Label = optionLabel,
                Stroke = optionStroke,
            }

            optionButton.MouseButton1Click:Connect(function()
                setValue(nextOptionValue, false)
            end)
        end

        display.MouseButton1Click:Connect(function()
            setOpen(not optionsFrame.Visible)
        end)

        function item.SetOptions(_, newOptions)
            options = newOptions or {}
            for _, child in ipairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            optionButtons = {}
            for _, option in ipairs(options) do
                local nextOptionValue = optionValue(option)
                local optionButton = New("TextButton", {
                    BackgroundColor3 = Theme.Colors.Control,
                    Size = UDim2.new(1, 0, 0, 34),
                    Text = "",
                    Parent = optionsFrame,
                })
                AddCorner(optionButton, Theme.Radius.Control)
                local optionStroke = AddStroke(optionButton)
                Components.Interaction(
                    optionButton,
                    function()
                        return nextOptionValue == value and Theme.Colors.AccentDim or Theme.Colors.Control
                    end,
                    function()
                        return nextOptionValue == value and Theme.Colors.AccentDim or Theme.Colors.ControlHover
                    end,
                    Theme.Colors.AccentDim
                )
                local optionLabel = Components.Label(optionButton, optionText(option), 14, Theme.Colors.TextMuted, false)
                optionLabel.Position = UDim2.fromOffset(8, 0)
                optionLabel.Size = UDim2.new(1, -16, 1, 0)
                optionLabel.TextTruncate = Enum.TextTruncate.AtEnd
                optionButtons[nextOptionValue] = {
                    Button = optionButton,
                    Label = optionLabel,
                    Stroke = optionStroke,
                }
                optionButton.MouseButton1Click:Connect(function()
                    setValue(nextOptionValue, false)
                end)
            end
            displayLabel.Text = findLabel(value)
            for nextOptValue, data in pairs(optionButtons) do
                local active = nextOptValue == value
                data.Button.BackgroundColor3 = active and Theme.Colors.AccentDim or Theme.Colors.Control
                data.Label.TextColor3 = active and Theme.Colors.Text or Theme.Colors.TextMuted
                if data.Stroke then
                    data.Stroke.Color = active and Theme.Colors.AccentSoft or Theme.Colors.Stroke
                end
            end
        end

        State:RegisterControl(item.key, {
            Type = "dropdown",
            SetValue = setValue,
            SetOptions = item.SetOptions,
            GetValue = function()
                return value
            end,
        })
        if item.onChanged then
            State.OnLoad = State.OnLoad or {}
            State.OnLoad[item.key] = item.onChanged
        end

        setValue(value, true)
        return root
    end

    function Components.Segmented(parent, item)
        Registry.Ensure(item.key, {
            Type = "segment",
            Title = item.title,
            Page = item.page,
            Internal = item.internal == true,
        })

        local options = item.options or {}
        local stacked = item.stacked == true
        local containerWidth = item.width or 284
        local root = Components.ControlFrame(parent, stacked and (item.desc and 92 or 74) or (item.desc and 72 or 54))
        local titleLabel = Components.TitleBlock(root, item, stacked and 24 or (containerWidth + 24))
        if stacked and not item.desc then
            titleLabel.Position = UDim2.fromOffset(12, 6)
            titleLabel.Size = UDim2.new(1, -48, 0, 22)
        end

        local container = New("Frame", {
            AnchorPoint = stacked and Vector2.new(0, 0) or Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = stacked and UDim2.new(0, 12, 1, -40) or UDim2.new(1, -12, 0.5, item.desc and 10 or 0),
            Size = stacked and UDim2.new(1, -24, 0, 30) or UDim2.fromOffset(containerWidth, 30),
            Parent = root,
        })
        AddCorner(container, Theme.Radius.Control)
        AddStroke(container)
        AddPadding(container, 3, 3, 3, 3)

        local layout = New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 4),
            Parent = container,
        })

        local buttons = {}

        local function optionText(option)
            return type(option) == "table" and (option.label or tostring(option.value)) or tostring(option)
        end

        local function optionValue(option)
            return type(option) == "table" and option.value or option
        end

        local value = State:Get("segment", item.key, item.default or optionValue(options[1]) or "")

        local function paint()
            for nextValue, button in pairs(buttons) do
                local active = nextValue == value
                local label = button:FindFirstChild("SegmentLabel")
                Tween(button, {
                    BackgroundColor3 = active and Theme.Colors.Accent or Theme.Colors.Control,
                }, Theme.Animation.Fast)
                if label then
                    Tween(label, { TextColor3 = active and Theme.Colors.Text or Theme.Colors.TextMuted }, Theme.Animation.Fast)
                end
            end
        end

        local function setValue(nextValue, silent, instant)
            value = nextValue
            State:Set("segment", item.key, value)
            paint()

            if not silent then
                State:AddLog("SEGMENT", (item.title or item.key) .. " = " .. tostring(value), item.key)
                Components.InvokeItem(item, {
                    type = "segment",
                    value = value,
                })
            end
        end

        local buttonCount = math.max(#options, 1)
        local buttonWidth = math.floor((containerWidth - 6 - math.max(#options - 1, 0) * 4) / buttonCount)
        for _, option in ipairs(options) do
            local nextValue = optionValue(option)
            local button = New("TextButton", {
                BackgroundColor3 = Theme.Colors.Control,
                Size = stacked and UDim2.new(1 / buttonCount, -math.ceil((math.max(buttonCount - 1, 0) * 4) / buttonCount), 1, 0) or UDim2.new(0, buttonWidth, 1, 0),
                Text = "",
                Parent = container,
            })
            AddCorner(button, Theme.Radius.Control)
            Components.Interaction(
                button,
                function()
                    return nextValue == value and Theme.Colors.Accent or Theme.Colors.Control
                end,
                function()
                    return nextValue == value and Theme.Colors.Accent or Theme.Colors.ControlHover
                end,
                Theme.Colors.AccentDim
            )

            local buttonLabel = Components.Label(button, optionText(option), 13, Theme.Colors.TextMuted, false)
            buttonLabel.Name = "SegmentLabel"
            buttonLabel.Size = UDim2.fromScale(1, 1)
            buttonLabel.TextXAlignment = Enum.TextXAlignment.Center
            buttonLabel.TextTruncate = Enum.TextTruncate.AtEnd

            buttons[nextValue] = button

            button.MouseButton1Click:Connect(function()
                setValue(nextValue, false)
            end)
        end

        State:RegisterControl(item.key, {
            Type = "segment",
            SetValue = setValue,
            GetValue = function()
                return value
            end,
        })
        if item.onChanged then
            State.OnLoad = State.OnLoad or {}
            State.OnLoad[item.key] = item.onChanged
        end

        paint()
        UI.Track(layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(paint), "page")
        return root
    end

    function Components.NumberInput(parent, item)
        Registry.Ensure(item.key, {
            Type = "number",
            Title = item.title,
            Page = item.page,
        })

        local minValue = item.min or -999999
        local maxValue = item.max or 999999
        if maxValue < minValue then
            minValue, maxValue = maxValue, minValue
        end
        local step = tonumber(item.step) or 1
        if step <= 0 then
            step = 1
        end
        local value = tonumber(State:Get("number", item.key, item.default or 0)) or 0

        local row = Components.ControlFrame(parent, 50)
        Components.TitleBlock(row, item, 180)

        local box = New("TextBox", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.new(1, -46, 0.5, 0),
            Size = UDim2.fromOffset(96, 28),
            Text = tostring(value),
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = row,
        })
        AddCorner(box, Theme.Radius.Control)
        AddStroke(box)

        local function format(nextValue)
            if item.format then
                return string.format(item.format, nextValue)
            end
            if math.floor(nextValue) == nextValue then
                return tostring(nextValue)
            end
            return string.format("%.2f", nextValue)
        end

        local function setValue(nextValue, silent)
            local raw = math.clamp(tonumber(nextValue) or value, minValue, maxValue)
            local stepped = math.floor(((raw - minValue) / step) + 0.5) * step + minValue
            value = math.clamp(stepped, minValue, maxValue)
            State:Set("number", item.key, value)
            box.Text = format(value)
            Tween(box, { TextColor3 = Theme.Colors.Text }, Theme.Animation.Fast)
            if not silent then
                State:AddLog("NUMBER", (item.title or item.key) .. " = " .. box.Text, item.key)
                Components.InvokeItem(item, { type = "number", value = value })
            end
        end

        local minus = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.Control,
            Position = UDim2.new(1, -148, 0.5, 0),
            Size = UDim2.fromOffset(28, 28),
            Text = "-",
            TextSize = 18,
            Parent = row,
        })
        AddCorner(minus, Theme.Radius.Control)
        AddStroke(minus)
        Components.Interaction(minus, Theme.Colors.Control, Theme.Colors.ControlHover, Theme.Colors.AccentDim)

        local plus = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.Control,
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.fromOffset(28, 28),
            Text = "+",
            TextSize = 18,
            Parent = row,
        })
        AddCorner(plus, Theme.Radius.Control)
        AddStroke(plus)
        Components.Interaction(plus, Theme.Colors.Control, Theme.Colors.ControlHover, Theme.Colors.AccentDim)

        minus.MouseButton1Click:Connect(function()
            setValue(value - step, false)
        end)
        plus.MouseButton1Click:Connect(function()
            setValue(value + step, false)
        end)
        box.FocusLost:Connect(function()
            setValue(box.Text, false)
        end)

        State:RegisterControl(item.key, {
            Type = "number",
            SetValue = setValue,
            GetValue = function()
                return value
            end,
        })
        if item.onChanged then
            State.OnLoad = State.OnLoad or {}
            State.OnLoad[item.key] = item.onChanged
        end

        setValue(value, true)
        return row
    end

    function Components.ColorPicker(parent, item)
        Registry.Ensure(item.key, {
            Type = "color",
            Title = item.title,
            Page = item.page,
        })

        local presets = item.presets or {
            { label = "Trace 蓝", value = Color3.fromRGB(60, 140, 255) },
            { label = "冷白", value = Color3.fromRGB(230, 236, 245) },
            { label = "雾灰", value = Color3.fromRGB(120, 130, 145) },
            { label = "柔绿", value = Color3.fromRGB(82, 180, 126) },
            { label = "琥珀", value = Color3.fromRGB(226, 176, 74) },
        }
        local value = State:Get("color", item.key, item.default or presets[1].value)

        local root = Components.ControlFrame(parent, 64)
        Components.TitleBlock(root, item, 236)

        local swatch = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = value,
            Position = UDim2.new(1, -204, 0.5, 0),
            Size = UDim2.fromOffset(30, 30),
            Parent = root,
        })
        AddCorner(swatch, Theme.Radius.Control)
        AddStroke(swatch, Theme.Colors.StrokeStrong)

        local holder = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.fromOffset(184, 30),
            Parent = root,
        })
        local layout = New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            Parent = holder,
        })

        local function setValue(nextValue, label, silent)
            value = nextValue
            State:Set("color", item.key, value)
            Tween(swatch, { BackgroundColor3 = value }, Theme.Animation.Fast)
            if not silent then
                State:AddLog("COLOR", (item.title or item.key) .. " = " .. (label or ColorToHex(value)), item.key)
                Components.InvokeItem(item, { type = "color", value = value, label = label, hex = ColorToHex(value) })
            end
        end

        for _, preset in ipairs(presets) do
            local button = New("TextButton", {
                BackgroundColor3 = preset.value,
                Size = UDim2.fromOffset(24, 24),
                Text = "",
                Parent = holder,
            })
            AddCorner(button, Theme.Radius.Pill)
            AddStroke(button, Theme.Colors.StrokeStrong)
            Components.Tooltip(button, preset.label .. " " .. ColorToHex(preset.value))
            button.MouseButton1Click:Connect(function()
                setValue(preset.value, preset.label, false)
            end)
        end

        State:RegisterControl(item.key, {
            Type = "color",
            SetValue = setValue,
            GetValue = function()
                return value
            end,
        })
        if item.onChanged then
            State.OnLoad = State.OnLoad or {}
            State.OnLoad[item.key] = item.onChanged
        end

        return root
    end

    function Components.MultiDropdown(parent, item)
        Registry.Ensure(item.key, {
            Type = "multi-dropdown",
            Title = item.title,
            Page = item.page,
        })

        local root = Components.ControlFrame(parent, 56)
        Components.TitleBlock(root, item, 230)

        local selected = State:Get("multi-dropdown", item.key, ShallowCopy(item.default or {}))
        local options = item.options or {}

        local display = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.new(1, -12, 0, 30),
            Size = UDim2.fromOffset(220, 30),
            Text = "",
            Parent = root,
        })
        AddCorner(display, Theme.Radius.Control)
        local displayStroke = AddStroke(display)
        Components.Interaction(display, Theme.Colors.PanelDeep, Theme.Colors.Control, Theme.Colors.ControlHover)

        local label = Components.Label(display, "", 13, Theme.Colors.TextMuted, false)
        label.Position = UDim2.fromOffset(8, 0)
        label.Size = UDim2.new(1, -26, 1, 0)
        label.TextTruncate = Enum.TextTruncate.AtEnd

        local arrow = Components.Label(display, "v", 13, Theme.Colors.TextDim, true)
        arrow.AnchorPoint = Vector2.new(1, 0.5)
        arrow.Position = UDim2.new(1, -8, 0.5, 0)
        arrow.Size = UDim2.fromOffset(14, 16)
        arrow.TextXAlignment = Enum.TextXAlignment.Center

        local popup = New("ScrollingFrame", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.new(0.5, 0, 0, 52.5),
            Size = UDim2.new(1, -24, 0, 0),
            Visible = false,
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarThickness = 3,
            Parent = root,
            ZIndex = 35,
        })
        AddCorner(popup, Theme.Radius.Panel)
        AddStroke(popup, Theme.Colors.Stroke)
        AddPadding(popup, 7, 7, 7, 7)
        local popupLayout = New("UIListLayout", {
            Padding = UDim.new(0, 5),
            Parent = popup,
        })
        SetScrollCanvas(popup, popupLayout, 14, "page")

        local function selectedText()
            local names = {}
            for _, option in ipairs(options) do
                local optionValue = ResolveOptionValue(option)
                if selected[optionValue] then
                    local label = item.optionLabelCallback and item.optionLabelCallback(optionValue, ResolveOptionLabel(option)) or ResolveOptionLabel(option)
                    table.insert(names, label)
                end
            end
            return #names == 0 and "未选择" or table.concat(names, ", ")
        end

        local function syncLabel()
            label.Text = selectedText()
            local hasSelected = false
            for _, enabled in pairs(selected) do
                if enabled then
                    hasSelected = true
                    break
                end
            end
            Tween(label, { TextColor3 = hasSelected and Theme.Colors.Text or Theme.Colors.TextMuted }, Theme.Animation.Fast)
            Tween(arrow, { TextColor3 = hasSelected and Theme.Colors.Accent or Theme.Colors.TextDim }, Theme.Animation.Fast)
            Tween(displayStroke, { Color = hasSelected and Theme.Colors.AccentSoft or Theme.Colors.Stroke }, Theme.Animation.Fast)
        end

        local function fire(silent)
            State:Set("multi-dropdown", item.key, selected)
            if silent then return end
            State:AddLog("MULTI", (item.title or item.key) .. " = " .. selectedText(), item.key)
            Components.InvokeItem(item, { type = "multi-dropdown", value = selected, label = selectedText() })
        end

        local openToken = 0
        local optionRows = {}

        local function paintOptions()
            for optionValue, data in pairs(optionRows) do
                local disabled = item.isOptionDisabled and item.isOptionDisabled(optionValue)
                local active = selected[optionValue] == true and not disabled
                data.Check.Text = active and "✓" or ""
                local opt = data.option
                if opt and disabled and item.optionLabelCallback then
                    data.Text.Text = item.optionLabelCallback(optionValue, ResolveOptionLabel(opt))
                elseif opt and not disabled and item.optionLabelCallback then
                    data.Text.Text = ResolveOptionLabel(opt)
                end
                Tween(data.Button, { BackgroundColor3 = disabled and Theme.Colors.ControlDim or (active and Theme.Colors.AccentDim or Theme.Colors.Control) }, Theme.Animation.Fast)
                Tween(data.Text, { TextColor3 = disabled and Theme.Colors.TextDim or (active and Theme.Colors.Text or Theme.Colors.TextMuted) }, Theme.Animation.Fast)
                if data.Stroke then
                    Tween(data.Stroke, { Color = disabled and Theme.Colors.Stroke or (active and Theme.Colors.AccentSoft or Theme.Colors.Stroke) }, Theme.Animation.Fast)
                end
            end
        end

        for _, option in ipairs(options) do
            local optionValue = ResolveOptionValue(option)
            local defaultLabel = ResolveOptionLabel(option)
            local optionLabel = item.optionLabelCallback and item.optionLabelCallback(optionValue, defaultLabel) or defaultLabel
            local optionButton = New("TextButton", {
                BackgroundColor3 = Theme.Colors.Control,
                Size = UDim2.new(1, 0, 0, 26),
                Text = "",
                Parent = popup,
                ZIndex = 36,
            })
            AddCorner(optionButton, Theme.Radius.Control)
            local optionStroke = AddStroke(optionButton)
            Components.Interaction(
                optionButton,
                function()
                    return selected[optionValue] and Theme.Colors.AccentDim or Theme.Colors.Control
                end,
                function()
                    return selected[optionValue] and Theme.Colors.AccentDim or Theme.Colors.ControlHover
                end,
                Theme.Colors.AccentDim
            )

            local check = Components.Label(optionButton, selected[optionValue] and "✓" or "", 14, Theme.Colors.Accent, true)
            check.Position = UDim2.fromOffset(8, 0)
            check.Size = UDim2.fromOffset(20, 26)
            check.TextXAlignment = Enum.TextXAlignment.Center
            check.ZIndex = 37

            local text = Components.Label(optionButton, optionLabel, 13, Theme.Colors.TextMuted, false)
            text.Position = UDim2.fromOffset(34, 0)
            text.Size = UDim2.new(1, -42, 1, 0)
            text.TextTruncate = Enum.TextTruncate.AtEnd
            text.ZIndex = 37
            optionRows[optionValue] = {
                Button = optionButton,
                Check = check,
                Text = text,
                Stroke = optionStroke,
                option = option,
            }

            optionButton.MouseButton1Click:Connect(function()
                if item.isOptionDisabled and item.isOptionDisabled(optionValue) then return end
                selected[optionValue] = not selected[optionValue] or nil
                syncLabel()
                paintOptions()
                fire()
            end)
        end

        local popupHeight = 170

        local function setOpen(open)
            openToken += 1
            local token = openToken
            arrow.Text = open and "^" or "v"
            if open then
                popup.Visible = true
                popup.BackgroundTransparency = 1
                popup.Size = UDim2.new(1, -24, 0, 1)
                local optionCount = #options
                local itemH = 26
                local gap = 5
                local padding = 14
                local h = optionCount * itemH + math.max(optionCount - 1, 0) * gap + padding
                task.defer(function()
                    if token ~= openToken then return end
                    Tween(popup, {
                        BackgroundTransparency = 0,
                        Size = UDim2.new(1, -24, 0, h),
                    }, Theme.Animation.Normal)
                    Tween(root, { Size = UDim2.new(1, 0, 0, 60 + h) }, Theme.Animation.Normal)
                end)
            else
                Tween(popup, {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -24, 0, 1),
                }, Theme.Animation.Normal)
                Tween(root, { Size = UDim2.new(1, 0, 0, 56) }, Theme.Animation.Normal)
                task.delay(Theme.Animation.Normal + 0.03, function()
                    if popup and popup.Parent and token == openToken then
                        popup.Visible = false
                    end
                end)
            end
            RefreshContentCanvas()
        end

        display.MouseButton1Click:Connect(function()
            setOpen(not popup.Visible)
        end)

        State:RegisterControl(item.key, {
            Type = "multi-dropdown",
            SetValue = function(nextValue, silent)
                selected = ShallowCopy(nextValue or {})
                syncLabel()
                paintOptions()
                fire(silent)
            end,
            GetValue = function()
                return selected
            end,
        })
        if item.onChanged then
            State.OnLoad = State.OnLoad or {}
            State.OnLoad[item.key] = item.onChanged
        end

        syncLabel()
        paintOptions()
        return root
    end

    function Components.Keybind(parent, item)
        Registry.Ensure(item.key, {
            Type = "keybind",
            Title = item.title,
            Page = item.page,
        })

        local value = State.Keybinds[item.key] or item.default or "未绑定"
        local row = Components.ControlFrame(parent, 48)
        Components.TitleBlock(row, item, 140)

        local button = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.fromOffset(116, 28),
            Text = tostring(value),
            TextColor3 = Theme.Colors.TextMuted,
            TextSize = 13,
            Parent = row,
        })
        AddCorner(button, Theme.Radius.Control)
        AddStroke(button)
        Components.Interaction(button, Theme.Colors.PanelDeep, Theme.Colors.Control, Theme.Colors.ControlHover)

        local waiting = false
        local normalStroke = button:FindFirstChildOfClass("UIStroke")
        button.MouseButton1Click:Connect(function()
            waiting = true
            button.Text = "按下按键..."
            Tween(button, { BackgroundColor3 = Theme.Colors.AccentDim, TextColor3 = Theme.Colors.Text }, Theme.Animation.Fast)
            if normalStroke then
                Tween(normalStroke, { Color = Theme.Colors.AccentSoft }, Theme.Animation.Fast)
            end
            State:AddLog("UI", "等待键位绑定: " .. (item.title or item.key), item.key)
        end)

        UI.Track(Services.UserInputService.InputBegan:Connect(function(input, processed)
            if not waiting or processed then
                return
            end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end
            waiting = false
            value = input.KeyCode.Name
            State.Keybinds[item.key] = value
            button.Text = value
            Tween(button, { BackgroundColor3 = Theme.Colors.PanelDeep, TextColor3 = Theme.Colors.TextMuted }, Theme.Animation.Fast)
            if normalStroke then
                Tween(normalStroke, { Color = Theme.Colors.Stroke }, Theme.Animation.Fast)
            end
            State:AddLog("KEY", (item.title or item.key) .. " = " .. value, item.key)
            Components.InvokeItem(item, { type = "keybind", value = value })
        end), "page")

        return row
    end

    function Components.Progress(parent, item)
        if not item.internal then
            Registry.Ensure(item.key, {
                Type = "progress",
                Title = item.title,
                Page = item.page,
                Internal = item.internal == true,
            })
        end

        local value = math.clamp(item.value or item.default or 0, 0, 1)
        local row = Components.ControlFrame(parent, 58)
        Components.TitleBlock(row, item, 120)

        local valueLabel = Components.Label(row, string.format("%d%%", value * 100), 13, Theme.Colors.TextMuted, true)
        valueLabel.AnchorPoint = Vector2.new(1, 0)
        valueLabel.Position = UDim2.new(1, -12, 0, 9)
        valueLabel.Size = UDim2.fromOffset(70, 18)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local bar = New("Frame", {
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.new(0, 12, 1, -20),
            Size = UDim2.new(1, -24, 0, 8),
            Parent = row,
        })
        AddCorner(bar, Theme.Radius.Pill)

        local fill = New("Frame", {
            BackgroundColor3 = item.color or Theme.Colors.Accent,
            Size = UDim2.new(value, 0, 1, 0),
            Parent = bar,
        })
        AddCorner(fill, Theme.Radius.Pill)

        return row
    end

    function Components.TagRow(parent, item)
        if not item.internal then
            Registry.Ensure(item.key, {
                Type = "tags",
                Title = item.title,
                Page = item.page,
                Internal = true,
            })
        end

        local row = Components.ControlFrame(parent, 58)
        Components.TitleBlock(row, item, 300)

        local holder = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.fromOffset(280, 28),
            Parent = row,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = holder,
        })

        for _, tag in ipairs(item.tags or {}) do
            local tagLabel = Components.Label(holder, type(tag) == "table" and tag.label or tostring(tag), 12, Theme.Colors.TextMuted, true)
            tagLabel.BackgroundColor3 = type(tag) == "table" and (tag.color or Theme.Colors.Control) or Theme.Colors.Control
            tagLabel.BackgroundTransparency = 0
            tagLabel.Size = UDim2.fromOffset(type(tag) == "table" and (tag.width or 62) or 62, 24)
            tagLabel.TextXAlignment = Enum.TextXAlignment.Center
            AddCorner(tagLabel, Theme.Radius.Pill)
            AddStroke(tagLabel)
        end

        return row
    end

    function Components.Table(parent, item)
        if not item.internal then
            Registry.Ensure(item.key, {
                Type = "table",
                Title = item.title,
                Page = item.page,
                Internal = true,
            })
        end

        local rows = item.rows or {}
        if type(rows) == "function" then
            local ok, result = pcall(rows)
            rows = ok and result or {}
        end

        local columns = item.columns or {
            { key = "name", label = "名称", width = 0.45 },
            { key = "value", label = "值", width = 0.55 },
        }

        local root = New("Frame", {
            BackgroundColor3 = Theme.Colors.Card,
            Size = UDim2.new(1, 0, 0, math.max(90, 34 + (#rows * 30))),
            Parent = parent,
        })
        AddCorner(root, Theme.Radius.Panel)
        AddStroke(root)
        AddPadding(root, 10, 10, 10, 10)

        local header = New("Frame", {
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Size = UDim2.new(1, 0, 0, 34),
            Parent = root,
        })
        AddCorner(header, Theme.Radius.Control)

        local xOffset = 0
        for _, column in ipairs(columns) do
            local label = Components.Label(header, column.label, 12, Theme.Colors.TextDim, true)
            label.Position = UDim2.new(xOffset, 8, 0, 0)
            label.Size = UDim2.new(column.width, -10, 1, 0)
            xOffset += column.width
        end

        local y = 34
        for _, row in ipairs(rows) do
            local line = New("Frame", {
                BackgroundColor3 = Theme.Colors.Control,
                BackgroundTransparency = 0.25,
                Position = UDim2.fromOffset(0, y),
                Size = UDim2.new(1, 0, 0, 26),
                Parent = root,
            })
            AddCorner(line, Theme.Radius.Control)

            xOffset = 0
            for _, column in ipairs(columns) do
                local value = row[column.key]
                local cell = Components.Label(line, tostring(value or ""), 12, Theme.Colors.TextMuted, false)
                cell.Position = UDim2.new(xOffset, 8, 0, 0)
                cell.Size = UDim2.new(column.width, -10, 1, 0)
                cell.TextTruncate = Enum.TextTruncate.AtEnd
                xOffset += column.width
            end
            y += 30
        end

        return root
    end

    function Components.StatusLabel(parent, item)
        if not item.internal then
            Registry.Ensure(item.key, {
                Type = "status",
                Title = item.title,
                Page = item.page,
                Internal = true,
            })
        end

        local row = Components.ControlFrame(parent, 44)
        Components.TitleBlock(row, item, 130)

        local resolvedValue = item.value
        if type(resolvedValue) == "function" then
            local ok, result = pcall(resolvedValue)
            resolvedValue = ok and result or "读取失败"
        end

        local badge = Components.Label(row, resolvedValue or "待定", 13, Theme.Colors.Text, true)
        badge.AnchorPoint = Vector2.new(1, 0.5)
        badge.BackgroundColor3 = Theme.Colors.AccentDim
        badge.BackgroundTransparency = 0
        badge.Position = UDim2.new(1, -12, 0.5, 0)
        badge.Size = UDim2.fromOffset(100, 24)
        badge.TextXAlignment = Enum.TextXAlignment.Center
        AddCorner(badge, Theme.Radius.Control)
        AddStroke(badge, Theme.Colors.AccentSoft)

        State:RegisterControl(item.key, {
            Type = "status",
            SetValue = function(_, value)
                if type(value) ~= "string" then return end
                badge.Text = value
            end,
            GetValue = function()
                return badge.Text
            end,
        })

        return row
    end

    function Components.ListItem(parent, item)
        if not item.internal then
            Registry.Ensure(item.key, {
                Type = "list-item",
                Title = item.title,
                Page = item.page,
                Internal = item.internal == true,
            })
        end

        local row = Components.ControlFrame(parent, item.desc and 52 or 36)
        Components.TitleBlock(row, item, item.badge and 110 or 24)

        if item.badge then
            local badge = Components.Label(row, item.badge, 12, Theme.Colors.TextMuted, true)
            badge.AnchorPoint = Vector2.new(1, 0.5)
            badge.BackgroundColor3 = Theme.Colors.Control
            badge.BackgroundTransparency = 0
            badge.Position = UDim2.new(1, -12, 0.5, 0)
            badge.Size = UDim2.fromOffset(86, 22)
            badge.TextXAlignment = Enum.TextXAlignment.Center
            AddCorner(badge, Theme.Radius.Control)
        end

        return row
    end

    function Components.CategoryCard(parent, item)
        Registry.Ensure(item.key, {
            Type = "category-card",
            Title = item.title,
            Page = item.page,
            TargetPage = item.targetPage,
            Internal = true,
        })

        local button = New("TextButton", {
            BackgroundColor3 = Theme.Colors.Card,
            Size = UDim2.new(1, 0, 0, 58),
            Text = "",
            Parent = parent,
        })
        AddCorner(button, Theme.Radius.Panel)
        AddStroke(button)
        Components.Interaction(button, Theme.Colors.Card, Theme.Colors.CardHover, Theme.Colors.ControlHover)
        local cardScale = New("UIScale", { Scale = 1, Parent = button })
        button.MouseEnter:Connect(function()
            Tween(cardScale, { Scale = 1.02 }, Theme.Animation.Normal)
        end)
        button.MouseLeave:Connect(function()
            Tween(cardScale, { Scale = 1 }, Theme.Animation.Normal)
        end)

        local icon = Components.Label(button, item.icon or ">", 18, Theme.Colors.Accent, true)
        icon.BackgroundColor3 = Theme.Colors.AccentDim
        icon.BackgroundTransparency = 0
        icon.Position = UDim2.fromOffset(12, 11)
        icon.Size = UDim2.fromOffset(36, 36)
        icon.TextXAlignment = Enum.TextXAlignment.Center
        AddCorner(icon, Theme.Radius.Control)
        AddStroke(icon, Theme.Colors.AccentSoft)

        local title = Components.Label(button, item.title, 16, Theme.Colors.Text, true)
        title.Position = UDim2.fromOffset(58, 8)
        title.Size = UDim2.new(1, -112, 0, 20)

        local desc = Components.Label(button, item.desc, 13, Theme.Colors.TextDim, false)
        desc.Position = UDim2.fromOffset(58, 30)
        desc.Size = UDim2.new(1, -112, 0, 18)
        desc.TextTruncate = Enum.TextTruncate.AtEnd

        local arrow = Components.Label(button, ">", 18, Theme.Colors.TextDim, true)
        arrow.AnchorPoint = Vector2.new(1, 0.5)
        arrow.Position = UDim2.new(1, -14, 0.5, 0)
        arrow.Size = UDim2.fromOffset(20, 24)
        arrow.TextXAlignment = Enum.TextXAlignment.Center

        button.MouseButton1Click:Connect(function()
            if item.targetPage then
                UI.SetPage(item.targetPage)
            end
            State:AddLog("UI", "进入 " .. (item.title or item.targetPage or ""), item.key)
        end)

        return button
    end

    function Components.Collapsible(parent, item)
        Registry.Ensure(item.key, {
            Type = "collapsible-group",
            Title = item.title,
            Page = item.page,
            Internal = true,
        })

        local root = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = parent,
        })

        local layout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = root,
        })

        local header = New("TextButton", {
            BackgroundColor3 = Theme.Colors.Control,
            Size = UDim2.new(1, 0, 0, 38),
            Text = "",
            Parent = root,
        })
        AddCorner(header, Theme.Radius.Panel)
        AddStroke(header)
        Components.Interaction(header, Theme.Colors.Control, Theme.Colors.ControlHover, Theme.Colors.AccentDim)

        local arrow = Components.Label(header, "v", 14, Theme.Colors.TextDim, true)
        arrow.Position = UDim2.fromOffset(12, 0)
        arrow.Size = UDim2.fromOffset(18, 38)
        arrow.TextXAlignment = Enum.TextXAlignment.Center

        local title = Components.Label(header, item.title or "分组", 16, Theme.Colors.Text, true)
        title.Position = UDim2.fromOffset(36, 0)
        title.Size = UDim2.new(1, -48, 1, 0)

        local content = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true,
            Parent = root,
        })

        local contentLayout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = content,
        })

        local collapsed = State.Collapsed[item.key] == true

        local function getContentHeight()
            return contentLayout.AbsoluteContentSize.Y + 8
        end

        local animToken = 0
        local function animate(expand)
            animToken += 1
            local token = animToken
            if expand then
                content.Visible = true
                content.Size = UDim2.new(1, 0, 0, 0)
                task.defer(function()
                    if token ~= animToken then return end
                    local h = getContentHeight()
                    Tween(content, { Size = UDim2.new(1, 0, 0, h) }, Theme.Animation.Normal)
                end)
            else
                local cur = content.AbsoluteSize.Y
                if cur > 0 then
                    Tween(content, { Size = UDim2.new(1, 0, 0, 1) }, Theme.Animation.Fast)
                    task.delay(Theme.Animation.Fast + 0.03, function()
                        if token == animToken then
                            content.Visible = false
                        end
                    end)
                else
                    content.Visible = false
                end
            end
        end

        header.MouseButton1Click:Connect(function()
            collapsed = not collapsed
            State.Collapsed[item.key] = collapsed
            arrow.Text = collapsed and ">" or "v"
            animate(not collapsed)
            State:AddLog("UI", (collapsed and "折叠 " or "展开 ") .. (item.title or item.key), item.key)
        end)

        if collapsed then
            content.Visible = false
            content.Size = UDim2.new(1, 0, 0, 0)
        else
            task.defer(function()
                local h = getContentHeight()
                content.Size = UDim2.new(1, 0, 0, h)
            end)
        end
        return root, content
    end

    function Components.LogOutput(parent, item)
        Registry.Ensure(item.key, {
            Type = "log-output",
            Title = item.title,
            Page = item.page,
            Internal = true,
        })

        local root = New("Frame", {
            BackgroundColor3 = Theme.Colors.Card,
            Size = UDim2.new(1, 0, 0, 300),
            Parent = parent,
        })
        AddCorner(root, Theme.Radius.Panel)
        AddStroke(root)
        AddPadding(root, 10, 10, 10, 10)

        local header = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 32),
            Parent = root,
        })

        local title = Components.Label(header, item.title or "日志输出", 17, Theme.Colors.Text, true)
        title.Size = UDim2.new(1, -100, 1, 0)

        local clear = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Theme.Colors.Control,
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(84, 26),
            Text = "清空",
            TextSize = 14,
            TextColor3 = Theme.Colors.TextMuted,
            Parent = header,
        })
        AddCorner(clear, Theme.Radius.Control)
        AddStroke(clear)
        Components.Interaction(clear, Theme.Colors.Control, Theme.Colors.ControlHover, Theme.Colors.AccentDim)

        Registry.Ensure(item.clearKey or "logs.clear", {
            Type = "button",
            Title = "清空日志",
            Page = item.page,
            Internal = true,
        })

        clear.MouseButton1Click:Connect(function()
            State:ClearLogs()
            State:AddLog("UI", "日志已清空", item.clearKey or "logs.clear")
        end)

        local scroller = New("ScrollingFrame", {
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.fromOffset(0, 38),
            Size = UDim2.new(1, 0, 1, -38),
            CanvasSize = UDim2.fromOffset(0, 0),
            Parent = root,
        })
        AddCorner(scroller, Theme.Radius.Control)
        AddStroke(scroller)
        AddPadding(scroller, 8, 8, 8, 8)

        local layout = New("UIListLayout", {
            Padding = UDim.new(0, 5),
            Parent = scroller,
        })
        SetScrollCanvas(scroller, layout, 16, "log")

        UI.LogList = scroller
        UI.RefreshLogs()
        return root
    end

    function Components.SearchBox(parent)
        local box = New("TextBox", {
            BackgroundColor3 = Theme.Colors.PanelDeep,
            PlaceholderText = "搜索 key / 标题 / 描述",
            Size = UDim2.fromOffset(250, 30),
            Text = State.SearchText,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = parent,
        })
        AddCorner(box, Theme.Radius.Control)
        AddStroke(box)
        AddPadding(box, 9, 9, 0, 0)

        box:GetPropertyChangedSignal("Text"):Connect(function()
            local previousText = State.SearchText or ""
            State.SearchText = box.Text
            if State.SearchScope == "global" and box.Text ~= "" then
                if State.CurrentPage ~= "search" then
                    State.SearchReturnPage = State.CurrentPage
                end
                State.CurrentPage = "search"
                UI.UpdateSidebar()
            elseif State.SearchScope == "global" and previousText ~= "" and box.Text == "" and State.CurrentPage == "search" then
                local returnPage = State.SearchReturnPage or AppConfig.DefaultPage
                if Pages.ById[returnPage] then
                    State.CurrentPage = returnPage
                    UI.UpdateSidebar()
                end
            end
            if UI.RenderPage then
                UI.RenderPage(State.CurrentPage)
            end
        end)

        return box
    end

    function Components.Marquee(parent, text)
        local root = New("Frame", {
            BackgroundColor3 = Theme.Colors.PanelDeep,
            ClipsDescendants = true,
            Size = UDim2.fromOffset(250, 30),
            Parent = parent,
        })
        AddCorner(root, Theme.Radius.Control)

        local label = Components.Label(root, text or "", 14, Theme.Colors.TextMuted, false)
        label.Name = "MarqueeText"
        label.AnchorPoint = Vector2.new(0, 0.5)
        label.Position = UDim2.new(0, 0, 0.5, 0)
        label.Size = UDim2.new(0, 0, 0, root.Size.Y.Offset)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextTruncate = Enum.TextTruncate.None

        local function start()
            UI.MarqueeToken += 1
            local token = UI.MarqueeToken
            task.defer(function()
                task.wait()
                while root and root.Parent and token == UI.MarqueeToken do
                    local rootWidth = math.max(root.AbsoluteSize.X, 1)
                    local textWidth = Services.TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(math.huge, root.AbsoluteSize.Y)).X
                    label.Size = UDim2.fromOffset(textWidth, root.AbsoluteSize.Y)
                    label.Position = UDim2.new(0, rootWidth + 100, 0.5, 0)
                    task.wait()

                    local distance = rootWidth + textWidth + 100
                    local duration = math.max(distance / 72, 1.2) / 1.2
                    local tween = Tween(label, {
                        Position = UDim2.new(0, -textWidth, 0.5, 0),
                    }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    if tween then
                        tween.Completed:Wait()
                    else
                        task.wait(duration)
                    end
                end
            end)
        end

        start()
        return root
    end


    function Components.LockOverlay(parent, text)
        local overlay = Instance.new("TextButton")
        overlay.BackgroundColor3 = Theme.Colors.Card
        overlay.BackgroundTransparency = 0.9
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.Position = UDim2.fromOffset(0, 0)
        overlay.Text = ""
        overlay.AutoButtonColor = false
        overlay.BorderSizePixel = 0
        overlay.Parent = parent
        overlay.ZIndex = 50
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
        corner.Parent = overlay
        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.Colors.Stroke
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = overlay
        -- Lock icon
        local icon = Instance.new("ImageLabel")
        icon.Image = "rbxassetid://124695679871798"
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, 28, 0, 28)
        icon.Position = UDim2.new(0.5, -14, 0.32, -14)
        icon.ImageColor3 = Theme.Colors.TextMuted
        icon.ImageTransparency = 0.25
        icon.ZIndex = 51
        icon.Parent = overlay
        -- Hint text
        local hint = Instance.new("TextLabel")
        hint.Text = text or "当前功能未开发。后续将会挨个补齐。"
        hint.BackgroundTransparency = 1
        hint.Size = UDim2.new(1, -24, 0, 24)
        hint.Position = UDim2.new(0, 12, 0.58, 0)
        hint.TextSize = 15
        hint.TextColor3 = Theme.Colors.TextDim
        hint.TextXAlignment = Enum.TextXAlignment.Center
        hint.TextYAlignment = Enum.TextYAlignment.Top
        hint.Font = Theme.Font
        hint.ZIndex = 51
        hint.Parent = overlay
        return overlay
    end

function AddPage(page)
        table.insert(Pages.List, page)
        Pages.ById[page.id] = page
    end

    local function Option(label, value)
        return {
            label = label,
            value = value,
        }
    end

    AddPage({
        id = "server",
        title = "服务器",
        icon = "S",
        subtitle = "请选择要跳转的服务器",
        sections = {
            {
                title = "服务器列表",
                items = {
                    { type = "status", key = "server.info", title = "服务器功能", desc = "请选择合适的服务器进行跳转", value = "就绪" },
                },
            },
            {
                title = "⚔️ Combat Warriors / 战斗勇士",
                items = {
                    { type = "button", key = "server.s_0", title = "战斗勇士Hydra Hub V2", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "⚔️ Entrenched",
                items = {
                    { type = "button", key = "server.s_1", title = "根深蒂固ww1脚本", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "⚽ Blade Ball / 刀刃球",
                items = {
                    { type = "button", key = "server.s_2", title = "刀刃球3", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_3", title = "刀刃球世界最强脚本uwuKenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_4", title = "刀刃球nodex脚本Kenny汉化", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🇺🇸 Ohio / 俄亥俄州",
                items = {
                    { type = "button", key = "server.s_5", title = "俄亥俄州(1) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_6", title = "俄亥俄州脚本BRUH (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_7", title = "俄亥俄州子追秒开保险柜脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_8", title = "Ohio Blade Spam", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "✨ 飞行脚本（通用）",
                items = {
                    { type = "button", key = "server.s_9", title = "飞行脚本", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "✨ FE 通用脚本",
                items = {
                    { type = "button", key = "server.s_10", title = "猎杀僵尸zeehubKenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_11", title = "找僵尸马", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_12", title = "FE Goner Hat Script 通用 DA 引擎盖支持(通用)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_13", title = "FE僵尸脚本支持R6", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_14", title = "fe热更改虚拟形象", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_15", title = "FE隐形", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_16", title = "FE拥抱脚本(3)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_17", title = "FE指令", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🌌 星体犯罪 / Criminality",
                items = {
                    { type = "button", key = "server.s_18", title = "femware(犯罪脚本) (2)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🌙 99夜 / 森林中的99夜",
                items = {
                    { type = "button", key = "server.s_19", title = "99夜虚空简体汉化脚本（无卡密）", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_20", title = "99夜虚空脚本Kenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_21", title = "99夜op级汉化脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_22", title = "二狗子森林中的99夜脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_23", title = "森林里的99夜Cps natural脚本（个人感觉比虚空强）Kenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_24", title = "森林中的99夜H4x脚本小鱼仙汉化(完整汉化版)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_25", title = "L l森林99夜(1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🍂 落叶中心",
                items = {
                    { type = "button", key = "server.s_26", title = "落叶中心", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🍽️ Restaurant Tycoon",
                items = {
                    { type = "button", key = "server.s_27", title = "我的餐厅自动烹饪自动送餐生意金额超多", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🎀 AUT",
                items = {
                    { type = "button", key = "server.s_28", title = "AUT脚本VellureKenny汉化+破解卡密验证", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🏴‍☠️ Blox Fruits / 海贼王",
                items = {
                    { type = "button", key = "server.s_29", title = "海贼王9大超级脚本(1) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_30", title = "造船", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_31", title = "bf脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_32", title = "bf脚本 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_33", title = "bf脚本好用的(1) (1) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_34", title = "blox fruits汉化脚本-redz (1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🐉 龙脚本",
                items = {
                    { type = "button", key = "server.s_35", title = "龙脚本(破解版)(1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🐝 Bee Swarm Simulator",
                items = {
                    { type = "button", key = "server.s_36", title = "kometa蜂群(1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🐟 Fisch / 钓鱼",
                items = {
                    { type = "button", key = "server.s_37", title = "冰上钓鱼模拟器 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_38", title = "fisch脚本（无需卡密）", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "👑 King’s Legacy / 国王遗产",
                items = {
                    { type = "button", key = "server.s_39", title = "国王遗产通用免费脚本", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "👽 AlienX",
                items = {
                    { type = "button", key = "server.s_40", title = "AlienX-NOL (1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "💀 WTB / 被遗弃",
                items = {
                    { type = "button", key = "server.s_41", title = "被遗弃", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_42", title = "被遗弃虚空汉化脚本 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_43", title = "WTB--新版 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_44", title = "WTB-被遗弃 (1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "💣 Saboteur / 破坏者",
                items = {
                    { type = "button", key = "server.s_45", title = "破坏者谜团2很多功能脚本", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "💪 Arm Wrestling Simulator",
                items = {
                    { type = "button", key = "server.s_46", title = "掰手腕模拟器", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "📂 脚本中心 / Hub",
                items = {
                    { type = "button", key = "server.s_47", title = "北极星中心V3(1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_48", title = "脚本中心脚本（有各种脚本）", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_49", title = "天空脚本中心正式版 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_50", title = "Fish It脚本Lonely_HubKenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_51", title = "Fish It脚本VinzHubKenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_52", title = "Oily Hub-破解白名单", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_53", title = "Rb脚本中心---Yungengxin", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "📜 白脚本合集",
                items = {
                    { type = "button", key = "server.s_54", title = "白脚本白名单破解", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_55", title = "白脚本最新(1)(1) (1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "📜 叶脚本合集",
                items = {
                    { type = "button", key = "server.s_56", title = "叶脚本-河北唐县 (1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "📜 夜脚本合集",
                items = {
                    { type = "button", key = "server.s_57", title = "夜脚本 (1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "📦 皮脚本合集",
                items = {
                    { type = "button", key = "server.s_58", title = "皮脚本 (4)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_59", title = "皮脚本 ohio ", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_60", title = "皮脚本-Rooms&doors(1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "📦 其他脚本",
                items = {
                    { type = "button", key = "server.s_61", title = "巴掌最强脚本（快速刷巴掌，回忆踢人，向导全自动）", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_62", title = "创世纪FE脚本-猫娘", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_63", title = "德育中山垃圾亡命速递源码", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_64", title = "丁丁脚本VB抢先版 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_65", title = "犯罪汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_66", title = "犯罪脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_67", title = "犯罪脚本(英文天脚本同款) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_68", title = "红木监狱脚本Kenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_69", title = "后门整合包(1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_70", title = "狐--RC最新版", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_71", title = "竞争对手Lexus汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_72", title = "空脚本源码", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_73", title = "脑红（78无卡密）", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_74", title = "无卡密版乱码脚本（Kenny）", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_75", title = "无卡密画我脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_76", title = "隐身打飞别人(需要键盘)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_77", title = "长途", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_78", title = "找熔岩马", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_79", title = "aimbot瞄准机器人", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_80", title = "BF现版本刷级最强(1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_81", title = "BS脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_82", title = "cw超级暴力脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_83", title = "cw游戏脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_84", title = "Doors BlackKing (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_85", title = "dxgui第四版", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_86", title = "Fish It脚本CelestialKenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_87", title = "forsaken自动杀戮,自动引导修机(1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_88", title = "lyy-ohio-自动换服开保险-公益(1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_89", title = "OE我们的处决", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_90", title = "REAL X DY Loader", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_91", title = "roblox2025最新孵化之旅脚本(1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_92", title = "RTX脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_93", title = "snow Ohio源码", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_94", title = "TX退休脚本V2 (2)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🔒 监狱人生 / Prison Life",
                items = {
                    { type = "button", key = "server.s_95", title = "监狱人生(开挂人生)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_96", title = "监狱人生（直接获得ak和传送）", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_97", title = "监狱人生吊打一切脚本 (2)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_98", title = "监狱人生新菜单(1) (1) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_99", title = "监狱人生の脚本2号", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_100", title = "ASH监狱人生脚本", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🔥 Kaboom / 禁漫中心",
                items = {
                    { type = "button", key = "server.s_101", title = "禁漫中心", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🔫 兵工厂 / Arsenal",
                items = {
                    { type = "button", key = "server.s_102", title = "兵工厂超级强脚本Tbao中心Kenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_103", title = "兵工厂锂", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_104", title = "兵工厂Weed脚本Kenny汉化", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🖋️ Ink Game / 墨水游戏",
                items = {
                    { type = "button", key = "server.s_105", title = "墨水游戏汉化 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_106", title = "墨水游戏汉化脚本-Ringta", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_107", title = "墨水游戏汉化脚本(目前第二强)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_108", title = "墨水游戏汉化脚本(修复版) (1) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_109", title = "墨水游戏ax汉化脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_110", title = "墨水游戏Ringta脚本Kenny汉化", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🦑 Squid Game / 鱿鱼游戏",
                items = {
                    { type = "button", key = "server.s_111", title = "鱿鱼游戏脚本", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🧠 Steal a Brainrot / 偷走脑红",
                items = {
                    { type = "button", key = "server.s_112", title = "偷走脑红_AC_反作弊绕过", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_113", title = "偷走脑红汉化脚本(by 晓月lol) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_114", title = "偷走脑红红辣椒脚本Kenny汉化", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🧱 方块故事 / Block Tales",
                items = {
                    { type = "button", key = "server.s_115", title = "方块故事tex脚本Kenny汉化", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🪖 战争大亨 / War Tycoon",
                items = {
                    { type = "button", key = "server.s_116", title = "战争大亨整合", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🪵 伐木大亨 / Lumber Tycoon 2",
                items = {
                    { type = "button", key = "server.s_117", title = "伐木大亨 2 10 复制(1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_118", title = "伐木大亨2复制脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_119", title = "伐木大亨2最强 LuaWare (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_120", title = "伐木大亨外挂 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_121", title = "伐木原版op", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_122", title = "黄油轮毂（伐木）", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_123", title = "极狐木材大亨2破解版(1)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🚂 Dead Rails / 死铁轨",
                items = {
                    { type = "button", key = "server.s_124", title = "死铁轨超强红叶脚本Kenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_125", title = "死铁轨脚本大全整合3 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_126", title = "死铁轨近战增强脚本Kenny汉化 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_127", title = "死铁轨强力挥击Kenny汉化", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_128", title = "死铁轨找闪电马，飞行脚本(2)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_129", title = "死铁轨自动刷债券(没有卡密)v2", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_130", title = "死铁轨自动刷债券(无卡密) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_131", title = "RINGTA死铁轨Kenny汉化", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🚓 越狱 / Jailbreak",
                items = {
                    { type = "button", key = "server.s_132", title = "越狱 AUTOFARM 脚本", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_133", title = "越狱优质脚本", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🚗 一路向西 / Westbound",
                items = {
                    { type = "button", key = "server.s_134", title = "一路向西脚本 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_135", title = "一路向西GUI", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🚗 Driving Empire",
                items = {
                    { type = "button", key = "server.s_136", title = "驾驶帝国自动农场", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🚪 DOORS / Rooms",
                items = {
                    { type = "button", key = "server.s_137", title = "鬼脚本源码", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_138", title = "小黑子脚本(超多脚本) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_139", title = "DOORS VYNIXU GUI - VERY OVERPOWERED", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_140", title = "doors（外网搬）手机可用 (1) (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_141", title = "NB DOORS压力脚本", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🚪 DOORS / Rooms（门）",
                items = {
                    { type = "button", key = "server.s_142", title = "门ms4", desc = "点击执行脚本", actionText = "执行" }
                },
            },
            {
                title = "🚪 DOORS / Rooms（压力）",
                items = {
                    { type = "button", key = "server.s_143", title = "压力脚本 (1)", desc = "点击执行脚本", actionText = "执行" },
                    { type = "button", key = "server.s_144", title = "压力脚本 (3)", desc = "点击执行脚本", actionText = "执行" }
                },
            },
        },
    })

    AddPage({
        id = "autotranslate",
        title = "自动汉化",
        icon = "T",
        subtitle = "自动汉化设置",
        sections = {
            {
                title = "汉化功能",
                items = {
                    { type = "status", key = "translate.status", title = "汉化状态", desc = "自动汉化尚未实装", value = "待开发" },
                },
            },
        },
    })

    AddPage({
        id = "about",
        title = "关于",
        icon = "I",
        subtitle = "脚本信息中心",
        sections = {
            {
                title = "脚本信息",
                items = {
                    { type = "status", key = "about.version", title = "当前版本", desc = "跳转中心", value = "1.0.1" },
                    { type = "status", key = "about.ui_version", title = "当前UI版本", desc = "当前UI为无描边边框版本", value = "3.0" },
                    { type = "status", key = "about.author", title = "创作者", value = "青木" },
                    { type = "status", key = "about.encrypt", title = "加密脚本贡献者", value = "Yeskid" },
                    { type = "status", key = "about.ui_idea", title = "Ui想法者", value = "青木" },
                },
            },
            {
                title = "贡献者",
                items = {
                    { type = "status", key = "about.contributor.guajianxiu", title = "挂剑修十二宗万岁(时杀)", value = "贡献者" },
                    { type = "status", key = "about.contributor.yuki", title = "yuki", value = "贡献者" },
                    { type = "status", key = "about.contributor.yeskid", title = "Yeskid", value = "贡献者" },
                    { type = "status", key = "about.contributor.zzc", title = "叫我zzc就好了", value = "贡献者" },
                },
            },
        },
    })

    local function RegisterItems(page, section, items)
        for _, item in ipairs(items or {}) do
            item.page = page.id

            if item.key then
                Registry.Ensure(item.key, {
                    Type = item.type,
                    Title = item.title,
                    Page = page.id,
                    Section = section and section.title or nil,
                    Internal = item.internal == true,
                })
            end

            if item.items then
                RegisterItems(page, section, item.items)
            end
        end
    end

    local function RegisterPageKeys()
        for _, page in ipairs(Pages.List) do
            if page.sections then
                for _, section in ipairs(page.sections) do
                    RegisterItems(page, section, section.items)
                end
            end

            if page.subcategories then
                Registry.Ensure("page." .. page.id .. ".subcategory", {
                    Type = "segment",
                    Title = page.title .. "子分类",
                    Page = page.id,
                    Internal = true,
                })

                for _, subcategory in ipairs(page.subcategories) do
                    for _, section in ipairs(subcategory.sections or {}) do
                        RegisterItems(page, section, section.items)
                    end
                end
            end
        end

        Registry.Ensure("topbar.marquee", { Type = "marquee", Title = "顶部走马灯", Internal = true })
        Registry.Ensure("window.minimize", { Type = "icon-button", Title = "最小化", Internal = true })
        Registry.Ensure("window.close", { Type = "icon-button", Title = "关闭", Internal = true })
        Registry.Ensure("window.restore", { Type = "button", Title = "恢复窗口", Internal = true })
    end

    function UI.GetScreenParent()
        local candidates = {}

        local okHui, hui = pcall(function()
            if gethui then
                return gethui()
            end
            return nil
        end)

        if okHui and hui then
            table.insert(candidates, hui)
        end

        table.insert(candidates, Services.CoreGui)

        local localPlayer = Services.Players.LocalPlayer
        if localPlayer then
            table.insert(candidates, localPlayer:WaitForChild("PlayerGui"))
        end

        for _, candidate in ipairs(candidates) do
            local testGui = Instance.new("ScreenGui")
            local ok = pcall(function()
                testGui.Parent = candidate
            end)
            testGui:Destroy()

            if ok then
                return candidate
            end
        end

        return Services.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    function UI.GetWindowPresetSize()
        for _, preset in ipairs(AppConfig.WindowPresets) do
            if preset.value == State.WindowPreset then
                return preset.size
            end
        end

        return AppConfig.WindowSize
    end

    function UI.GetBoundedWindowSize(targetSize)
        targetSize = targetSize or UI.GetWindowPresetSize()
        if not UI.RootGui then
            return targetSize
        end

        local rootSize = UI.RootGui.AbsoluteSize
        if rootSize.X <= 0 or rootSize.Y <= 0 then
            return targetSize
        end

        local scale = math.max(State.DpiScale or 1, 0.01)
        local maxWidth = math.max(1, math.floor((rootSize.X - 24) / scale))
        local maxHeight = math.max(1, math.floor((rootSize.Y - 24) / scale))

        return Vector2.new(math.min(targetSize.X, maxWidth), math.min(targetSize.Y, maxHeight))
    end

    function UI.ApplyWindowBounds()
        if UI.Main then
            local targetSize = UI.GetBoundedWindowSize(UI.GetWindowPresetSize())
            UI.Main.Size = UDim2.fromOffset(targetSize.X, targetSize.Y)
            UI.Main.Position = ClampFrameToScreen(UI.Main, UI.Main.Position)
        end

        if UI.ShowButton then
            UI.ShowButton.Position = ClampFrameToScreen(UI.ShowButton, UI.ShowButton.Position)
        end
    end

    function UI.SetDpi(scale)
        State.DpiScale = math.clamp(scale or 1, AppConfig.MinimumDpi / 100, AppConfig.MaximumDpi / 100)
        local percent = math.floor(State.DpiScale * 100 + 0.5)
        local presetValue = tostring(percent)
        State.Sliders["settings.ui.dpi"] = percent
        State.Segments["settings.ui.scale_preset"] = presetValue

        local dpiControl = State.Controls["settings.ui.dpi"]
        if dpiControl and dpiControl.SetValue then
            dpiControl.SetValue(percent, true, true)
        end

        local presetControl = State.Controls["settings.ui.scale_preset"]
        if presetControl and presetControl.SetValue then
            presetControl.SetValue(presetValue, true, true)
        end

        if UI.Scale then
            UI.Scale.Scale = State.DpiScale
        end
        if UI.ToastScale then
            UI.ToastScale.Scale = State.DpiScale
        end
        if UI.TooltipScale then
            UI.TooltipScale.Scale = State.DpiScale
        end
        if UI.ModalScale then
            UI.ModalScale.Scale = State.DpiScale
        end
        if UI.ShowScale then
            UI.ShowScale.Scale = State.DpiScale
        end
        UI.ApplyWindowBounds()
    end

    function UI.SetWindowPreset(presetId)
        State.WindowPreset = presetId or State.WindowPreset
        State.Dropdowns["settings.ui.window_preset"] = State.WindowPreset

        local targetSize = UI.GetBoundedWindowSize(UI.GetWindowPresetSize())

        if UI.Main then
            Tween(UI.Main, {
                Size = UDim2.fromOffset(targetSize.X, targetSize.Y),
            }, Theme.Animation.Slow)
            task.delay(Theme.Animation.Slow + 0.02, function()
                if UI.Main then
                    UI.Main.Position = ClampFrameToScreen(UI.Main, UI.Main.Position)
                end
            end)
        end
    end

    function UI.SetWindowTransparency(value)
        State.WindowTransparency = math.clamp(value or 0, 0, 45)
        local transparency = State.WindowTransparency / 100

        if UI.Main then
            UI.Main.BackgroundTransparency = transparency
        end
        if UI.Sidebar then
            UI.Sidebar.BackgroundTransparency = 0
        end
        if UI.Content then
            UI.Content.BackgroundTransparency = 0
        end
    end

    function UI.SetVisible(visible)
        UI.VisibleToken = (UI.VisibleToken or 0) + 1
        local token = UI.VisibleToken
        local MinimizeDuration = 0.06

        if visible then
            if UI.Main then
                UI.Main.Visible = true
                UI.Main.Size = UDim2.fromOffset(1, 1)
                task.defer(function()
                    if token ~= UI.VisibleToken then return end
                    Tween(UI.Main, {
                        Size = UI._savedWindowSize or UDim2.fromOffset(760, 500),
                    }, Theme.Animation.Slow, Enum.EasingStyle.Back)
                end)
            end
            if UI.ShowButton then
                Tween(UI.ShowButton, { BackgroundTransparency = 1, ImageTransparency = 1 }, MinimizeDuration)
                if UI.ShowButtonStroke then Tween(UI.ShowButtonStroke, { Transparency = 1 }, MinimizeDuration) end
                task.delay(MinimizeDuration + 0.02, function()
                    if UI.ShowButton and token == UI.VisibleToken and visible then
                        UI.ShowButton.Visible = false
                        UI.ShowButton.ImageTransparency = 0
                    end
                end)
            end
        else
            if UI.Main then
                UI._savedWindowSize = UI.Main.Size
                Tween(UI.Main, {
                    Size = UDim2.fromOffset(1, 1),
                }, Theme.Animation.Normal)
                task.delay(Theme.Animation.Normal + 0.04, function()
                    if token == UI.VisibleToken and not visible then
                        UI.Main.Visible = false
                        UI.Main.Size = UI._savedWindowSize
                    end
                end)
            end
            if UI.ShowButton then
                UI.ShowButton.Visible = true
                UI.ShowButton.BackgroundTransparency = 1
                UI.ShowButton.ImageTransparency = 1
                Tween(UI.ShowButton, { BackgroundTransparency = 1, ImageTransparency = 0 }, MinimizeDuration)
                if UI.ShowButtonStroke then Tween(UI.ShowButtonStroke, { Transparency = 0 }, MinimizeDuration) end
            end
        end
        State:AddLog("UI", visible and "已打开窗口" or "已隐藏窗口", "window.visibility")
    end

    function UI.ToggleSidebar()
        UI.SidebarCollapsed = not UI.SidebarCollapsed
        local width = UI.SidebarCollapsed and 56 or 150

        if UI.Sidebar then
            Tween(UI.Sidebar, { Size = UDim2.new(0, width - 1, 1, -43) }, Theme.Animation.Normal)
        end

        if UI.Content then
            Tween(UI.Content, {
                Position = UDim2.fromOffset(width, 42),
                Size = UDim2.new(1, -width, 1, -42),
            }, Theme.Animation.Normal)
        end

        for _, button in pairs(UI.SidebarButtons) do
            local label = button:FindFirstChild("PageName")
            if label then
                label.Visible = not UI.SidebarCollapsed
            end
        end

        State:AddLog("UI", UI.SidebarCollapsed and "侧栏已折叠" or "侧栏已展开", "window.sidebar")
    end

    function UI.Track(connection, scope)
        if not connection then
            return nil
        end

        if scope == "page" then
            table.insert(UI.PageConnections, connection)
        elseif scope == "log" then
            table.insert(UI.LogConnections, connection)
        else
            table.insert(UI.Connections, connection)
        end
        return connection
    end

    function UI.ClearPageConnections()
        DisconnectConnections(UI.PageConnections)
    end

    function UI.ClearLogConnections()
        DisconnectConnections(UI.LogConnections)
    end

    function UI.Destroy()
        UI.ClearPageConnections()
        UI.ClearLogConnections()
        DisconnectConnections(UI.Connections)
        State:ClearVisibleControls()

        if UI.RootGui then
            UI.RootGui:Destroy()
        end
        UI.RootGui = nil
        UI.Main = nil
        UI.ShowButton = nil
        UI.Content = nil
        UI.ContentLayout = nil
        UI.Sidebar = nil
        UI.LogList = nil
        UI.ToastRoot = nil
        UI.ToastThrottle = {}
        UI.ToastScale = nil
        UI.TooltipScale = nil
        UI.TooltipSource = nil
        UI.ModalScale = nil
        UI.ShowScale = nil
        UI.Livestream = nil
        UI.ShowButtonStroke = nil
        UI.Tooltip = nil
        UI.TooltipToken += 1
        UI.VisibleToken += 1
        UI.ModalRoot = nil
        UI.SidebarButtons = {}
        UI.Connections = {}
        UI.PageConnections = {}
        UI.LogConnections = {}
    end

    function UI.UpdateSidebar()
        for pageId, button in pairs(UI.SidebarButtons) do
            local active = pageId == State.CurrentPage
            local targetColor = active and Theme.Colors.AccentDim or Theme.Colors.Window
            local targetStroke = active and Theme.Colors.AccentSoft or Theme.Colors.Stroke

            Tween(button, { BackgroundColor3 = targetColor }, Theme.Animation.Fast)
            local stroke = button:FindFirstChildOfClass("UIStroke")
            if stroke then
                Tween(stroke, { Color = targetStroke }, Theme.Animation.Fast)
            end
        end
    end

    function UI.SetPage(pageId)
        if not Pages.ById[pageId] then
            return
        end

        State.CurrentPage = pageId
        UI.UpdateSidebar()
        UI.RenderPage(pageId)
    end

    function UI.FindItems(query)
        local results = {}
        query = string.lower(query or "")

        local function scanItems(page, items, sectionTitle)
            for _, item in ipairs(items or {}) do
                if UI.ItemMatches(item, query) then
                    table.insert(results, {
                        page = page,
                        section = sectionTitle or "",
                        item = item,
                    })
                end

                if item.items then
                    scanItems(page, item.items, sectionTitle)
                end
            end
        end

        for _, page in ipairs(Pages.List) do
            for _, section in ipairs(page.sections or {}) do
                scanItems(page, section.items, section.title)
            end

            for _, subcategory in ipairs(page.subcategories or {}) do
                for _, section in ipairs(subcategory.sections or {}) do
                    scanItems(page, section.items, subcategory.title .. " / " .. section.title)
                end
            end
        end

        return results
    end

    function UI.ItemTextMatches(item, query)
        return ContainsText(item.key, query)
            or ContainsText(item.title, query)
            or ContainsText(item.desc, query)
            or ContainsText(item.badge, query)
    end

    function UI.ItemMatches(item, query)
        if query == "" then
            return true
        end

        if UI.ItemTextMatches(item, query) then
            return true
        end

        for _, child in ipairs(item.items or {}) do
            if UI.ItemMatches(child, query) then
                return true
            end
        end

        return false
    end

    function UI.RenderItem(parent, item, forceChildren)
        local query = State.CurrentPage == "search" and "" or string.lower(State.SearchText or "")
        if not forceChildren and not UI.ItemMatches(item, query) then
            return false
        end

        local rendered = true
        local control = nil
        if item.type == "button" then
            control = Components.Button(parent, item)
        elseif item.type == "toggle" then
            control = Components.Toggle(parent, item)
        elseif item.type == "slider" then
            control = Components.Slider(parent, item)
        elseif item.type == "input" then
            control = Components.TextInput(parent, item)
        elseif item.type == "dropdown" then
            control = Components.Dropdown(parent, item)
        elseif item.type == "segment" then
            control = Components.Segmented(parent, item)
        elseif item.type == "number" then
            control = Components.NumberInput(parent, item)
        elseif item.type == "color" then
            control = Components.ColorPicker(parent, item)
        elseif item.type == "multi" then
            control = Components.MultiDropdown(parent, item)
        elseif item.type == "keybind" then
            control = Components.Keybind(parent, item)
        elseif item.type == "progress" then
            control = Components.Progress(parent, item)
        elseif item.type == "tags" then
            control = Components.TagRow(parent, item)
        elseif item.type == "table" then
            control = Components.Table(parent, item)
        elseif item.type == "status" then
            control = Components.StatusLabel(parent, item)
        elseif item.type == "list" then
            control = Components.ListItem(parent, item)
        elseif item.type == "category" then
            control = Components.CategoryCard(parent, item)
        elseif item.type == "log" then
            control = Components.LogOutput(parent, item)
        elseif item.type == "collapsible" then
            local _, content = Components.Collapsible(parent, item)
            if item.locked then Components.LockOverlay(content, item.lockText) end
            local groupMatched = UI.ItemTextMatches(item, query)
            for _, child in ipairs(item.items or {}) do
                UI.RenderItem(content, child, forceChildren or groupMatched)
            end
        else
            State:AddLog("ERROR", "未知控件类型: " .. tostring(item.type), item.key or "render.unknown")
            rendered = false
        end

        if control and item.locked then
            Components.LockOverlay(control, item.lockText)
        end

        return rendered
    end

    function UI.ResolveSections(page)
        if page.dynamic == "favorites" then
            local items = {}
            for key in pairs(State.Favorites) do
                local meta = Registry.Meta[key]
                if meta then
                    table.insert(items, {
                        type = "list",
                        key = "favorites.item." .. key,
                        title = meta.Title or key,
                        desc = key .. " / " .. (meta.Page or "unknown"),
                        badge = meta.Type or "key",
                        internal = true,
                        page = page.id,
                    })
                end
            end
            table.sort(items, function(a, b)
                return a.key < b.key
            end)
            if #items == 0 then
                items = {
                    { type = "list", key = "favorites.empty", title = "暂无收藏", desc = "收藏入口已从控件行移除，避免标题和按钮布局被挤乱。", badge = "空", internal = true, page = page.id },
                }
            end
            return { { title = "收藏功能", subtitle = "保留旧收藏数据展示，不再在控件上显示星标。", items = items } }
        elseif page.dynamic == "recent" then
            local items = {}
            for _, row in ipairs(State.Recent) do
                table.insert(items, {
                    type = "list",
                    key = "recent.item." .. row.key,
                    title = row.title,
                    desc = row.key .. " / " .. row.time,
                    badge = row.page ~= "" and row.page or "recent",
                    internal = true,
                    page = page.id,
                })
            end
            if #items == 0 then
                items = {
                    { type = "list", key = "recent.empty", title = "暂无最近使用", desc = "操作任意控件后会自动显示在这里。", badge = "空", internal = true, page = page.id },
                }
            end
            return { { title = "最近使用", subtitle = "自动记录最近操作过的控件。", items = items } }
        elseif page.dynamic == "search" then
            local items = {}
            if State.SearchText ~= "" then
                for _, result in ipairs(UI.FindItems(State.SearchText)) do
                    table.insert(items, {
                        type = "list",
                        key = "search.result." .. result.item.key,
                        title = result.item.title or result.item.key,
                        desc = result.item.key .. " / " .. result.page.title .. " / " .. result.section,
                        badge = result.item.type or "item",
                        internal = true,
                        page = page.id,
                    })
                end
            end
            if #items == 0 then
                items = {
                    { type = "list", key = "search.empty", title = "没有全局搜索结果", desc = "在顶部搜索框输入 key、标题或描述。", badge = "搜索", internal = true, page = page.id },
                }
            end
            return { { title = "全局搜索", subtitle = "搜索全部页面、子分类和控件。", items = items } }
        elseif page.dynamic == "registry" then
            local items = {}
            for _, row in ipairs(Registry.GetAll()) do
                table.insert(items, {
                    type = "list",
                    key = "registry.item." .. row.Key,
                    title = row.Title or row.Key,
                    desc = row.Key .. " / " .. (row.Page or "global"),
                    badge = row.Bound and "已绑定" or "空回调",
                    internal = true,
                    page = page.id,
                })
            end
            return {
                {
                    title = "Registry Key 清单",
                    subtitle = "用于以后接功能时查 key，默认都是空回调。",
                    items = items,
                },
            }
        end

        if not page.subcategories then
            return page.sections or {}
        end

        local active = State.SubPages[page.id]
        if not active and page.subcategories[1] then
            active = page.subcategories[1].id
            State.SubPages[page.id] = active
        end

        for _, subcategory in ipairs(page.subcategories) do
            if subcategory.id == active then
                return subcategory.sections or {}
            end
        end

        return {}
    end

    function UI.RenderSubcategories(parent, page)
        if not page.subcategories then
            return
        end

        local options = {}
        for _, subcategory in ipairs(page.subcategories) do
            table.insert(options, Option(subcategory.title, subcategory.id))
        end

        Components.Segmented(parent, {
            type = "segment",
            key = "page." .. page.id .. ".subcategory",
            page = page.id,
            title = "子分类",
            desc = "切换当前分类下的功能组。",
            default = State.SubPages[page.id] or (page.subcategories[1] and page.subcategories[1].id),
            options = options,
            stacked = true,
            internal = true,
            onChanged = function(value)
                State.SubPages[page.id] = value
                UI.RenderPage(page.id)
            end,
        })
    end

    function UI.RenderPage(pageId)

        if not UI.Content then
            return
        end

        local page = Pages.ById[pageId]
        if not page then
            return
        end

        UI.ClearPageConnections()
        UI.ClearLogConnections()
        UI.HideTooltip()
        UI.LogList = nil
        State:ClearVisibleControls()
        UI.Content:ClearAllChildren()
        UI.Content.CanvasPosition = Vector2.zero
        AddCorner(UI.Content, Theme.Radius.Window)
        AddPadding(UI.Content, 16, 16, 14, 16)

        local layout = New("UIListLayout", {
            Padding = UDim.new(0, 14),
            Parent = UI.Content,
        })
        UI.ContentLayout = layout
        SetScrollCanvas(UI.Content, layout, 20)

        local header = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 50),
            Parent = UI.Content,
        })

        local title = Components.Label(header, page.title, 24, Theme.Colors.Text, true)
        title.Size = UDim2.new(1, 0, 0, 28)

        local subtitle = Components.Label(header, page.subtitle or "", 14, Theme.Colors.TextDim, false)
        subtitle.Position = UDim2.fromOffset(0, 30)
        subtitle.Size = UDim2.new(1, 0, 0, 18)

        UI.RenderSubcategories(UI.Content, page)

        local query = page.id == "search" and "" or string.lower(State.SearchText or "")
        local renderedAny = false

        for _, section in ipairs(UI.ResolveSections(page)) do
            local sectionHasVisibleItem = false
            for _, item in ipairs(section.items or {}) do
                if UI.ItemMatches(item, query) then
                    sectionHasVisibleItem = true
                    break
                end
            end

            if sectionHasVisibleItem then
                local sectionFrame = Components.Section(UI.Content, section.title, section.subtitle)
                for _, item in ipairs(section.items or {}) do
                    if UI.RenderItem(sectionFrame, item, false) then
                        renderedAny = true
                    end
                end
            end
        end

        if not renderedAny then
            local empty = Components.ControlFrame(UI.Content, 58)
            local label = Components.Label(empty, "没有匹配内容", 17, Theme.Colors.TextMuted, true)
            label.Size = UDim2.new(1, -24, 1, 0)
            label.Position = UDim2.fromOffset(12, 0)
        end

        if pageId == 'config' and ConfigManager and ConfigManager.RefreshDropdown then
            task.wait(0.3)
            ConfigManager:RefreshDropdown()
        end

    end

    function UI.RefreshLogs()
        if not UI.LogList then
            return
        end

        UI.ClearLogConnections()
        for _, child in ipairs(UI.LogList:GetChildren()) do
            if not child:IsA("UICorner") and not child:IsA("UIStroke") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end

        if not UI.LogList:FindFirstChildOfClass("UIPadding") then
            AddPadding(UI.LogList, 8, 8, 8, 8)
        end

        local layout = New("UIListLayout", {
            Padding = UDim.new(0, 5),
            Parent = UI.LogList,
        })
        SetScrollCanvas(UI.LogList, layout, 16, "log")

        if #State.Logs == 0 then
            local empty = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 34),
                Text = "暂无日志",
                TextColor3 = Theme.Colors.TextDim,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = UI.LogList,
            })
            return empty
        end

        for _, log in ipairs(State.Logs) do
            local row = New("Frame", {
                BackgroundColor3 = Theme.Colors.Control,
                Size = UDim2.new(1, 0, 0, 30),
                Parent = UI.LogList,
            })
            AddCorner(row, Theme.Radius.Control)

            local level = Components.Label(row, log.Level, 12, Theme.Colors.Accent, true)
            level.Position = UDim2.fromOffset(8, 0)
            level.Size = UDim2.fromOffset(58, 30)

            local msgText = type(log.Message) == "string" and log.Message or tostring(log.Message or ""); local message = Components.Label(row, log.Time .. "  " .. msgText, 13, Theme.Colors.TextMuted, false)
            message.Position = UDim2.fromOffset(70, 0)
            message.Size = UDim2.new(1, -210, 1, 0)
            message.TextTruncate = Enum.TextTruncate.AtEnd

            local key = Components.Label(row, log.Key, 12, Theme.Colors.TextDim, false)
            key.AnchorPoint = Vector2.new(1, 0)
            key.Position = UDim2.new(1, -8, 0, 0)
            key.Size = UDim2.fromOffset(130, 30)
            key.TextXAlignment = Enum.TextXAlignment.Right
            key.TextTruncate = Enum.TextTruncate.AtEnd
        end
    end

    function UI.BuildToastRoot(parent)
        UI.ToastRoot = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -math.floor(8 * State.DpiScale), 0, math.floor(10 * State.DpiScale)),
            Size = UDim2.fromOffset(460, 420),
            Parent = parent,
            ZIndex = 80,
        })
        UI.ToastScale = New("UIScale", {
            Scale = State.DpiScale,
            Parent = UI.ToastRoot,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = UI.ToastRoot,
        })
    end

    function UI.Notify(level, message, key)
        if not UI.ToastRoot then
            return
        end

        key = tostring(key or "")
        message = tostring(message or "")

        local now = os.clock()
        local throttleKey = key ~= "" and key or message
        if throttleKey ~= "" and UI.ToastThrottle[throttleKey] and now - UI.ToastThrottle[throttleKey] < 0.1 then
            return
        end
        UI.ToastThrottle[throttleKey] = now

        UI.ToastId += 1
        local toastId = UI.ToastId
        local accent = level == "ERROR" and Color3.fromRGB(255, 96, 96) or Theme.Colors.Accent
        local textW = Services.TextService:GetTextSize(message, 16, Theme.Font, Vector2.new(math.huge, 22)).X
        local toastWidth = math.max(math.min(textW + 44, 420), 160)
        local toastHeight = 50
        local progressStart = Color3.fromRGB(70, 180, 255)
        local progressEnd = Color3.fromRGB(255, 80, 80)

        local wrapper = New("Frame", {
            BackgroundTransparency = 1,
            LayoutOrder = -toastId,
            Size = UDim2.fromOffset(toastWidth, toastHeight),
            Parent = UI.ToastRoot,
            ZIndex = 81,
        })

        local maskContainer = New("Frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Size = UDim2.new(0.98, 0, 1, 0),
            Parent = wrapper,
            ZIndex = 81,
        })
        AddCorner(maskContainer, Theme.Radius.Panel)

        local toast = New("Frame", {
            BackgroundColor3 = Theme.Colors.Window,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 0, 1),
            Size = UDim2.new(1, -2, 1, -2),
            Parent = maskContainer,
            ZIndex = 81,
        })
        AddCorner(toast, Theme.Radius.Panel)
        local stroke = AddStroke(toast, Color3.fromRGB(235, 235, 235))
        stroke.Transparency = 1

        local bar = New("Frame", {
            BackgroundColor3 = accent,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 4, 1, -12),
            Position = UDim2.fromOffset(8, 6),
            Parent = toast,
            ZIndex = 82,
        })
        AddCorner(bar, Theme.Radius.Pill)

        local title = Components.Label(toast, tostring(level or "INFO"), 13, accent, true)
        title.Position = UDim2.fromOffset(18, 4)
        title.Size = UDim2.fromOffset(74, 14)
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.TextTransparency = 1
        title.ZIndex = 82

        local text = Components.Label(toast, message, 16, Theme.Colors.Text, false)
        text.Position = UDim2.fromOffset(18, 18)
        text.Size = UDim2.new(1, -28, 0, 22)
        text.TextTruncate = Enum.TextTruncate.AtEnd
        text.TextTransparency = 1
        text.ZIndex = 82

        local progressBg = New("Frame", {
            BackgroundColor3 = Theme.Colors.StrokeStrong,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 18, 1, -8),
            Size = UDim2.new(1, -28, 0, 3),
            Parent = toast,
            ZIndex = 82,
        })
        AddCorner(progressBg, Theme.Radius.Pill)

        local progressClip = New("Frame", {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = progressBg,
            ZIndex = 83,
        })
        AddCorner(progressClip, Theme.Radius.Pill)

        local progressBar = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = progressStart,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Parent = progressClip,
            ZIndex = 84,
        })
        AddCorner(progressBar, Theme.Radius.Pill)

        Tween(toast, {
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 1, 0, 1),
        }, 0.5)
        Tween(bar, { BackgroundTransparency = 0 }, 0.22)
        Tween(title, { TextTransparency = 0 }, 0.22)
        Tween(text, { TextTransparency = 0 }, 0.22)
        Tween(progressBg, { BackgroundTransparency = 0.35 }, 0.22)
        Tween(progressBar, { BackgroundTransparency = 0 }, 0.22)
        Tween(stroke, { Transparency = 0.38 }, 0.22)
        Tween(progressBar, {
            Size = UDim2.new(0, 0, 1, 0),
        }, Theme.Animation.ToastDuration, Enum.EasingStyle.Linear)
        task.delay(math.max(Theme.Animation.ToastDuration - 0.5, 0), function()
            if progressBar and progressBar.Parent then
                Tween(progressBar, { BackgroundColor3 = progressEnd }, 0.5)
            end
        end)

        task.delay(Theme.Animation.ToastDuration, function()
            if not wrapper or not wrapper.Parent or not toast or not toast.Parent then
                return
            end

            for _, child in ipairs(toast:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    Tween(child, {
                        TextTransparency = 1,
                        BackgroundTransparency = 1,
                    }, Theme.Animation.Slow)
                elseif child:IsA("Frame") then
                    Tween(child, { BackgroundTransparency = 1 }, Theme.Animation.Slow)
                elseif child:IsA("UIStroke") then
                    Tween(child, { Transparency = 1 }, Theme.Animation.Slow)
                end
            end

            Tween(toast, {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 1.5, 0),
            }, 0.3)
            Tween(stroke, { Transparency = 1 }, 0.3)

            task.delay(0.3, function()
                if wrapper and wrapper.Parent then
                    wrapper:Destroy()
                end
            end)
        end)
    end

    function UI.ShowCenterToast(text)
        if not UI.RootGui then return end
        text = text or "欢迎使用青木脚本"

        local root = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, -28),
            Size = UDim2.fromOffset(200, 28),
            Parent = UI.RootGui,
            ZIndex = 200,
        })
        root.Visible = false
        AddCorner(root, Theme.Radius.Panel)
        local stroke = AddStroke(root, Color3.fromRGB(255, 255, 255))
        stroke.Transparency = 0.8

        root.ClipsDescendants = false
        local label = Components.Label(root, text, 16, Color3.fromRGB(255, 255, 255), false)
        label.Size = UDim2.new(1, -8, 1, 0)
        label.Position = UDim2.fromOffset(4, 0)
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 201

        -- slide down from off-screen
        root.Visible = true
        Tween(root, { BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0, 16) }, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        task.delay(5, function()
            if not root or not root.Parent then return end
            Tween(root, { BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0, -28) }, 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(0.4, function()
                if root and root.Parent then root:Destroy() end
            end)
        end)
    end

    function UI.PositionTooltip(object)
        if not UI.Tooltip or not UI.RootGui then
            return
        end

        object = object or UI.TooltipSource
        if not object then
            return
        end

        local rootPosition = UI.RootGui.AbsolutePosition
        local objectPosition = object.AbsolutePosition
        local objectSize = object.AbsoluteSize
        local gap = 8
        local x = objectPosition.X - rootPosition.X + objectSize.X + gap
        local y = objectPosition.Y - rootPosition.Y + objectSize.Y + gap

        UI.Tooltip.Position = UDim2.fromOffset(math.floor(x + 0.5), math.floor(y + 0.5))
    end

    function UI.ShowTooltip(text, object)
        if not UI.RootGui then
            return
        end

        UI.TooltipToken += 1
        local token = UI.TooltipToken
        UI.TooltipSource = object
        UI.HideTooltip(nil, true)

        local function createTooltip()
            if token ~= UI.TooltipToken or UI.TooltipSource ~= object or not UI.RootGui then
                return
            end

            local textSize = Services.TextService:GetTextSize(tostring(text), 12, Theme.Font, Vector2.new(300, 120))
            local width = math.clamp(textSize.X + 22, 180, 320)
            local height = math.clamp(textSize.Y + 18, 38, 104)

            local tooltip = New("Frame", {
                BackgroundColor3 = Theme.Colors.PanelDeep,
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(width, math.max(1, height - 6)),
                Parent = UI.RootGui,
                ZIndex = 120,
            })
            UI.TooltipScale = New("UIScale", {
                Scale = State.DpiScale,
                Parent = tooltip,
            })
            AddCorner(tooltip, Theme.Radius.Control)
            AddStroke(tooltip, Theme.Colors.StrokeStrong)
            AddPadding(tooltip, 10, 10, 7, 7)

            local label = Components.Label(tooltip, text, 12, Theme.Colors.TextMuted, false)
            label.Size = UDim2.fromScale(1, 1)
            label.TextWrapped = true
            label.TextYAlignment = Enum.TextYAlignment.Top
            label.TextTransparency = 1
            label.ZIndex = 121

            UI.Tooltip = tooltip
            UI.PositionTooltip(object)

            Tween(tooltip, {
                BackgroundTransparency = 0,
                Size = UDim2.fromOffset(width, height),
            }, Theme.Animation.Fast, Theme.Animation.EmphasisStyle)
            Tween(label, { TextTransparency = 0 }, Theme.Animation.Fast)
            local stroke = tooltip:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Transparency = 1
                Tween(stroke, { Transparency = 0 }, Theme.Animation.Fast)
            end
        end

        if Theme.Animation.TooltipDelay > 0 then
            task.delay(Theme.Animation.TooltipDelay, createTooltip)
        else
            createTooltip()
        end
    end

    function UI.HideTooltip(source, keepToken)
        if source and UI.TooltipSource and source ~= UI.TooltipSource then
            return
        end

        if not keepToken then
            UI.TooltipToken += 1
            UI.TooltipSource = nil
        end

        if UI.Tooltip then
            local tooltip = UI.Tooltip
            UI.Tooltip = nil
            local stroke = tooltip:FindFirstChildOfClass("UIStroke")
            for _, child in ipairs(tooltip:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    Tween(child, { TextTransparency = 1 }, Theme.Animation.Fast)
                end
            end
            if stroke then
                Tween(stroke, { Transparency = 1 }, Theme.Animation.Fast)
            end
            Tween(tooltip, { BackgroundTransparency = 1 }, Theme.Animation.Fast)
            task.delay(Theme.Animation.Fast + 0.03, function()
                if tooltip and tooltip.Parent then
                    tooltip:Destroy()
                end
            end)
        end
    end

    function UI.Confirm(title, text, onConfirm)
        if not UI.RootGui then
            return
        end

        if not State.ConfirmEnabled then
            if onConfirm then
                onConfirm()
            end
            return
        end

        if UI.ModalRoot then
            UI.ModalRoot:Destroy()
        end

        local overlay = New("TextButton", {
            BackgroundColor3 = Theme.Colors.Overlay,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            Parent = UI.RootGui,
            ZIndex = 100,
        })
        UI.ModalRoot = overlay

        local modal = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Colors.Window,
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(344, 158),
            Parent = overlay,
            ZIndex = 101,
        })
        UI.ModalScale = New("UIScale", {
            Scale = State.DpiScale,
            Parent = modal,
        })
        AddCorner(modal, Theme.Radius.Window)
        local modalStroke = AddStroke(modal, Theme.Colors.StrokeStrong)
        modalStroke.Transparency = 1

        local titleLabel = Components.Label(modal, title or "确认操作", 18, Theme.Colors.Text, true)
        titleLabel.Position = UDim2.fromOffset(0, 16)
        titleLabel.Size = UDim2.new(1, 0, 0, 24)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Center
        titleLabel.TextTransparency = 1
        titleLabel.ZIndex = 102

        local desc = Components.Label(modal, text or "确认执行？", 14, Theme.Colors.TextMuted, false)
        desc.TextXAlignment = Enum.TextXAlignment.Center
        desc.Position = UDim2.fromOffset(18, 48)
        desc.Size = UDim2.new(1, -36, 0, 54)
        desc.TextWrapped = true
        desc.TextTransparency = 1
        desc.ZIndex = 102

        local cancel = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Colors.Control,
            Position = UDim2.new(0.5, -43, 1, -48),
            Size = UDim2.fromOffset(76, 30),
            Text = "取消",
            TextSize = 14,
            TextColor3 = Theme.Colors.TextMuted,
            TextTransparency = 1,
            Parent = modal,
            ZIndex = 102,
        })
        AddCorner(cancel, Theme.Radius.Control)
        AddStroke(cancel)
        Components.Interaction(cancel, Theme.Colors.Control, Theme.Colors.ControlHover, Theme.Colors.AccentDim)

        local confirm = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Colors.AccentDim,
            Position = UDim2.new(0.5, 43, 1, -48),
            Size = UDim2.fromOffset(76, 30),
            Text = "确认",
            TextSize = 14,
            TextColor3 = Theme.Colors.Text,
            TextTransparency = 1,
            Parent = modal,
            ZIndex = 102,
        })
        AddCorner(confirm, Theme.Radius.Control)
        AddStroke(confirm, Theme.Colors.AccentSoft)
        Components.Interaction(confirm, Theme.Colors.AccentDim, Theme.Colors.AccentSoft, Theme.Colors.Accent)

        local function close()
            local root = UI.ModalRoot
            if not root then
                return
            end
            UI.ModalRoot = nil
            Tween(overlay, { BackgroundTransparency = 1 }, Theme.Animation.Fast)
            Tween(modal, {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(344, 158),
            }, Theme.Animation.Fast)
            Tween(modalStroke, { Transparency = 1 }, Theme.Animation.Fast)
            Tween(titleLabel, { TextTransparency = 1 }, Theme.Animation.Fast)
            Tween(desc, { TextTransparency = 1 }, Theme.Animation.Fast)
            Tween(cancel, { TextTransparency = 1, BackgroundTransparency = 1 }, Theme.Animation.Fast)
            Tween(confirm, { TextTransparency = 1, BackgroundTransparency = 1 }, Theme.Animation.Fast)
            task.delay(Theme.Animation.Fast + 0.03, function()
                if root and root.Parent then
                    root:Destroy()
                end
            end)
        end

        cancel.Activated:Connect(close)
        overlay.Activated:Connect(close)
        confirm.Activated:Connect(function()
            close()
            if onConfirm then
                onConfirm()
            end
        end)

        Tween(overlay, { BackgroundTransparency = 0.45 }, Theme.Animation.Normal)
        Tween(modal, {
            BackgroundTransparency = 0,
            Size = UDim2.fromOffset(360, 170),
        }, Theme.Animation.Normal, Theme.Animation.EmphasisStyle)
        Tween(modalStroke, { Transparency = 0 }, Theme.Animation.Normal)
        Tween(titleLabel, { TextTransparency = 0 }, Theme.Animation.Normal)
        Tween(desc, { TextTransparency = 0 }, Theme.Animation.Normal)
        Tween(cancel, { TextTransparency = 0 }, Theme.Animation.Normal)
        Tween(confirm, { TextTransparency = 0 }, Theme.Animation.Normal)
    end

    function UI.MakeDraggable(frame, handle)
        local dragging = false
        local startMouse = nil
        local startPosition = nil
        local moved = false
        local dragInputType = nil

        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if frame == UI.ShowButton and UI.ShowButtonDragLock then return end
                dragging = true
                moved = false
                startMouse = input.Position
                startPosition = frame.Position
                dragInputType = input.UserInputType
            end
        end)

        UI.Track(Services.UserInputService.InputChanged:Connect(function(input)
            if not dragging then
                return
            end

            if dragInputType == Enum.UserInputType.Touch then
                if input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end
            elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then
                return
            end

            local delta = input.Position - startMouse
            if math.abs(delta.X) > 8 or math.abs(delta.Y) > 8 then
                moved = true
                if frame == UI.ShowButton then
                    UI.ShowButtonDragged = true
                end
            end
            local nextPosition = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
            frame.Position = ClampFrameToScreen(frame, nextPosition)
        end))

        UI.Track(Services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if frame == UI.ShowButton and not moved and startMouse then
                    local totalDelta = input.Position - startMouse
                    if math.abs(totalDelta.X) > 8 or math.abs(totalDelta.Y) > 8 then
                        moved = true
                        UI.ShowButtonDragged = true
                    end
                end
                if frame == UI.ShowButton and moved then
                    task.delay(0.08, function()
                        UI.ShowButtonDragged = false
                    end)
                end
                dragging = false
                dragInputType = nil
            end
        end))
    end

    function UI.BuildSidebar(parent)
        UI.Sidebar = New("ScrollingFrame", {
            BackgroundColor3 = Theme.Colors.Window,
            Position = UDim2.fromOffset(1, 42),
            Size = UDim2.new(0, 149, 1, -43),
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarThickness = 3,
            Parent = parent,
        })
        AddCorner(UI.Sidebar, Theme.Radius.Window)
        AddPadding(UI.Sidebar, 10, 10, 10, 10)

        local layout = New("UIListLayout", {
            Padding = UDim.new(0, 7),
            Parent = UI.Sidebar,
        })
        SetScrollCanvas(UI.Sidebar, layout, 28, "window")

        for _, page in ipairs(Pages.List) do
            local button = New("TextButton", {
                BackgroundColor3 = Theme.Colors.Window,
                Size = UDim2.new(1, 0, 0, 36),
                Text = "",
                Parent = UI.Sidebar,
            })
            AddCorner(button, Theme.Radius.Panel)
            Components.Interaction(
                button,
                function()
                    return page.id == State.CurrentPage and Theme.Colors.AccentDim or Theme.Colors.Window
                end,
                function()
                    return page.id == State.CurrentPage and Theme.Colors.AccentDim or Theme.Colors.Control
                end,
                Theme.Colors.AccentDim
            )
            local sideScale = New("UIScale", { Scale = 1, Parent = button })

            local name = Components.Label(button, page.title, 13, Theme.Colors.TextMuted, true)
            name.Name = "PageName"
            name.Position = UDim2.fromOffset(0, 0)
            name.Size = UDim2.new(1, 0, 1, 0)
            name.TextXAlignment = Enum.TextXAlignment.Center
            name.Visible = not UI.SidebarCollapsed

            button.MouseButton1Click:Connect(function()
                Tween(sideScale, { Scale = 0.95 }, Theme.Animation.Press)
                task.delay(Theme.Animation.Press + 0.04, function()
                    Tween(sideScale, { Scale = 1 }, Theme.Animation.Fast)
                end)
                UI.SetPage(page.id)
                State:AddLog("UI", "切换页面: " .. page.title, "sidebar." .. page.id)
            end)

            UI.SidebarButtons[page.id] = button
        end

        return layout
    end

    function UI.DestroyLivestream()
        if UI.Livestream then
            UI.Livestream:Destroy()
            UI.Livestream = nil
        end
    end

    function UI.UpdateLivestreamPos(cont)
        local c = cont or UI.Livestream
        if not c then return end
        local x = State.Sliders["settings.ui.livestream_x"] or 52
        local y = State.Sliders["settings.ui.livestream_y"] or -7
        c.Position = UDim2.new(x / 100, 0, y / 100, 10)
    end

    function UI.BuildLivestream()
        UI.DestroyLivestream()
        if not UI.RootGui then return end
        if not State.Toggles["settings.toggle.livestream"] then return end
        local container = Instance.new("Frame")
        container.Name = "TopColorfulText"
        container.Size = UDim2.new(0, 320, 0, 40)
        container.AnchorPoint = Vector2.new(0.5, 0)
        container.BackgroundTransparency = 1
        container.Parent = UI.RootGui
        container.ZIndex = 10
        local fs = State.Sliders["settings.ui.livestream_size"] or 20
        local gap = fs + 90
        container.Size = UDim2.new(0, gap * 3, 0, fs + 20)
        UI.UpdateLivestreamPos(container)
        local texts = {}
        local xOffset = 0
        local lh = fs + 10
        for _, data in ipairs(texts) do
            local shadow = Instance.new("TextLabel")
            shadow.Size = UDim2.new(0, gap, 0, lh)
            shadow.Position = UDim2.new(0, xOffset + 2, 0, 2)
            shadow.BackgroundTransparency = 1
            shadow.Text = data.text
            shadow.TextColor3 = data.color
            shadow.TextTransparency = 0.5
            shadow.TextSize = fs
            shadow.Font = Enum.Font.SourceSansBold
            shadow.TextXAlignment = Enum.TextXAlignment.Left
            shadow.Parent = container
            local main = Instance.new("TextLabel")
            main.Size = UDim2.new(0, gap, 0, lh)
            main.Position = UDim2.new(0, xOffset, 0, 0)
            main.BackgroundTransparency = 1
            main.Text = data.text
            main.TextColor3 = Color3.new(1, 1, 1)
            main.TextSize = fs
            main.Font = Enum.Font.SourceSansBold
            main.TextXAlignment = Enum.TextXAlignment.Left
            main.Parent = container
            xOffset = xOffset + gap
        end
        UI.Livestream = container
    end

    function UI.ToggleLivestream(value)
        if value then
    
        else
            UI.DestroyLivestream()
        end
    end

    function UI.UpdateBtnPos()
        if not UI.ShowButton then return end
        if State.Toggles["settings.toggle.custom_btn_pos"] then
            local x = State.Sliders["settings.ui.btn_pos_x"] or 90
            local y = State.Sliders["settings.ui.btn_pos_y"] or 50
            UI.ShowButton.Position = UDim2.new(1, -x, 0, y)
            UI.ShowButton.Visible = true
            UI.ShowButtonDragLock = true
        else
            if UI.Main and UI.Main.Visible then
                UI.ShowButton.Visible = false
            end
            UI.ShowButton.Position = UDim2.new(1, -90, 0, 50)
            UI.ShowButtonDragLock = false
        end
    end
    
    function UI.UpdateBtnSize()
        if not UI.ShowButton then return end
        local sz = State.Sliders["settings.ui.btn_size"] or 80
        UI.ShowButton.Size = UDim2.fromOffset(sz, math.floor(sz * 0.5))
    end

    function UI.Build()
        UI.Destroy()
        RegisterPageKeys()

        local root = New("ScreenGui", {
            Name = AppConfig.GuiName,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            Parent = UI.GetScreenParent(),
        })
        UI.RootGui = root
        UI.BuildToastRoot(root)

        local initialWindowSize = UI.GetBoundedWindowSize()
        local main = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Colors.Window,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(initialWindowSize.X, initialWindowSize.Y),
            Parent = root,
        })
        AddCorner(main, Theme.Radius.Window)
        AddStroke(main, Theme.Colors.StrokeStrong)
        main.ClipsDescendants = true
        UI.Main = main

        UI.Scale = New("UIScale", {
            Scale = State.DpiScale,
            Parent = main,
        })

        local topbar = New("Frame", {
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.fromOffset(1, 1),
            Size = UDim2.new(1, -2, 0, 41),
            Parent = main,
        })
        AddCorner(topbar, Theme.Radius.Window)

        local logo = New("ImageLabel", {
            BackgroundTransparency = 1,
            Image = "rbxassetid://104393405110206",
            ScaleType = Enum.ScaleType.Fit,
            Position = UDim2.fromOffset(10, 8),
            Size = UDim2.fromOffset(125, 26),
            Parent = topbar,
        })

        local topRight = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.new(1, -150, 0, 30),
            Parent = topbar,
        })

        -- Top-right controls: buttons anchored to right edge
        local topRightLayout = {
            MarqueePosition = UDim2.fromOffset(0, 0),
            MarqueeSize = UDim2.new(1, -75, 0, 30),
            MinimizePosition = UDim2.new(1, -70, 0, -2.5),
            MinimizeSize = UDim2.fromOffset(35, 35),
            ClosePosition = UDim2.new(1, -30, 0, -2.5),
            CloseSize = UDim2.fromOffset(35, 35),
        }

        local closeButton = Components.IconButton(topRight, "window.close", "X", "关闭窗口", function()
            UI.Confirm("确认退出", "确定要关闭此脚本吗？关闭之后需要重新执行脚本才能打开哦。", function()
                State:AddLog("UI", "关闭窗口", "window.close")
                UI.Destroy()
            end)
        end)
        closeButton.Position = topRightLayout.ClosePosition
        closeButton.Size = topRightLayout.CloseSize

        local minimizeButton = Components.IconButton(topRight, "window.minimize", "-", "最小化窗口", function()
            UI.SetVisible(false)
        end)
        minimizeButton.Position = topRightLayout.MinimizePosition
        minimizeButton.Size = topRightLayout.MinimizeSize

        local marquee = Components.Marquee(topRight, AppConfig.MarqueeText)
        marquee.Position = topRightLayout.MarqueePosition
        marquee.Size = topRightLayout.MarqueeSize

        UI.BuildSidebar(main)

        UI.Content = New("ScrollingFrame", {
            BackgroundColor3 = Theme.Colors.Background,
            Position = UDim2.fromOffset(150, 42),
            Size = UDim2.new(1, -150, 1, -42),
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarThickness = 3,
            Parent = main,
        })
        AddCorner(UI.Content, Theme.Radius.Window)

        UI.ShowButton = New("ImageButton", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(1, -90, 0, 50),
            Size = UDim2.fromOffset(80, 40),
            Image = "rbxassetid://106447267002508",
            BackgroundTransparency = 1,
            ZIndex = 999,
            Visible = false,
            Parent = root,
        })
        AddCorner(UI.ShowButton, 8)
        UI.ShowButtonStroke = AddStroke(UI.ShowButton, Color3.fromRGB(255, 255, 255))
        UI.ShowScale = New("UIScale", {
            Scale = State.DpiScale,
            Parent = UI.ShowButton,
        })

        UI._showDragStart = nil
        UI.ShowButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                UI._showDragStart = input.Position
            end
        end)
        UI.ShowButton.InputEnded:Connect(function(input)
            if UI._showDragStart and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                local dx = math.abs(input.Position.X - UI._showDragStart.X)
                local dy = math.abs(input.Position.Y - UI._showDragStart.Y)
                if dx > 8 or dy > 8 then
                    UI.ShowButton.Active = false
                    task.delay(0.15, function() UI.ShowButton.Active = true end)
                end
                UI._showDragStart = nil
            end
        end)
        UI.ShowButton.Activated:Connect(function()
            Tween(UI.ShowButton, { Size = UDim2.fromOffset(72, 36) }, Theme.Animation.Press)
            task.delay(Theme.Animation.Press + 0.04, function()
                Tween(UI.ShowButton, { Size = UDim2.fromOffset(80, 40) }, Theme.Animation.Fast)
            end)
            UI.SetVisible(true)
        end)

        UI.MakeDraggable(main, topbar)
        UI.MakeDraggable(UI.ShowButton, UI.ShowButton)
        UI.Track(Services.UserInputService.InputBegan:Connect(function(input, processed)
            if processed or input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end

            local toggleKeyName = State.Keybinds["settings.keybind.toggle_ui"] or "RightShift"
            if input.KeyCode.Name == toggleKeyName then
                UI.SetVisible(not (UI.Main and UI.Main.Visible))
            end
        end))
        UI.Track(root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            UI.ApplyWindowBounds()
        end))

        UI.SetPage(AppConfig.DefaultPage)
        task.defer(function()
        end)
        UI.UpdateBtnPos()
        State:AddLog("UI", "欢迎使用此脚本。当前已进入中转站", "app.start")
        State:AddLog("UI", "请选择合适的服务器，祝你使用愉快。", "app.start")
        UI.ShowCenterToast("欢迎使用青木脚本")
    end

    local previous = rawget(_G, "BanFengHeUIFramework")
    if previous and previous.UI and previous.UI.Destroy then
        pcall(function()
            previous.UI.Destroy()
        end)
    end

    -- ===== ConfigManager — 存档系统 =====
    ConfigManager = {
        Configs = {},
        CurrentName = nil,
    }

    function ConfigManager:TryWriteFile(path, data)
        local ok = pcall(function() writefile(path, data) end)
        if ok then return true end
        return false
    end
    function ConfigManager:TryReadFile(path)
        local ok, result = pcall(function() return readfile(path) end)
        if ok then return true, result end
        return false, nil
    end
    function ConfigManager:TryDeleteFile(path)
        local ok = pcall(function() delfile(path) end)
        return ok
    end
    function ConfigManager:TryListFiles(pattern)
        if not listfiles then return false, {} end
        local ok, files = pcall(function()
            local results = {}
            for _, f in ipairs(listfiles('') or {}) do
                if tostring(f):match(pattern) then
                    local name = f:match('UI_Config_(.+)%.json') or f
                    local decoded = game:GetService("HttpService"):UrlDecode(name)
                    table.insert(results, decoded)
                end
            end
            return results
        end)
        if ok then return true, files end
        return false, {}
    end

    function ConfigManager:SaveConfig(name)
        if not name or name == '' then return false, '请输入配置名称' end

        -- 叠加替换模式：关=自动编号，开=直接覆盖
        if State.Toggles["config.toggle.overwrite"] == false then
            local suffix = 1
            local newName = name
            while ConfigManager.Configs[newName] ~= nil do
                newName = name .. " (" .. suffix .. ")"
                suffix = suffix + 1
            end
            name = newName
        end

        local data = {
            __version = 1.0,
            __savedAt = os.time(),
            Toggles = {},
            Sliders = {},
            Inputs = {},
            Dropdowns = {},
            Segments = {},
            Colors = {},
            Numbers = {},
            MultiDropdowns = {},
            Keybinds = {},
        }

        for k, v in pairs(State.Toggles or {}) do data.Toggles[k] = v end
        for k, v in pairs(State.Sliders or {}) do data.Sliders[k] = v end
        for k, v in pairs(State.Inputs or {}) do if type(v)=="string" and not v:find("^table: 0") then data.Inputs[k]=v end end
        for k, v in pairs(State.Dropdowns or {}) do if type(v)=="string" and not v:find("^table: 0") then data.Dropdowns[k]=v end end
        for k, v in pairs(State.Segments or {}) do data.Segments[k] = v end
        for k, v in pairs(State.Colors or {}) do data.Colors[k] = v end
        for k, v in pairs(State.Numbers or {}) do data.Numbers[k] = v end
        for k, v in pairs(State.MultiDropdowns or {}) do data.MultiDropdowns[k] = v end
        for k, v in pairs(State.Keybinds or {}) do data.Keybinds[k] = v end

        local json = game:GetService('HttpService'):JSONEncode(data)
        local writeOk = ConfigManager:TryWriteFile('青木/UI_Config_' .. name .. '.json', json)
        if not writeOk then return false, '保存失败' end
        ConfigManager.Configs[name] = data
        ConfigManager.CurrentName = name
        return true, '配置已保存: ' .. name
    end

    function ConfigManager:LoadConfig(name)
        if not name then return false, '请选择配置' end
        if ConfigManager.Configs[name] and ConfigManager.Configs[name] ~= true then
            return ConfigManager:ApplyData(ConfigManager.Configs[name], name)
        end
        local readOk, json = ConfigManager:TryReadFile('青木/UI_Config_' .. name .. '.json')
        if not readOk then return false, '配置不存在: ' .. name end
        local decodeOk, data = pcall(function()
            return game:GetService('HttpService'):JSONDecode(json)
        end)
        if not decodeOk then return false, '配置解析失败' end
        ConfigManager.Configs[name] = data
        return ConfigManager:ApplyData(data, name)
    end


    local APPLY = {
        ["pvp.toggle.aimbot"] = function(v) PVP.toggle(v) end,
        ["pvp.toggle.team"] = function(v) PVP.toggleTeamCheck(v) end,
        ["pvp.toggle.fov"] = function(v) PVP.toggleFOV(v) end,
        ["pvp.toggle.prediction"] = function(v) PVP.togglePrediction(v) end,
        ["pvp.slider.fov_range"] = function(v) PVP.setFOV(v) end,
        ["pvp.slider.bullet_speed"] = function(v) PVP.setBulletSpeed(v) end,
        ["pvp.dropdown.aim_part"] = function(v) PVP.setAimPart(v) end,
        ["pvp_auto_fire.toggle.enabled"] = function(v) PVP.toggleAutoFire(v) end,
        ["pvp_auto_fire.toggle.team_check"] = function(v) PVP.toggleAutoFireTeamCheck(v) end,
        ["pvp_auto_fire.toggle.raycast"] = function(v) PVP.toggleAutoFireRaycast(v) end,
        ["pvp_auto_fire.toggle.autoreload"] = function(v) PVP.toggleAutoFireReload(v) end,
        ["pvp_auto_fire.slider.aim_time"] = function(v) PVP.setAutoFireAimTime(v) end,
        ["pvp_auto_fire.slider.shoot_interval"] = function(v) PVP.setAutoFireShootInterval(v) end,
        ["pvp_auto_fire.slider.equip_speed"] = function(v) PVP.setAutoFireEquipSpeed(v) end,
        ["pvp_auto_fire.slider.max_aim_range"] = function(v) PVP.setAutoFireMaxRange(v) end,
        ["pvp.toggle.teleport"] = function(v) PVP.toggleTeleport(v) end,
        ["pvp.toggle.bayonet"] = function(v) PVP.toggleBayonet(v) end,
        ["pvp.toggle.melee"] = function(v) PVP.toggleMelee(v) end,
                                        ["kill.toggle.hitbox_zombie"] = function(v) KILL.toggleZombieHitbox(v) end,
        ["kill.slider.hitbox_zombie_size"] = function(v) KILL.setZombieHitboxSize(v) end,
        ["kill.toggle.highfreq"] = function(v) KILL.toggleHighFreq(v) end,
        ["kill.toggle.bayonet"] = function(v) KILL.toggleBayonet(v) end,
        ["kill.toggle.wall_barrel"] = function(v) KILL.toggleWallBarrel(v) end,
        ["features.toggle.auto_face"] = function(v) KILL.toggleAutoFace(v) end,
        ["kill.toggle.show_type_labels"] = function(v) KILL.toggleTypeLabels(v) end,

        ["esp.toggle.axe"] = function(v) ESP.zombieToggle("Axe", v) end,
        ["esp.toggle.axe_name"] = function(v) ESP.zombieName("Axe", v) end,
        ["esp.toggle.runner"] = function(v) ESP.zombieToggle("Eye", v) end,
        ["esp.toggle.runner_name"] = function(v) ESP.zombieName("Eye", v) end,
        ["esp.toggle.cuirassier"] = function(v) ESP.zombieToggle("Sword", v) end,
        ["esp.toggle.cuirassier_name"] = function(v) ESP.zombieName("Sword", v) end,
        ["esp.toggle.barrel"] = function(v) ESP.zombieToggle("Barrel", v) end,
        ["esp.toggle.barrel_name"] = function(v) ESP.zombieName("Barrel", v) end,
        ["esp.toggle.lantern"] = function(v) ESP.zombieToggle("FTorso", v) end,
        ["esp.toggle.lantern_name"] = function(v) ESP.zombieName("FTorso", v) end,
        ["esp.toggle.normal"] = function(v) ESP.zombieToggle("Normal", v) end,
        ["esp.toggle.normal_name"] = function(v) ESP.zombieName("Normal", v) end,
        ["esp.toggle.fort_roundshot"] = function(v) ESP.toggleFortDraw("RoundShot", v) end,
        ["esp.toggle.fort_swab"] = function(v) ESP.toggleFortDraw("Swab", v) end,
        ["esp.toggle.player"] = function(v) ESP.playerToggle(v) end,
        ["esp.toggle.player_name"] = function(v) ESP.playerName(v) end,
        ["esp.toggle.player_health"] = function(v) ESP.playerHealth(v) end,
        ["esp.toggle.player_team"] = function(v) ESP.playerTeam(v) end,
        ["get.button.baguette"] = function() FEATURES.getBaguette() end,
        ["get.button.voivode"] = function() FEATURES.getVoivode() end,
        ["get.button.stake"] = function() FEATURES.getStake() end,
        ["get.button.all"] = function() FEATURES.getAllWeapons() end,
        ["get.button.achievement"] = function() FEATURES.getAchievement() end,
        ["get.button.baguette"] = function() FEATURES.getBaguette() end,
        ["get.button.voivode"] = function() FEATURES.getVoivode() end,
        ["get.button.stake"] = function() FEATURES.getStake() end,
        ["get.button.all"] = function() FEATURES.getAllWeapons() end,
        ["features.toggle.coord_speed"] = function(v) FEATURES.toggleCoordSpeed(v) end,
        ["features.slider.coord_speed"] = function(v) FEATURES.setCoordSpeed(v) end,
        ["features.toggle.speed"] = function(v) FEATURES.toggleSpeed(v) end,
        ["features.slider.player_speed"] = function(v) FEATURES.setPlayerSpeed(v) end,
        ["features.toggle.fly"] = function(v) FEATURES.toggleFly(v) end,
        ["features.slider.fly_speed"] = function(v) FEATURES.setFlySpeed(v) end,
        ["features.toggle.autodig"] = function(v) FEATURES.toggleAutoDig(v) end,
        ["features.toggle.autocollect"] = function(v) FEATURES.toggleAutoCollect(v) end,
        ["features.toggle.autodoor"] = function(v) FEATURES.toggleAutoDoor(v) end,
        ["features.toggle.autocannon"] = function(v) FEATURES.toggleAutoCannon(v) end,
        ["features.toggle.autobrick"] = function(v) FEATURES.toggleAutoBrick(v) end,
        ["features.toggle.autobarrel"] = function(v) FEATURES.toggleAutoBarrel(v) end,
        ["features.toggle.autowestminster"] = function(v) FEATURES.toggleAutoWestminster(v) end,
        ["features.toggle.autoleipzig"] = function(v) FEATURES.toggleAutoLeipzig(v) end,
        ["features.toggle.autoleipzig_barricade"] = function(v) FEATURES.toggleAutoLeipzigBarricade(v) end,
        ["features.toggle.autocopenhagen"] = function(v) FEATURES.toggleAutoCopenhagenGate(v) end,
        ["features.toggle.autobell"] = function(v) FEATURES.toggleAutoBell(v) end,
        ["features.toggle.autolog"] = function(v) FEATURES.toggleAutoLog(v) end,
        ["features.toggle.autoplace"] = function(v) FEATURES.toggleAutoPlace(v) end,
        ["features.toggle.autobridge"] = function(v) FEATURES.toggleAutoBridge(v) end,
        ["features.toggle.autorepair"] = function(v) FEATURES.toggleAutoRepair(v) end,
        ["fun.toggle.spin"] = function(v) FEATURES.toggleSpin(v) end,
        ["fun.slider.spin_speed"] = function(v) FEATURES.setSpinSpeed(v) end,
        ["fun.toggle.handstand"] = function(v) FEATURES.toggleHandstand(v) end,
        ["features.toggle.jump_control"] = function(v) FEATURES.toggleJumpControl(v) end,
        ["features.toggle.manual_jump"] = function(v) FEATURES.toggleManualJump(v) end,
        ["features.toggle.recycle"] = function(v) FEATURES.toggleRecycle(v) end,
        ["features.toggle.elbow_range"] = function(v) FEATURES.toggleElbowRange(v) end,
        ["features.toggle.elbow"] = function(v) FEATURES.toggleElbow(v) end,
        ["features.slider.auto_jump_height"] = function(v) FEATURES.setAutoJumpHeight(v) end,
        ["get.button.achievement"] = function() FEATURES.getAchievement() end,
        ["get.button.baguette"] = function() FEATURES.getBaguette() end,
        ["get.button.voivode"] = function() FEATURES.getVoivode() end,
        ["get.button.stake"] = function() FEATURES.getStake() end,
        ["get.button.all"] = function() FEATURES.getAllWeapons() end,
        ["protect.toggle.auto_escape"] = function(v) FEATURES.toggleAutoEscape(v) end,
        ["protect.slider.float_height"] = function(v) FEATURES.setFloatHeight(v) end,
        ["protect.toggle.fall_protect"] = function(v) FEATURES.toggleFallProtect(v) end,
        ["protect.toggle.damage_display"] = function(v) FEATURES.toggleDamageDisplay(v) end,
        ["protect.toggle.elbow_save"] = function(v) FEATURES.toggleElbowSave(v) end,
        ["protect.toggle.push_barrel"] = function(v) FEATURES.togglePushBarrel(v) end,
        ["protect.slider.push_barrel_size"] = function(v) FEATURES.setPushBarrelSize(v) end,
        ["fps.toggle.disable_fire"] = function(v) FEATURES.toggleFpsFire(v) end,
        ["fps.button.remove_carriage"] = function() FEATURES.fpsRemoveCarriage() end,
        ["fps.button.extreme_simplify"] = function() FEATURES.fpsExtremeSimplify() end,
        ["fps.slider.brightness"] = function(v) FEATURES.fpsSetBrightness(v) end,
        ["fps.button.del_hats"] = function() FEATURES.fpsRemoveHats() end,
        ["fps.button.del_shirts"] = function() FEATURES.fpsRemoveShirts() end,
        ["fps.button.del_pants"] = function() FEATURES.fpsRemovePants() end,
        ["fun.toggle.remove_jump_limit"] = function(v) FEATURES.toggleRemoveJumpLimit(v) end,
        ["fun.toggle.kill_sound"] = function(v) FEATURES.toggleKillSound(v) end,
        ["fun.slider.kill_sound_vol"] = function(v) FEATURES.setKillSoundVol(v) end,
        ["features.toggle.autobucket"] = function(v) FEATURES.toggleAutoBucket(v) end,
        ["features.toggle.london_board"] = function(v) FEATURES.toggleLondonBoard(v) end,
        ["esp.toggle.fort_supplies"] = function(v) FEATURES.toggleCannonSupplies(v) end,
        ["features.slider.leipzig_fly_speed"] = function(v) FEATURES.setLeipzigFlySpeed(v) end,
        ["features.toggle.path_visuals"] = function(v) FEATURES.togglePathVisuals(v) end,
    }

    local function _applySlider(k, v)
        local fn = APPLY[k]
        if fn then pcall(fn, v) end
    end

    local function _applyToggle(k, v)
        local fn = APPLY[k]
        if fn then pcall(fn, v) end
    end

    function ConfigManager:ApplyData(data, name)
        -- Pre-clean: reset any corrupted values (tables or table-ref strings) in State before applying saved data
        for k, v in pairs(State.Inputs) do
            if type(v) ~= "string" or v:find("^table: 0") then
                State.Inputs[k] = ""
            end
        end
        for k, v in pairs(State.Dropdowns) do
            if type(v) ~= "string" or v:find("^table: 0") then
                State.Dropdowns[k] = ""
            end
        end
        if data.Toggles then
            for k, v in pairs(data.Toggles) do
                if type(v) ~= "boolean" then continue end
                State.Toggles[k] = v
                local ctrl = State.Controls[k]
                if ctrl and ctrl.SetValue then ctrl.SetValue(v, true, true) end
                _applyToggle(k, v)
                local alFn = State.OnLoad and State.OnLoad[k]
                if alFn then pcall(alFn, v) end
            end
        end
        if data.Sliders then
            for k, v in pairs(data.Sliders) do
                if type(v) ~= "number" then continue end
                State.Sliders[k] = v
                local ctrl = State.Controls[k]
                if ctrl and ctrl.SetValue then ctrl.SetValue(v, true, true) end
                _applySlider(k, v)
            end
        end
        if data.Inputs then
            for k, v in pairs(data.Inputs) do
                if type(v) ~= "string" or v:find("^table: 0") then continue end
                State.Inputs[k] = v
                local ctrl = State.Controls[k]
                if ctrl and ctrl.SetValue then ctrl.SetValue(v, true, true) end
            end
        end
        if data.Dropdowns then
            for k, v in pairs(data.Dropdowns) do
                if type(v) ~= "string" or v:find("^table: 0") then continue end
                State.Dropdowns[k] = v
                local ctrl = State.Controls[k]
                if ctrl and ctrl.SetValue then ctrl.SetValue(v, true, true) end
                _applySlider(k, v)
            end
        end
        if data.Segments then
            for k, v in pairs(data.Segments) do
                if type(v) ~= "string" then continue end
                State.Segments[k] = v
                local ctrl = State.Controls[k]
                if ctrl and ctrl.SetValue then ctrl.SetValue(v, true, true) end
            end
        end
        if data.Colors then
            for k, v in pairs(data.Colors) do
                State.Colors[k] = v
                local ctrl = State.Controls[k]
                if ctrl and ctrl.SetValue then ctrl.SetValue(v, true, true) end
            end
        end
        if data.Numbers then
            for k, v in pairs(data.Numbers) do
                if type(v) ~= "number" then continue end
                State.Numbers[k] = v
                local ctrl = State.Controls[k]
                if ctrl and ctrl.SetValue then ctrl.SetValue(v, true, true) end
            end
        end
        if data.MultiDropdowns then
            for k, v in pairs(data.MultiDropdowns) do
                State.MultiDropdowns[k] = v
                local ctrl = State.Controls[k]
                if ctrl and ctrl.SetValue then ctrl.SetValue(v, true, true) end
            end
        end
        if data.Keybinds then
            for k, v in pairs(data.Keybinds) do
                State.Keybinds[k] = v
                local ctrl = State.Controls[k]
                if ctrl and ctrl.SetValue then ctrl.SetValue(v, true, true) end
            end
        end
        
ConfigManager.CurrentName = name
        return true, '配置已加载: ' .. name
    end

    function ConfigManager:ListConfigs()
        local names = {}
        for name in pairs(ConfigManager.Configs) do
            if ConfigManager.Configs[name] ~= true then table.insert(names, name) end
        end
        if listfiles then
            local ok, files = ConfigManager:TryListFiles('青木/UI_Config_(.+)%.json')
            if ok then
                for _, f in ipairs(files or {}) do
                    local found = false
                    for _, n in ipairs(names) do if n == f then found = true; break end end
                    if not found then table.insert(names, f); ConfigManager.Configs[f] = true end
                end
            end
        end
        table.sort(names)
        return names
    end

    function ConfigManager:_DebugConfigs()
        local out = {}
        if listfiles then
            local all = {listfiles("")}
            table.insert(out, "files: " .. #all)
            for _, f in ipairs(all) do
                if tostring(f):find("UI_Config_") then
                    table.insert(out, "  found: " .. tostring(f))
                end
            end
        end
        for k in pairs(ConfigManager.Configs) do
            table.insert(out, "  memory: " .. tostring(k))
        end
        return out
    end

    function ConfigManager:WriteAutoLoad(name)
        local ok = pcall(function() writefile("UI_Config_autoload.txt", name) end)
        return ok
    end

        function ConfigManager:ReadAutoLoad()
        local ok, data = pcall(function() return readfile("UI_Config_autoload.txt") end)
        if ok and data and data ~= "" then
            return true, data:match("^%s*(.-)%s*$")
        end
        return false, nil
    end

    function ConfigManager:DeleteConfig(name)
        if not name then return false, '请选择配置' end
        local ok = ConfigManager:TryDeleteFile('青木/UI_Config_' .. name .. '.json')
        ConfigManager.Configs[name] = nil
        if ConfigManager.CurrentName == name then ConfigManager.CurrentName = nil end
        return true, '已删除: ' .. name
    end

    function ConfigManager:RefreshDropdown()
        local names = ConfigManager:ListConfigs()
        local opts = {}
        for _, n in ipairs(names) do
            table.insert(opts, { label = n, value = n })
        end
        local ctrl = State.Controls['config.dropdown.select']
        if ctrl and ctrl.SetOptions then ctrl:SetOptions(opts) end

        -- 如果当前选中的配置已不存在，重置为"无"
        if ctrl and ctrl.SetValue then
            local currentVal = State.Dropdowns['config.dropdown.select']
            if currentVal and currentVal ~= '无' then
                local found = false
                for _, opt in ipairs(opts) do
                    if opt.value == currentVal then found = true; break end
                end
                if not found then
                    ctrl.SetValue('无', true)
                end
            end
        end

        local statusCtrl = State.Controls['config.status.current']
        if statusCtrl and statusCtrl.SetValue then
            statusCtrl.SetValue(statusCtrl, ConfigManager.CurrentName or '无', true)
        end
    end

    -- ===== AutoSave =====
    do
        local AutoSave = {
            Dirty = false,
            SaveInterval = 5,
            Filename = 'UI_Config_autosave',
        }

        local OrigStateSet = State.Set
        if OrigStateSet then
            State.Set = function(self, kind, key, value)
                OrigStateSet(self, kind, key, value)
                if kind == 'toggle' and key == 'config.toggle.autosave' and not value then
                    pcall(function() delfile('UI_Config_autosave.json') end)
                end
                if not State.Toggles['config.toggle.autosave'] then return end
                AutoSave.Dirty = true
            end
        end

        -- Auto-save loop
        task.spawn(function()
            while task.wait(AutoSave.SaveInterval) do
                if not State.Toggles['config.toggle.autosave'] then AutoSave.Dirty = false; continue end
                if not AutoSave.Dirty then continue end
                AutoSave.Dirty = false
                local data = {
                    __version = 1.0,
                    Toggles = {}, Sliders = {}, Inputs = {},
                    Dropdowns = {}, Segments = {}, Colors = {},
                    Numbers = {}, MultiDropdowns = {}, Keybinds = {},
                }
                for k, v in pairs(State.Toggles or {}) do data.Toggles[k] = v end
                for k, v in pairs(State.Sliders or {}) do data.Sliders[k] = v end
                for k, v in pairs(State.Inputs or {}) do if type(v)=="string" and not v:find("^table: 0") then data.Inputs[k]=v end end
                for k, v in pairs(State.Dropdowns or {}) do if type(v)=="string" and not v:find("^table: 0") then data.Dropdowns[k]=v end end
                for k, v in pairs(State.Segments or {}) do data.Segments[k] = v end
                for k, v in pairs(State.Colors or {}) do data.Colors[k] = v end
                for k, v in pairs(State.Numbers or {}) do data.Numbers[k] = v end
                for k, v in pairs(State.MultiDropdowns or {}) do data.MultiDropdowns[k] = v end
                for k, v in pairs(State.Keybinds or {}) do data.Keybinds[k] = v end
                local ok, json = pcall(function()
                    return game:GetService('HttpService'):JSONEncode(data)
                end)
                if ok then ConfigManager:TryWriteFile(AutoSave.Filename .. '.json', json) end
            end
        end)

        
        -- Startup cleanup: delete corrupted autosave and manual config files
        pcall(function()
            local ok, json = ConfigManager:TryReadFile('UI_Config_autosave.json')
            if ok and json then
                local corrupted = json:find('table: 0') ~= nil
                if corrupted then
                    ConfigManager:TryDeleteFile('UI_Config_autosave.json')
                end
            end
        end)
        pcall(function()
            if not listfiles then return end
            local ok, files = ConfigManager:TryListFiles('青木/UI_Config_(.+)%.json')
            if ok and files then
                for _, fname in ipairs(files) do
                    local fok, fjson = ConfigManager:TryReadFile('青木/UI_Config_' .. fname .. '.json')
                    if fok and fjson and fjson:find('table: 0') then
                        ConfigManager:TryDeleteFile('青木/UI_Config_' .. fname .. '.json')
                    end
                end
            end
        end)
-- Load autosave
        task.spawn(function()
            task.wait(1)
            local readOk, json = ConfigManager:TryReadFile(AutoSave.Filename .. '.json')
            if readOk then
                local decodeOk, data = pcall(function()
                    return game:GetService('HttpService'):JSONDecode(json)
                end)
                if decodeOk and data.Toggles and data.Toggles['config.toggle.autosave'] then
                    if data.Toggles then for k, v in pairs(data.Toggles) do if type(v)=="boolean" then State.Toggles[k]=v end end end
                    if data.Sliders then for k, v in pairs(data.Sliders) do if type(v)=="number" then State.Sliders[k]=v end end end
                    if data.Inputs then for k, v in pairs(data.Inputs) do if type(v)=="string" and not v:find("^table: 0") then State.Inputs[k]=v end end end
                    if data.Dropdowns then for k, v in pairs(data.Dropdowns) do if type(v)=="string" and not v:find("^table: 0") then State.Dropdowns[k]=v end end end
                    if data.Segments then for k, v in pairs(data.Segments) do State.Segments[k] = v end end
                    if data.Colors then for k, v in pairs(data.Colors) do State.Colors[k] = v end end
                    if data.Numbers then for k, v in pairs(data.Numbers) do State.Numbers[k] = v end end
                    if data.MultiDropdowns then for k, v in pairs(data.MultiDropdowns) do State.MultiDropdowns[k] = v end end
                    if data.Keybinds then for k, v in pairs(data.Keybinds) do State.Keybinds[k] = v end end
                    State:AddLog('AutoSave', '自动存档已恢复', 'autosave.load')
                end
            end
        end)
    end

    -- ===== AutoSave End =====

            Registry.Bind("server.s_0", function()
        local url = "https://raw.githubusercontent.com/frkfx/Combat-Warriors/main/Script"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[⚔️ Combat Warriors / 战斗勇士] 战斗勇士Hydra Hub V2 已执行", "server.s_0")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_0")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_0")
        end
    end)

    Registry.Bind("server.s_1", function()
        local url = "https://rawscripts.net/raw/ENTRENCHED-WW1-USA-Imp-Hub-X-Silent-Aim-Aimbot-Auto-Reload-Auto-Deploy-Esp-83633"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[⚔️ Entrenched] 根深蒂固ww1脚本 已执行", "server.s_1")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_1")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_1")
        end
    end)

    Registry.Bind("server.s_2", function()
        local url = "https://pastebin.com/raw/FqaMTqtT"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[⚽ Blade Ball / 刀刃球] 刀刃球3 已执行", "server.s_2")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_2")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_2")
        end
    end)

    Registry.Bind("server.s_3", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/UWU.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[⚽ Blade Ball / 刀刃球] 刀刃球世界最强脚本uwuKenny汉化 已执行", "server.s_3")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_3")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_3")
        end
    end)

    Registry.Bind("server.s_4", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/nodex.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[⚽ Blade Ball / 刀刃球] 刀刃球nodex脚本Kenny汉化 已执行", "server.s_4")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_4")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_4")
        end
    end)

    Registry.Bind("server.s_5", function()
        local url = "https://pastebin.com/raw/hkvHeHed"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🇺🇸 Ohio / 俄亥俄州] 俄亥俄州(1) (1) 已执行", "server.s_5")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_5")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_5")
        end
    end)

    Registry.Bind("server.s_6", function()
        local url = "https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/Ohio.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🇺🇸 Ohio / 俄亥俄州] 俄亥俄州脚本BRUH (1) 已执行", "server.s_6")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_6")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_6")
        end
    end)

    Registry.Bind("server.s_7", function()
        local url = "https://gist.githubusercontent.com/ClasiniZukov/e7547e7b48fa90d10eb7f85bd3569147/raw/f95cd3561a3bb3ac6172a14eb74233625b52e757/gistfile1.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🇺🇸 Ohio / 俄亥俄州] 俄亥俄州子追秒开保险柜脚本 已执行", "server.s_7")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_7")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_7")
        end
    end)

    Registry.Bind("server.s_8", function()
        local url = "https://raw.githubusercontent.com/454244513/Open-Source/refs/heads/main/Ohio%20Blade%20Spam.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🇺🇸 Ohio / 俄亥俄州] Ohio Blade Spam 已执行", "server.s_8")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_8")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_8")
        end
    end)

    Registry.Bind("server.s_9", function()
        local url = "https://raw.githubusercontent.com/leg1337/legadmv2/main/legadminv2.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[✨ 飞行脚本（通用）] 飞行脚本 已执行", "server.s_9")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_9")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_9")
        end
    end)

    Registry.Bind("server.s_10", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/js.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[✨ FE 通用脚本] 猎杀僵尸zeehubKenny汉化 已执行", "server.s_10")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_10")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_10")
        end
    end)

    Registry.Bind("server.s_11", function()
        local url = "https://raw.githubusercontent.com/wehjf/Pestilenceringta.github.io/refs/heads/main/horseringta.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[✨ FE 通用脚本] 找僵尸马 已执行", "server.s_11")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_11")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_11")
        end
    end)

    Registry.Bind("server.s_12", function()
        local url = "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Goner"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[✨ FE 通用脚本] FE Goner Hat Script 通用 DA 引擎盖支持(通用) 已执行", "server.s_12")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_12")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_12")
        end
    end)

    Registry.Bind("server.s_13", function()
        local url = "https://pastefy.app/w7KnPY70/raw"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[✨ FE 通用脚本] FE僵尸脚本支持R6 已执行", "server.s_13")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_13")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_13")
        end
    end)

    Registry.Bind("server.s_14", function()
        local url = "https://pastefy.app/S7xNJSXX/raw"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[✨ FE 通用脚本] fe热更改虚拟形象 已执行", "server.s_14")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_14")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_14")
        end
    end)

    Registry.Bind("server.s_15", function()
        local url = "https://pastebin.com/raw/K0khSQFN"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[✨ FE 通用脚本] FE隐形 已执行", "server.s_15")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_15")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_15")
        end
    end)

    Registry.Bind("server.s_16", function()
        local url = "https://rawscripts.net/raw/Universal-Script-Hug-Gui-R6-17818"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[✨ FE 通用脚本] FE拥抱脚本(3) 已执行", "server.s_16")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_16")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_16")
        end
    end)

    Registry.Bind("server.s_17", function()
        local url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[✨ FE 通用脚本] FE指令 已执行", "server.s_17")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_17")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_17")
        end
    end)

    Registry.Bind("server.s_18", function()
        local url = "https://raw.githubusercontent.com/JackHiggly/RobloxThings/main/FemWare0"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🌌 星体犯罪 / Criminality] femware(犯罪脚本) (2) 已执行", "server.s_18")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_18")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_18")
        end
    end)

    Registry.Bind("server.s_19", function()
        local url = "https://raw.githubusercontent.com/atnew2025/Chinese-scripts/refs/heads/main/voidware-cn.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🌙 99夜 / 森林中的99夜] 99夜虚空简体汉化脚本（无卡密） 已执行", "server.s_19")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_19")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_19")
        end
    end)

    Registry.Bind("server.s_20", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/99%E5%A4%9C%E8%99%9A%E7%A9%BA.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🌙 99夜 / 森林中的99夜] 99夜虚空脚本Kenny汉化 已执行", "server.s_20")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_20")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_20")
        end
    end)

    Registry.Bind("server.s_21", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/99Nights"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🌙 99夜 / 森林中的99夜] 99夜op级汉化脚本 已执行", "server.s_21")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_21")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_21")
        end
    end)

    Registry.Bind("server.s_22", function()
        local url = "https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/99day.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🌙 99夜 / 森林中的99夜] 二狗子森林中的99夜脚本 已执行", "server.s_22")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_22")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_22")
        end
    end)

    Registry.Bind("server.s_23", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/99Cps%20natural.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🌙 99夜 / 森林中的99夜] 森林里的99夜Cps natural脚本（个人感觉比虚空强）Kenny汉化 已执行", "server.s_23")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_23")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_23")
        end
    end)

    Registry.Bind("server.s_24", function()
        local url = "https://raw.githubusercontent.com/xyx8846/-/refs/heads/main/H4x%E6%B1%89%E5%8C%96%E8%84%9A%E6%9C%AC"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🌙 99夜 / 森林中的99夜] 森林中的99夜H4x脚本小鱼仙汉化(完整汉化版) 已执行", "server.s_24")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_24")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_24")
        end
    end)

    Registry.Bind("server.s_25", function()
        local url = "https://raw.githubusercontent.com/xcmsnd/-/refs/heads/main/obfuscated_script-1758337497437.lua.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🌙 99夜 / 森林中的99夜] L l森林99夜(1) 已执行", "server.s_25")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_25")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_25")
        end
    end)

    Registry.Bind("server.s_26", function()
        local url = "https://raw.githubusercontent.com/krlpl/Deciduous-center-LS/main/%E8%90%BD%E5%8F%B6%E4%B8%AD%E5%BF%83%E6%B7%B7%E6%B7%86.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🍂 落叶中心] 落叶中心 已执行", "server.s_26")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_26")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_26")
        end
    end)

    Registry.Bind("server.s_27", function()
        local url = "https://raw.githubusercontent.com/NukeVsCity/TheALLHACKLoader/main/NukeLoader"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🍽️ Restaurant Tycoon] 我的餐厅自动烹饪自动送餐生意金额超多 已执行", "server.s_27")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_27")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_27")
        end
    end)

    Registry.Bind("server.s_28", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/AUTVellure.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🎀 AUT] AUT脚本VellureKenny汉化+破解卡密验证 已执行", "server.s_28")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_28")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_28")
        end
    end)

    Registry.Bind("server.s_29", function()
        local url = "https://raw.githubusercontent.com/Hanabi112/Loading/main/main.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🏴‍☠️ Blox Fruits / 海贼王] 海贼王9大超级脚本(1) (1) 已执行", "server.s_29")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_29")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_29")
        end
    end)

    Registry.Bind("server.s_30", function()
        local url = "https://scriptblox.com/raw/UPDATE-16-Blox-Fruits-xQuartyx-Blox-Fruit-6557"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🏴‍☠️ Blox Fruits / 海贼王] 造船 已执行", "server.s_30")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_30")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_30")
        end
    end)

    Registry.Bind("server.s_31", function()
        local url = "https://raw.githubusercontent.com/Domadicoof/Domadicoof/main/Domadichub/NottoGay/Start.ranscript"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🏴‍☠️ Blox Fruits / 海贼王] bf脚本 已执行", "server.s_31")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_31")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_31")
        end
    end)

    Registry.Bind("server.s_32", function()
        local url = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🏴‍☠️ Blox Fruits / 海贼王] bf脚本 (1) 已执行", "server.s_32")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_32")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_32")
        end
    end)

    Registry.Bind("server.s_33", function()
        local url = "https://raw.githubusercontent.com/Anniecuti/Free-Scr/main/Annie-Hub.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🏴‍☠️ Blox Fruits / 海贼王] bf脚本好用的(1) (1) (1) 已执行", "server.s_33")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_33")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_33")
        end
    end)

    Registry.Bind("server.s_34", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/Redz"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🏴‍☠️ Blox Fruits / 海贼王] blox fruits汉化脚本-redz (1) 已执行", "server.s_34")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_34")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_34")
        end
    end)

    Registry.Bind("server.s_35", function()
        local url = "https://raw.githubusercontent.com/nahida-cn/Roblox/main/long"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🐉 龙脚本] 龙脚本(破解版)(1) 已执行", "server.s_35")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_35")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_35")
        end
    end)

    Registry.Bind("server.s_36", function()
        local url = "https://raw.githubusercontent.com/max0mind/lua/main/loader.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🐝 Bee Swarm Simulator] kometa蜂群(1) 已执行", "server.s_36")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_36")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_36")
        end
    end)

    Registry.Bind("server.s_37", function()
        local url = "https://raw.githubusercontent.com/dingding123hhh/anlushanjinchangantangwanle/refs/heads/main/bingshangdiaofish.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🐟 Fisch / 钓鱼] 冰上钓鱼模拟器 (1) 已执行", "server.s_37")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_37")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_37")
        end
    end)

    Registry.Bind("server.s_38", function()
        local url = "https://raw.githubusercontent.com/Yumiara/CPP/refs/heads/main/Main.cpp"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🐟 Fisch / 钓鱼] fisch脚本（无需卡密） 已执行", "server.s_38")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_38")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_38")
        end
    end)

    Registry.Bind("server.s_39", function()
        local url = "http://riverhub.xyz/"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[👑 King’s Legacy / 国王遗产] 国王遗产通用免费脚本 已执行", "server.s_39")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_39")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_39")
        end
    end)

    Registry.Bind("server.s_40", function()
        local url = "https://api.luarmor.net/files/v3/loaders/64c115c468ba4af6ddc2f73daed2595c.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[👽 AlienX] AlienX-NOL (1) 已执行", "server.s_40")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_40")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_40")
        end
    end)

    Registry.Bind("server.s_41", function()
        local url = "https://raw.githubusercontent.com/SilkScripts/AppleStuff/refs/heads/main/AppleFSKV2"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[💀 WTB / 被遗弃] 被遗弃 已执行", "server.s_41")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_41")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_41")
        end
    end)

    Registry.Bind("server.s_42", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/%E8%A2%AB%E9%81%97%E5%BC%83"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[💀 WTB / 被遗弃] 被遗弃虚空汉化脚本 (1) 已执行", "server.s_42")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_42")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_42")
        end
    end)

    Registry.Bind("server.s_43", function()
        local url = "https://pastebin.com/raw/DNHCLyBB"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[💀 WTB / 被遗弃] WTB--新版 (1) 已执行", "server.s_43")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_43")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_43")
        end
    end)

    Registry.Bind("server.s_44", function()
        local url = "https://raw.githubusercontent.com/JackUltraman/fish/refs/heads/main/%E8%A2%AB%E9%81%97%E5%BC%83"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[💀 WTB / 被遗弃] WTB-被遗弃 (1) 已执行", "server.s_44")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_44")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_44")
        end
    end)

    Registry.Bind("server.s_45", function()
        local url = "https://raw.githubusercontent.com/Ethanoj1/EclipseMM2/master/Script"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[💣 Saboteur / 破坏者] 破坏者谜团2很多功能脚本 已执行", "server.s_45")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_45")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_45")
        end
    end)

    Registry.Bind("server.s_46", function()
        local url = "https://raw.githubusercontent.com/ThisIsTuff/ArmWrestleSim/main/ArmWrestleSim.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[💪 Arm Wrestling Simulator] 掰手腕模拟器 已执行", "server.s_46")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_46")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_46")
        end
    end)

    Registry.Bind("server.s_47", function()
        local url = "https://raw.githubusercontent.com/zilinskaslandon/AAAA/refs/heads/main/%E5%8C%97%E6%9E%81%E6%98%9F%E8%84%9A%E6%9C%ACV3%F0%9F%8D%92.Lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📂 脚本中心 / Hub] 北极星中心V3(1) 已执行", "server.s_47")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_47")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_47")
        end
    end)

    Registry.Bind("server.s_48", function()
        local url = "https://github.com/devslopo/DVES/raw/main/XK%20Hub"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📂 脚本中心 / Hub] 脚本中心脚本（有各种脚本） 已执行", "server.s_48")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_48")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_48")
        end
    end)

    Registry.Bind("server.s_49", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/skyhub"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📂 脚本中心 / Hub] 天空脚本中心正式版 (1) 已执行", "server.s_49")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_49")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_49")
        end
    end)

    Registry.Bind("server.s_50", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/Lonely_Hub.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📂 脚本中心 / Hub] Fish It脚本Lonely_HubKenny汉化 已执行", "server.s_50")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_50")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_50")
        end
    end)

    Registry.Bind("server.s_51", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/VinzHub.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📂 脚本中心 / Hub] Fish It脚本VinzHubKenny汉化 已执行", "server.s_51")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_51")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_51")
        end
    end)

    Registry.Bind("server.s_52", function()
        local url = "https://raw.githubusercontent.com/Syndromehsh/bypass-Script/refs/heads/main/Oliy%20hub%20bypass"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📂 脚本中心 / Hub] Oily Hub-破解白名单 已执行", "server.s_52")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_52")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_52")
        end
    end)

    Registry.Bind("server.s_53", function()
        local url = "https://raw.githubusercontent.com/Yungengxin/roblox/refs/heads/main/Rb-Hub"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📂 脚本中心 / Hub] Rb脚本中心---Yungengxin 已执行", "server.s_53")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_53")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_53")
        end
    end)

    Registry.Bind("server.s_54", function()
        local url = "https://raw.githubusercontent.com/mohun-sciprt/normal/refs/heads/main/bc.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📜 白脚本合集] 白脚本白名单破解 已执行", "server.s_54")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_54")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_54")
        end
    end)

    Registry.Bind("server.s_55", function()
        local url = "https://raw.githubusercontent.com/wev666666/baijiaobengV2.0beta/main/%E7%99%BD%E8%84%9A%E6%9C%ACbeta"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📜 白脚本合集] 白脚本最新(1)(1) (1) 已执行", "server.s_55")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_55")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_55")
        end
    end)

    Registry.Bind("server.s_56", function()
        local url = "https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/YE%20SCRIPT-Tang%20County%2C%20Hebei.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📜 叶脚本合集] 叶脚本-河北唐县 (1) 已执行", "server.s_56")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_56")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_56")
        end
    end)

    Registry.Bind("server.s_57", function()
        local url = "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/yejiaoben"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📜 夜脚本合集] 夜脚本 (1) 已执行", "server.s_57")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_57")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_57")
        end
    end)

    Registry.Bind("server.s_58", function()
        local url = "https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 皮脚本合集] 皮脚本 (4) 已执行", "server.s_58")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_58")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_58")
        end
    end)

    Registry.Bind("server.s_59", function()
        local url = "https://raw.githubusercontent.com/pijiaobenMSJMleng/ehhdvdhd/refs/heads/main/xiaopi77xiaopi77mainQQ1002100032-Roblox-Pi-script.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 皮脚本合集] 皮脚本 ohio  已执行", "server.s_59")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_59")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_59")
        end
    end)

    Registry.Bind("server.s_60", function()
        local url = "https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/Roblox-Pi-Script-Rooms%26doors.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 皮脚本合集] 皮脚本-Rooms&doors(1) 已执行", "server.s_60")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_60")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_60")
        end
    end)

    Registry.Bind("server.s_61", function()
        local url = "https://raw.githubusercontent.com/Giangplay/Slap_Battles/main/Slap_Battles.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 巴掌最强脚本（快速刷巴掌，回忆踢人，向导全自动） 已执行", "server.s_61")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_61")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_61")
        end
    end)

    Registry.Bind("server.s_62", function()
        local url = "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Neko"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 创世纪FE脚本-猫娘 已执行", "server.s_62")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_62")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_62")
        end
    end)

    Registry.Bind("server.s_63", function()
        local url = "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 德育中山垃圾亡命速递源码 已执行", "server.s_63")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_63")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_63")
        end
    end)

    Registry.Bind("server.s_64", function()
        local url = "https://pastebin.com/raw/up7yXRdK"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 丁丁脚本VB抢先版 (1) 已执行", "server.s_64")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_64")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_64")
        end
    end)

    Registry.Bind("server.s_65", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/shark/refs/heads/main/%E7%8A%AF%E7%BD%AA.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 犯罪汉化 已执行", "server.s_65")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_65")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_65")
        end
    end)

    Registry.Bind("server.s_66", function()
        local url = "https://raw.githubusercontent.com/LisSploit/FemboysHubBoosr/2784d6c4ede4340ad9af4865828d915ffc26c7bb/Criminality"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 犯罪脚本 已执行", "server.s_66")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_66")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_66")
        end
    end)

    Registry.Bind("server.s_67", function()
        local url = "https://raw.githubusercontent.com/UNDETECTEDWARE/SCRIPT/refs/heads/main/UNDETECTEDWARENEW"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 犯罪脚本(英文天脚本同款) (1) 已执行", "server.s_67")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_67")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_67")
        end
    end)

    Registry.Bind("server.s_68", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%BA%A2%E6%9C%A8%E7%9B%91%E7%8B%B1.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 红木监狱脚本Kenny汉化 已执行", "server.s_68")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_68")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_68")
        end
    end)

    Registry.Bind("server.s_69", function()
        local url = "https://raw.githubusercontent.com/iK4oS/backdoor.exe/v6x/source.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 后门整合包(1) 已执行", "server.s_69")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_69")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_69")
        end
    end)

    Registry.Bind("server.s_70", function()
        local url = "https://pastebin.com/raw/qqT4Ek4t"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 狐--RC最新版 已执行", "server.s_70")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_70")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_70")
        end
    end)

    Registry.Bind("server.s_71", function()
        local url = "https://raw.githubusercontent.com/atnew2025/Chinese-scripts/refs/heads/main/zh-Lexus.Hub"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 竞争对手Lexus汉化 已执行", "server.s_71")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_71")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_71")
        end
    end)

    Registry.Bind("server.s_72", function()
        local url = "https://pastebin.com/raw/j9TdK86G"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 空脚本源码 已执行", "server.s_72")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_72")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_72")
        end
    end)

    Registry.Bind("server.s_73", function()
        local url = "https://pastebin.com/raw/ke146qjn"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 脑红（78无卡密） 已执行", "server.s_73")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_73")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_73")
        end
    end)

    Registry.Bind("server.s_74", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/obfuscated_script-1758351873821.lua.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 无卡密版乱码脚本（Kenny） 已执行", "server.s_74")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_74")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_74")
        end
    end)

    Registry.Bind("server.s_75", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/KENNY画我.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 无卡密画我脚本 已执行", "server.s_75")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_75")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_75")
        end
    end)

    Registry.Bind("server.s_76", function()
        local url = "https://pastebin.com/raw/kenX0BHc"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 隐身打飞别人(需要键盘) 已执行", "server.s_76")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_76")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_76")
        end
    end)

    Registry.Bind("server.s_77", function()
        local url = "https://scriptblox.com/raw/a-dusty-trip-FREE-CAR-Gui-14352"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 长途 已执行", "server.s_77")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_77")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_77")
        end
    end)

    Registry.Bind("server.s_78", function()
        local url = "https://raw.githubusercontent.com/fjruie/Warhorse.github.io/refs/heads/main/ringta.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] 找熔岩马 已执行", "server.s_78")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_78")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_78")
        end
    end)

    Registry.Bind("server.s_79", function()
        local url = "https://raw.githubusercontent.com/ttwizz/Open-Aimbot/master/source.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] aimbot瞄准机器人 已执行", "server.s_79")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_79")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_79")
        end
    end)

    Registry.Bind("server.s_80", function()
        local url = "https://raw.githubusercontent.com/Basicallyy/Basicallyy/main/MinGamingV4.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] BF现版本刷级最强(1) 已执行", "server.s_80")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_80")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_80")
        end
    end)

    Registry.Bind("server.s_81", function()
        local url = "https://gitlab.com/ajduoxcz/bs-center-of-the-black-hole/-/raw/main/BS%20Center%20of%20the%20black%20hole"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] BS脚本 已执行", "server.s_81")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_81")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_81")
        end
    end)

    Registry.Bind("server.s_82", function()
        local url = "https://raw.githubusercontent.com/1f0yt/community/master/novahub"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] cw超级暴力脚本 已执行", "server.s_82")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_82")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_82")
        end
    end)

    Registry.Bind("server.s_83", function()
        local url = "https://raw.githubusercontent.com/IsaaaKK/cwhb/main/cw.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] cw游戏脚本 已执行", "server.s_83")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_83")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_83")
        end
    end)

    Registry.Bind("server.s_84", function()
        local url = "https://raw.githubusercontent.com/KINGHUB01/BlackKing/main/Blackking%20Game"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] Doors BlackKing (1) 已执行", "server.s_84")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_84")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_84")
        end
    end)

    Registry.Bind("server.s_85", function()
        local url = "https://raw.githubusercontent.com/DocYogurt/lolololololololololololololollolololololololololololololollolololololololololololololollolololololol/main/lolololololololololololololollolololololololololololololollolololololololololololololollolololololololololololololollolololololololololololololollolololololololololololololollolololololololololololololollolololololololololololololollolololololololololololololollolololololololololololololollolololololololololololololol.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] dxgui第四版 已执行", "server.s_85")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_85")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_85")
        end
    end)

    Registry.Bind("server.s_86", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/Celestial.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] Fish It脚本CelestialKenny汉化 已执行", "server.s_86")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_86")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_86")
        end
    end)

    Registry.Bind("server.s_87", function()
        local url = "https://lumin-hub.lol/loader.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] forsaken自动杀戮,自动引导修机(1) 已执行", "server.s_87")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_87")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_87")
        end
    end)

    Registry.Bind("server.s_88", function()
        local url = "https://raw.githubusercontent.com/zjx902/11758211663/refs/heads/main/obfuscated_script-1755261708376.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] lyy-ohio-自动换服开保险-公益(1) 已执行", "server.s_88")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_88")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_88")
        end
    end)

    Registry.Bind("server.s_89", function()
        local url = "https://raw.githubusercontent.com/q639977310-design/ui-/refs/heads/main/%E6%88%91%E4%BB%AC%E7%9A%84%E5%A4%84%E5%86%B3"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] OE我们的处决 已执行", "server.s_89")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_89")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_89")
        end
    end)

    Registry.Bind("server.s_90", function()
        local url = "https://raw.githubusercontent.com/mabdu21/2askdkn21h3u21ddaa/refs/heads/main/djajuu1yhka.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] REAL X DY Loader 已执行", "server.s_90")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_90")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_90")
        end
    end)

    Registry.Bind("server.s_91", function()
        local url = "https://raw.githubusercontent.com/gumanba/Scripts/main/TheHatch"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] roblox2025最新孵化之旅脚本(1) 已执行", "server.s_91")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_91")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_91")
        end
    end)

    Registry.Bind("server.s_92", function()
        local url = "https://pastefy.app/xXkUxA0P/raw"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] RTX脚本 已执行", "server.s_92")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_92")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_92")
        end
    end)

    Registry.Bind("server.s_93", function()
        local url = "https://pastefy.app/ud7GghOq/raw"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] snow Ohio源码 已执行", "server.s_93")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_93")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_93")
        end
    end)

    Registry.Bind("server.s_94", function()
        local url = "https://raw.githubusercontent.com/JsYb666/TX-Free-YYDS/refs/heads/main/FREE-TX-TEAM"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[📦 其他脚本] TX退休脚本V2 (2) 已执行", "server.s_94")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_94")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_94")
        end
    end)

    Registry.Bind("server.s_95", function()
        local url = "https://raw.githubusercontent.com/alphaalt0409/WEIRDAPPLEBEEPANEL/main/weirdapplebee.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔒 监狱人生 / Prison Life] 监狱人生(开挂人生) 已执行", "server.s_95")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_95")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_95")
        end
    end)

    Registry.Bind("server.s_96", function()
        local url = "https://raw.githubusercontent.com/114514mim/kdjddjosso/refs/heads/main/91scriptlua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔒 监狱人生 / Prison Life] 监狱人生（直接获得ak和传送） 已执行", "server.s_96")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_96")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_96")
        end
    end)

    Registry.Bind("server.s_97", function()
        local url = "https://raw.githubusercontent.com/Denverrz/scripts/master/PRISONWARE_v1.3.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔒 监狱人生 / Prison Life] 监狱人生吊打一切脚本 (2) 已执行", "server.s_97")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_97")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_97")
        end
    end)

    Registry.Bind("server.s_98", function()
        local url = "https://raw.githubusercontent.com/LiverMods/xRawnder/main/HubMoblie"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔒 监狱人生 / Prison Life] 监狱人生新菜单(1) (1) (1) 已执行", "server.s_98")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_98")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_98")
        end
    end)

    Registry.Bind("server.s_99", function()
        local url = "https://raw.githubusercontent.com/KuriWasTaken/MonkeyScripts/main/JailMonkey.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔒 监狱人生 / Prison Life] 监狱人生の脚本2号 已执行", "server.s_99")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_99")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_99")
        end
    end)

    Registry.Bind("server.s_100", function()
        local url = "https://raw.githubusercontent.com/NUIke1/ui/refs/heads/main/%E7%9B%91%E7%8B%B1%E4%BA%BA%E7%94%9F.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔒 监狱人生 / Prison Life] ASH监狱人生脚本 已执行", "server.s_100")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_100")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_100")
        end
    end)

    Registry.Bind("server.s_101", function()
        local url = "https://raw.githubusercontent.com/dingding123hhh/ng/main/jmlllllllIIIIlllllII.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔥 Kaboom / 禁漫中心] 禁漫中心 已执行", "server.s_101")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_101")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_101")
        end
    end)

    Registry.Bind("server.s_102", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/Tbao.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔫 兵工厂 / Arsenal] 兵工厂超级强脚本Tbao中心Kenny汉化 已执行", "server.s_102")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_102")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_102")
        end
    end)

    Registry.Bind("server.s_103", function()
        local url = "https://raw.githubusercontent.com/Sempiller/Lithium/refs/heads/main/main.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔫 兵工厂 / Arsenal] 兵工厂锂 已执行", "server.s_103")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_103")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_103")
        end
    end)

    Registry.Bind("server.s_104", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/Weed.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🔫 兵工厂 / Arsenal] 兵工厂Weed脚本Kenny汉化 已执行", "server.s_104")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_104")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_104")
        end
    end)

    Registry.Bind("server.s_105", function()
        local url = "https://raw.githubusercontent.com/XOTRXONY/INKGAME/main/INKGAMEE.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🖋️ Ink Game / 墨水游戏] 墨水游戏汉化 (1) 已执行", "server.s_105")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_105")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_105")
        end
    end)

    Registry.Bind("server.s_106", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/Ringta"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🖋️ Ink Game / 墨水游戏] 墨水游戏汉化脚本-Ringta 已执行", "server.s_106")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_106")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_106")
        end
    end)

    Registry.Bind("server.s_107", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/TexRBLlX"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🖋️ Ink Game / 墨水游戏] 墨水游戏汉化脚本(目前第二强) 已执行", "server.s_107")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_107")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_107")
        end
    end)

    Registry.Bind("server.s_108", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/OK/refs/heads/main/sb"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🖋️ Ink Game / 墨水游戏] 墨水游戏汉化脚本(修复版) (1) (1) 已执行", "server.s_108")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_108")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_108")
        end
    end)

    Registry.Bind("server.s_109", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/AX%20CN"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🖋️ Ink Game / 墨水游戏] 墨水游戏ax汉化脚本 已执行", "server.s_109")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_109")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_109")
        end
    end)

    Registry.Bind("server.s_110", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%B1%89%E5%8C%96%E5%A2%A8%E6%B0%B4Ringta.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🖋️ Ink Game / 墨水游戏] 墨水游戏Ringta脚本Kenny汉化 已执行", "server.s_110")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_110")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_110")
        end
    end)

    Registry.Bind("server.s_111", function()
        local url = "https://raw.githubusercontent.com/LilFrench21/Hecta/main/Script/Squid%20Game"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🦑 Squid Game / 鱿鱼游戏] 鱿鱼游戏脚本 已执行", "server.s_111")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_111")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_111")
        end
    end)

    Registry.Bind("server.s_112", function()
        local url = "https://raw.githubusercontent.com/Awakenchan/GcViewerV2/refs/heads/main/Utility/FindFunction.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🧠 Steal a Brainrot / 偷走脑红] 偷走脑红_AC_反作弊绕过 已执行", "server.s_112")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_112")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_112")
        end
    end)

    Registry.Bind("server.s_113", function()
        local url = "https://raw.githubusercontent.com/hdjsjjdgrhj/script-hub/refs/heads/main/偷走脑红"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🧠 Steal a Brainrot / 偷走脑红] 偷走脑红汉化脚本(by 晓月lol) (1) 已执行", "server.s_113")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_113")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_113")
        end
    end)

    Registry.Bind("server.s_114", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%BA%A2%E8%BE%A3%E6%A4%92.txt"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🧠 Steal a Brainrot / 偷走脑红] 偷走脑红红辣椒脚本Kenny汉化 已执行", "server.s_114")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_114")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_114")
        end
    end)

    Registry.Bind("server.s_115", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%96%B9%E5%9D%97%E6%95%85%E4%BA%8Btex.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🧱 方块故事 / Block Tales] 方块故事tex脚本Kenny汉化 已执行", "server.s_115")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_115")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_115")
        end
    end)

    Registry.Bind("server.s_116", function()
        local url = "https://raw.githubusercontent.com/Vortex194/main/main/oilwarfare"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🪖 战争大亨 / War Tycoon] 战争大亨整合 已执行", "server.s_116")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_116")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_116")
        end
    end)

    Registry.Bind("server.s_117", function()
        local url = "https://raw.githubusercontent.com/0x37Dev/Cool-Solo-Dupe-Thing/main/script.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🪵 伐木大亨 / Lumber Tycoon 2] 伐木大亨 2 10 复制(1) 已执行", "server.s_117")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_117")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_117")
        end
    end)

    Registry.Bind("server.s_118", function()
        local url = "https://bit.ly/Stepshop"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🪵 伐木大亨 / Lumber Tycoon 2] 伐木大亨2复制脚本 已执行", "server.s_118")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_118")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_118")
        end
    end)

    Registry.Bind("server.s_119", function()
        local url = "https://raw.githubusercontent.com/frencaliber/LuaWareLoader.lw/main/luawareloader.wtf"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🪵 伐木大亨 / Lumber Tycoon 2] 伐木大亨2最强 LuaWare (1) 已执行", "server.s_119")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_119")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_119")
        end
    end)

    Registry.Bind("server.s_120", function()
        local url = "https://pastebin.com/raw/H7VAJx6Q"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🪵 伐木大亨 / Lumber Tycoon 2] 伐木大亨外挂 (1) 已执行", "server.s_120")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_120")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_120")
        end
    end)

    Registry.Bind("server.s_121", function()
        local url = "https://raw.githubusercontent.com/Butterisgood/Butter/main/Root2.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🪵 伐木大亨 / Lumber Tycoon 2] 伐木原版op 已执行", "server.s_121")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_121")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_121")
        end
    end)

    Registry.Bind("server.s_122", function()
        local url = "https://raw.githubusercontent.com/kode-sec/Butter/refs/heads/main/main.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🪵 伐木大亨 / Lumber Tycoon 2] 黄油轮毂（伐木） 已执行", "server.s_122")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_122")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_122")
        end
    end)

    Registry.Bind("server.s_123", function()
        local url = "https://raw.githubusercontent.com/debug420/Ez-Hub/master/Modules/EzLib.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🪵 伐木大亨 / Lumber Tycoon 2] 极狐木材大亨2破解版(1) 已执行", "server.s_123")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_123")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_123")
        end
    end)

    Registry.Bind("server.s_124", function()
        local url = "https://getnative.cc/script/loader"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚂 Dead Rails / 死铁轨] 死铁轨超强红叶脚本Kenny汉化 已执行", "server.s_124")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_124")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_124")
        end
    end)

    Registry.Bind("server.s_125", function()
        local url = "https://pastefy.app/7vZN3EwV/raw"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚂 Dead Rails / 死铁轨] 死铁轨脚本大全整合3 (1) 已执行", "server.s_125")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_125")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_125")
        end
    end)

    Registry.Bind("server.s_126", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E8%BF%91%E6%88%98.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚂 Dead Rails / 死铁轨] 死铁轨近战增强脚本Kenny汉化 (1) 已执行", "server.s_126")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_126")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_126")
        end
    end)

    Registry.Bind("server.s_127", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%AD%BB%E9%93%81%E8%BD%A8v4.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚂 Dead Rails / 死铁轨] 死铁轨强力挥击Kenny汉化 已执行", "server.s_127")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_127")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_127")
        end
    end)

    Registry.Bind("server.s_128", function()
        local url = "https://raw.githubusercontent.com/wehjf/famineringta.github.io/refs/heads/main/horseringta.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚂 Dead Rails / 死铁轨] 死铁轨找闪电马，飞行脚本(2) 已执行", "server.s_128")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_128")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_128")
        end
    end)

    Registry.Bind("server.s_129", function()
        local url = "https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatHub.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚂 Dead Rails / 死铁轨] 死铁轨自动刷债券(没有卡密)v2 已执行", "server.s_129")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_129")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_129")
        end
    end)

    Registry.Bind("server.s_130", function()
        local url = "https://raw.githubusercontent.com/thantzy/thanhub/refs/heads/main/thanv1"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚂 Dead Rails / 死铁轨] 死铁轨自动刷债券(无卡密) (1) 已执行", "server.s_130")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_130")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_130")
        end
    end)

    Registry.Bind("server.s_131", function()
        local url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%AD%BB%E9%93%81%E8%BD%A8.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚂 Dead Rails / 死铁轨] RINGTA死铁轨Kenny汉化 已执行", "server.s_131")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_131")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_131")
        end
    end)

    Registry.Bind("server.s_132", function()
        local url = "https://raw.githubusercontent.com/BlitzIsKing/UniversalFarm/main/Loader/Regular"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚓 越狱 / Jailbreak] 越狱 AUTOFARM 脚本 已执行", "server.s_132")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_132")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_132")
        end
    end)

    Registry.Bind("server.s_133", function()
        local url = "https://raw.githubusercontent.com/Pxsta72/ProjectAuto/main/free"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚓 越狱 / Jailbreak] 越狱优质脚本 已执行", "server.s_133")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_133")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_133")
        end
    end)

    Registry.Bind("server.s_134", function()
        local url = "https://raw.githubusercontent.com/Drifter0507/scripts/main/westbound"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚗 一路向西 / Westbound] 一路向西脚本 (1) 已执行", "server.s_134")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_134")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_134")
        end
    end)

    Registry.Bind("server.s_135", function()
        local url = "https://kiriot22.com/releases/ESP.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚗 一路向西 / Westbound] 一路向西GUI 已执行", "server.s_135")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_135")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_135")
        end
    end)

    Registry.Bind("server.s_136", function()
        local url = "https://raw.githubusercontent.com/Simak90/pfsetcetc/main/fluxed.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚗 Driving Empire] 驾驶帝国自动农场 已执行", "server.s_136")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_136")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_136")
        end
    end)

    Registry.Bind("server.s_137", function()
        local url = "https://pastebin.com/raw/gEd1QwJE"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚪 DOORS / Rooms] 鬼脚本源码 已执行", "server.s_137")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_137")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_137")
        end
    end)

    Registry.Bind("server.s_138", function()
        local url = "https://pastebin.com/raw/y2WmccLk"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚪 DOORS / Rooms] 小黑子脚本(超多脚本) (1) 已执行", "server.s_138")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_138")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_138")
        end
    end)

    Registry.Bind("server.s_139", function()
        local url = "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Doors/Script.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚪 DOORS / Rooms] DOORS VYNIXU GUI - VERY OVERPOWERED 已执行", "server.s_139")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_139")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_139")
        end
    end)

    Registry.Bind("server.s_140", function()
        local url = "https://raw.githubusercontent.com/GamingScripter/Darkrai-X/main/Games/Doors"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚪 DOORS / Rooms] doors（外网搬）手机可用 (1) (1) 已执行", "server.s_140")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_140")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_140")
        end
    end)

    Registry.Bind("server.s_141", function()
        local url = "https://github.com/DocYogurt/Main/raw/main/Scripts/Pressure"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚪 DOORS / Rooms] NB DOORS压力脚本 已执行", "server.s_141")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_141")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_141")
        end
    end)

    Registry.Bind("server.s_142", function()
        local url = "https://api.luarmor.net/files/v3/loaders/002c19202c9946e6047b0c6e0ad51f84.lua"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚪 DOORS / Rooms（门）] 门ms4 已执行", "server.s_142")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_142")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_142")
        end
    end)

    Registry.Bind("server.s_143", function()
        local url = "https://raw.githubusercontent.com/9kn-1/preeorrr/main/pressure.luau"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚪 DOORS / Rooms（压力）] 压力脚本 (1) 已执行", "server.s_143")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_143")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_143")
        end
    end)

    Registry.Bind("server.s_144", function()
        local url = "https://pastebin.com/raw/iZuasZCc"
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)
        if success and content and content ~= "" then
            local ok, err = pcall(loadstring(content))
            if ok then
                State:AddLog("UI", "[🚪 DOORS / Rooms（压力）] 压力脚本 (3) 已执行", "server.s_144")
                task.delay(0.5, function()
                    if UI.Destroy then UI.Destroy() end
                end)
            else
                State:AddLog("ERROR", "脚本执行失败: " .. tostring(err), "server.s_144")
            end
        else
            State:AddLog("ERROR", "无法获取远程脚本", "server.s_144")
        end
    end)

    UI.Build()

end