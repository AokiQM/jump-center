--[[
    半缝合 v1.0 正式版

    全功能集成版本。
]]

do
    local AppConfig = {
        Name = "半缝合 v1.0",
        Version = "1.0.3",
        Author = "青木作者",
        GuiName = "BanFengHeUIFramework",
        ShellMode = true,
        DefaultPage = "general",
        MarqueeText = "正式版 v1.0 全功能集成 | 青木制作",
                AnnouncementTitle = "公告详情",
        AnnouncementText = [=[
               
               【置顶】作者:青木  目前脚本:内脏与黑火药 欢迎使用此脚本！
 求点赞 关注 谢谢你的支持是我的最大动力 作者快手:ROBLOX[青木🤓🖕] Q群:1079353586
                 当前因脚本资金短缺希望有好心人可以捐赠一波😭😭🙏🙏
 功能只做了一半还有一半没对接|但功能已做但都是优化好的[除了杀戮光环菜单以外]
 目前内存消耗挺低的|并且性能也是给优化到位了😡👆
]=] .. string.char(10) .. string.char(10) .. "" .. string.char(10) .. string.rep(string.char(10), 1500) .. "别再往下翻了，下面啥都没有" .. string.rep(string.char(10), 500) .. "都说了别往下翻了，真的啥都没有" .. string.rep(string.char(10), 1000) .. "原创者秋容" .. string.char(10) .. "666居然发现我了",WindowSize = Vector2.new(760, 500),
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
        Announcement = nil,
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
        return New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = color or Theme.Colors.Stroke,
            Thickness = thickness or 1,
            Parent = parent,
        })
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
        title.Position = UDim2.fromOffset(12, item.desc and 7 or 0)
        title.Size = UDim2.new(1, -(rightWidth or 110) - 24, 0, item.desc and 19 or 1)
        title.TextTruncate = Enum.TextTruncate.AtEnd

        if not item.desc then
            title.Size = UDim2.new(1, -(rightWidth or 110) - 24, 1, 0)
        end

        if item.desc then
            local desc = Components.Label(parent, item.desc, 13, Theme.Colors.TextDim, false)
            desc.Position = UDim2.fromOffset(12, 27)
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
        AddStroke(root)

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
        id = "esp",
        title = "透视",
        icon = "E",
        subtitle = "僵尸绘制与玩家透视",
        sections = {
            {
                title = "僵尸碰撞箱",
                items = {
                    { type = "toggle", key = "kill.toggle.hitbox_zombie", title = "僵尸碰撞箱", desc = "为僵尸添加更大的命中箱", default = false, internal = true, onChanged = function(v) KILL.toggleZombieHitbox(v) end },
                    { type = "slider", key = "kill.slider.hitbox_zombie_size", title = "碰撞箱大小", desc = "调整命中箱大小（共30级）", min = 1, max = 30, step = 1, default = 3, internal = true, onChanged = function(v) KILL.setZombieHitboxSize(v) end }
                },
            },
            {
                title = "马尔多赫斯要塞绘制",
                items = {
                    { type = "toggle", key = "esp.toggle.fort_roundshot", title = "炮弹", desc = "高亮12磅炮弹", default = false, internal = true, onChanged = function(v) ESP.toggleFortDraw("RoundShot", v) end },
                    { type = "toggle", key = "esp.toggle.fort_swab", title = "炮刷", desc = "高亮炮刷", default = false, internal = true, onChanged = function(v) ESP.toggleFortDraw("Swab", v) end },
                    { type = "toggle", key = "esp.toggle.fort_supplies", title = "火炮物资", desc = "高亮瓦尔多要塞的火炮物资", default = false, internal = true, onChanged = function(v) FEATURES.toggleCannonSupplies(v) end },
                },
            },
            {
                title = "斧头僵尸",
                items = {
                    { type = "toggle", key = "esp.toggle.axe", title = "高亮透视", desc = "斧头僵尸高亮透视", default = false, internal = true, onChanged = function(v) ESP.zombieToggle("Axe", v) end },
                    { type = "toggle", key = "esp.toggle.axe_name", title = "名称标签", desc = "显示斧头僵尸名称标签", default = false, internal = true, onChanged = function(v) ESP.zombieName("Axe", v) end },
                },
            },
            {
                title = "红眼",
                items = {
                    { type = "toggle", key = "esp.toggle.runner", title = "高亮透视", desc = "红眼高亮透视", default = false, internal = true, onChanged = function(v) ESP.zombieToggle("Eye", v) end },
                    { type = "toggle", key = "esp.toggle.runner_name", title = "名称标签", desc = "显示红眼名称标签", default = false, internal = true, onChanged = function(v) ESP.zombieName("Eye", v) end },
                },
            },
            {
                title = "胸甲骑兵",
                items = {
                    { type = "toggle", key = "esp.toggle.cuirassier", title = "高亮透视", desc = "胸甲骑兵高亮透视", default = false, internal = true, onChanged = function(v) ESP.zombieToggle("Sword", v) end },
                    { type = "toggle", key = "esp.toggle.cuirassier_name", title = "名称标签", desc = "显示胸甲骑兵名称标签", default = false, internal = true, onChanged = function(v) ESP.zombieName("Sword", v) end },
                },
            },
            {
                title = "自爆",
                items = {
                    { type = "toggle", key = "esp.toggle.barrel", title = "高亮透视", desc = "自爆高亮透视", default = false, internal = true, onChanged = function(v) ESP.zombieToggle("Barrel", v) end },
                    { type = "toggle", key = "esp.toggle.barrel_name", title = "名称标签", desc = "显示自爆名称标签", default = false, internal = true, onChanged = function(v) ESP.zombieName("Barrel", v) end },
                    { type = "toggle", key = "features.toggle.bomb_range", title = "显示自爆范围", desc = "显示自爆爆炸范围", default = false, internal = true , onChanged = function(v) FEATURES.toggleBombRange(v) end },
                },
            },
            {
                title = "提灯人",
                items = {
                    { type = "toggle", key = "esp.toggle.lantern", title = "高亮透视", desc = "提灯人高亮透视", default = false, internal = true, onChanged = function(v) ESP.zombieToggle("FTorso", v) end },
                    { type = "toggle", key = "esp.toggle.lantern_name", title = "名称标签", desc = "显示提灯人名称标签", default = false, internal = true, onChanged = function(v) ESP.zombieName("FTorso", v) end },
                    { type = "toggle", key = "features.toggle.disable_fire", title = "禁用火焰粒子", desc = "禁用部分火焰粒子", default = false, internal = true , onChanged = function(v) FEATURES.toggleDisableFire(v) end },
                },
            },
            {
                title = "山伯乐",
                items = {
                    { type = "toggle", key = "esp.toggle.normal", title = "高亮透视", desc = "山伯乐高亮透视", default = false, internal = true, onChanged = function(v) ESP.zombieToggle("Normal", v) end },
                    { type = "toggle", key = "esp.toggle.normal_name", title = "名称标签", desc = "显示山伯乐名称标签", default = false, internal = true, onChanged = function(v) ESP.zombieName("Normal", v) end },
                },
            },
            {
                title = "玩家",
                items = {
                    { type = "toggle", key = "esp.toggle.player", title = "玩家透视", desc = "开启后对玩家高亮", default = false, internal = true, onChanged = function(v) ESP.playerToggle(v) end },
                    { type = "toggle", key = "esp.toggle.player_name", title = "显示名称", desc = "开启显示玩家用户名", default = false, internal = true, onChanged = function(v) ESP.playerName(v) end },
                    { type = "toggle", key = "esp.toggle.player_health", title = "显示血量", desc = "开启显示玩家血量数值", default = false, internal = true, onChanged = function(v) ESP.playerHealth(v) end },
                    { type = "toggle", key = "esp.toggle.player_team", title = "队伍检测", desc = "开启后只高亮透视敌方队伍玩家", default = false, internal = true, onChanged = function(v) ESP.playerTeam(v) end },
                    { type = "toggle", key = "esp.toggle.player_infection", title = "显示玩家感染值", desc = "在玩家头上显示感染值百分比", default = false, internal = true, onChanged = function(v) FEATURES.togglePlayerInfection(v) end },
                },
            },
        },
    })

    AddPage({
        id = "killpvp",
        title = "杀戮与PVP",
        icon = "K",
        subtitle = "杀戮光环与玩家对战",
        sections = {
            {
                title = "僵尸锁定类型",
                items = {
                    { type = "multi", key = "kill.multi.zombie_types", title = "攻击僵尸类型", desc = "选择要攻击的僵尸类型（多选，不选则不攻击）", default = {}, options = { {label="自爆", value="Barrel"}, {label="斧头僵尸", value="Sapper"}, {label="红眼", value="Fast"}, {label="胸甲骑兵", value="Sword"}, {label="提灯人", value="Igniter"}, {label="山伯乐", value="Normal"} }, internal = true, isOptionDisabled = function(v) return v == "Barrel" and State:Get("toggle", "kill.toggle.wall_barrel", false) end },
                    { type = "toggle", key = "kill.toggle.show_type_labels", title = "显示类型标签", desc = "在僵尸头顶显示检测到的类型名称", default = false, onChanged = function(v) KILL.toggleTypeLabels(v) end },
                },
            },
            {
                title = "杀戮光环特殊选项",
                items = {
                    { type = "toggle", key = "features.toggle.auto_face", title = "自动转向", desc = "自动面向范围内的僵尸，搭配攻击僵尸类型使用", default = false, internal = true, onChanged = function(v) KILL.toggleAutoFace(v) end },
                    { type = "slider", key = "features.slider.auto_face_range", title = "自动转向范围", desc = "僵尸进入距离时自动转向", min = 1, max = 50, step = 1, default = 15, internal = true, onChanged = function(v) KILL.setAutoFaceRange(v) end },
                    { type = "toggle", key = "kill.toggle.wall_barrel", title = "攻击墙后自爆", desc = "开启后将会禁止攻击僵尸类型的自爆，关闭即可重新开启僵尸类型里面的自爆开关", default = false, internal = true, onChanged = function(v) KILL.toggleWallBarrel(v) end },
                    { type = "toggle", key = "features.toggle.headshot", title = "强制爆头", desc = "强制爆头", default = false, internal = true , onChanged = function(v) FEATURES.toggleHeadshot(v) end },
                },
            },
            {
                title = "高频光环",
                items = {
                    { type = "toggle", key = "kill.toggle.highfreq", title = "高频光环", desc = "高频杀戮体验极致爽感（防封）", default = false, internal = true, onChanged = function(v) KILL.toggleHighFreq(v) end },
                    { type = "slider", key = "kill.slider.highfreq_range", title = "攻击距离", desc = "高频光环攻击距离", min = 0, max = 45, step = 1, default = 45, internal = true, onChanged = function(v) KILL.setHighFreqRange(v) end },
                    { type = "slider", key = "kill.slider.highfreq_count", title = "攻击数量", desc = "攻击僵尸数量", min = 0, max = 5, step = 1, default = 5, internal = true, onChanged = function(v) KILL.setHighFreqCount(v) end },
                },
            },
{
                title = "刺刀光环",
                items = {
                    { type = "toggle", key = "kill.toggle.bayonet", title = "刺刀光环", desc = "依旧变成刺刀大牛", default = false, internal = true, onChanged = function(v) KILL.toggleBayonet(v) end },
                    { type = "slider", key = "kill.slider.bayonet_range", title = "刺刀攻击距离", desc = "刺刀光环攻击距离", min = 1, max = 100, step = 1, default = 45, internal = true, onChanged = function(v) KILL.setBayonetRange(v) end },
                },
            },
            {
                title = "PVP",
                items = {
                    { type = "toggle", key = "pvp.toggle.teleport", title = "传送至敌方头顶", desc = "传送到最近的敌方玩家头顶", default = false, internal = true, onChanged = function(v) PVP.toggleTeleport(v) end },
                    { type = "toggle", key = "pvp.toggle.bayonet", title = "杀戮光环[刺刀]", desc = "开启秒变刺刀大蛇", default = false, internal = true, onChanged = function(v) PVP.toggleBayonet(v) end },
                    { type = "toggle", key = "pvp.toggle.melee", title = "杀戮光环", desc = "体验虐杀的快感", default = false, internal = true, onChanged = function(v) PVP.toggleMelee(v) end },
                },
            },
            {
                title = "PVP自瞄",
                items = {
                    { type = "toggle", key = "pvp.toggle.aimbot", title = "自瞄开关", desc = "开启后自动瞄准最近的敌方玩家", default = false, internal = true, onChanged = function(v) PVP.toggle(v) end },
                    { type = "dropdown", key = "pvp.dropdown.aim_part", title = "自瞄部位", desc = "选择瞄准部位", default = "head", options = { {label="头部", value="head"}, {label="身体", value="body"} }, internal = true, onChanged = function(v) PVP.setAimPart(v) end },
                    { type = "toggle", key = "pvp.toggle.fov", title = "显示FOV圈", desc = "显示自瞄FOV范围", default = false, internal = true, onChanged = function(v) PVP.toggleFOV(v) end },
                    { type = "slider", key = "pvp.slider.fov_range", title = "FOV范围", desc = "调整FOV大小", min = 1, max = 360, step = 1, default = 90, internal = true, onChanged = function(v) PVP.setFOV(v) end },
                    { type = "toggle", key = "pvp.toggle.team", title = "队伍检测", desc = "开启后不攻击同队伍玩家", default = false, internal = true, onChanged = function(v) PVP.toggleTeamCheck(v) end },
                    { type = "toggle", key = "pvp.toggle.prediction", title = "子弹预判", desc = "预判敌人移动位置射击", default = false, internal = true, onChanged = function(v) PVP.togglePrediction(v) end },
                    { type = "slider", key = "pvp.slider.bullet_speed", title = "子弹速度", desc = "子弹飞行速度（越大预判越远）", min = 50, max = 1000, step = 10, default = 700, internal = true, onChanged = function(v) PVP.setBulletSpeed(v) end },

                },
            },

        },
    })

    AddPage({
        id = "general",
        title = "人物",
        icon = "G",
        subtitle = "移动与飞行",
        sections = {
            {
                title = "功能",
                items = {
                    { type = "toggle", key = "features.toggle.coord_speed", title = "坐标加速", desc = "控制移动", default = false, internal = true, onChanged = function(v) FEATURES.toggleCoordSpeed(v) end },
                    { type = "slider", key = "features.slider.coord_speed", title = "坐标加速速度", desc = "调整坐标移动速度", min = 1, max = 35, step = 1, default = 16, internal = true, onChanged = function(v) FEATURES.setCoordSpeed(v) end },
                    { type = "toggle", key = "features.toggle.speed", title = "速度调整", desc = "速度控制", default = false, internal = true, onChanged = function(v) FEATURES.toggleSpeed(v) end },
                    { type = "slider", key = "features.slider.player_speed", title = "玩家速度", desc = "调整移动速度", min = 1, max = 45, step = 1, default = 35, internal = true, onChanged = function(v) FEATURES.setPlayerSpeed(v) end },
                    { type = "toggle", key = "features.toggle.fly", title = "飞行", desc = "飞行不拉回GB脚本", default = false, internal = true, onChanged = function(v) FEATURES.toggleFly(v) end },
                    { type = "slider", key = "features.slider.fly_speed", title = "飞行速度", desc = "飞行速度", min = 1, max = 60, step = 1, default = 45, internal = true, onChanged = function(v) FEATURES.setFlySpeed(v) end },
                    { type = "toggle", key = "features.toggle.manual_jump", title = "手动跳跃", desc = "按空格无限连跳（免伤+状态锁定+可防骨折）", default = false, internal = true, onChanged = function(v) FEATURES.toggleManualJump(v) end },
                    { type = "slider", key = "features.slider.auto_jump_height", title = "跳跃高度", desc = "调节跳跃高度", min = 0, max = 90, step = 1, default = 20, internal = true, onChanged = function(v) FEATURES.setAutoJumpHeight(v) end },

                },
            },
            {
                title = "人物",
                items = {
                    { type = "toggle", key = "features.toggle.third_person", title = "强制第三人称", desc = "强制第三人称缩放上限200", default = false, internal = true, onChanged = function(v) FEATURES.toggleThirdPerson(v) end },
                    { type = "toggle", key = "features.toggle.noslow", title = "无减速", desc = "移除减速效果（重生后需重新开启）", default = false, internal = true , onChanged = function(v) FEATURES.toggleNoSlow(v) end },
                    { type = "toggle", key = "features.toggle.nofall", title = "移除摔伤", desc = "移除摔落伤害（注意不防骨折）", default = false, internal = true , onChanged = function(v) FEATURES.toggleNoFall(v) end },
                    { type = "toggle", key = "features.toggle.showbackpack", title = "显示物品栏", desc = "强制显示物品栏", default = false, internal = true , onChanged = function(v) FEATURES.toggleBackpack(v) end },
                    { type = "toggle", key = "features.toggle.bright", title = "亮度提升", desc = "提高场景亮度", default = false, internal = true , onChanged = function(v) FEATURES.toggleBright(v) end },
                    { type = "toggle", key = "features.toggle.unlock_camera", title = "解除视角限制", desc = "开学后解除玩家视角上限", default = false, internal = true , onChanged = function(v) FEATURES.toggleUnlockCamera(v) end },
                },
            },
        },
    })

    AddPage({
        id = "protect",
        title = "防护",
        icon = "S",
        subtitle = "被动防御与自救",
        sections = {
            {
                title = "防护",
                items = {
                    { type = "toggle", key = "protect.toggle.auto_escape", title = "防红眼扑", desc = "被扑倒后自动传送解除", default = false, internal = true, onChanged = function(v) FEATURES.toggleAutoEscape(v) end },
                    { type = "slider", key = "protect.slider.float_height", title = "传送悬浮高度", desc = "自定义悬浮高度", min = 0, max = 10, step = 1, default = 3, internal = true, onChanged = function(v) FEATURES.setFloatHeight(v) end },
                    { type = "toggle", key = "protect.toggle.fall_protect", title = "防骨折", desc = "防止玩家从高处坠落骨折", default = false, internal = true, onChanged = function(v) FEATURES.toggleFallProtect(v) end },
                    { type = "toggle", key = "protect.toggle.damage_display", title = "显示受伤伤害", desc = "显示伤害数字", default = false, internal = true, onChanged = function(v) FEATURES.toggleDamageDisplay(v) end },
                                        { type = "toggle", key = "protect.toggle.elbow_save", title = "肘击自救", desc = "不一定百分百有用", default = false, internal = true, onChanged = function(v) FEATURES.toggleElbowSave(v) end },
                    { type = "toggle", key = "protect.toggle.push_barrel", title = "自爆拉扯", desc = "进入设定范围会被弹开", default = false, internal = true, onChanged = function(v) FEATURES.togglePushBarrel(v) end },
                    { type = "slider", key = "protect.slider.push_barrel_size", title = "自爆拉扯范围", desc = "进入设定范围自动弹出", min = 1, max = 15, step = 1, default = 10, internal = true, onChanged = function(v) FEATURES.setPushBarrelSize(v) end },
                },
            },
        },
    })

    AddPage({
        id = "automap",
        title = "地图自动",
        icon = "A",
        subtitle = "地图专用自动功能",
        sections = {
            {
                title = "地图通用功能",
                items = {
                    { type = "toggle", key = "features.toggle.autocollect", title = "自动收集", desc = "自动收集物品", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoCollect(v) end },
                    { type = "toggle", key = "features.toggle.autodoor", title = "自动开门", desc = "自动开门", default = false, internal = true, onChanged = function(v) FEATURES.toggleAutoDoor(v) end },
                    { type = "toggle", key = "features.toggle.autocannon", title = "自动装填大炮", desc = "自动装填最近的12磅炮", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoCannon(v) end },
                    { type = "toggle", key = "features.toggle.autobucket", title = "自动水桶灭火", desc = "自动装备水桶灭火", default = false, internal = true, onChanged = function(v) FEATURES.toggleAutoBucket(v) end },
                },
            },
            {
                title = "瓦尔多赫斯要塞",
                items = {
                    { type = "toggle", key = "features.toggle.autodig", title = "自动挖雪", desc = "自动挖掘雪堆", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoDig(v) end },
                },
            },
            {
                title = "巴黎地下墓穴",
                items = {
                    { type = "toggle", key = "features.toggle.autobrick", title = "自动砸砖墙", desc = "巴黎地下墓穴自动砸砖墙", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoBrick(v) end },
                },
            },
            {
                title = "伦敦",
                items = {
                    { type = "toggle", key = "features.toggle.autobarrel", title = "自动打酒桶", desc = "自动攻击酒桶", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoBarrel(v) end },
                    { type = "toggle", key = "features.toggle.london_board", title = "自动打伦敦四块木板", desc = "自动攻击伦敦木板", default = false, internal = true, onChanged = function(v) FEATURES.toggleLondonBoard(v) end },
                },
            },
            {
                title = "威斯特敏",
                items = {
                    { type = "toggle", key = "features.toggle.autowestminster", title = "自动打威斯特敏障碍", desc = "自动攻击威斯特敏路障", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoWestminster(v) end },
                },
            },
            {
                title = "莱比锡全自动",
                items = {
                    { type = "toggle", key = "features.toggle.autoleipzig", title = "通关莱比锡", desc = "自动飞行完成任务", default = false, internal = true, onChanged = function(v) FEATURES.toggleAutoLeipzig(v) end },
                    { type = "slider", key = "features.slider.leipzig_fly_speed", title = "飞行速度", desc = "控制自动飞行的移动速度", min = 10, max = 100, step = 1, default = 37, internal = true, onChanged = function(v) FEATURES.setLeipzigFlySpeed(v) end },
                    { type = "toggle", key = "features.toggle.autodoor", title = "自动开门", desc = "自动开门（同步）", default = false, internal = true, onChanged = function(v) FEATURES.toggleAutoDoor(v) end },
                    { type = "toggle", key = "features.toggle.autobell", title = "自动拉铃铛", desc = "靠近铃铛时自动交互", default = false, internal = true, onChanged = function(v) FEATURES.toggleAutoBell(v) end },
                    { type = "toggle", key = "features.toggle.autoleipzig_barricade", title = "自动打莱比锡木板", desc = "自动攻击莱比锡木板", default = false, internal = true, onChanged = function(v) FEATURES.toggleAutoLeipzigBarricade(v) end },
                },
            },
            {
                title = "哥本哈根",
                items = {
                    { type = "toggle", key = "features.toggle.autocopenhagen", title = "自动打哥本哈根锁", desc = "自动攻击哥本哈根锁", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoCopenhagenGate(v) end },
                },
            },
            {
                title = "别列津纳修桥",
                items = {
                    { type = "toggle", key = "features.toggle.autobridge", title = "自动修桥", desc = "自动搭桥", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoBridge(v) end },
                    { type = "toggle", key = "features.toggle.autolog", title = "自动拿木头", desc = "自动拿木头", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoLog(v) end },
                    { type = "toggle", key = "features.toggle.autoplace", title = "自动点击放置", desc = "自动点击ProximityPrompt", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoPlace(v) end },
                    { type = "toggle", key = "features.toggle.autorepair", title = "自动修建筑", desc = "自动修复建筑", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoRepair(v) end },
                },
            },
        },
    })

    AddPage({
        id = "career",
        title = "职业",
        icon = "R",
        subtitle = "职业功能",
        sections = {
            {
                title = "工兵",
                items = {
                    { type = "toggle", key = "features.toggle.auto_repair_bow", title = "自动修复建筑物", desc = "自动修复建筑物", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoRepair(v) end },
                    { type = "toggle", key = "features.toggle.recycle", title = "攻击回收", desc = "攻击时自动回收武器来达到移除后摇的效果", default = false, internal = true , onChanged = function(v) FEATURES.toggleRecycle(v) end },
                    { type = "toggle", key = "features.toggle.elbow_range", title = "肘击范围扩大", desc = "扩大肘击范围", default = false, internal = true , onChanged = function(v) FEATURES.toggleElbowRange(v) end },
                    { type = "toggle", key = "features.toggle.elbow", title = "肘击", desc = "自动肘击", default = false, internal = true , onChanged = function(v) FEATURES.toggleElbow(v) end },
                },
            },
            {
                title = "军官",
                items = {
                    { type = "toggle", key = "features.toggle.autoreload", title = "自动换弹", desc = "自动换弹", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoReload(v) end },
                    { type = "toggle", key = "features.toggle.auto_reequip", title = "换弹完成后自动重新装备武器", desc = "每装填一发子弹后自动收回枪械再装备", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoReequip(v) end },
                    { type = "toggle", key = "features.toggle.blackgun", title = "自动黑枪", desc = "已自动为浮木购买无限名刀", default = false, internal = true , onChanged = function(v) FEATURES.toggleBlackGun(v) end },
                    { type = "toggle", key = "features.toggle.jump_knife", title = "自动跳刀", desc = "军刀前刺时自动跳跃", default = false, internal = true , onChanged = function(v) FEATURES.toggleJumpKnife(v) end },
                    { type = "slider", key = "features.slider.jump_knife_height", title = "自动跳刀高度", desc = "军刀前刺时跳跃高度", min = 0, max = 90, step = 1, default = 30, internal = true , onChanged = function(v) FEATURES.setJumpKnifeHeight(v) end },
                    { type = "toggle", key = "features.toggle.auto_charge", title = "自动冲锋", desc = "能量值满后自动开启冲锋", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoCharge(v) end },
                },
            },
            {
                title = "自定义军官",
                items = {
                    { type = "toggle", key = "features.toggle.custom_blackgun", title = "自动黑枪", desc = "可调参数自动黑枪", default = false, internal = true , onChanged = function(v) FEATURES.toggleCustomBlackGun(v) end },
                    { type = "slider", key = "features.slider.aim_time", title = "转向时间(秒)", desc = "数值越低越快", min = 0.01, max = 1, step = 0.01, default = 0.28, internal = true , onChanged = function(v) FEATURES.setAimTime(v) end },
                    { type = "slider", key = "features.slider.shoot_interval", title = "射击间隔(秒)", desc = "射击速度", min = 0.01, max = 1, step = 0.01, default = 0.1, internal = true , onChanged = function(v) FEATURES.setShootInterval(v) end },
                    { type = "slider", key = "features.slider.equip_speed", title = "装备速度(秒)", desc = "数值越低越快", min = 0.01, max = 1, step = 0.01, default = 0.2, internal = true , onChanged = function(v) FEATURES.setEquipSpeed(v) end },
                    { type = "slider", key = "features.slider.barrel_detect", title = "自爆检测距离", desc = "检测自爆离玩家的距离", min = 1, max = 50, step = 1, default = 14, internal = true , onChanged = function(v) FEATURES.setBarrelDetect(v) end },
                    { type = "slider", key = "features.slider.max_aim_range", title = "最大瞄准距离", desc = "自动瞄准的最远距离", min = 1, max = 200, step = 1, default = 50, internal = true , onChanged = function(v) FEATURES.setMaxAimRange(v) end },
                    { type = "toggle", key = "features.toggle.custom_wall_check", title = "墙体检测", desc = "不会射击被墙体遮挡住的", default = false, internal = true , onChanged = function(v) FEATURES.toggleCustomWallCheck(v) end },
                },
            },
            {
                title = "自动射击",
                items = {
                    { type = "toggle", key = "features.toggle.autoshoot_barrel", title = "自爆", desc = "自动射击自爆", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoShoot("Barrel", v) end },
                    { type = "toggle", key = "features.toggle.autoshoot_cuirassier", title = "胸甲骑兵", desc = "自动射击胸甲骑兵", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoShoot("Cuirassier", v) end },
                    { type = "toggle", key = "features.toggle.autoshoot_runner", title = "红眼", desc = "自动射击红眼", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoShoot("Runner", v) end },
                    { type = "toggle", key = "features.toggle.autoshoot_axe", title = "斧头", desc = "自动射击斧头", default = false, internal = true , onChanged = function(v) FEATURES.toggleAutoShoot("Electrocutioner", v) end },
                },
            },
            {
                title = "医生",
                items = {
                    { type = "toggle", key = "features.toggle.doctor", title = "自动治疗受伤玩家", desc = "自动向受伤玩家治疗", default = false, internal = true , onChanged = function(v) FEATURES.toggleDoctor(v) end },
                    { type = "slider", key = "features.slider.doctor_threshold", title = "医疗阈值(%)", desc = "自动治疗低于阀值玩家", min = 1, max = 100, step = 1, default = 50, internal = true , onChanged = function(v) FEATURES.setDoctorThreshold(v) end },
                },
            },
            {
                title = "牧师",
                items = {
                    { type = "toggle", key = "features.toggle.chaplain", title = "自动祝福感染玩家", desc = "自动向感染玩家发送祝福", default = false, internal = true , onChanged = function(v) FEATURES.toggleChaplain(v) end },
                    { type = "slider", key = "features.slider.chaplain_threshold", title = "祝福阈值(%)", desc = "感染值高于阀值自动祝福", min = 1, max = 100, step = 1, default = 50, internal = true , onChanged = function(v) FEATURES.setChaplainThreshold(v) end },
                },
            },
        },
    })

    AddPage({
        id = "getitems",
        title = "强制获取",
        icon = "T",
        subtitle = "强制获取物品",
        sections = {
            {
                title = "功能",
                items = {
                    { type = "button", key = "get.button.achievement", title = "解锁成就军团", desc = "解锁成就军团", onChanged = function() FEATURES.getAchievement() end, actionText = "解锁", internal = true },
                    { type = "button", key = "get.button.baguette", title = "获取法棍", desc = "获取法棍 (Baguette)", onChanged = function() FEATURES.getBaguette() end, actionText = "获取", internal = true },
                    { type = "button", key = "get.button.voivode", title = "获取吸血鬼刀", desc = "获取吸血鬼刀 (Voivode)", onChanged = function() FEATURES.getVoivode() end, actionText = "获取", internal = true },
                    { type = "button", key = "get.button.stake", title = "获取铁桩", desc = "获取铁桩 (Iron Stake)", onChanged = function() FEATURES.getStake() end, actionText = "获取", internal = true },
                    { type = "button", key = "get.button.all", title = "获取所有武器", desc = "获取所有武器并装备", onChanged = function() FEATURES.getAllWeapons() end, actionText = "获取全部", internal = true },
                },
            },
        },
    })

    AddPage({
        id = "fun",
        title = "娱乐",
        icon = "F",
        subtitle = "娱乐功能",
        sections = {
            {
                title = "功能",
                items = {
                    { type = "toggle", key = "fun.toggle.spin", title = "旋转", desc = "开机后让人物旋转", default = false, internal = true , onChanged = function(v) FEATURES.toggleSpin(v) end },
                    { type = "slider", key = "fun.slider.spin_speed", title = "旋转速度", desc = "开局后让人物旋转", min = 1, max = 50, step = 1, default = 10, internal = true , onChanged = function(v) FEATURES.setSpinSpeed(v) end },
                    { type = "toggle", key = "fun.toggle.handstand", title = "倒立行走", desc = "让玩家倒立", default = false, internal = true , onChanged = function(v) FEATURES.toggleHandstand(v) end },
                    { type = "toggle", key = "fun.toggle.stutter", title = "我好像有点卡顿", desc = "让人物看起来卡卡的", default = false, internal = true, onChanged = function(v) FEATURES.toggleStutter(v) end },
                    { type = "slider", key = "fun.slider.stutter_speed", title = "卡顿程度", desc = "调整卡顿频率", min = 1, max = 10, step = 1, default = 3, internal = true, onChanged = function(v) FEATURES.setStutterSpeed(v) end },
                    { type = "toggle", key = "fun.toggle.remove_jump_limit", title = "移除跳跃限制", desc = "移除跳跃限制", default = false, internal = true, onChanged = function(v) FEATURES.toggleRemoveJumpLimit(v) end },
                    { type = "toggle", key = "fun.toggle.kill_sound", title = "开启击杀音效", desc = "击杀僵尸时播放音效", default = false, internal = true, onChanged = function(v) FEATURES.toggleKillSound(v) end },
                    { type = "slider", key = "fun.slider.kill_sound_vol", title = "击杀音效音量", desc = "调整音效音量", min = 1, max = 10, step = 1, default = 7, internal = true, onChanged = function(v) FEATURES.setKillSoundVol(v) end },
                },
            },
        },
    })

    AddPage({
        id = "beauty",
        title = "美化",
        icon = "B",
        subtitle = "特效与动画",
        sections = {
            {
                title = "美化",
                items = {
                    { type = "toggle", key = "beauty.toggle.angel", title = "天使光环", desc = "天使光环特效", default = false, internal = true, onChanged = function(v) FEATURES.toggleAngel(v) end },
                    { type = "toggle", key = "beauty.toggle.stinky", title = "你好臭呀", desc = "腐烂发臭", default = false, internal = true, onChanged = function(v) FEATURES.toggleStinky(v) end },
                    { type = "toggle", key = "beauty.toggle.cripple", title = "残疾人", desc = "双腿失缺", default = false, internal = true, onChanged = function(v) FEATURES.toggleCripple(v) end },
                },
            },
            {
                title = "动画",
                items = {
                    { type = "toggle", key = "anim.toggle.normal", title = "山伯乐", desc = "山伯乐动画", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimNormal(v) end },
                    { type = "toggle", key = "anim.toggle.runner", title = "红眼", desc = "红眼动画", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimRunner(v) end },
                    { type = "toggle", key = "anim.toggle.cuirassier", title = "胸甲骑兵", desc = "胸甲骑兵动画", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimCuirassier(v) end },
                    { type = "toggle", key = "anim.toggle.cuirassier_charge", title = "胸甲骑兵冲锋快捷栏", desc = "打开小方块快捷栏执行冲锋", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimCuirassierCharge(v) end },
                    { type = "toggle", key = "anim.toggle.lantern", title = "提灯人", desc = "提灯人动画", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimLantern(v) end },
                    { type = "toggle", key = "anim.toggle.axe", title = "斧头僵尸", desc = "斧头僵尸ZAPPER动画", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimAxe(v) end },
                    { type = "toggle", key = "anim.toggle.axe_slash", title = "斧头僵尸劈砍快捷栏", desc = "打开小方块快捷栏执行劈砍", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimAxeSlash(v) end },
                    { type = "toggle", key = "anim.toggle.barrel", title = "自爆", desc = "自爆动画", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimBarrel(v) end },
                    { type = "toggle", key = "anim.toggle.crawler", title = "爬尸", desc = "爬尸动画（爬行模式）", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimCrawler(v) end },
                    { type = "toggle", key = "anim.toggle.heavy_charge", title = "重剑冲锋", desc = "重剑冲锋动画", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimHeavyCharge(v) end },
                    { type = "toggle", key = "anim.toggle.musket_charge", title = "滑膛枪冲锋", desc = "滑膛枪冲锋动画", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimMusketCharge(v) end },
                    { type = "toggle", key = "anim.toggle.charge", title = "冲锋", desc = "冲锋动画", default = false, internal = true, onChanged = function(v) FEATURES.toggleAnimCharge(v) end },
                },
            },
        },
    })
    AddPage({
        id = "fps",
        title = "帧率提升",
        icon = "Z",
        subtitle = "性能优化与画质调整",
        sections = {
            {
                title = "帧率优化",
                items = {
                    { type = "toggle", key = "fps.toggle.disable_fire", title = "禁用部分火焰粒子", desc = "禁用部分火焰粒子提高帧率", default = false, internal = true, onChanged = function(v) FEATURES.toggleFpsFire(v) end },
                    { type = "button", key = "fps.button.remove_carriage", title = "移除马车模型", desc = "删除马车模型减少卡顿", onChanged = function() FEATURES.fpsRemoveCarriage() end, actionText = "移除", internal = true },
                    { type = "button", key = "fps.button.extreme_simplify", title = "开启迷你世界画质", desc = "开启迷你世界画质不可恢复", onChanged = function() FEATURES.fpsExtremeSimplify() end, actionText = "开启", confirm = true, confirmText = "确认开启迷你世界画质？不可恢复！", internal = true },
                    { type = "slider", key = "fps.slider.brightness", title = "画面亮度", desc = "暗<10<亮", min = 0, max = 20, step = 1, default = 10, internal = true, onChanged = function(v) FEATURES.fpsSetBrightness(v) end },
                    { type = "button", key = "fps.button.del_hats", title = "删除帽子", desc = "移除玩家帽子", onChanged = function() FEATURES.fpsRemoveHats() end, actionText = "删除", internal = true },
                    { type = "button", key = "fps.button.del_shirts", title = "删除上衣", desc = "移除玩家上衣", onChanged = function() FEATURES.fpsRemoveShirts() end, actionText = "删除", internal = true },
                    { type = "button", key = "fps.button.del_pants", title = "删除裤子", desc = "移除玩家裤子", onChanged = function() FEATURES.fpsRemovePants() end, actionText = "删除", internal = true },
                },
            },
        },
    })

    AddPage({
        id = "config",
        title = "存档",
        icon = "C",
        subtitle = "配置存档管理",
        sections = {
            {
                title = "配置管理",
                items = {
                    {
                        type = "input",
                        key = "config.input.name",
                        title = "配置名称",
                        desc = "输入存档名称",
                        placeholder = "例如: 配置1",
                        default = "",
                    },
                    {
                        type = "toggle",
                        key = "config.toggle.overwrite",
                        title = "叠加替换原名称",
                        desc = "开启：同名直接替换 / 关闭：同名自动编号保存",
                        default = true,
                        internal = true,
                    },
                    {
                        type = "button",
                        key = "config.button.save",
                        title = "保存配置",
                        desc = "将当前所有控件状态保存到文件",
                        actionText = "保存",
                        internal = true,
                        onChanged = function()
                            local name = State.Inputs['config.input.name'] or ''
                            if name == '' then
                                State:AddLog('存档', '请输入配置名称', 'config.save.empty')
                                return
                            end
                            local ok, msg = ConfigManager:SaveConfig(name)
                            State:AddLog('存档', msg, ok and 'config.save.ok' or 'config.save.fail')
                            ConfigManager:RefreshDropdown()
                        end,
                    },
                    {
                        type = "dropdown",
                        key = "config.dropdown.select",
                        title = "选择配置",
                        desc = "选择一个已保存的配置",
                        default = "无",
                        options = {},
                    },
                    {
                        type = "button",
                        key = "config.button.load",
                        title = "加载配置",
                        desc = "加载选中配置到当前界面",
                        actionText = "加载",
                        internal = true,
                        onChanged = function()
                            local name = State.Dropdowns['config.dropdown.select']
                            if type(name) ~= 'string' then
                                State:AddLog('存档', '无效的配置选择', 'config.load.invalid')
                                return
                            end
                            if not name then
                                State:AddLog('存档', '请先选择配置', 'config.load.empty')
                                return
                            end
                            local ok, msg = ConfigManager:LoadConfig(name)
                            ConfigManager:RefreshDropdown()
                            local ctrlLoad = State.Controls["config.dropdown.select"]
                            if ctrlLoad and ctrlLoad.SetValue then ctrlLoad.SetValue(name, true) end
                            if type(msg) ~= 'string' then msg = ok and '配置已加载' or '操作失败' end
                            if State.Toggles['config.toggle.autosave'] then
                                State.Toggles['config.toggle.autosave'] = false
                                local ac = State.Controls['config.toggle.autosave']
                                if ac and ac.SetValue then ac.SetValue(false, true) end
                                State:AddLog('TOGGLE', '自动保存已关闭', 'config.autosave.off')
                            end
                            State:AddLog('存档', msg, ok and 'config.load.ok' or 'config.load.fail')
                        end,
                    },
                    {
                        type = "button",
                        key = "config.button.delete",
                        title = "删除配置",
                        desc = "删除选中的配置文件",
                        actionText = "删除",
                        confirm = true,
                        confirmText = '确认删除此配置？',
                        internal = true,
                        onChanged = function()
                            local name = State.Dropdowns['config.dropdown.select']
                            if type(name) ~= 'string' then
                                State:AddLog('存档', '无效的配置选择', 'config.delete.invalid')
                                return
                            end
                            if not name then
                                State:AddLog('存档', '请先选择配置', 'config.delete.empty')
                                return
                            end
                            local ok, msg = ConfigManager:DeleteConfig(name)
                            task.wait()
                            ConfigManager:RefreshDropdown()
                            local ctrlDel = State.Controls['config.dropdown.select']
                            if ctrlDel and ctrlDel.SetValue then ctrlDel.SetValue('无', true) end
                            if type(msg) ~= 'string' then msg = ok and '已删除' or '操作失败' end
                            State:AddLog('存档', msg, ok and 'config.delete.ok' or 'config.delete.fail')
                        end,
                    },
                    {
                        type = "button",
                        key = "config.button.autoload",
                        title = "自动加载",
                        desc = "设置当前选中配置为下次启动时自动加载",
                        actionText = "设置自动加载",
                        internal = true,
                        onChanged = function()
                            local name = State.Dropdowns["config.dropdown.select"]
                            if not name or name == "无" then
                                State:AddLog("存档", "请先选择配置", "config.autoload.empty")
                                return
                            end
                            ConfigManager:WriteAutoLoad(name)
                            local ok, msg = ConfigManager:LoadConfig(name)
                            ConfigManager:RefreshDropdown()
                            if ok then
                                local ctrl = State.Controls["config.dropdown.select"]
                                if ctrl and ctrl.SetValue then ctrl.SetValue(name, true) end
                            end
                            if State.Toggles["config.toggle.autosave"] then
                                State.Toggles["config.toggle.autosave"] = false
                                local ac = State.Controls["config.toggle.autosave"]
                                if ac and ac.SetValue then ac.SetValue(false, true) end
                                State:AddLog("TOGGLE", "自动保存已关闭", "config.autosave.off")
                            end
                            State:AddLog("存档", ok and "已设置自动加载: " .. name or "操作失败", ok and "config.autoload.ok" or "config.autoload.fail")
                        end,
                    },
                    {
                        type = "status",
                        key = "config.status.current",
                        title = "当前自动加载配置",
                        desc = "当前加载的配置名称",
                        value = "无",
                    },
                },
            },
            {
                title = "自动保存",
                items = {
                    {
                        type = "toggle",
                        key = "config.toggle.autosave",
                        title = "自动保存与读取",
                        desc = "记录你上次开关了哪些按钮，下次执行脚本时自动恢复",
                        default = false,
                        internal = true,
                    },
                },
            },
        },
    })

    AddPage({
        id = "settings",
        title = "设置",
        icon = "S",
        subtitle = "DPI、窗口尺寸",
        sections = {
            {
                title = "界面设置",
                items = {
                    {
                        type = "slider",
                        key = "settings.ui.dpi",
                        title = "DPI 缩放",
                        desc = "只影响本 UI。",
                        min = AppConfig.MinimumDpi,
                        max = AppConfig.MaximumDpi,
                        step = 5,
                        default = 75,
                        format = "%d%%",
                        internal = true,
                        onChanged = function(value)
                            UI.SetDpi(value / 100)
                        end,
                    },
                    {
                        type = "dropdown",
                        key = "settings.ui.window_preset",
                        title = "窗口尺寸",
                        desc = "只调整 UI 外壳尺寸。",
                        default = "mini",
                        options = { Option("迷你", "mini"), Option("标准", "standard"), Option("宽屏", "wide"), Option("大型", "large") },
                        onChanged = function(value)
                            UI.SetWindowPreset(value)
                        end,
                    },
                    {
                        type = "toggle",
                        key = "settings.toggle.livestream",
                        title = "直播引导",
                        desc = "显示/隐藏直播引导文字",
                        default = false,
                        internal = true,
                        onChanged = function(value) UI.ToggleLivestream(value) end,
                    },
                    {
                        type = "slider",
                        key = "settings.ui.livestream_x",
                        title = "直播引导X",
                        desc = "水平位置 (0-100)",
                        min = 0,
                        max = 100,
                        step = 0.1,
                        format = "%.1f",
                        default = 53,
                        internal = true,
                        onChanged = function() UI.UpdateLivestreamPos() end,
                    },
                    {
                        type = "slider",
                        key = "settings.ui.livestream_y",
                        title = "直播引导Y",
                        desc = "垂直位置 (-50~50)",
                        min = -50,
                        max = 50,
                        step = 0.1,
                        format = "%.1f",
                        default = 7.4,
                        internal = true,
                        onChanged = function() UI.UpdateLivestreamPos() end,
                    },
                    {
                        type = "slider",
                        key = "settings.ui.livestream_size",
                        title = "直播引导大小",
                        desc = "文字大小",
                        min = 10,
                        max = 40,
                        step = 1,
                        default = 20,
                        internal = true,
                        onChanged = function() UI.BuildLivestream() end,
                    },
                    {
                        type = "toggle",
                        key = "settings.toggle.custom_btn_pos",
                        title = "自定义悬浮窗位置",
                        desc = "开启后可调是缩小后的悬浮窗位置，并且进行固定",
                        default = false,
                        internal = true,
                        onChanged = function() UI.UpdateBtnPos() end,
                    },
                    {
                        type = "slider",
                        key = "settings.ui.btn_pos_x",
                        title = "悬浮窗X",
                        desc = "水平偏移（像素）",
                        min = 0,
                        max = 1000,
                        step = 1,
                        default = 90,
                        format = "%dpx",
                        internal = true,
                        onChanged = function() UI.UpdateBtnPos() end,
                    },
                    {
                        type = "slider",
                        key = "settings.ui.btn_pos_y",
                        title = "悬浮窗Y",
                        desc = "垂直偏移（像素）",
                        min = 0,
                        max = 1000,
                        step = 1,
                        default = 50,
                        format = "%dpx",
                        internal = true,
                        onChanged = function() UI.UpdateBtnPos() end,
                    },
                    { type = "button", key = "settings.framework.reset_ui_state", title = "重置 UI 状态", desc = "清空本 UI 的控件状态并重建界面，不影响游戏。", actionText = "重置", confirm = true, confirmText = "确认重置本 UI 的开关、输入、下拉和折叠状态？", internal = true, onChanged = function() State:ResetControls(); UI.Build() end }
                },
            },
        },
    })

    AddPage({
        id = "logs",
        title = "日志",
        icon = "L",
        subtitle = "日志输出",
        sections = {
            {
                title = "日志输出",
                items = {
                    { type = "log", key = "logs.output.main", clearKey = "logs.button.clear", title = "操作日志" },
                },
            },
        },
    })

    AddPage({
        id = "about",
        title = "关于",
        icon = "I",
        subtitle = "版本信息",
        sections = {
            {
                title = "框架信息",
                items = {
                    { type = "status", key = "about.version", title = "当前版本", desc = "正式版 v1.0", value = AppConfig.Version },
                    { type = "status", key = "about.author", title = "缝合作者", desc = "青木作者", value = "青木" },
                    { type = "status", key = "about.source", title = "源码贡献者", desc = "柳叶贡献", value = "柳叶" },
                    { type = "status", key = "about.assistant", title = "协助者", desc = "kinub目前已跑路", value = "kinub" },
                    { type = "status", key = "about.supporter", title = "UI创作者", desc = "秋容", value = "秋容" },
                    { type = "status", key = "about.obfuscator", title = "混淆加密脚本者", desc = "混析加密脚本当前仅为1.0版本", value = "秋容" },
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
            Size = UDim2.fromOffset(180, 420),
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
        local toastWidth = 180
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

    function UI.ShowAnnouncement()
        if not UI.Main then
            return
        end

        if UI.Announcement and UI.Announcement.Parent then
            UI.Announcement:Destroy()
        end

        local mainSize = UI.Main.AbsoluteSize
        local width = math.max(math.floor(mainSize.X * 0.92), 550)
        local height = math.max(math.floor(mainSize.Y * 0.85), 350)

        local panel = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Colors.Window,
            BackgroundTransparency = 0,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(width, height),
            Parent = UI.Main,
            ZIndex = 70,
        })
        UI.Announcement = panel
        AddCorner(panel, Theme.Radius.Window)
        AddStroke(panel, Theme.Colors.StrokeStrong)

        local header = New("Frame", {
            BackgroundColor3 = Theme.Colors.PanelDeep,
            Position = UDim2.fromOffset(1, 1),
            Size = UDim2.new(1, -2, 0, 40),
            Parent = panel,
            ZIndex = 71,
        })
        AddCorner(header, Theme.Radius.Window)

        local title = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(0.98, 0, 1.25, 0),
            Text = AppConfig.AnnouncementTitle or "公告详情",
            TextColor3 = Theme.Colors.Text,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            Font = Enum.Font.SourceSansBold,
            Parent = header,
            ZIndex = 72,
        })

        local close = Components.IconButton(header, "announcement.close", "X", "", function()
            if panel and panel.Parent then
                panel:Destroy()
            end
            if UI.Announcement == panel then
                UI.Announcement = nil
            end
        end)
        close.AnchorPoint = Vector2.new(1, 0.5)
        close.Position = UDim2.new(1, -8, 0.5, 0)
        close.Size = UDim2.fromOffset(28, 28)
        close.ZIndex = 72

        local body = New("ScrollingFrame", {
            BackgroundColor3 = Theme.Colors.Background,
            Position = UDim2.fromOffset(12, 52),
            Size = UDim2.new(1, -24, 1, -64),
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Colors.StrokeStrong,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Parent = panel,
            ZIndex = 71,
        })
        AddCorner(body, Theme.Radius.Panel)
        AddStroke(body, Theme.Colors.Stroke)

        local text = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -30, 0, 0),
            Position = UDim2.fromOffset(14, 10),
            Text = AppConfig.AnnouncementText or "",
            TextColor3 = Theme.Colors.TextMuted,
            TextSize = 15,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Top,
            Font = Theme.Font,
            Parent = body,
            ZIndex = 72,
        })

        local function updateCanvas()
            task.wait()
            if text and text.Parent then
                local h = Services.TextService:GetTextSize(text.Text, text.TextSize, text.Font, Vector2.new(text.AbsoluteSize.X, math.huge)).Y
                text.Size = UDim2.new(1, -30, 0, h)
                body.CanvasSize = UDim2.fromOffset(0, h + 24)
            end
        end

        task.spawn(updateCanvas)
        UI.Track(body:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas))

        UI.MakeDraggable(panel, header)
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
            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
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
                dragging = false
                dragInputType = nil
                if frame == UI.ShowButton and moved then
                    task.delay(0.08, function()
                        UI.ShowButtonDragged = false
                    end)
                end
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
            AddStroke(button)
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
        local texts = {
            {text = "高级PS技术", color = Color3.fromRGB(255, 100, 100)},
            {text = "注意分辨",   color = Color3.fromRGB(100, 255, 100)},
            {text = "无不良引导", color = Color3.fromRGB(100, 100, 255)}
        }
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
            UI.BuildLivestream()
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
            MinimizePosition = UDim2.new(1, -68, 0, 1),
            MinimizeSize = UDim2.fromOffset(28, 28),
            ClosePosition = UDim2.new(1, -30, 0, 1),
            CloseSize = UDim2.fromOffset(28, 28),
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
            Visible = false,
            Parent = root,
        })
        AddCorner(UI.ShowButton, 8)
        UI.ShowButtonStroke = AddStroke(UI.ShowButton, Color3.fromRGB(255, 255, 255))
        UI.ShowScale = New("UIScale", {
            Scale = State.DpiScale,
            Parent = UI.ShowButton,
        })

        local function _showButtonClick()
            if UI.ShowButtonDragged then return end
            Tween(UI.ShowButton, { Size = UDim2.fromOffset(72, 36) }, Theme.Animation.Press)
            task.delay(Theme.Animation.Press + 0.04, function()
                Tween(UI.ShowButton, { Size = UDim2.fromOffset(80, 40) }, Theme.Animation.Fast)
            end)
            UI.SetVisible(true)
        end
        UI.ShowButton.MouseButton1Click:Connect(_showButtonClick)
        -- InputEnded 补充检测，解决左侧点击无效的问题
        UI.ShowButton.InputEnded:Connect(function(input)
            if UI.ShowButtonDragged then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                _showButtonClick()
            end
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
            UI.ShowAnnouncement()
        end)
        UI.BuildLivestream()
        UI.UpdateBtnPos()
        State:AddLog("UI", "框架启动: " .. AppConfig.Version, "app.start")
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
        ["fun.toggle.stutter"] = function(v) FEATURES.toggleStutter(v) end,
        ["fun.slider.stutter_speed"] = function(v) FEATURES.setStutterSpeed(v) end,
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

    
    
    -- ===== ESP Module (移植自 Skin HUB ) =====
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lp = Players.LocalPlayer

    local function lightenColor(color, factor)
        factor = factor or 0.5
        return Color3.new(color.R + (1 - color.R) * factor, color.G + (1 - color.G) * factor, color.B + (1 - color.B) * factor)
    end

    ESP.ZOMBIE_TYPES = {
        Axe    = { name = "斧头僵尸", color = Color3.fromRGB(180, 0, 250), highlightColor = lightenColor(Color3.fromRGB(180, 0, 250)), part = "Axe" },
        Eye    = { name = "红眼",      color = Color3.fromRGB(255, 50, 50),  highlightColor = lightenColor(Color3.fromRGB(255, 50, 50)),  part = "Eye" },
        Sword  = { name = "胸甲骑兵",  color = Color3.fromRGB(255, 0, 255),  highlightColor = lightenColor(Color3.fromRGB(255, 0, 255)),  part = "Sword" },
        Barrel = { name = "自爆",      color = Color3.fromRGB(250, 250, 0),  highlightColor = lightenColor(Color3.fromRGB(250, 250, 0)),  part = "Barrel" },
        FTorso = { name = "提灯人",    color = Color3.fromRGB(255, 120, 0),  highlightColor = lightenColor(Color3.fromRGB(255, 120, 0)),  part = "FTorso" },
        Normal = { name = "山伯乐",    color = Color3.fromRGB(144, 238, 144), highlightColor = Color3.fromRGB(144, 238, 144), part = nil }
    }

    ESP.zHL = {}  -- highlight toggles: typeKey -> bool
    ESP.zNM = {}  -- name toggles: typeKey -> bool
    ESP.zFX = {}  -- zombie effects cache

    function ESP.zombieToggle(typeKey, state)
        if state then ESP.zHL[typeKey] = true else ESP.zHL[typeKey] = nil end
        ESP._updateZombie()
    end
    function ESP.zombieName(typeKey, state)
        if state then ESP.zNM[typeKey] = true else ESP.zNM[typeKey] = nil end
        ESP._updateZombie()
    end

    function ESP._getZombieTypeKey(zombie)
        for tk, cfg in pairs(ESP.ZOMBIE_TYPES) do
            if cfg.part and zombie:FindFirstChild(cfg.part) then return tk end
        end
        return "Normal"
    end

    function ESP._mkTag(zombie, tk)
        local cfg = ESP.ZOMBIE_TYPES[tk]; if not cfg then return nil end
        local at = zombie.PrimaryPart or zombie:FindFirstChild("Head") or zombie:FindFirstChild("HumanoidRootPart")
        if not at then return nil end
        local g = Instance.new("BillboardGui")
        g.Size = UDim2.new(0, 120, 0, 30); g.StudsOffset = Vector3.new(0, 2.5, 0)
        g.AlwaysOnTop = true; g.Adornee = at; g.Parent = zombie
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
        l.Text = cfg.name; l.TextColor3 = cfg.highlightColor; l.TextTransparency = 0.3
        l.Font = Enum.Font.GothamBold; l.TextSize = 14
        l.TextStrokeTransparency = 0.5; l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.Parent = g; return g
    end

    function ESP._mkHL(z, c)
        local h = Instance.new("Highlight")
        h.FillColor = c; h.FillTransparency = 0.7; h.OutlineColor = c; h.OutlineTransparency = 0.7
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; h.Adornee = z; h.Parent = z; return h
    end

    function ESP._remZ(z)
        local e = ESP.zFX[z]; if e then
            if e.tag then e.tag:Destroy() end
            if e.highlight then e.highlight:Destroy() end
            ESP.zFX[z] = nil
        end
    end

    function ESP._clearZ() for z in pairs(ESP.zFX) do ESP._remZ(z) end end
    -- 马尔多赫斯要塞绘制（事件驱动，零轮询）
    ESP.fortHL = {}  -- toggle
    ESP.fortFX = {}  -- obj -> Highlight
    ESP.fortConns = {}  -- RBXScriptSignal connections
    ESP.fortThread = nil  -- 哨兵线程

    local FORT_WHITE = Color3.fromRGB(255, 255, 255)
    local FORT_NAMES = { ["12 lb. Roundshots"] = true, ["Swab"] = true }

    local function _fortCleanup()
        if ESP.fortThread then task.cancel(ESP.fortThread); ESP.fortThread = nil end
        for _, c in ipairs(ESP.fortConns) do pcall(function() c:Disconnect() end) end
        ESP.fortConns = {}
        for obj, hl in pairs(ESP.fortFX) do hl:Destroy() end
        ESP.fortFX = {}
    end

    local function _fortHL(item)
        if not ESP.fortFX[item] then ESP.fortFX[item] = ESP._mkHL(item, FORT_WHITE) end
    end

    local function _fortFind(fort)
        for _, item in ipairs(fort:GetDescendants()) do
            if FORT_NAMES[item.Name] then _fortHL(item) end
        end
    end

    local function _fortHook(fort)
        _fortFind(fort)
        table.insert(ESP.fortConns, fort.DescendantAdded:Connect(function(desc)
            if FORT_NAMES[desc.Name] then _fortHL(desc) end
        end))
    end

    function ESP.toggleFortDraw(typeKey, state)
        ESP.fortHL[typeKey] = state
        local anyOn = false
        for _, v in pairs(ESP.fortHL) do if v then anyOn = true; break end end
        if not anyOn then _fortCleanup(); return end

        _fortCleanup()

        local function _tryHook(fort)
            if fort then _fortHook(fort) end
        end

        local vh = workspace:FindFirstChild("Vardohus Fortress")
        if vh then _tryHook(vh)
        else
            table.insert(ESP.fortConns, workspace.ChildAdded:Connect(function(c)
                if c.Name == "Vardohus Fortress" then _tryHook(c) end
            end))
        end

        -- 哨兵监听：只盯一个对象，高亮消失就重绘，被销毁就换一个
        local _fortWatcher = nil
        ESP.fortThread = task.spawn(function()
            while ESP.fortThread do
                task.wait(2)
                if _fortWatcher then
                    if not _fortWatcher.Parent then
                        _fortWatcher = nil
                        for obj in pairs(ESP.fortFX) do _fortWatcher = obj; break end
                    elseif not ESP.fortFX[_fortWatcher] then
                        local vh3 = workspace:FindFirstChild("Vardohus Fortress")
                        if vh3 then _fortFind(vh3) end
                        _fortWatcher = nil
                        for obj in pairs(ESP.fortFX) do _fortWatcher = obj; break end
                    end
                else
                    for obj in pairs(ESP.fortFX) do _fortWatcher = obj; break end
                end
            end
        end)

        -- 玩家身上拾取的物品
        local lp = game:GetService("Players").LocalPlayer
        table.insert(ESP.fortConns, lp.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            for _, d in ipairs(char:GetDescendants()) do
                if FORT_NAMES[d.Name] then _fortHL(d) end
            end
        end))
        if lp.Character then
            for _, d in ipairs(lp.Character:GetDescendants()) do
                if FORT_NAMES[d.Name] then _fortHL(d) end
            end
        end
    end

    function ESP._updateZombie()
        local anyImg = false; local anyName = false
        for _ in pairs(ESP.zHL) do anyImg = true; break end
        for _ in pairs(ESP.zNM) do anyName = true; break end
        if not anyImg and not anyName then ESP._clearZ(); return end
        local char = lp.Character; local rp = char and char:FindFirstChild("HumanoidRootPart")
        local pos = rp and rp.Position
        if not pos then ESP._clearZ(); return end
        for z in pairs(ESP.zFX) do if not z.Parent then ESP._remZ(z) end end
        local cam = workspace:FindFirstChild("Camera")
        if not cam then return end
        for _, z in ipairs(cam:GetDescendants()) do
            if z:IsA("Model") and z.Name:find("Zombie") then
                local root = z:FindFirstChild("HumanoidRootPart") or z:FindFirstChild("Head") or z:FindFirstChild("Torso")
                if root and (root.Position - pos).Magnitude <= 200 then
                    local tk = ESP._getZombieTypeKey(z)
                    local needHL = ESP.zHL[tk]; local needNM = ESP.zNM[tk]
                    if needHL or needNM then
                        local cfg = ESP.ZOMBIE_TYPES[tk]
                        if not ESP.zFX[z] then ESP.zFX[z] = {} end
                        local fx = ESP.zFX[z]
                        if needNM and not fx.tag then fx.tag = ESP._mkTag(z, tk)
                        elseif not needNM and fx.tag then fx.tag:Destroy(); fx.tag = nil end
                        if needHL and not fx.highlight then fx.highlight = ESP._mkHL(z, cfg.highlightColor)
                        elseif not needHL and fx.highlight then fx.highlight:Destroy(); fx.highlight = nil end
                    else
                        if ESP.zFX[z] then ESP._remZ(z) end
                    end
                end
            end
        end
    end

    -- Player ESP
    ESP._playerEnabled = false; ESP._playerShowName = false; ESP._playerShowHealth = false; ESP._playerTeamCheck = false
    ESP.pFX = {}

    function ESP.playerToggle(s) ESP._playerEnabled = s; if not s then for p in pairs(ESP.pFX) do ESP._pDestroy(p) end end end
    function ESP.playerName(s) ESP._playerShowName = s; ESP._pRefresh() end
    function ESP.playerHealth(s) ESP._playerShowHealth = s; ESP._pRefresh() end
    function ESP.playerTeam(s) ESP._playerTeamCheck = s; ESP._pRefresh() end

    function ESP._getPlayerTeam(p)
        if p.Team then return p.Team end
        local a = p:GetAttribute("Team"); if a then return a end
        local c = p.Character; if c then
            local t = c:FindFirstChild("TeamTag") or c:FindFirstChild("Team")
            if t then return t.Value end end; return nil
    end

    function ESP._pGetColor(p)
        if ESP._playerTeamCheck then
            local mt = ESP._getPlayerTeam(lp); local pt = ESP._getPlayerTeam(p)
            if mt and pt and mt == pt then return Color3.fromRGB(100,150,255) end
            return Color3.fromRGB(255,100,100)
        end
        local ok, tc = pcall(function() return p.TeamColor.Color end)
        if ok and tc then return tc end
        return Color3.fromRGB(255,100,100)
    end

    function ESP._pDestroy(p)
        local e = ESP.pFX[p]; if e then
            if e.hl then e.hl:Destroy() end; if e.nm then e.nm:Destroy() end
            if e.hp then e.hp:Destroy() end; ESP.pFX[p] = nil end
    end

    function ESP._pUpdate(p)
        if not ESP._playerEnabled then ESP._pDestroy(p); return end
        local ch = p.Character; if not ch or p == lp then ESP._pDestroy(p); return end
        local hrp = ch:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local mc = lp.Character; local mh = mc and mc:FindFirstChild("HumanoidRootPart")
        local near = not mh or (hrp.Position - mh.Position).Magnitude <= 300
        local clr = ESP._pGetColor(p)
        if near then
            if not ESP.pFX[p] then ESP.pFX[p] = {} end
            local e = ESP.pFX[p]
            if not e.hl then
                local h = Instance.new("Highlight"); h.Adornee = ch; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.FillTransparency = 0.3; h.OutlineTransparency = 0.3; h.Parent = ch; e.hl = h
            end
            e.hl.FillColor = clr; e.hl.OutlineColor = clr
            if ESP._playerShowName then
                if not e.nm then
                    local g = Instance.new("BillboardGui"); g.Size = UDim2.new(0,150,0,30)
                    g.StudsOffset = Vector3.new(0,-2.5,0); g.AlwaysOnTop = true; g.Adornee = hrp; g.Parent = ch
                    local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
                    l.Text = p.Name; l.TextColor3 = clr; l.TextSize = 11; l.Font = Enum.Font.GothamBold
                    l.TextStrokeTransparency = 0; l.TextStrokeColor3 = Color3.fromRGB(0,0,0); l.Parent = g; e.nm = g
                end
            elseif e.nm then e.nm:Destroy(); e.nm = nil end
            if ESP._playerShowHealth then
                if not e.hp then
                    local g = Instance.new("BillboardGui"); g.Size = UDim2.new(0,100,0,30)
                    g.StudsOffset = Vector3.new(-2.5,1.5,0); g.AlwaysOnTop = true
                    g.Adornee = ch:FindFirstChild("Head") or hrp; g.Parent = ch
                    local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
                    l.TextSize = 11; l.Font = Enum.Font.GothamBold
                    l.TextStrokeTransparency = 0; l.TextStrokeColor3 = Color3.fromRGB(0,0,0); l.Parent = g; e.hp = g
                end
                local hu = ch:FindFirstChildOfClass("Humanoid")
                local hp = hu and math.floor(hu.Health / hu.MaxHealth * 100) or 100
                local ll = e.hp:FindFirstChildOfClass("TextLabel")
                if ll then ll.Text = hp .. "%"; ll.TextColor3 = clr end
            elseif e.hp then e.hp:Destroy(); e.hp = nil end
        elseif ESP.pFX[p] then ESP._pDestroy(p) end
    end

    function ESP._pRefresh()
        for _, p in ipairs(Players:GetPlayers()) do ESP._pUpdate(p) end
    end

    -- Connections
    local function setupEvents()
        Players.PlayerAdded:Connect(function(p)
            if p.Character then task.wait(0.5); ESP._pUpdate(p) end
            p.CharacterAdded:Connect(function() task.wait(0.2); ESP._pUpdate(p) end)
            p.CharacterRemoving:Connect(function() ESP._pDestroy(p) end)
        end)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp then
                p.CharacterAdded:Connect(function() task.wait(0.2); ESP._pUpdate(p) end)
                p.CharacterRemoving:Connect(function() ESP._pDestroy(p) end)
            end
        end
        Players.PlayerRemoving:Connect(function(p) ESP._pDestroy(p) end)
        lp.CharacterAdded:Connect(function() task.wait(0.5); ESP._pRefresh() end)

    end
    setupEvents()

    -- ===== 胸甲骑兵冲锋提醒 =====
    ESP._chargeEnabled = false
    local _lastChargeState = false
    local _chargeThread = nil

    function ESP.chargeToggle(state)
        ESP._chargeEnabled = state
        if state then
            _lastChargeState = false
            if not _chargeThread then
                _chargeThread = task.spawn(function()
                    while ESP._chargeEnabled do
                        local zf = workspace:FindFirstChild("Camera")
                        if zf then
                            local slim = zf:FindFirstChild("Slim")
                            if slim then
                                local sv = slim:FindFirstChild("State")
                                if sv and sv:IsA("StringValue") then
                                    local charging = (sv.Value == "BeginCharge" or sv.Value == "Charge")
                                    if charging and not _lastChargeState then
                                        State:AddLog("透视", "胸甲骑兵冲锋中！", "esp.charge")
                                    end
                                    _lastChargeState = charging
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                    _chargeThread = nil
                end)
            end
        else
            if _chargeThread then task.cancel(_chargeThread); _chargeThread = nil end
        end
    end


    -- ===== KILL Module (完整对照 Skin HUB  重写) =====
    local KillRS = game:GetService("RunService")
    local KillLP = game:GetService("Players").LocalPlayer

    KILL = {}
    KILL.highFreqEnabled = false
    KILL.highFreqThread = nil
    KILL.highFreqRange = 45
    KILL.highFreqCount = 5

    KILL.manualEnabled = false
    KILL.manualRange = 45
    KILL.manualConn = nil

    KILL.bayonetEnabled = false
    KILL.bayonetThread = nil
    KILL.bayonetRange = 30
    KILL.bayonetIndex = 1

    KILL.wallBarrelEnabled = false
    KILL.wallBarrelThread = nil
    KILL.wallBarrelSearchRange = 15
    KILL.wallBarrelAttackRange = 45
    KILL.wallBarrelAttackSpeed = 2
    KILL.wallBarrelMultiplier = 1
    KILL.wallBarrelDelay = 0.005
    KILL.wallBarrelIndex = 1

    -- 距离缩放 (同 Skin HUB: displayRange * 28/45)
    local function _getActualRange(sliderVal)
        return sliderVal * (28 / 45)
    end

    -- 工具: 获取近战武器 (同 Skin HUB getHeldMelee)
    local function _getWeapon()
        local c = KillLP.Character; if not c then return nil end
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") and t:GetAttribute("Melee") then return t end
        end
        return c:FindFirstChildOfClass("Tool")
    end

    -- 工具: 获取僵尸类型key (同 ESP._getZombieTypeKey)
    local function _getZombieType(z)
        if z:FindFirstChild("Barrel") then return "Barrel" end
        if z:FindFirstChild("Sword") then return "Sword" end
        local attr = z:GetAttribute("Type")
        if attr then return attr end
        local name = z.Name
        if name:find("Barrel") then return "Barrel"
        elseif name:find("Fast") then return "Fast"
        elseif name:find("Igniter") then return "Igniter"
        elseif name:find("Sapper") then return "Sapper"
        elseif name:find("Sword") or name:find("Cuirassier") then return "Sword"
        end
        return "Normal"
    end

    -- 工具: 检测僵尸类型是否在用户选中的类型中
    local function _isTypeSelected(z)
        local selected = State:Get("multi-dropdown", "kill.multi.zombie_types", {})
        if not next(selected) then return false end
        local tk = _getZombieType(z)
        for k, v in pairs(selected) do if v and k == tk then return true end end
        return false
    end

    -- 工具: 检测是否允许攻击此僵尸 (同 Skin HUB isZombieAttackAllowed)
    local function _canAttack(z)
        if z:FindFirstChild("State") and z.State.Value == "Spawn" then return false end
        if not _isTypeSelected(z) then return false end
        return true
    end

    -- 工具: 获取僵尸列表 (同 Skin HUB 逻辑: workspace.Zombies + GetChildren)
    local function _getZombiesInRange(maxDist)
        local c = KillLP.Character; local rp = c and c:FindFirstChild("HumanoidRootPart")
        if not rp then return {} end
        local zf = workspace:FindFirstChild("Zombies")
        if not zf then return {} end
        local list = {}
        for _, z in ipairs(zf:GetChildren()) do
            if z:IsA("Model") and z:FindFirstChild("HumanoidRootPart") and _canAttack(z) then
                if KILL.skipBarrel and z:GetAttribute("Type") == "Barrel" then continue end
                local d = (z.HumanoidRootPart.Position - rp.Position).Magnitude
                if d <= maxDist then table.insert(list, {z=z, d=d, root=z.HumanoidRootPart}) end
            end
        end
        table.sort(list, function(a,b) return a.d < b.d end)
        return list
    end

    -- ===== 高频光环 (完全对照 Skin HUB  attackLoop) =====
    function KILL._isFastWeapon()
        local char = KillLP.Character
        if not char then return false end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return false end
        local name = tool.Name
        if name == "Axe" or name == "Baguette" or name == "Pickaxe" or name == "Spade" or name == "Shovel" then
            return true
        end
        if name:lower():find("斧") or name:lower():find("法棍") or name:lower():find("镐") or name:lower():find("铲") then
            return true
        end
        return false
    end

    function KILL._highFreqLoop()
        while KILL.highFreqEnabled do
            local weapon = _getWeapon()
            if weapon then
                local range = _getActualRange(KILL.highFreqRange)
                local raw = {}
                local c = KillLP.Character
                if c then
                    local myRoot = c:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        local folder = workspace:FindFirstChild("Zombies")
                        if folder then
                            for _, z in ipairs(folder:GetChildren()) do
                                if z:IsA("Model") and z:FindFirstChild("HumanoidRootPart") and _canAttack(z) then
                                    if KILL.skipBarrel and z:GetAttribute("Type") == "Barrel" then continue end
                                    local dist = (z.HumanoidRootPart.Position - myRoot.Position).Magnitude
                                    if dist <= range then table.insert(raw, {z=z, root=z.HumanoidRootPart, dist=dist}) end
                                end
                            end
                            table.sort(raw, function(a, b) return a.dist < b.dist end)
                            local toAttack = math.min(KILL.highFreqCount, #raw)
                            for i = 1, toAttack do
                                local remote = weapon:FindFirstChild("RemoteEvent")
                                if remote then
                                    local head = raw[i].z:FindFirstChild("Head")
                                    if head then
                                        remote:FireServer("Swing", "Side")
                                        remote:FireServer("HitZombie", raw[i].z, head.Position, true)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            local waitTime = 0.05
            if not KILL._isFastWeapon() then waitTime = 0.15 end
            task.wait(waitTime)
        end
        KILL.highFreqThread = nil
    end

    function KILL.toggleHighFreq(state)
        KILL.highFreqEnabled = state
        if state then
            if not KILL.highFreqThread then KILL.highFreqThread = task.spawn(KILL._highFreqLoop) end
        else
            if KILL.highFreqThread then task.cancel(KILL.highFreqThread); KILL.highFreqThread = nil end
        end
    end
    function KILL.setHighFreqRange(v) KILL.highFreqRange = v end
    function KILL.setHighFreqCount(v) KILL.highFreqCount = v end

    -- ===== 手动光环 (对照 Skin HUB onKillAnimationPlayed + performSingleAnimAttack) =====
    function KILL._manualAttack()
        local wep = _getWeapon()
        if not wep then return end
        local range = _getActualRange(KILL.manualRange)
        local list = _getZombiesInRange(range)
        if #list > 0 then
            local re = wep:FindFirstChild("RemoteEvent")
            if re then
                local h = list[1].z:FindFirstChild("Head") or list[1].root
                re:FireServer("Swing", "Side")
                re:FireServer("HitZombie", list[1].z, h.Position, true)
            end
        end
    end

    function KILL.toggleManual(state)
        KILL.manualEnabled = state
        if state then
            if KILL.manualConn then return end
            local hu = KillLP.Character and KillLP.Character:FindFirstChildOfClass("Humanoid")
            if hu then
                KILL.manualConn = hu.AnimationPlayed:Connect(function(anim)
                    if KILL.manualEnabled and anim.Animation.AnimationId:find("attack") then
                        task.wait(0.1); KILL._manualAttack()
                    end
                end)
            end
        else
            if KILL.manualConn then KILL.manualConn:Disconnect(); KILL.manualConn = nil end
        end
    end
    function KILL.setManualRange(v) KILL.manualRange = v end

    -- ===== 刺刀光环 (移植自 Skin HUB v3.6 bayonetAttackLoop) =====
    function KILL._getMusket()
        local c = KillLP.Character; if not c then return nil end
        for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t.Name == "Musket" then return t end end
        local bp = KillLP:FindFirstChild("Backpack")
        if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and t.Name == "Musket" then return t end end end
        return nil
    end

    function KILL._attackZombieWithBayonet(zombie, weapon)
        if not weapon then return false end
        if not _canAttack(zombie) then return false end
        local re = weapon:FindFirstChild("RemoteEvent")
        if not re then return false end
        local head = zombie:FindFirstChild("Head")
        if not head then return false end
        re:FireServer("ThrustBayonet")
        re:FireServer("Bayonet_HitZombie", zombie, head.Position, true)
        return true
    end

    function KILL._getSortedZombiesInRange()
        local c = KillLP.Character; if not c then return {} end
        local myRoot = c:FindFirstChild("HumanoidRootPart")
        if not myRoot then return {} end
        local list = {}
        local zf = workspace:FindFirstChild("Zombies")
        if zf then
            for _, z in ipairs(zf:GetChildren()) do
                if z:IsA("Model") and z:FindFirstChild("HumanoidRootPart") and _canAttack(z) then
                    if KILL.skipBarrel and z:GetAttribute("Type") == "Barrel" then continue end
                    if z:FindFirstChild("State") and z.State.Value == "Spawn" then continue end
                    local d = (z.HumanoidRootPart.Position - myRoot.Position).Magnitude
                    if d <= KILL.bayonetRange then
                        table.insert(list, {zombie = z, dist = d})
                    end
                end
            end
        end
        table.sort(list, function(a, b) return a.dist < b.dist end)
        return list
    end

    function KILL._bayonetLoop()
        KILL.bayonetIndex = 1
        while KILL.bayonetEnabled do
            local c = KillLP.Character
            if c then
                local hu = c:FindFirstChildOfClass("Humanoid")
                if hu and hu.Health > 0 then
                    local wep = KILL._getMusket()
                    if wep then
                        local zombies = KILL._getSortedZombiesInRange()
                        local count = #zombies
                        if count > 0 then
                            if KILL.bayonetIndex > count then KILL.bayonetIndex = 1 end
                            local target = zombies[KILL.bayonetIndex]
                            if target then
                                KILL._attackZombieWithBayonet(target.zombie, wep)
                            end
                            KILL.bayonetIndex = KILL.bayonetIndex + 1
                            if KILL.bayonetIndex > count then KILL.bayonetIndex = 1 end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
        KILL.bayonetThread = nil
    end

    function KILL.toggleBayonet(state)
        KILL.bayonetEnabled = state
        if state then
            if not KILL.bayonetThread then KILL.bayonetThread = task.spawn(KILL._bayonetLoop) end
        else
            if KILL.bayonetThread then task.cancel(KILL.bayonetThread); KILL.bayonetThread = nil end
        end
    end
    function KILL.setBayonetRange(v) KILL.bayonetRange = v end

    -- ===== 攻击墙后自爆 (移植自 Skin HUB v3.6，含raycast墙体检测) =====
    function KILL._getBarrelZombies()
        local barrels = {}
        local zf = workspace:FindFirstChild("Zombies")
        if zf then
            for _, z in ipairs(zf:GetChildren()) do
                if z:IsA("Model") and (z:GetAttribute("Type") == "Barrel" or z:FindFirstChild("Barrel")) then
                    table.insert(barrels, z)
                end
            end
        end
        return barrels
    end

    function KILL._isBarrelBehindWall(zombie)
        local c = KillLP.Character; if not c then return true end
        local head = c:FindFirstChild("Head"); if not head then return true end
        local targetPart = zombie:FindFirstChild("Head") or zombie:FindFirstChild("HumanoidRootPart")
        if not targetPart then return true end
        local origin = head.Position
        local dir = targetPart.Position - origin
        local ray = Ray.new(origin, dir)
        local ignoreList = {c}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= lp and pl.Character then table.insert(ignoreList, pl.Character) end
        end
        local zf = workspace:FindFirstChild("Zombies")
        if zf then for _, z in ipairs(zf:GetChildren()) do if z:IsA("Model") then table.insert(ignoreList, z) end end end
        local cf = workspace:FindFirstChild("Camera")
        if cf then for _, z in ipairs(cf:GetChildren()) do if z:IsA("Model") and z.Name == "m_Zombie" then table.insert(ignoreList, z) end end end
        local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
        if hit and not hit:IsDescendantOf(zombie) then return true end
        return false
    end

    function KILL._wallBarrelLoop()
        while KILL.wallBarrelEnabled do
            local c = KillLP.Character; local hu = c and c:FindFirstChildOfClass("Humanoid")
            if hu and hu.Health > 0 then
                local wep = _getWeapon()
                if wep then
                    local re = wep:FindFirstChild("RemoteEvent")
                    if re then
                        local myRoot = c:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            local targets = {}
                            for _, z in ipairs(KILL._getBarrelZombies()) do
                                local hrp = z:FindFirstChild("HumanoidRootPart")
                                if hrp and (hrp.Position - myRoot.Position).Magnitude <= KILL.wallBarrelSearchRange then
                                    if KILL._isBarrelBehindWall(z) then
                                        table.insert(targets, z)
                                    end
                                end
                            end
                            local count = #targets
                            if count > 0 then
                                if KILL.wallBarrelIndex > count then KILL.wallBarrelIndex = 1 end
                                local toAttack = math.min(KILL.wallBarrelAttackSpeed, count)
                                local attacked = 0
                                local i = KILL.wallBarrelIndex
                                while attacked < toAttack do
                                    local barrel = targets[i]
                                    if barrel then
                                        local head = barrel:FindFirstChild("Head")
                                        if head then
                                            for _ = 1, KILL.wallBarrelMultiplier do
                                                re:FireServer("Swing", "Side")
                                                re:FireServer("HitZombie", barrel, head.Position, true)
                                            end
                                            attacked = attacked + 1
                                        end
                                    end
                                    i = i + 1
                                    if i > count then i = 1 end
                                end
                                KILL.wallBarrelIndex = i
                            else
                                KILL.wallBarrelIndex = 1
                            end
                        end
                    end
                end
            end
            task.wait(KILL.wallBarrelDelay)
        end
        KILL.wallBarrelThread = nil
    end

    function KILL.toggleWallBarrel(state)
        KILL.wallBarrelEnabled = state
        if state then
            KILL.wallBarrelIndex = 1
            if not KILL.wallBarrelThread then KILL.wallBarrelThread = task.spawn(KILL._wallBarrelLoop) end
        else
            if KILL.wallBarrelThread then task.cancel(KILL.wallBarrelThread); KILL.wallBarrelThread = nil end
            KILL.wallBarrelIndex = 1
        end
    end

    -- ===== 自动转向 (移植自 Skin HUB v3.6) =====
    KILL.autoFaceEnabled = false
    KILL.autoFaceRange = 17
    KILL.skipBarrel = false
    KILL.autoFaceConnection = nil

    function KILL._getNearestZombieInRange()
        local c = KillLP.Character; if not c then return nil end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local nearest = nil; local nearestDist = math.huge
        local zf = workspace:FindFirstChild("Zombies")
        if zf then
            for _, z in ipairs(zf:GetChildren()) do
                if z:IsA("Model") and z:FindFirstChild("HumanoidRootPart") then
                    if KILL.skipBarrel and z:GetAttribute("Type") == "Barrel" then continue end
                    local state = z:FindFirstChild("State")
                    if state and state.Value == "Spawn" then continue end
                    if not _isTypeSelected(z) then continue end
                    local d = (z.HumanoidRootPart.Position - root.Position).Magnitude
                    if d <= KILL.autoFaceRange and d < nearestDist then
                        nearestDist = d; nearest = z
                    end
                end
            end
        end
        return nearest
    end

    function KILL._faceZombie(zombie)
        if not zombie or not zombie:FindFirstChild("HumanoidRootPart") then return end
        local c = KillLP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hu = c:FindFirstChildOfClass("Humanoid")
        if not root or not hu then return end
        local tp = zombie.HumanoidRootPart.Position
        local targetCF = CFrame.lookAt(root.Position, Vector3.new(tp.X, root.Position.Y, tp.Z))
        local was = hu.AutoRotate
        hu.AutoRotate = false
        root.CFrame = root.CFrame:Lerp(targetCF, 0.3)
        hu.AutoRotate = was
    end

    function KILL._autoFaceLoop()
        while KILL.autoFaceEnabled do
            local target = KILL._getNearestZombieInRange()
            if target then KILL._faceZombie(target) end
            task.wait()
        end
    end

    function KILL.toggleAutoFace(state)
        KILL.autoFaceEnabled = state
        if KILL.autoFaceConnection then
            task.cancel(KILL.autoFaceConnection)
            KILL.autoFaceConnection = nil
        end
        if state then
            KILL.autoFaceConnection = task.spawn(KILL._autoFaceLoop)
        end
    end

    function KILL.setAutoFaceRange(v) KILL.autoFaceRange = v end
    function KILL.toggleSkipBarrel(v) KILL.skipBarrel = v end

    -- 重生重连
    KillLP.CharacterAdded:Connect(function()
        if KILL.highFreqEnabled then KILL.toggleHighFreq(false); task.wait(0.5); KILL.toggleHighFreq(true) end
        if KILL.bayonetEnabled then KILL.toggleBayonet(false); task.wait(0.5); KILL.toggleBayonet(true) end
        if KILL.autoFaceEnabled then
            task.wait(0.5)
            KILL.toggleAutoFace(false)
            task.wait(0.1)
            KILL.toggleAutoFace(true)
        end
    end)

    -- ===== 僵尸类型标签 (使用 ESP._getZombieTypeKey) =====
    local TYPE_LABELS = {}
    TYPE_LABELS.tags = {}
    TYPE_LABELS.enabled = false
    TYPE_LABELS.thread = nil

    local _tlNames = {
        Barrel = "自爆", Sapper = "斧头僵尸", Fast = "红眼",
        Sword = "胸甲骑兵", Igniter = "提灯人", Normal = "山伯乐"
    }

    function KILL._updateTypeLabels()
        -- 先清理所有旧标签（含其他脚本残留）
        local zf = workspace:FindFirstChild("Zombies")
        if not zf then return end
        for _, z in ipairs(zf:GetChildren()) do
            if not z:IsA("Model") then continue end
            local old = z:FindFirstChild("KillTypeLabel")
            if old then pcall(function() old:Destroy() end) end
        end
        -- 创建/更新标签
        for _, z in ipairs(zf:GetChildren()) do
            if not z:IsA("Model") then continue end
            local at = z.PrimaryPart or z:FindFirstChild("Head") or z:FindFirstChild("HumanoidRootPart")
            if not at then continue end
            local tk = _getZombieType(z)
            local name = _tlNames[tk] or tk
            local g = Instance.new("BillboardGui")
            g.Name = "KillTypeLabel"
            g.Size = UDim2.new(0, 120, 0, 30)
            g.StudsOffset = Vector3.new(0, 3, 0)
            g.AlwaysOnTop = true
            g.Adornee = at
            g.Parent = z
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 1, 0)
            l.BackgroundTransparency = 0.5
            l.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            l.Text = name
            l.TextColor3 = Color3.fromRGB(255, 255, 255)
            l.TextSize = 14
            l.Font = Enum.Font.GothamBold
            l.TextStrokeTransparency = 0.3
            l.Parent = g
            TYPE_LABELS.tags[z] = { tag = g }
        end
    end

    function KILL.toggleTypeLabels(state)
        TYPE_LABELS.enabled = state
        if state then
            if not TYPE_LABELS.thread then
                TYPE_LABELS.thread = task.spawn(function()
                    while TYPE_LABELS.enabled do
                        KILL._updateTypeLabels()
                        task.wait(0.5)
                    end
                    for z, objs in pairs(TYPE_LABELS.tags) do
                        if objs.tag then pcall(function() objs.tag:Destroy() end) end
                    end
                    TYPE_LABELS.tags = {}
                    TYPE_LABELS.thread = nil
                end)
            end
        else
            TYPE_LABELS.enabled = false
        end
    end

    -- Heartbeat loops
    local _lastUpdate = 0
    RunService.Heartbeat:Connect(function()
        local now = tick()
        if now - _lastUpdate >= 0.2 then
            _lastUpdate = now
            ESP._updateZombie()
            if ESP._playerEnabled then
                for _, p in ipairs(Players:GetPlayers()) do ESP._pUpdate(p) end
            end
        end
    end)


    -- ===== 碰撞箱系统 (移植自 Skin HUB v3.6) =====
    local HITBOX = {}
    HITBOX.zombieEnabled = false
    HITBOX.zombieSize = 10
    HITBOX.zombieAdded = {}
    
    HITBOX.zombieTransparency = 1
    

    local function _getPlayerTeam(p)
        if p.Team then return p.Team end
        local ta = p:GetAttribute("Team"); if ta then return ta end
        local c = p.Character
        if c then
            local tt = c:FindFirstChild("TeamTag") or c:FindFirstChild("Team")
            if tt then return tt.Value end
        end
        return nil
    end

    local function _isEnemy(p)
        if p == lp then return false end
        local mt = _getPlayerTeam(lp); local tt = _getPlayerTeam(p)
        if mt and tt then return mt ~= tt end
        return true
    end

    -- 僵尸碰撞箱
    local function _addZombieHitbox(z)
        if not HITBOX.zombieEnabled then return end
        if HITBOX.zombieAdded[z] then return end
        local hrp = z:FindFirstChild("HumanoidRootPart")
        local head = z:FindFirstChild("Head")
        if not hrp or not head then return end
        local outer = Instance.new("Part")
        outer.Name = "ZombieHitbox_Outer"
        outer.Size = Vector3.new(HITBOX.zombieSize, HITBOX.zombieSize, HITBOX.zombieSize)
        outer.Transparency = HITBOX.zombieTransparency; outer.CanCollide = false; outer.CanTouch = true; outer.CanQuery = true; outer.CanQuery = true
        outer.Massless = true; outer.Anchored = false; outer.CFrame = hrp.CFrame
        outer.Parent = z
        local wo = Instance.new("WeldConstraint"); wo.Part0 = hrp; wo.Part1 = outer; wo.Parent = outer
        local hb = Instance.new("Part")
        hb.Name = "ZombieHitbox_Head"
        hb.Size = Vector3.new(HITBOX.zombieSize/2, HITBOX.zombieSize/2, HITBOX.zombieSize/2)
        hb.Transparency = HITBOX.zombieTransparency; hb.CanCollide = false; hb.CanTouch = true; hb.CanQuery = true; hb.CanQuery = true
        hb.Massless = true; hb.Anchored = false; hb.CFrame = head.CFrame
        hb.Parent = z
        local wh = Instance.new("WeldConstraint"); wh.Part0 = head; wh.Part1 = hb; wh.Parent = hb
        HITBOX.zombieAdded[z] = { outer = outer, head = hb }
    end

    local function _removeZombieHitbox(z)
        local parts = HITBOX.zombieAdded[z]
        if parts then
            if parts.outer then pcall(function() parts.outer:Destroy() end) end
            if parts.head then pcall(function() parts.head:Destroy() end) end
            HITBOX.zombieAdded[z] = nil
        else
            for _, c in ipairs(z:GetChildren()) do
                if c.Name == "ZombieHitbox_Outer" or c.Name == "ZombieHitbox_Head" then
                    pcall(function() c:Destroy() end)
                end
            end
        end
    end

    local function _refreshZombieHitboxes()
        if not HITBOX.zombieEnabled then
            for z, _ in pairs(HITBOX.zombieAdded) do _removeZombieHitbox(z) end
            HITBOX.zombieAdded = {}; return
        end
        local all = {}
        local zf = workspace:FindFirstChild("Zombies")
        if zf then for _, z in ipairs(zf:GetChildren()) do if z:IsA("Model") and z.Name == "m_Zombie" then table.insert(all, z) end end end
        local cf = workspace:FindFirstChild("Camera")
        if cf then for _, z in ipairs(cf:GetChildren()) do if z:IsA("Model") and z.Name == "m_Zombie" then table.insert(all, z) end end end
        local gone = {}
        for z, _ in pairs(HITBOX.zombieAdded) do
            local found = false
            for _, z2 in ipairs(all) do if z2 == z then found = true; break end end
            if not found then table.insert(gone, z) end
        end
        for _, z in ipairs(gone) do _removeZombieHitbox(z) end
        for _, z in ipairs(all) do
            if not HITBOX.zombieAdded[z] then _addZombieHitbox(z) end
        end
    end

    local function _updateAllZombieHitboxSizes()
        if not HITBOX.zombieEnabled then return end
        for _, parts in pairs(HITBOX.zombieAdded) do
            if parts.outer and parts.outer.Parent then parts.outer.Size = Vector3.new(HITBOX.zombieSize, HITBOX.zombieSize, HITBOX.zombieSize) end
            if parts.head and parts.head.Parent then parts.head.Size = Vector3.new(HITBOX.zombieSize/2, HITBOX.zombieSize/2, HITBOX.zombieSize/2) end
        end
    end

    function KILL.toggleZombieHitbox(state)
        HITBOX.zombieEnabled = state
        if state then _refreshZombieHitboxes() else _refreshZombieHitboxes() end
    end
    function KILL.setZombieHitboxSize(v) HITBOX.zombieSize = v; if HITBOX.zombieEnabled then _updateAllZombieHitboxSizes(); _refreshZombieHitboxes() end end

    -- 僵尸新增事件（实时添加碰撞箱）
    local function _onZombieAdded(z)
        if HITBOX.zombieEnabled and z:IsA("Model") and z.Name == "m_Zombie" then
            task.wait(0.1)
            _addZombieHitbox(z)
        end
    end
    local zf = workspace:FindFirstChild("Zombies")
    if zf then zf.ChildAdded:Connect(_onZombieAdded) end
    local cf = workspace:FindFirstChild("Camera")
    if cf then cf.ChildAdded:Connect(_onZombieAdded) end



    

    -- ===== PVP 功能（直接移植自 Skin HUB v3.6） =====
    PVP = {}
    PVP.teleport = { enabled = false, heightOffset = 4, target = nil, highlight = nil, thread = nil }
    PVP.bayonetActive = false
    PVP.meleeActive = false
    PVP.heartbeatConn = nil
    PVP.attackedBayonet = {}
    PVP.attackedMelee = {}
    PVP.bayonetRange = 17
    PVP.meleeRange = 45

    -- _isEnemy already defined above (line ~6205)

    function PVP._getMusket()
        local c = lp.Character
        if not c then return nil end
        for _, t in pairs(c:GetChildren()) do
            if t:IsA("Tool") and t.Name == "Musket" then return t end
        end
        return nil
    end

    function PVP._getMeleeWeapon()
        local c = lp.Character
        if not c then return nil end
        for _, t in pairs(c:GetChildren()) do
            if t:IsA("Tool") and t:FindFirstChild("RemoteEvent") and t.Name ~= "Musket" then return t end
        end
        for _, t in pairs(lp.Backpack:GetChildren()) do
            if t:IsA("Tool") and t:FindFirstChild("RemoteEvent") and t.Name ~= "Musket" then return t end
        end
        return nil
    end

    function PVP._isValidTarget(p, root, range)
        if not p or p == lp then return false end
        if not _isEnemy(p) then return false end
        local c = p.Character
        if not c then return false end
        local hu = c:FindFirstChildOfClass("Humanoid")
        if not hu or hu.Health <= 0 then return false end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local dx = math.abs(hrp.Position.X - root.Position.X)
        local dz = math.abs(hrp.Position.Z - root.Position.Z)
        return dx <= range and dz <= range
    end

    function PVP._getClosestBayonetTarget(root)
        local best, bestD = nil, math.huge
        for _, pl in ipairs(Players:GetPlayers()) do
            if PVP._isValidTarget(pl, root, PVP.bayonetRange) and not PVP.attackedBayonet[pl] then
                local c = pl.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dx = hrp.Position.X - root.Position.X; local dz = hrp.Position.Z - root.Position.Z
                    local d = dx*dx + dz*dz
                    if d < bestD then bestD = d; best = pl end
                end
            end
        end
        return best
    end

    function PVP._getClosestMeleeTarget(root)
        local best, bestD = nil, math.huge
        for _, pl in ipairs(Players:GetPlayers()) do
            if PVP._isValidTarget(pl, root, PVP.meleeRange) and not PVP.attackedMelee[pl] then
                local c = pl.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dx = hrp.Position.X - root.Position.X; local dz = hrp.Position.Z - root.Position.Z
                    local d = dx*dx + dz*dz
                    if d < bestD then bestD = d; best = pl end
                end
            end
        end
        return best
    end

    function PVP._attackBayonet(p)
        local musket = PVP._getMusket()
        if not musket then return end
        local remote = musket:FindFirstChild("RemoteEvent")
        if not remote then return end
        local c = p.Character; if not c then return end
        local head = c:FindFirstChild("Head"); local hu = c:FindFirstChildOfClass("Humanoid")
        if not head or not hu then return end
        remote:FireServer("ThrustBayonet")
        remote:FireServer("Bayonet_HitPlayer", hu, head.Position)
    end

    function PVP._attackMelee(p)
        local weapon = PVP._getMeleeWeapon()
        if not weapon then return end
        local remote = weapon:FindFirstChild("RemoteEvent")
        if not remote then return end
        local c = p.Character; if not c then return end
        local head = c:FindFirstChild("Head"); local hu = c:FindFirstChildOfClass("Humanoid")
        if not head or not hu then return end

        if weapon.Name == "Axe" then
            if hu and hu.Health > 0 then
                remote:FireServer("BraceBlock")
                remote:FireServer("StopBraceBlock")
                remote:FireServer("FeedbackStun", p, head.Position)
            end
        end

        remote:FireServer("PrepareSwing")
        remote:FireServer("Swing", "Side")
        remote:FireServer("HitPlayer", hu, head.Position)
    end

    function PVP._cleanupBayonet(root)
        for t, _ in pairs(PVP.attackedBayonet) do
            if not PVP._isValidTarget(t, root, PVP.bayonetRange) then PVP.attackedBayonet[t] = nil end
        end
    end

    function PVP._cleanupMelee(root)
        for t, _ in pairs(PVP.attackedMelee) do
            if not PVP._isValidTarget(t, root, PVP.meleeRange) then PVP.attackedMelee[t] = nil end
        end
    end

    function PVP._onHeartbeat()
        local c = lp.Character; if not c then return end
        local hu = c:FindFirstChildOfClass("Humanoid"); if not hu or hu.Health <= 0 then return end
        local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end

        if PVP.bayonetActive then
            PVP._cleanupBayonet(root)
            local t = PVP._getClosestBayonetTarget(root)
            if t then PVP._attackBayonet(t); PVP.attackedBayonet[t] = true
            else PVP.attackedBayonet = {} end
        end

        if PVP.meleeActive then
            PVP._cleanupMelee(root)
            local t = PVP._getClosestMeleeTarget(root)
            if t then PVP._attackMelee(t); PVP.attackedMelee[t] = true
            else PVP.attackedMelee = {} end
        end
    end

    function PVP._updateHeartbeat()
        if PVP.bayonetActive or PVP.meleeActive then
            if not PVP.heartbeatConn then
                PVP.heartbeatConn = game:GetService("RunService").Heartbeat:Connect(PVP._onHeartbeat)
            end
        else
            if PVP.heartbeatConn then PVP.heartbeatConn:Disconnect(); PVP.heartbeatConn = nil end
        end
    end

    -- 传送至敌方头顶
    function PVP.toggleTeleport(state)
        if state then
            if PVP.teleport.thread then return end
            PVP.teleport.enabled = true
            PVP.teleport.target = nil
            if PVP.teleport.highlight then PVP.teleport.highlight:Destroy(); PVP.teleport.highlight = nil end
            PVP.teleport.thread = task.spawn(function()
                while PVP.teleport.enabled do
                    local c = lp.Character
                    if c then
                        local root = c:FindFirstChild("HumanoidRootPart")
                        if root then
                            -- validate current target
                            local t = PVP.teleport.target
                            if t then
                                local ok = false
                                if t.Character and t.Character:FindFirstChild("Head") and t.Character:FindFirstChild("HumanoidRootPart") then
                                    local hu = t.Character:FindFirstChildOfClass("Humanoid")
                                    if hu and hu.Health > 0 then
                                        local myTeam = _getPlayerTeam(lp)
                                        local theirTeam = _getPlayerTeam(t)
                                        if myTeam ~= theirTeam then ok = true end
                                    end
                                end
                                if not ok then
                                    if PVP.teleport.highlight then PVP.teleport.highlight:Destroy(); PVP.teleport.highlight = nil end
                                    PVP.teleport.target = nil
                                end
                            end
                            -- find new target
                            if not PVP.teleport.target then
                                local enemies = {}
                                local myTeam = _getPlayerTeam(lp)
                                for _, pl in ipairs(Players:GetPlayers()) do
                                    if pl ~= lp then
                                        local theirTeam = _getPlayerTeam(pl)
                                        if not myTeam or not theirTeam or myTeam ~= theirTeam then
                                            if pl.Character and pl.Character:FindFirstChild("Head") and pl.Character:FindFirstChild("HumanoidRootPart") then
                                                local hu = pl.Character:FindFirstChildOfClass("Humanoid")
                                                if hu and hu.Health > 0 then table.insert(enemies, pl) end
                                            end
                                        end
                                    end
                                end
                                if #enemies > 0 then
                                    table.sort(enemies, function(a, b)
                                        local aR = a.Character:FindFirstChild("HumanoidRootPart")
                                        local bR = b.Character:FindFirstChild("HumanoidRootPart")
                                        if not aR or not bR then return false end
                                        return (aR.Position - root.Position).Magnitude < (bR.Position - root.Position).Magnitude
                                    end)
                                    local best = enemies[1]
                                    PVP.teleport.target = best
                                    local hl = Instance.new("Highlight")
                                    hl.FillColor = Color3.fromRGB(0, 255, 0)
                                    hl.OutlineColor = Color3.fromRGB(0, 255, 0)
                                    hl.Adornee = best.Character; hl.Parent = best.Character
                                    PVP.teleport.highlight = hl
                                end
                            end
                            -- teleport
                            t = PVP.teleport.target
                            if t and t.Character then
                                local head = t.Character:FindFirstChild("Head")
                                if head then
                                    root.CFrame = CFrame.new(head.Position + Vector3.new(0, PVP.teleport.heightOffset, 0), head.Position)
                                end
                            end
                        end
                    end
                    task.wait()
                end
            end)
        else
            PVP.teleport.enabled = false
            if PVP.teleport.thread then task.cancel(PVP.teleport.thread); PVP.teleport.thread = nil end
            if PVP.teleport.highlight then PVP.teleport.highlight:Destroy(); PVP.teleport.highlight = nil end
            PVP.teleport.target = nil
        end
    end

    function PVP.toggleBayonet(state)
        PVP.bayonetActive = state
        if not state then PVP.attackedBayonet = {} end
        PVP._updateHeartbeat()
    end

    function PVP.toggleMelee(state)
        PVP.meleeActive = state
        if not state then PVP.attackedMelee = {} end
        PVP._updateHeartbeat()
    end

    -- 重生重置
    lp.CharacterAdded:Connect(function()
        PVP.attackedBayonet = {}
        PVP.attackedMelee = {}
    end)

-- ===== PVP自瞄 (完全重写 - 极简版) =====
    PVP = PVP or {}
    PVP.enabled = false
    PVP.aimPart = "Head"
    PVP.showFov = false
    PVP.fov = 90
    PVP.teamCheck = false
    PVP.prediction = false
    PVP.bulletSpeed = 200
    PVP.conn = nil

    -- 清理旧FOV圈
    for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name == "AimbotFOV" or v.Name:find("FOV") or v.Name:find("Aimbot")) then
            v:Destroy()
        end
    end
    local fovGui = Instance.new("ScreenGui")
    fovGui.Name = "AimbotFOV"
    fovGui.ResetOnSpawn = false
    fovGui.IgnoreGuiInset = true
    fovGui.Parent = game:GetService("CoreGui")

    local fovCircle = Instance.new("Frame")
    fovCircle.Name = "FOVCircle"
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    fovCircle.Size = UDim2.new(0, PVP.fov * 2, 0, PVP.fov * 2)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Visible = false
    fovCircle.ZIndex = 10
    fovCircle.Parent = fovGui

    local fovStroke = Instance.new("UIStroke")
    fovStroke.Thickness = 2
    fovStroke.Color = Color3.fromRGB(255, 0, 0)
    fovStroke.Parent = fovCircle

    local fovCorner = Instance.new("UICorner")
    fovCorner.CornerRadius = UDim.new(1, 0)
    fovCorner.Parent = fovCircle

    -- 墙体检测可视射线
    local wallLine = Drawing.new("Line")
    wallLine.Thickness = 2
    wallLine.Transparency = 1
    wallLine.Visible = false
    wallLine.Color = Color3.fromRGB(255, 0, 0)

    -- 找最近通畅目标（墙体检测内嵌）
    local function _findClear()
        local lp = game:GetService("Players").LocalPlayer
        local mc = lp.Character; if not mc then return nil end
        local mHead = mc:FindFirstChild("Head") or mc:FindFirstChild("HumanoidRootPart"); if not mHead then return nil end
        local cam = workspace.CurrentCamera
        local best, bestD = nil, math.huge
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p == lp then continue end
            local c = p.Character; if not c then continue end
            local hu = c:FindFirstChildOfClass("Humanoid"); if not hu or hu.Health <= 0 then continue end
            if PVP.teamCheck and p.Team == lp.Team then continue end
            local pt = c:FindFirstChild(PVP.aimPart) or c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
            if not pt then continue end
            if (pt.Position - cam.CFrame.Position).Magnitude > 1000 then continue end
            local pos, on = cam:WorldToViewportPoint(pt.Position); if not on then continue end
            local d2 = (Vector2.new(pos.X, pos.Y) - cam.ViewportSize/2).Magnitude
            if d2 > PVP.fov or d2 >= bestD then continue end
            -- 墙体检测
            local rp = RaycastParams.new()
            rp.FilterType = Enum.RaycastFilterType.Blacklist
            rp.FilterDescendantsInstances = {mc, c}
            if workspace:Raycast(mHead.Position, pt.Position - mHead.Position, rp) then continue end
            bestD = d2; best = p
        end
        return best
    end

    -- 找最近被挡目标（仅用于画红线）
    local function _findBlocked()
        local lp = game:GetService("Players").LocalPlayer
        local mc = lp.Character; if not mc then return nil end
        local mHead = mc:FindFirstChild("Head") or mc:FindFirstChild("HumanoidRootPart"); if not mHead then return nil end
        local cam = workspace.CurrentCamera
        local best, bestD = nil, math.huge
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p == lp then continue end
            local c = p.Character; if not c then continue end
            local hu = c:FindFirstChildOfClass("Humanoid"); if not hu or hu.Health <= 0 then continue end
            if PVP.teamCheck and p.Team == lp.Team then continue end
            local pt = c:FindFirstChild(PVP.aimPart) or c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
            if not pt then continue end
            if (pt.Position - cam.CFrame.Position).Magnitude > 1000 then continue end
            local pos, on = cam:WorldToViewportPoint(pt.Position); if not on then continue end
            local d2 = (Vector2.new(pos.X, pos.Y) - cam.ViewportSize/2).Magnitude
            if d2 > PVP.fov or d2 >= bestD then continue end
            -- 墙体检测：必须是挡住的
            local rp = RaycastParams.new()
            rp.FilterType = Enum.RaycastFilterType.Blacklist
            rp.FilterDescendantsInstances = {mc, c}
            if not workspace:Raycast(mHead.Position, pt.Position - mHead.Position, rp) then continue end
            bestD = d2; best = p
        end
        return best
    end

    local function _drawLine(targetChar, color)
        if not targetChar then return end
        local lp = game:GetService("Players").LocalPlayer
        local mc = lp.Character; if not mc then return end
        local sp = mc:FindFirstChild("Head") or mc:FindFirstChild("HumanoidRootPart"); if not sp then return end
        local pt = targetChar:FindFirstChild(PVP.aimPart) or targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart"); if not pt then return end
        local cam = workspace.CurrentCamera
        local s, _ = cam:WorldToViewportPoint(sp.Position)
        local e, _ = cam:WorldToViewportPoint(pt.Position)
        wallLine.From = Vector2.new(s.X, s.Y)
        wallLine.To = Vector2.new(e.X, e.Y)
        wallLine.Visible = true
        wallLine.Color = color
    end

    local function _start()
        if PVP.conn then return end
        PVP.conn = game:GetService("RunService").RenderStepped:Connect(function()
            fovCircle.Size = UDim2.new(0, PVP.fov * 2, 0, PVP.fov * 2)
            fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
            fovCircle.Visible = PVP.enabled and PVP.showFov
            if not PVP.enabled then return end
            local t = _findClear()
            if t and t.Character then
                _drawLine(t.Character, Color3.fromRGB(0, 255, 0))
                local pt = t.Character:FindFirstChild(PVP.aimPart) or t.Character:FindFirstChild("Head") or t.Character:FindFirstChild("HumanoidRootPart")
                if pt then
                    local aimPos = pt.Position
                    if PVP.prediction and PVP.bulletSpeed > 0 then
                        local hrp = t.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local cam = workspace.CurrentCamera
                            local dist = (pt.Position - cam.CFrame.Position).Magnitude
                            local travelTime = dist / PVP.bulletSpeed
                            aimPos = pt.Position + (hrp.Velocity * travelTime)
                        end
                    end
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, aimPos)
                end
            else
                local bt = _findBlocked()
                if bt and bt.Character then
                    _drawLine(bt.Character, Color3.fromRGB(255, 0, 0))
                else
                    wallLine.Visible = false
                end
            end
        end)
    end

    local function _stop()
        if PVP.conn then PVP.conn:Disconnect(); PVP.conn = nil end
        fovCircle.Visible = false
        wallLine.Visible = false
    end

    function PVP.toggle(state)
        PVP.enabled = state
        if state then _start() else _stop() end
    end

    function PVP.setAimPart(v)
        if v == "body" then PVP.aimPart = "HumanoidRootPart" else PVP.aimPart = "Head" end
    end

    function PVP.toggleFOV(state)
        PVP.showFov = state
        fovCircle.Visible = PVP.enabled and state
    end

    function PVP.setFOV(v) PVP.fov = v end
    function PVP.toggleTeamCheck(state) PVP.teamCheck = state end
    function PVP.togglePrediction(state) PVP.prediction = state end
    function PVP.setBulletSpeed(v) PVP.bulletSpeed = v end

    -- 死亡时关闭自瞄，重生时自动开启
    local lp = game:GetService("Players").LocalPlayer
    local _wasOn = false
    lp.CharacterRemoving:Connect(function()
        if PVP.enabled then _wasOn = true; PVP.toggle(false) end
    end)
    lp.CharacterAdded:Connect(function()
        if _wasOn then task.wait(0.5); _wasOn = false; PVP.toggle(true) end
    end)
    _G.BanFengHeUIFramework = {
        AppConfig = AppConfig,
        Theme = Theme,
        UI = UI,
        Components = Components,
        Registry = Registry,
        Pages = Pages,
        State = State,
    }

    UI.Build()

    -- Auto-load
    local autoOk, autoName = ConfigManager:ReadAutoLoad()
    if autoOk and autoName and autoName ~= "" then
        local name = autoName:match("^%s*(.-)%s*$")
        task.delay(0.5, function()
            ConfigManager:LoadConfig(name)
            ConfigManager:RefreshDropdown()
            local ctrl = State.Controls["config.dropdown.select"]
            if ctrl and ctrl.SetValue then pcall(ctrl.SetValue, ctrl, name, true) end
            if State.Toggles["config.toggle.autosave"] then
                State.Toggles["config.toggle.autosave"] = false
                local ac = State.Controls["config.toggle.autosave"]
                if ac and ac.SetValue then pcall(ac.SetValue, ac, false, true) end
            end
            ConfigManager.CurrentName = name
            State:AddLog("log", 'Loaded: ' .. name, "autoload")
        end)
    end

    

    -- ===== 通用功能（直接移植 Skin HUB ，已验证有效） =====
    FEATURES = {}
-- ==================== 强制第三人称功能（缩放上限200） ====================
do
    local thirdPersonEnabled = false
    local thirdPersonConn = nil
    local lp = game:GetService("Players").LocalPlayer

    local function applyThirdPerson()
        pcall(function()
            if lp.CameraMode ~= Enum.CameraMode.Classic then
                lp.CameraMode = Enum.CameraMode.Classic
            end
            lp.CameraMinZoomDistance = 0.5
            lp.CameraMaxZoomDistance = 200
        end)
    end

    local function enableThirdPerson()
        if thirdPersonConn then return end
        thirdPersonEnabled = true
        applyThirdPerson()
        thirdPersonConn = game:GetService("RunService").RenderStepped:Connect(function()
            if not thirdPersonEnabled then return end
            applyThirdPerson()
        end)
    end

    local function disableThirdPerson()
        thirdPersonEnabled = false
        if thirdPersonConn then
            thirdPersonConn:Disconnect()
            thirdPersonConn = nil
        end
    end

    lp.CharacterAdded:Connect(function()
        task.wait(0.5)
        if thirdPersonEnabled then applyThirdPerson() end
    end)

    if not FEATURES then FEATURES = {} end
    function FEATURES.toggleThirdPerson(state)
        if state then enableThirdPerson() else disableThirdPerson() end
    end
end

-- ==================== 显示其他玩家感染值 ====================
do
    local infectionEnabled = false
    local infectionBillboards = {}
    local infectionUpdateConn = nil
    local infectionPlayerAddedConn = nil
    local infectionPlayerRemovingConn = nil
    local lp = game:GetService("Players").LocalPlayer
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local function getInfectionForPlayer(player)
        if not player then return 0 end
        local infection = 0
        pcall(function()
            local wsPlayers = workspace:FindFirstChild("Players")
            if wsPlayers then
                local folder = wsPlayers:FindFirstChild(player.Name)
                if folder and folder:FindFirstChild("UserStates") then
                    local val = folder.UserStates:FindFirstChild("Infected")
                    if val then infection = tonumber(val.Value) or 0; return end
                end
            end
            if player:FindFirstChild("UserStates") then
                local val = player.UserStates:FindFirstChild("Infected")
                if val then infection = tonumber(val.Value) or 0 end
            end
        end)
        return infection
    end

    local function createInfectionUI(player)
        if not player or player == lp then return nil end
        local char = player.Character
        if not char then return nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil end
        if infectionBillboards[player] then
            infectionBillboards[player]:Destroy()
            infectionBillboards[player] = nil
        end
        local bill = Instance.new("BillboardGui")
        bill.Name = "PlayerInfectionDisplay"
        bill.Size = UDim2.new(0, 100, 0, 20)
        bill.StudsOffset = Vector3.new(-2.5, 0.5, 0)
        bill.AlwaysOnTop = true
        bill.MaxDistance = 150
        bill.Adornee = head
        bill.Parent = char
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "感染: 0%"
        label.TextColor3 = Color3.fromRGB(255, 200, 0)
        label.TextSize = 11
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0.2
        label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        label.Parent = bill
        infectionBillboards[player] = bill
        return bill
    end

    local function removeInfectionUI(player)
        local bill = infectionBillboards[player]
        if bill then bill:Destroy() end
        infectionBillboards[player] = nil
    end

    local function updateAllInfection()
        if not infectionEnabled then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player == lp then continue end
            local char = player.Character
            if not char or not char.Parent then
                removeInfectionUI(player)
                continue
            end
            local head = char:FindFirstChild("Head")
            if not head then
                removeInfectionUI(player)
                continue
            end
            local bill = infectionBillboards[player]
            if not bill or not bill.Parent then
                bill = createInfectionUI(player)
            end
            if bill then
                local infection = getInfectionForPlayer(player)
                local label = bill:FindFirstChildOfClass("TextLabel")
                if label then
                    label.Text = string.format("感染: %d%%", infection)
                    if infection >= 70 then
                        label.TextColor3 = Color3.fromRGB(255, 50, 50)
                    elseif infection >= 30 then
                        label.TextColor3 = Color3.fromRGB(255, 200, 0)
                    else
                        label.TextColor3 = Color3.fromRGB(0, 255, 0)
                    end
                end
                if bill.Adornee ~= head then bill.Adornee = head end
            end
        end
        for player, _ in pairs(infectionBillboards) do
            if not player or not player.Parent then removeInfectionUI(player) end
        end
    end

    local function startInfectionUpdating()
        if infectionUpdateConn then return end
        infectionUpdateConn = RunService.RenderStepped:Connect(updateAllInfection)
        infectionPlayerAddedConn = Players.PlayerAdded:Connect(function(pl)
            if infectionEnabled and pl ~= lp then
                task.wait(0.5)
                createInfectionUI(pl)
            end
        end)
        infectionPlayerRemovingConn = Players.PlayerRemoving:Connect(removeInfectionUI)
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= lp then createInfectionUI(pl) end
        end
    end

    local function stopInfectionUpdating()
        if infectionUpdateConn then
            infectionUpdateConn:Disconnect()
            infectionUpdateConn = nil
        end
        if infectionPlayerAddedConn then
            infectionPlayerAddedConn:Disconnect()
            infectionPlayerAddedConn = nil
        end
        if infectionPlayerRemovingConn then
            infectionPlayerRemovingConn:Disconnect()
            infectionPlayerRemovingConn = nil
        end
        for _, bill in pairs(infectionBillboards) do
            if bill then bill:Destroy() end
        end
        infectionBillboards = {}
    end

    if not FEATURES then FEATURES = {} end
    function FEATURES.togglePlayerInfection(state)
        infectionEnabled = state
        if state then
            startInfectionUpdating()
        else
            stopInfectionUpdating()
        end
    end
end

    FEATURES._th = {}
    FEATURES._vals = { flySpeed=45, walkSpeed=25, coordSpeed=16, jumpHeight=60, autoJumpHeight=60 }

    -- 坐标加速（原版：Heartbeat + dt）
    do
        local _enabled = false; local _conn = nil; local _val = 16
        function FEATURES.toggleCoordSpeed(s)
            _enabled = s
            if s then
                if not _conn then
                    _conn = game:GetService("RunService").Heartbeat:Connect(function(dt)
                        if not _enabled then return end
                        local c = lp.Character; if not c then return end
                        local h = c:FindFirstChild("HumanoidRootPart"); local hu = c:FindFirstChildOfClass("Humanoid")
                        if not h or not hu then return end
                        local md = hu.MoveDirection
                        if md.Magnitude > 0 then h.CFrame = h.CFrame + md.Unit * _val * dt end
                    end)
                end
            else
                if _conn then _conn:Disconnect(); _conn = nil end
            end
        end
        function FEATURES.setCoordSpeed(v) _val = math.clamp(v, 1, 35) end
    end

    -- 速度调整（原版：心跳锁定 + WalkSpeed变化监听）
    do
        local _enabled = false; local _speed = 25; local _conn = nil; local _propConns = {}
        function FEATURES.toggleSpeed(s)
            _enabled = s
            if s then
                if not _conn then
                    _conn = game:GetService("RunService").Heartbeat:Connect(function()
                        if not _enabled then return end
                        local c = lp.Character; if not c then return end
                        local hu = c:FindFirstChildOfClass("Humanoid")
                        if hu then pcall(function() hu.WalkSpeed = _speed end)
                            if not _propConns[hu] then
                                local conn
                                conn = hu:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                                    if _enabled and hu and hu.Parent then pcall(function() hu.WalkSpeed = _speed end) end
                                end)
                                _propConns[hu] = conn
                            end
                        end
                    end)
                end
            else
                if _conn then _conn:Disconnect(); _conn = nil end
                for _, c in pairs(_propConns) do pcall(function() c:Disconnect() end) end
                _propConns = {}
                local c = lp.Character; if c then local hu = c:FindFirstChildOfClass("Humanoid")
                    if hu then pcall(function() hu.WalkSpeed = 16 end) end end
            end
        end
        function FEATURES.setPlayerSpeed(v) _speed = math.clamp(v, 1, 45) end
    end

    -- 飞行（飞行不拉回GB.lua 逐行移植）
    do
        local _isFlying = false; local _flySpeed = 45
        local _bv = nil; local _bg = nil; local _animCache = nil
        local _loopThread = nil
        local _ctrl = require(lp.PlayerScripts:WaitForChild("PlayerModule")):GetControls()

        local function _startFly()
            local char = lp.Character or lp.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            local hum = char:WaitForChild("Humanoid", 5)
            local animate = char:FindFirstChild("Animate")
            if animate then _animCache = animate; animate.Parent = nil end

            _bv = Instance.new("BodyVelocity", hrp)
            _bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            _bg = Instance.new("BodyGyro", hrp)
            _bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
            _bg.P = 8000

            _loopThread = task.spawn(function()
                while _isFlying and char.Parent do
                    local moveVec = _ctrl:GetMoveVector()
                    local camCF = workspace.CurrentCamera.CFrame
                    local moveDir = (camCF.LookVector * -moveVec.Z) + (camCF.RightVector * moveVec.X)
                    if moveVec.Magnitude > 0 then
                        _bv.Velocity = moveDir.Unit * _flySpeed
                        _bg.CFrame = CFrame.new(Vector3.zero, moveDir)
                    else
                        _bv.Velocity = Vector3.new(0, 0.01, 0)
                        _bg.CFrame = CFrame.new(Vector3.zero, Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z))
                    end
                    hum:ChangeState(Enum.HumanoidStateType.Climbing)
                    game:GetService("RunService").RenderStepped:Wait()
                end
                if _animCache then _animCache.Parent = char end
                if _bv then _bv:Destroy() end
                if _bg then _bg:Destroy() end
            end)
        end

        function FEATURES.toggleFly(s)
            _isFlying = s
            if s then _startFly() end
        end

        function FEATURES.setFlySpeed(v) _flySpeed = math.clamp(v, 10, 60) end
    end

    -- ===== 地图自动功能（全部移植 Skin HUB ） =====
    -- 1. 自动挖雪
    do
        local _active = false; local _th = nil
        local _DIG_PATHS = { "Vardohus Fortress/Modes/Objective/DoorSnow/Diggable", "Vardohus Fortress/Modes/Objective/Diggable", "OLD Vardohus Fortress/Modes/Objective/DigSnow/Diggable" }
        local function _findDiggable()
            for _, p in ipairs(_DIG_PATHS) do
                local cur = workspace
                for _, n in ipairs(p:split("/")) do cur = cur:FindFirstChild(n); if not cur then break end end
                if cur then return cur end
            end
        end
        local function _getDigTool()
            local c = lp.Character; if not c then return nil end
            for _, t in ipairs(c:GetChildren()) do if (t.Name=="Shovel"or t.Name=="Spade") and t:FindFirstChild("RemoteEvent") then return t end end
            for _, t in ipairs(lp.Backpack:GetChildren()) do if (t.Name=="Shovel"or t.Name=="Spade") and t:FindFirstChild("RemoteEvent") then return t end end
        end
        local function _digLoop()
            while _active do
                local d = _findDiggable(); local t = _getDigTool()
                if d and t then
                    if t.Parent ~= lp.Character then t.Parent = lp.Character; task.wait(0.2) end
                    local re = t:FindFirstChild("RemoteEvent")
                    if re then re:FireServer("Dig", d, d.Position) end
                end
                task.wait(0.05)
            end
        end
        function FEATURES.toggleAutoDig(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_digLoop)
            else if _londonThread then task.cancel(_londonThread); _londonThread = nil end end
        end
    end

    -- 2. 自动开门（无延迟版）
    do
        local _active = false; local _th = nil; local _processing = {}
        local function _doorLoop()
            while _active do
                local c = lp.Character; local r = c and c:FindFirstChild("HumanoidRootPart")
                if r then
                    for _, item in ipairs(workspace:GetDescendants()) do
                        if item.Name == "Main" and item:IsA("Model") and not _processing[item] then
                            if (r.Position - item:GetModelCFrame().Position).Magnitude <= 23 then
                                local isOpen = item:GetAttribute("Open")
                                if isOpen == nil then pcall(function() isOpen = item.Open end) end
                                if isOpen == false then
                                    local mp = item:FindFirstChild("Main"); local re = mp and mp:FindFirstChild("Interact")
                                    if re and re:IsA("RemoteEvent") then
                                        _processing[item] = true
                                        task.spawn(function() re:FireServer(); task.wait(0.1); _processing[item] = nil end)
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end
        function FEATURES.toggleAutoDoor(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_doorLoop)
            else if _th then task.cancel(_th); _th = nil end; _processing = {} end
        end
    end

    -- 3. 自动收集
    do
        local _active = false; local _th = nil; local _prompts = {}; local _conn = nil
        local function _setup()
            _prompts = {}
            for _, d in ipairs(workspace:GetDescendants()) do if d:IsA("ProximityPrompt") then _prompts[d] = true end end
            if _conn then _conn:Disconnect() end
            _conn = workspace.DescendantAdded:Connect(function(d) if d:IsA("ProximityPrompt") then _prompts[d] = true end end)
        end
        local function _collectLoop()
            while _active do
                local c = lp.Character; local r = c and c:FindFirstChild("HumanoidRootPart")
                if r then
                    for p in pairs(_prompts) do
                        if p and p.Parent and p:IsA("ProximityPrompt") and p.Enabled then
                            local part = p.Parent
                            if part:IsA("BasePart") and (part.Position - r.Position).Magnitude <= p.MaxActivationDistance then
                                fireproximityprompt(p)
                            end
                        else _prompts[p] = nil end
                    end
                end
                task.wait(0.1)
            end
        end
        function FEATURES.toggleAutoCollect(s)
            _active = s
            if s then _setup(); if _th then task.cancel(_th) end; _th = task.spawn(_collectLoop)
            else if _th then task.cancel(_th); _th = nil end; if _conn then _conn:Disconnect(); _conn = nil end end
        end
    end

    -- 4. 自动装填大炮
    do
        local _active = false; local _conn = nil; local _lastTime = 0
        local function _findGun()
            local c = lp.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); if not r then return nil end
            local best, bestD = nil, math.huge
            for _, g in ipairs(workspace:GetDescendants()) do
                if g.Name == "12 Pound Gun" and g:IsA("Model") then
                    local hole = g:FindFirstChild("Gun") and g.Gun:FindFirstChild("Hole")
                    if hole then local d = (hole.Position - r.Position).Magnitude; if d < bestD then bestD = d; best = g end end
                end
            end
            return best
        end
        local function _reload()
            local now = tick(); if now - _lastTime < 0.5 then return end
            local gun = _findGun()
            if gun then
                local interact = gun:FindFirstChild("Gun") and gun.Gun:FindFirstChild("Hole") and gun.Gun.Hole:FindFirstChild("Interact")
                if interact and interact:IsA("RemoteEvent") then interact:FireServer(); _lastTime = now end
            end
        end
        function FEATURES.toggleAutoCannon(s)
            _active = s
            if s then if _conn then _conn:Disconnect() end; _conn = game:GetService("RunService").Heartbeat:Connect(_reload)
            else if _conn then _conn:Disconnect(); _conn = nil end end
        end
    end

    -- 5. 自动砸砖（巴黎地下墓穴）
    do
        local _active = false; local _th = nil
        local _cachedMap, _cachedWall, _cachedBricks, _lastRefresh = nil, nil, nil, 0
        local function _getTool()
            local c = lp.Character; if not c then return nil end
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and t:FindFirstChild("RemoteEvent") then
                    local n = t.Name:lower()
                    if n:find("斧") or n:find("锤") or n:find("axe") or n:find("hammer") or n:find("sledge") or n:find("pickaxe") then
                        return t:FindFirstChild("RemoteEvent")
                    end
                end
            end
        end
        local function _getBricks()
            local now = tick()
            if now - _lastRefresh < 1 and _cachedWall then return _cachedBricks or {}, _cachedWall end
            _lastRefresh = now
            if not _cachedMap or not _cachedMap.Parent then
                _cachedMap = workspace:FindFirstChild("Catacombes de Paris")
                if not _cachedMap then for _, v in ipairs(workspace:GetChildren()) do if v.Name:lower():find("catacomb") then _cachedMap = v; break end end end
            end
            if not _cachedMap then return {}, nil end
            local wall = _cachedMap:FindFirstChild("Modes") and _cachedMap.Modes:FindFirstChild("Objective") and _cachedMap.Modes.Objective:FindFirstChild("brickwall")
            if not wall then return {}, nil end
            local bricks = {}
            for _, ch in ipairs(wall:GetChildren()) do if ch:IsA("BasePart") then bricks[#bricks+1] = ch end end
            _cachedBricks = bricks; _cachedWall = wall; return bricks, wall
        end
        local function _breakOnce()
            local ev = _getTool(); if not ev then return end
            local bricks, wall = _getBricks(); if not wall or #bricks == 0 then return end
            local c = lp.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); if not r then return end
            if (r.Position - wall:GetPivot().Position).Magnitude > 10 then return end
            pcall(function() ev:FireServer("Swing", "Over") end)
            local dir = Vector3.new(0.97238314151764, 0, -0.23338980972767)
            for i = 1, #bricks, 25 do
                for j = i, math.min(i+24, #bricks) do pcall(function() ev:FireServer("HitBreakable", {bricks[j]}, dir) end) end
                task.wait(0.1)
            end
        end
        local function _brickLoop()
            while _active do _breakOnce(); task.wait(0.3) end
        end
        function FEATURES.toggleAutoBrick(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_brickLoop)
            else if _th then task.cancel(_th); _th = nil end; _cachedMap=nil; _cachedWall=nil; _cachedBricks=nil end
        end
    end

    -- 6. 自动打酒桶（伦敦）
    do
        local _active = false; local _th = nil
        local _zones = {
            { center=Vector3.new(119.068,12.912,-49.648), radius=12, attacks={{wait=0.1,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Over"},{wait=0.1,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Under"}} },
            { center=Vector3.new(131.407,12.912,-52.442), radius=12, attacks={{wait=0.1,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Over"},{wait=0.1,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Under"}} },
            { center=Vector3.new(143.765,12.912,-49.364), radius=12, attacks={{wait=0.1,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Over"},{wait=0.1,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Under"}} },
            { center=Vector3.new(155.114,12.912,-45.748), radius=12, attacks={{wait=0.1,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Over"},{wait=0.1,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Over"},{wait=0.05,event="Swing",arg="Under"}} },
        }
        local function _getWeapon()
            local c = lp.Character; if not c then return nil end
            for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t:FindFirstChild("RemoteEvent") then return t:FindFirstChild("RemoteEvent") end end
        end
        local function _getEvt()
            local rs = game:GetService("ReplicatedStorage")
            local e = rs:FindFirstChild("Events"); if not e then return nil end
            local wi = e:FindFirstChild("WeaponHitEvent"); if wi then return wi end
            local wh = e:FindFirstChild("WeaponHit"); if wh then return wh end
        end
        local function _barrelLoop()
            while _active do
                local c = lp.Character; local r = c and c:FindFirstChild("HumanoidRootPart")
                if r then
                    local cz = nil
                    for _, z in ipairs(_zones) do if (r.Position - z.center).Magnitude <= z.radius then cz = z; break end end
                    if cz then
                        local we = _getWeapon(); local ev = _getEvt()
                        if we then
                            for _, atk in ipairs(cz.attacks) do
                                if not _active then break end
                                pcall(function() we:FireServer(atk.event, atk.arg) end)
                                task.wait(atk.wait)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end
        function FEATURES.toggleAutoBarrel(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_barrelLoop)
            else if _th then task.cancel(_th); _th = nil end end
        end
    end

    -- 7. 自动打威斯特敏障碍（ 完整攻击: PrepareSwing→Swing→HitCon）
    do
        local _active = false; local _th = nil
        local _ATK_INT = 0.1; local _ATK_RANGE = 15

        local function _getTargets()
            local w = workspace:FindFirstChild("Westminster")
            if not w then return {} end
            local m = w:FindFirstChild("Modes"); if not m then return {} end
            local o = m:FindFirstChild("Objective"); if not o then return {} end
            local b = o:FindFirstChild("StreetBarricade"); if not b then return {} end
            local mo = b:FindFirstChild("Model"); if not mo then return {} end
            local bb = mo:FindFirstChild("BoundingBox"); if not bb then return {} end
            local parts = {}
            if bb:IsA("BasePart") then parts[#parts+1] = bb end
            local kids = bb:GetDescendants()
            for i = 1, #kids do if kids[i]:IsA("BasePart") then parts[#parts+1] = kids[i] end end
            return parts
        end

        local function _getWeapon()
            if not lp.Character then return nil, nil end
            local tools = lp.Character:GetChildren()
            for i = 1, #tools do
                if tools[i]:IsA("Tool") then
                    local re = tools[i]:FindFirstChild("RemoteEvent")
                    if re then return re, tools[i] end
                end
            end
            return nil, nil
        end

        local function _attack(remote, target, hitPos, normal)
            if not remote then return end
            remote:FireServer("PrepareSwing")
            task.wait(0.02)
            remote:FireServer("Swing", "Side")
            task.wait(0.02)
            remote:FireServer("HitCon", target, hitPos, normal)
        end

        local function _loop()
            while _active do
                local re, wp = _getWeapon()
                if re and wp and lp.Character then
                    local r = lp.Character:FindFirstChild("HumanoidRootPart")
                    if r then
                        local parts = _getTargets()
                        local best, bestD = nil, _ATK_RANGE + 1
                        for i = 1, #parts do
                            local d = (parts[i].Position - r.Position).Magnitude
                            if d < bestD then bestD = d; best = parts[i] end
                        end
                        if best and bestD <= _ATK_RANGE then
                            local hitPos = best.Position
                            local normal = (r.Position - hitPos).Unit
                            _attack(re, best, hitPos, normal)
                        end
                    end
                end
                task.wait(_ATK_INT)
            end
        end

        function FEATURES.toggleAutoWestminster(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_loop)
            else if _th then task.cancel(_th); _th = nil end end
        end
    end    -- 8. 自动打莱比锡木板
    do
        local _active = false; local _th = nil; local _ATK_INT = 0.3
        local function _getTarget()
            local l = workspace:FindFirstChild("Leipzig"); if not l then return nil end
            local m = l:FindFirstChild("Modes"); if not m then return nil end
            local o = m:FindFirstChild("Objective"); if not o then return nil end
            local b = o:FindFirstChild("Barricade"); if not b then return nil end
            return b:FindFirstChild("Hitbox")
        end
        local function _getWeapon()
            local c = lp.Character; if not c then return nil end
            for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local re = t:FindFirstChild("RemoteEvent"); if re then return re end end end
        end
        local function _leipzigLoop()
            while _active do
                local re = _getWeapon(); local t = _getTarget()
                if re and t then
                    local hitPos = Vector3.new(-154.15071105957, -6.2045636177063, -95.362197875977)
                    local normal = Vector3.new(0.25880479812622, 0, 0.96592962741852)
                    re:FireServer("HitCon", t, hitPos, normal)
                end
                task.wait(_ATK_INT)
            end
        end
        function FEATURES.toggleAutoLeipzigBarricade(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_leipzigLoop)
            else if _th then task.cancel(_th); _th = nil end end
        end
    end

    -- 9. 自动打哥本哈根锁（ 完整攻击: PrepareSwing→Swing(Thrust)→HitCon）
    do
        local _active = false; local _th = nil; local _ATK_RANGE = 5; local _ATK_INT = 0.2
        local function _getTarget()
            local c = workspace:FindFirstChild("Copenhagen"); if not c then return nil end
            local m = c:FindFirstChild("Modes"); if not m then return nil end
            local o = m:FindFirstChild("Objective"); if not o then return nil end
            local g = o:FindFirstChild("GateObj"); if not g then return nil end
            local ga = g:FindFirstChild("Gate"); if not ga then return nil end
            return ga:FindFirstChild("Lock")
        end
        local function _getWeapon()
            if not lp.Character then return nil, nil end
            local tools = lp.Character:GetChildren()
            for i = 1, #tools do if tools[i]:IsA("Tool") then local re = tools[i]:FindFirstChild("RemoteEvent"); if re then return re end end end
            return nil
        end
        local function _attack(remote, target)
            if not remote then return end
            local hitPos = Vector3.new(62.246265411377, 9.1976232528687, -45.480701446533)
            local normal = Vector3.new(0.90587776899338, 0.034834560006857, -0.42210423946381)
            remote:FireServer("PrepareSwing")
            task.wait(0.02)
            remote:FireServer("Swing", "Thrust")
            task.wait(0.02)
            remote:FireServer("HitCon", target, hitPos, normal)
        end
        local function _loop()
            while _active do
                local re = _getWeapon(); local t = _getTarget()
                if re and t then
                    local r = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                    if r and (r.Position - t.Position).Magnitude <= _ATK_RANGE then _attack(re, t) end
                end
                task.wait(_ATK_INT)
            end
        end
        function FEATURES.toggleAutoCopenhagenGate(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_loop)
            else if _th then task.cancel(_th); _th = nil end end
        end
    end

    -- 10. 自动拉铃铛（莱比锡）
    do
        local _active = false; local _th = nil
        local function _bellLoop()
            while _active do
                local c = lp.Character; local r = c and c:FindFirstChild("HumanoidRootPart")
                if r then
                    local ok, bell = pcall(function() return workspace.Leipzig.Modes.Objective.BellInteract end)
                    if ok and bell then
                        local bp = bell:IsA("BasePart") and bell or bell:FindFirstChildWhichIsA("BasePart", true)
                        if bp and (r.Position - bp.Position).Magnitude <= 14 then
                            pcall(function() bell.Interact:FireServer() end)
                        end
                    end
                end
                task.wait(1)
            end
        end
        function FEATURES.toggleAutoBell(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_bellLoop)
            else if _th then task.cancel(_th); _th = nil end end
        end
    end

    -- 11. 自动拿木头（别列津纳）
    do
        local _active = false; local _th = nil
        local function _logLoop()
            while _active do
                local re = workspace:FindFirstChild("Berezina") and workspace.Berezina:FindFirstChild("Modes") and workspace.Berezina.Modes:FindFirstChild("Holdout") and workspace.Berezina.Modes.Holdout:FindFirstChild("Log") and workspace.Berezina.Modes.Holdout.Log:FindFirstChild("Log") and workspace.Berezina.Modes.Holdout.Log.Log:FindFirstChild("Interact")
                if re and re:IsA("RemoteEvent") then pcall(function() re:FireServer() end) end
                task.wait(0.05)
            end
        end
        function FEATURES.toggleAutoLog(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_logLoop)
            else if _th then task.cancel(_th); _th = nil end end
        end
    end

    -- 12. 自动点击放置（自动点击 缝合）
    do
        local _active = false; local _conns = {}
        local _targets = {
            "Place supply", "Grab Delicious Leg", "Grab Firewood", "Grab Sheet",
            "Grab Pillow", "Place log", "Grab Chest", "Grab Musket", "Grab Powerd Keg",
            "Grab Box of Candles", "Grab Grenade Box", "Pick up", "Place Crate", "Take Log"
        }
        local _running = {}

        local function _stopPrompt(id)
            local co = _running[id]
            if co then task.cancel(co); _running[id] = nil end
        end

        local function _startPrompt(prompt)
            local id = tostring(prompt:GetDebugId())
            _stopPrompt(id)
            _running[id] = task.spawn(function()
                while _active and prompt and prompt.Parent and prompt.Enabled do
                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration + 0.01)
                    prompt:InputHoldEnd()
                    task.wait(0.05)
                end
                _running[id] = nil
            end)
        end

        local PPS = game:GetService("ProximityPromptService")

        function FEATURES.toggleAutoPlace(s)
            _active = s
            if s then
                for id in pairs(_running) do task.cancel(_running[id]); _running[id] = nil end
                table.insert(_conns, PPS.PromptShown:Connect(function(prompt)
                    if not _active then return end
                    for _, t in ipairs(_targets) do
                        if prompt.ActionText == t then _startPrompt(prompt); break end end
                end))
                table.insert(_conns, PPS.PromptHidden:Connect(function(prompt)
                    _stopPrompt(tostring(prompt:GetDebugId()))
                end))
            else
                for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end; _conns = {}
                for id in pairs(_running) do task.cancel(_running[id]); _running[id] = nil end
            end
        end
    end    -- 13. 自动修桥（一件搭桥修桥 缝合进框架UI）
    do
        local _active = false; local _th = nil
        local _repairRange = 15
        local _woodCache = {}; local _woodValid = false; local _woodTime = 0
        local _targetLog = nil
        local _teleConn = nil; local _isTele = false; local _telePos = nil
        local _step = "检查修理"
        local _repairing = false
        local _safeFall = 50
        local _origGrav = workspace.Gravity

        local function _stopTele()
            if _teleConn then _teleConn:Disconnect(); _teleConn = nil end
            _isTele = false; _telePos = nil
        end

        local function _getGroundHeight(pos)
            local p = RaycastParams.new(); p.FilterType = Enum.RaycastFilterType.Blacklist; p.FilterDescendantsInstances = {lp.Character}
            local r = workspace:Raycast(pos + Vector3.new(0,10,0), Vector3.new(0,-200,0), p)
            return r and r.Position.Y or nil
        end

        local function _startTele(target)
            _stopTele()
            local gh = _getGroundHeight(target)
            local adj = gh and Vector3.new(target.X, math.min(target.Y, gh + 5), target.Z) or target
            _isTele = true; _telePos = adj
            _teleConn = game:GetService("RunService").Heartbeat:Connect(function()
                local c = lp.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if not c or not _active then _stopTele(); return end
                if not hrp then _stopTele(); return end
                local rot = hrp.CFrame - hrp.CFrame.Position
                hrp.CFrame = CFrame.new(_telePos) * rot
                hrp.AssemblyLinearVelocity = Vector3.new(); hrp.AssemblyAngularVelocity = Vector3.new()
            end)
        end

        local function _scanWood()
            if _woodValid and tick() - _woodTime < 1 then return _woodCache end
            local b = workspace:FindFirstChild("Berezina"); if not b then _woodValid = false; return {} end
            local m = b:FindFirstChild("Modes"); if not m then _woodValid = false; return {} end
            local h = m:FindFirstChild("Holdout"); if not h then _woodValid = false; return {} end
            local lf = h:FindFirstChild("Log"); if not lf then _woodValid = false; return {} end
            local nc = {}
            for _, item in ipairs(lf:GetChildren()) do
                if item.Name == "Log" then table.insert(nc, {object=item, position=item.Position or Vector3.new()}) end end
            _woodCache = nc; _woodValid = true; _woodTime = tick(); return nc
        end

        local function _findNearestLog()
            local c = lp.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart"); if not hrp then return nil,0,Vector3.new() end
            local wl = _scanWood(); if #wl == 0 then return nil,0,Vector3.new() end
            if _targetLog then
                for _, wd in ipairs(wl) do if wd.object == _targetLog then return _targetLog, (hrp.Position - wd.position).Magnitude, wd.position end end
                _targetLog = nil end
            local best, bestD, bestP = nil, math.huge, Vector3.new()
            for _, wd in ipairs(wl) do
                local d = (hrp.Position - wd.position).Magnitude
                if d < bestD then bestD = d; best = wd.object; bestP = wd.position end end
            if best then _targetLog = best; return best, bestD, bestP end
            return nil,0,Vector3.new()
        end

        local function _isHoldingLog()
            local c = lp.Character; if not c then return false end
            for _, obj in ipairs(c:GetChildren()) do if obj:IsA("Tool") and obj.Name == "Log" then return true end end
            return false
        end

        local function _findPlacePos()
            local c = lp.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart"); if not hrp then return nil,0 end
            local bf = workspace:FindFirstChild("Berezina") and workspace.Berezina:FindFirstChild("Modes") and workspace.Berezina.Modes:FindFirstChild("Holdout") and workspace.Berezina.Modes.Holdout:FindFirstChild("Bridge")
            if not bf then return nil,0 end
            local bestP, bestD = nil, math.huge
            for _, sec in ipairs(bf:GetChildren()) do
                if sec.Name:match("^BridgeSection%d+$") then
                    for _, child in ipairs(sec:GetDescendants()) do
                        if child.Name == "PlaceLogProximityPrompt" then
                            local parent = child.Parent; local pos = parent.Position
                            local d = (hrp.Position - pos).Magnitude
                            if d < bestD then bestD = d; bestP = pos end end end end end
            return bestP, bestD
        end

        local function _checkNeedRepair()
            local c = lp.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
            local br = workspace:FindFirstChild("Berezina"); if not br then return nil end
            local bf = br:FindFirstChild("Modes") and br.Modes:FindFirstChild("Holdout") and br.Modes.Holdout:FindFirstChild("Bridge")
            if not bf then return nil end
            local bestP, bestD = nil, math.huge
            for _, sec in ipairs(bf:GetChildren()) do
                if sec.Name:match("^BridgeSection%d+$") then
                    local posts = sec:FindFirstChild("Posts")
                    if posts then for _, part in ipairs(posts:GetChildren()) do
                        if (part:IsA("BasePart") or part:IsA("Model")) and part:FindFirstChild("ConstructHealth") then
                            local pp = part:IsA("BasePart") and part.Position
                            if not pp then local ok,v = pcall(function() return part:GetModelCFrame().Position end); if ok then pp = v end end
                            if pp then local d = (hrp.Position - pp).Magnitude; if d < bestD then bestD = d; bestP = pp end end end end end
                    local beam = sec:FindFirstChild("Beam")
                    if beam and beam:FindFirstChild("ConstructHealth") then
                        local d = (hrp.Position - beam.Position).Magnitude; if d < bestD then bestD = d; bestP = beam.Position end end
                    for _, ch in ipairs(sec:GetChildren()) do
                        if ch.Name == "Joists" and ch:FindFirstChild("ConstructHealth") then
                            local cp = ch:IsA("BasePart") and ch.Position
                            if not cp then local ok,v = pcall(function() return ch:GetModelCFrame().Position end); if ok then cp = v end end
                            if cp then local d = (hrp.Position - cp).Magnitude; if d < bestD then bestD = d; bestP = cp end end end end
                end end
            return bestP
        end

        local function _getHammer()
            local c = lp.Character; if not c then return nil end
            for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t:FindFirstChild("RemoteEvent") and (t.Name=="Hammer" or t.Name=="Claw Hammer") then return t end end
            for _, t in ipairs(lp.Backpack:GetChildren()) do if t:IsA("Tool") and t:FindFirstChild("RemoteEvent") and (t.Name=="Hammer" or t.Name=="Claw Hammer") then return t end end
        end

        local function _doRepair()
            local pos = _checkNeedRepair(); if not pos then return false end
            local gh = _getGroundHeight(pos); local target = gh and Vector3.new(pos.X, gh + 1.5, pos.Z) or pos
            _startTele(target); _repairing = true
            local st = tick()
            while _active and tick() - st < 5 do
                if tick() - st > 1 then if not _checkNeedRepair() then _stopTele(); _repairing = false; return true end end
                game:GetService("RunService").Heartbeat:Wait()
            end
            _stopTele()
            local still = _checkNeedRepair()
            _repairing = still and true or false
            return not still
        end

        local function _getLog()
            local log, logDist, logPos = _findNearestLog(); if not log then return false end
            local gh = _getGroundHeight(logPos)
            local target = gh and Vector3.new(logPos.X, math.min(logPos.Y+0.5, gh+3), logPos.Z) or Vector3.new(logPos.X, logPos.Y+0.5, logPos.Z)
            _startTele(target)
            local tl = log; local st = tick()
            while _active and tick() - st < 3 do
                if not tl or not tl.Parent then _stopTele(); return _isHoldingLog() end
                if _isHoldingLog() then _stopTele(); return true end
                game:GetService("RunService").Heartbeat:Wait()
            end
            _stopTele(); return false
        end

        local function _placeLog()
            local pos, dist = _findPlacePos(); if not pos then return false end
            local gh = _getGroundHeight(pos); local target = gh and Vector3.new(pos.X, gh+1, pos.Z) or pos
            _startTele(target)
            local st = tick()
            while _active and tick() - st < 3 do
                if not _isHoldingLog() then _stopTele(); return true end
                game:GetService("RunService").Heartbeat:Wait()
            end
            _stopTele(); return false
        end

        local function _mainLoop()
            while _active do
                if _step == "检查修理" then
                    if _checkNeedRepair() then _doRepair()
                    elseif _isHoldingLog() then _step = "放置木材"
                    else _step = "获取木材" end
                elseif _step == "获取木材" then
                    _getLog(); _step = "检查修理"
                elseif _step == "放置木材" then
                    _placeLog(); _step = "检查修理"
                end
                game:GetService("RunService").Heartbeat:Wait()
            end
            _stopTele(); workspace.Gravity = _origGrav
        end

        function FEATURES.toggleAutoBridge(s)
            _active = s
            if s then
                if _th then task.cancel(_th) end
                _step = "检查修理"; _repairing = false; _woodValid = false
                _origGrav = workspace.Gravity
                _th = task.spawn(_mainLoop)
            else
                if _th then task.cancel(_th); _th = nil end
                _stopTele(); _step = "检查修理"; _repairing = false; workspace.Gravity = _origGrav
            end
        end

        lp.CharacterAdded:Connect(function()
            task.wait(2); _woodValid = false; _woodCache = {}; _targetLog = nil; _step = "检查修理"; _repairing = false
            _stopTele(); workspace.Gravity = _origGrav
            if _active then task.wait(0.5); if _th then task.cancel(_th) end; _th = task.spawn(_mainLoop) end
        end)
    end    -- 14. 自动修建筑物（缓存RemoteEvent，无需持锤，开启后手动吹一下激活）
    do
        local _active = false; local _th = nil; local _repairRange = 12
        local _re = nil

        local function _cacheRE()
            local c = lp.Character
            if not c then return false end
            local h = c:FindFirstChild("Hammer")
            if h and h:FindFirstChild("RemoteEvent") then _re = h.RemoteEvent; return true end
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and t.Name == "Hammer" and t:FindFirstChild("RemoteEvent") then _re = t.RemoteEvent; return true end end
            for _, t in ipairs(lp.Backpack:GetChildren()) do
                if t:IsA("Tool") and t.Name == "Hammer" and t:FindFirstChild("RemoteEvent") then _re = t.RemoteEvent; return true end end
            return false
        end

        local function _repairAll()
            local c = lp.Character; local r = c and c:FindFirstChild("HumanoidRootPart")
            if not r or not _re then return end

            -- Buildings
            local bf = workspace:FindFirstChild("Buildings")
            if bf then
                local function scan(folder)
                    for _, item in ipairs(folder:GetChildren()) do
                        local health = item:FindFirstChild("BuildingHealth")
                        if health and typeof(health.Value) == "number" then
                            local maxH = item.Name == "Barricade" and 210 or item.Name == "Stakes" and 150 or item.Name == "Caltrops" and 35 or 999
                            if health.Value < maxH then
                                local ok, ip = pcall(function() return item:IsA("BasePart") and item.Position or item:GetModelCFrame().Position end)
                                if ok and ip and (r.Position - ip).Magnitude <= _repairRange then
                                    pcall(function() _re:FireServer("Repair", health) end); task.wait(0.05) end end end
                        if item:IsA("Folder") or item:IsA("Model") then scan(item) end end end
                scan(bf) end

            -- Bridge
            local br = workspace:FindFirstChild("Berezina")
            if br then
                local bf2 = br:FindFirstChild("Modes") and br.Modes:FindFirstChild("Holdout") and br.Modes.Holdout:FindFirstChild("Bridge")
                if bf2 then
                    for _, sec in ipairs(bf2:GetChildren()) do
                        if sec.Name:match("^BridgeSection%d+$") then
                            local function tryRepair(part)
                                if not part then return end
                                local ok, ppos = pcall(function() return part:IsA("BasePart") and part.Position or part:GetModelCFrame().Position end)
                                if not ok or not ppos then return end
                                local health = part:FindFirstChild("ConstructHealth")
                                if health and health:IsA("NumberValue") and (ppos - r.Position).Magnitude <= _repairRange then
                                    pcall(function() _re:FireServer("Repair", health) end) end end
                            local posts = sec:FindFirstChild("Posts")
                            if posts then for _, p in ipairs(posts:GetChildren()) do tryRepair(p) end end
                            tryRepair(sec:FindFirstChild("Beam"))
                            for _, ch in ipairs(sec:GetChildren()) do
                                if ch.Name == "Joists" then tryRepair(ch) end end end end end end end

        local function _loop()
            while _active do
                if not _re then _cacheRE() end
                if _re then pcall(_repairAll) end
                task.wait(0.5)
            end
        end

        function FEATURES.toggleAutoRepair(s)
            _active = s
            if s then
                if _th then task.cancel(_th) end
                _re = nil; _cacheRE()
                _th = task.spawn(_loop)
            else if _th then task.cancel(_th); _th = nil end end
        end

        lp.CharacterAdded:Connect(function()
            task.wait(2)
            if _active then
                _re = nil
                if _th then task.cancel(_th); _th = nil end
                _th = task.spawn(_loop)
            end end)
    

    -- ===== 特殊功能（全部移植 Skin HUB ） =====
    -- 强制爆头（ 完整版：hook 刺刀/近战 HitCheck）
    do
        local _active = false; local _hooked = false
        local _oldBayonet, _oldMelee = nil, nil

        local function _hook()
            if _hooked then return end
            local wm = game:GetService("ReplicatedStorage"):FindFirstChild("Weapons")
            if not wm then return end
            local bayonet = wm:FindFirstChild("Bayonet")
            local melee = wm:FindFirstChild("Melee")
            if bayonet and bayonet:FindFirstChild("HitCheck") then
                _oldBayonet = bayonet.HitCheck
                bayonet.HitCheck = function(self, origin, direction, rp, he)
                    local rr = workspace:Raycast(origin, direction, rp)
                    if rr then
                        local hit = rr.Instance; local zm = hit and hit.Parent
                        if zm and zm.Name == "m_Zombie" and zm:FindFirstChild("Orig") then
                            local head = zm:FindFirstChild("Head")
                            if head and (head:IsA("Part") or head:IsA("MeshPart")) then
                                local zr = zm.Orig.Value
                                local hp = head.CFrame.Position
                                self.remoteEvent:FireServer("Bayonet_HitZombie", zr, hp, true, "Head")
                                zr:SetAttribute("WepHitID", tick())
                                zr:SetAttribute("WepHitDirection", direction * 10)
                                zr:SetAttribute("WepHitPos", rr.Position)
                                task.delay(0.2, function()
                                    if zr:GetAttribute("WepHitID") == tick() then
                                        zr:SetAttribute("WepHitDirection", nil)
                                        zr:SetAttribute("WepHitPos", nil)
                                        zr:SetAttribute("WepHitID", nil) end end)
                                return 1 end end end
                    if _oldBayonet then return _oldBayonet(self, origin, direction, rp, he) end
                    return 0 end end
            if melee and melee:FindFirstChild("HitCheck") then
                _oldMelee = melee.HitCheck
                melee.HitCheck = function(self, origin, direction, rp, he, isCharge)
                    local rr = workspace:Raycast(origin, direction, rp)
                    if rr then
                        local hit = rr.Instance; local zm = hit and hit.Parent
                        if zm and zm.Name == "m_Zombie" and zm:FindFirstChild("Orig") then
                            local head = zm:FindFirstChild("Head")
                            if head and (head:IsA("Part") or head:IsA("MeshPart")) then
                                local zr = zm.Orig.Value; local hp = head.CFrame.Position
                                if isCharge then
                                    self.remoteEvent:FireServer("ThrustCharge", zr, hp, rr.Normal)
                                else
                                    local hd = (hp - origin).Unit * 25
                                    self.remoteEvent:FireServer("HitZombie", zr, hp, true, hd, "Head", rr.Normal) end
                                return 1 end end end
                    if _oldMelee then return _oldMelee(self, origin, direction, rp, he, isCharge) end
                    return 0 end end
            _hooked = true end

        local function _unhook()
            if not _hooked then return end
            local wm = game:GetService("ReplicatedStorage"):FindFirstChild("Weapons")
            if wm then
                local bayonet = wm:FindFirstChild("Bayonet")
                if bayonet and _oldBayonet then bayonet.HitCheck = _oldBayonet; _oldBayonet = nil end
                local melee = wm:FindFirstChild("Melee")
                if melee and _oldMelee then melee.HitCheck = _oldMelee; _oldMelee = nil end end
            _hooked = false end

        function FEATURES.toggleHeadshot(s)
            _active = s
            if s then _hook() else _unhook() end end

        lp.CharacterAdded:Connect(function()
            if _active then task.wait(0.5); _hook() end end)
    end

    -- 无减速
    do
        local _active = false; local _wsConn = nil; local _caConn = nil
        local function _setup()
            local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if _wsConn then _wsConn:Disconnect() end
            _wsConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if _active and hum.WalkSpeed < 16 then hum.WalkSpeed = 16 end end)
            if _active and hum.WalkSpeed < 16 then hum.WalkSpeed = 16 end end
        function FEATURES.toggleNoSlow(s)
            _active = s
            if s then _setup(); _caConn = lp.CharacterAdded:Connect(function() task.wait(1); _setup() end)
            else if _wsConn then _wsConn:Disconnect(); _wsConn = nil end
                if _caConn then _caConn:Disconnect(); _caConn = nil end end end
    end

    -- 移除摔伤（ForceSelfDamage）
    do
        local _active = false; local _th = nil
        local function _loop()
            while _active do
                local c = lp.Character; local h = c and c:FindFirstChild("Health")
                if h then local fsd = h:FindFirstChild("ForceSelfDamage"); if fsd then fsd:FireServer(0) end end
                task.wait(1) end end
        function FEATURES.toggleNoFall(s)
            _active = s
            if s then if _th then task.cancel(_th) end; _th = task.spawn(_loop)
            else if _th then task.cancel(_th); _th = nil end end end
    end

    -- 显示物品栏
    do
        local _active = false; local _conn = nil
        function FEATURES.toggleBackpack(s)
            _active = s
            if s then
                local bg = lp:WaitForChild("PlayerGui"):FindFirstChild("BackpackGui")
                if bg then bg.Enabled = true
                    _conn = bg:GetPropertyChangedSignal("Enabled"):Connect(function()
                        if _active and not bg.Enabled then bg.Enabled = true end end) end
            else if _conn then _conn:Disconnect(); _conn = nil end end end
    end

    -- 亮度提升
    do
        local _active = false; local _orig = nil
        function FEATURES.toggleBright(s)
            _active = s; local lt = game:GetService("Lighting")
            if s then
                _orig = { ClockTime=lt.ClockTime, Ambient=lt.Ambient, GlobalShadows=lt.GlobalShadows, OutdoorAmbient=lt.OutdoorAmbient }
                lt.ClockTime = 14; lt.Ambient = Color3.fromRGB(255,255,255); lt.GlobalShadows = false; lt.OutdoorAmbient = Color3.fromRGB(255,255,255)
            elseif _orig then
                lt.ClockTime = _orig.ClockTime; lt.Ambient = _orig.Ambient; lt.GlobalShadows = _orig.GlobalShadows; lt.OutdoorAmbient = _orig.OutdoorAmbient end end
    end


    -- 解除视角限制（第三视角+MaxZoom）
    do
        local _active = false; local _conn = nil
        function FEATURES.toggleUnlockCamera(s)
            _active = s
            if s then
                lp.CameraMaxZoomDistance = 200
                if not _conn then
                    _conn = game:GetService("RunService").RenderStepped:Connect(function()
                        if _active then
                            local c = workspace.CurrentCamera
                            c.CameraType = Enum.CameraType.Custom
                            c.CameraSubject = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") or c.CameraSubject end end) end
            else
                if _conn then _conn:Disconnect(); _conn = nil end
                local c = workspace.CurrentCamera; c.CameraType = Enum.CameraType.Custom end end
        lp.CharacterAdded:Connect(function() task.wait(0.5); if _active then lp.CameraMaxZoomDistance = 200 end end)
    end

    -- 显示自爆范围
    do
        local _active = false; local _conn = nil; local _spheres = {}
        local _R = 10; local _WHITE = Color3.fromRGB(255,80,80); local _Y_OFF = -1.5
        local function _getZ()
            local zf = workspace:FindFirstChild("Zombies"); if not zf then return {} end
            local r = {}
            for _, z in ipairs(zf:GetChildren()) do if z:IsA("Model") and z:GetAttribute("Type") == "Barrel" then r[#r+1] = z end end
            return r end
        local function _mkSphere(pos)
            local s = Instance.new("Part"); s.Shape = Enum.PartType.Ball; s.Size = Vector3.new(_R*2,_R*2,_R*2)
            s.BrickColor = BrickColor.new(_WHITE); s.Color = _WHITE; s.Material = Enum.Material.Neon
            s.Transparency = 0.6; s.Anchored = true; s.CanCollide = false; s.CanQuery = false; s.CanTouch = false
            s.CastShadow = false; s.Position = pos; s.Parent = workspace; return s end
        local function _update()
            if not _active then
                for _, s in pairs(_spheres) do if s then s:Destroy() end end; _spheres = {}; return end
            local zs = _getZ(); local cs = {}
            for _, z in ipairs(zs) do cs[z] = true
                local p = z:FindFirstChild("HumanoidRootPart") or z:FindFirstChild("Head")
                if p then
                    local pos = p.Position + Vector3.new(0, _Y_OFF, 0)
                    if _spheres[z] then _spheres[z].Position = pos
                    else _spheres[z] = _mkSphere(pos) end end end
            for z, s in pairs(_spheres) do if not cs[z] then s:Destroy(); _spheres[z] = nil end end end
        function FEATURES.toggleBombRange(s)
            _active = s
            if s then if _conn then _conn:Disconnect() end; _conn = game:GetService("RunService").Heartbeat:Connect(_update); _update()
            else if _conn then _conn:Disconnect(); _conn = nil end; _update() end end
    end

    -- 自动射击（ 完整版）
    do
        -- State
        local _auto = { Bomber=false, Cuirassier=false, Runner=false, Electrocutioner=false }
        local _running = false; local _th = nil
        local _ATK_COOLDOWN = 0.1; local _LOCK_TIME = math.huge

        -- Utility: is gun
        local function _isGun(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local af = tool:FindFirstChild("Animations")
            if not af then return false end
            return af:FindFirstChild("Aim") ~= nil or af:FindFirstChild("Aiming") ~= nil
        end

        -- Utility: shots loaded
        local function _getShots(tool)
            if not tool then return 0 end
            local s = tool:FindFirstChild("ShotsLoaded")
            if s and (s:IsA("IntValue") or s:IsA("NumberValue")) then return s.Value end
            local wf = workspace:FindFirstChild("Players")
            if wf then
                local pf = wf:FindFirstChild(lp.Name)
                if pf then
                    local tf = pf:FindFirstChild(tool.Name)
                    if tf then
                        local sh = tf:FindFirstChild("ShotsLoaded")
                        if sh and (sh:IsA("IntValue") or sh:IsA("NumberValue")) then return sh.Value end end end end
            return 0
        end

        -- Utility: find remote
        local function _getRemote(tool)
            if not tool then return nil end
            local re = tool:FindFirstChild("RemoteEvent")
            if re then return re end
            local wf = workspace:FindFirstChild("Players")
            if wf then
                local pf = wf:FindFirstChild(lp.Name)
                if pf then
                    local tf = pf:FindFirstChild(tool.Name)
                    if tf then return tf:FindFirstChild("RemoteEvent") end end end
        end

        -- Wall check
        local function _isBlocked(origin, targetPos, targetModel)
            if not origin or not targetPos then return false end
            local dir = targetPos - origin; local dist = dir.Magnitude
            if dist <= 0 then return false end
            local function buildIgnore()
                local il = {}
                local cf = workspace:FindFirstChild("Camera")
                if cf then for _, d in ipairs(cf:GetDescendants()) do if d:IsA("Model") and d.Name=="m_Zombie" then il[#il+1]=d end end end
                local zf = workspace:FindFirstChild("Zombies")
                if zf then il[#il+1]=zf end
                for _, pl in ipairs(game:GetService("Players"):GetPlayers()) do if pl.Character then il[#il+1]=pl.Character end end
                if targetModel then il[#il+1]=targetModel end
                return il end
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Blacklist
            params.FilterDescendantsInstances = buildIgnore()
            for i = 1, 12 do
                local ok, result = pcall(function() return workspace:Raycast(origin, dir.Unit * dist, params) end)
                if not ok or not result then return false end
                local hi = result.Instance
                if not hi then return false end
                if targetModel and hi:IsDescendantOf(targetModel) then return false end
                local bp = hi:IsA("BasePart")
                if (bp and not hi.CanCollide) or (bp and hi.Transparency >= 0.95) then
                    local adv = result.Position + dir.Unit * 0.2
                    if (adv - origin).Magnitude >= dist - 0.0001 then return false end
                    origin = adv; dist = (targetPos - origin).Magnitude
                    local fl = params.FilterDescendantsInstances; fl[#fl+1] = hi
                    params.FilterDescendantsInstances = fl
                else return true end end
            return true end

        -- Zombie matchers
        local _matchers = {
            Bomber = function(m) return m:FindFirstChild("Barrel") ~= nil end,
            Cuirassier = function(m) return m:FindFirstChild("Sword") ~= nil end,
            Runner = function(m) return m:FindFirstChild("Eye") and not m:FindFirstChild("Axe") and m:FindFirstChild("Head") end,
            Electrocutioner = function(m) return m:FindFirstChild("Axe") and m:FindFirstChild("Head") end,
        }

        -- Find nearest target
        local function _findTarget(range, matcher)
            local cf = workspace:FindFirstChild("Camera"); local cam = workspace.CurrentCamera
            local origin = lp.Character and lp.Character:FindFirstChild("Head") and lp.Character.Head.Position or (cam and cam.CFrame.Position)
            if not origin then return nil, nil end
            if not cf then return nil, nil end
            local bestPart, bestD, bestM = nil, range + 0.0001, nil
            for _, model in ipairs(cf:GetChildren()) do
                if model:IsA("Model") and model.Name == "m_Zombie" and matcher(model) then
                    local head = model:FindFirstChild("Head"); local barrel = model:FindFirstChild("Barrel")
                    local torso = model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso") or model:FindFirstChild("HumanoidRootPart")
                    local mp = barrel or head or torso
                    if mp and mp:IsA("BasePart") then
                        local d = (mp.Position - origin).Magnitude
                        if d <= range + 0.0001 and d < bestD then
                            local bVis, hVis, tVis = false, false, false
                            if barrel and barrel:IsA("BasePart") then local ok,v=pcall(function() return not _isBlocked(origin, barrel.Position, model) end); if ok and v then bVis=true end end
                            if head and head:IsA("BasePart") then local ok,v=pcall(function() return not _isBlocked(origin, head.Position, model) end); if ok and v then hVis=true end end
                            if torso and torso:IsA("BasePart") then local ok,v=pcall(function() return not _isBlocked(origin, torso.Position, model) end); if ok and v then tVis=true end end
                            local cp = bVis and barrel or hVis and head or tVis and torso
                            if cp and cp:IsA("BasePart") then bestPart = cp; bestD = d; bestM = model end end end end end
            return bestPart, bestM end

        -- Smooth look-at
        local function _smoothLookAt(root, getPos, duration)
            if not root then return end
            local start = tick(); local startCF = root.CFrame
            local ok, initT = pcall(getPos); if not ok or not initT then return end
            while tick() - start < duration do
                if not root.Parent then return end
                local cur = nil; pcall(function() cur = getPos() end); if not cur then cur = initT end
                local desired = CFrame.new(root.Position, Vector3.new(cur.X, root.Position.Y, cur.Z))
                local t = math.clamp((tick() - start) / duration, 0, 1); local st = t * t * (3 - 2 * t)
                pcall(function() root.CFrame = startCF:Lerp(desired, st) end)
                game:GetService("RunService").RenderStepped:Wait() end
            local final = nil; pcall(function() final = getPos() end)
            if final then pcall(function() root.CFrame = CFrame.new(root.Position, root.Position + CFrame.new(root.Position, Vector3.new(final.X, root.Position.Y, final.Z)).LookVector) end) end end

        -- Play animation
        local function _playAnim(id, animator)
            if not id or not animator then return nil end
            local ok, track = pcall(function() local a = Instance.new("Animation"); a.AnimationId = id; return animator:LoadAnimation(a) end)
            if not ok or not track then return nil end
            track.Priority = Enum.AnimationPriority.Action; track:Play(0.05, 1, 1); return track end

        -- Aim then shoot
        local function _aimShoot(targetModel, initPart, tool)
            if not targetModel or not targetModel.Parent then return end
            if not initPart or not initPart.Parent or not initPart:IsA("BasePart") then return end
            if not tool or not tool.Parent or not tool:IsDescendantOf(lp.Character) then return end
            if not _isGun(tool) then return end
            local char = lp.Character; if not char then return end
            local hu = char:FindFirstChildOfClass("Humanoid"); if not hu then return end
            local animator = hu:FindFirstChildOfClass("Animator") or Instance.new("Animator", hu)
            local remote = tool:FindFirstChild("RemoteEvent")
            local af = tool:FindFirstChild("Animations")
            local aId, bId, fId
            if af then
                local aim = af:FindFirstChild("Aim"); if aim and aim:IsA("Animation") then aId = aim.AnimationId end
                local aiming = af:FindFirstChild("Aiming"); if aiming and aiming:IsA("Animation") then bId = aiming.AnimationId end
                local fire = af:FindFirstChild("Fire"); if fire and fire:IsA("Animation") then fId = fire.AnimationId end end
            aId = aId or "rbxassetid://83511222574103"; bId = bId or "rbxassetid://136849639865723"

            local trackA = _playAnim(aId, animator)
            if trackA then task.wait(math.min(trackA.Length or 0.6, 0.6)); pcall(function() trackA:Stop(0.05) end) end
            local trackB = _playAnim(bId, animator); task.wait(0.02)

            local curTarget = initPart
            local function getAimOrigin()
                if lp.Character and lp.Character:FindFirstChild("Head") and lp.Character.Head:IsA("BasePart") then return lp.Character.Head.Position end
                local cam = workspace.CurrentCamera; if cam then return cam.CFrame.Position end end
            local function isVis(part)
                if not part or not part.Parent or not part:IsA("BasePart") then return false end
                local o = getAimOrigin(); if not o then return false end
                local ok, r = pcall(function() return not _isBlocked(o, part.Position, targetModel) end); return ok and r end

            local root = char:FindFirstChild("HumanoidRootPart")
            if root and targetModel and targetModel.Parent then
                _smoothLookAt(root, function()
                    if not curTarget or not curTarget.Parent then
                        local b = targetModel:FindFirstChild("Barrel"); if b and isVis(b) then curTarget=b; return b.Position end
                        local h = targetModel:FindFirstChild("Head"); if h and isVis(h) then curTarget=h; return h.Position end
                        local t = targetModel:FindFirstChild("Torso") or targetModel:FindFirstChild("UpperTorso") or targetModel:FindFirstChild("HumanoidRootPart")
                        if t and isVis(t) then curTarget=t; return t.Position end end
                    if curTarget and curTarget.Parent then return curTarget.Position end
                end, 0.28)
            else
                if trackB then pcall(function() trackB:Stop(0.1) end) end; return end

            -- Wait for ammo (: wait until ShotsLoaded >= 1 or timeout)
            local waited = 0
            local shotsNow = _getShots(tool)
            while (not shotsNow or shotsNow < 1) and waited < 3 do
                if not tool or not tool.Parent or not tool:IsDescendantOf(lp.Character) then
                    if trackB then pcall(function() trackB:Stop(0.1) end) end; return end
                if not _running then
                    if trackB then pcall(function() trackB:Stop(0.1) end) end; return end
                if curTarget and (not isVis(curTarget)) then
                    local barrel = targetModel:FindFirstChild("Barrel")
                    local head = targetModel:FindFirstChild("Head")
                    local torso = targetModel:FindFirstChild("Torso") or targetModel:FindFirstChild("UpperTorso") or targetModel:FindFirstChild("HumanoidRootPart")
                    local sw = false
                    if barrel and barrel ~= curTarget and isVis(barrel) then curTarget = barrel; sw = true
                    elseif head and head ~= curTarget and isVis(head) then curTarget = head; sw = true
                    elseif torso and torso ~= curTarget and isVis(torso) then curTarget = torso; sw = true end
                    if not sw then if trackB then pcall(function() trackB:Stop(0.1) end) end; return end end
                game:GetService("RunService").RenderStepped:Wait()
                waited = waited + 0.05
                shotsNow = _getShots(tool) end

            if not shotsNow or shotsNow < 1 then
                if trackB then pcall(function() trackB:Stop(0.1) end) end; return end

            task.wait(0.03)
            if not curTarget or not curTarget.Parent or (not isVis(curTarget)) then
                local barrel = targetModel:FindFirstChild("Barrel")
                local head = targetModel:FindFirstChild("Head")
                local torso = targetModel:FindFirstChild("Torso") or targetModel:FindFirstChild("UpperTorso") or targetModel:FindFirstChild("HumanoidRootPart")
                if barrel and isVis(barrel) then curTarget = barrel
                elseif head and isVis(head) then curTarget = head
                elseif torso and isVis(torso) then curTarget = torso
                else if trackB then pcall(function() trackB:Stop(0.1) end) end; return end end

            -- Fire!
            if fId then pcall(function() _playAnim(fId, animator) end) end
            pcall(function()
                local mr = char:FindFirstChild("Model") or char
                local ts = workspace:GetServerTimeNow()
                remote = remote or tool:FindFirstChild("RemoteEvent")
                if remote and curTarget and curTarget.Parent then
                    remote:FireServer("Fire", mr, curTarget.Position, ts) end end)
            if trackB then task.wait(0.05); pcall(function() trackB:Stop(0.1) end) end
        end

        -- Per-type processing
        local function _processType(enabled, matcher)
            if not enabled then return end
            local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
            local isGun = tool and _isGun(tool); local shots = (tool and isGun) and _getShots(tool) or 0
            if enabled and tool and isGun and shots >= 1 then
                local part, model = _findTarget(200, matcher)
                if part and model then
                    task.wait(0.5)
                    if tool and tool.Parent and model and model.Parent and _isGun(tool) then
                        local ct = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
                        if ct and ct == tool then _aimShoot(model, part, ct) end end end end end

        -- Main loop
        local function _loop()
            while _running do
                if _auto.Barrel then _processType(true, _matchers.Bomber) end
                if _auto.Cuirassier then _processType(true, _matchers.Cuirassier) end
                if _auto.Runner then _processType(true, _matchers.Runner) end
                if _auto.Electrocutioner then _processType(true, _matchers.Electrocutioner) end
                task.wait(_ATK_COOLDOWN) end end

        -- Toggle functions
        function FEATURES.toggleAutoShoot(typeKey, state)
            if _auto[typeKey] ~= nil then _auto[typeKey] = state end
            local any = false
            for _, v in pairs(_auto) do if v then any = true; break end end
            if any and not _running then _running = true; _th = task.spawn(_loop)
            elseif not any and _running then _running = false; if _th then task.cancel(_th); _th = nil end end
        end

        -- init toggles from UI state if already set
        local function _checkAll()
            local any = false
            for _, v in pairs(_auto) do if v then any = true; break end end
            if any and not _running then _running = true; _th = task.spawn(_loop) end end
        _checkAll()
    end

    -- 娱乐功能：旋转 + 倒立行走（ 完整版）
    do
        -- 旋转
        local _spin = { enabled = false, speed = 10, conn = nil, animLock = nil }
        local RS = game:GetService("RunService")

        local function _spinAnimLock(char)
            if not char then return end
            local hu = char:FindFirstChildOfClass("Humanoid")
            if hu then hu.AutoRotate = false end
            if _spin.animLock then task.cancel(_spin.animLock); _spin.animLock = nil end
            _spin.animLock = task.spawn(function()
                local ani = char:WaitForChild("Animate", 3)
                while _spin.enabled and ani and ani.Parent do ani.Disabled = true; task.wait(0.2) end end)
        end

        local function _spinAnimUnlock(char)
            if not char then return end
            local hu = char:FindFirstChildOfClass("Humanoid")
            if hu then hu.AutoRotate = true end
            if _spin.animLock then task.cancel(_spin.animLock); _spin.animLock = nil end
            local ani = char:FindFirstChild("Animate")
            if ani then ani.Disabled = false end end

        local function _spinStart()
            if _spin.conn then return end
            _spin.conn = RS.RenderStepped:Connect(function(dt)
                if not _spin.enabled then return end
                local c = lp.Character; if not c then return end
                local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(_spin.speed * 350) * dt, 0) end)
            _spinAnimLock(lp.Character) end

        local function _spinStop()
            _spin.enabled = false
            if _spin.conn then _spin.conn:Disconnect(); _spin.conn = nil end
            _spinAnimUnlock(lp.Character) end

        function FEATURES.toggleSpin(s)
            _spin.enabled = s
            if s then _spinStart() else _spinStop() end end

        function FEATURES.setSpinSpeed(v) _spin.speed = v end

        lp.CharacterAdded:Connect(function(char)
            if _spin.enabled then task.wait(0.5); _spinAnimLock(char)
                if not _spin.conn then _spinStart() end end end)

        -- 倒立行走
        local _inv = { enabled = false, conn = nil }
        local function _invApply()
            if not _inv.enabled then return end
            local c = lp.Character; if not c then return end
            local r = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso")
            if r then local p = r.Position; r.CFrame = CFrame.new(p) * CFrame.Angles(math.rad(180), 0, 0) end end

        local function _invLoop()
            if _inv.conn then return end
            _inv.conn = RS.RenderStepped:Connect(function()
                if _inv.enabled then _invApply() end end) end

        local function _invUnloop()
            if _inv.conn then _inv.conn:Disconnect(); _inv.conn = nil end end

        function FEATURES.toggleHandstand(s)
            _inv.enabled = s
            if s then _invApply(); _invLoop()
            else _invUnloop()
                local c = lp.Character
                if c then local r = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso")
                    if r then local p = r.Position; local cf = r.CFrame
                        r.CFrame = CFrame.new(p) * CFrame.Angles(0, cf.Yaw, 0) end end end end

        lp.CharacterAdded:Connect(function()
            task.wait(0.1)
            if _inv.enabled then _invApply()
                if not _inv.conn then _invLoop() end end end)
    end

    -- 禁用火焰粒子
    do
        local _active = false; local _conn = nil
        local function _setFire(enabled)
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") and obj.Name:lower():find("fire") then
                    obj.Enabled = enabled; if not enabled then obj.Rate = 0 else obj.Rate = 20 end end end end
        function FEATURES.toggleDisableFire(s)
            _active = s
            if s then
                _setFire(false)
                if not _conn then _conn = workspace.DescendantAdded:Connect(function(desc)
                    if desc:IsA("ParticleEmitter") and desc.Name:lower():find("fire") then desc.Enabled = false; desc.Rate = 0 end end) end
            else
                if _conn then _conn:Disconnect(); _conn = nil end; _setFire(true) end end
    end
end    -- 自动跳跃 + 手动跳跃（共用高度值）
    do
        local _manualEnabled = false; local _height = 60
        local _jrConn = nil; local _rsConn = nil
        local _hookInstalled = false; local _oldNC = nil
        local UIS = game:GetService("UserInputService")
        local RS = game:GetService("RunService")

-- 手动跳跃（JumpRequest + 免伤 + 状态锁定）
        function FEATURES.toggleManualJump(s)
            _manualEnabled = s
            if s then
                if not _hookInstalled then
                    local mt = getrawmetatable(game)
                    _oldNC = mt.__namecall
                    setreadonly(mt, false)
                    mt.__namecall = newcclosure(function(self, ...)
                        if getnamecallmethod() == "FireServer" and tostring(self) == "ForceSelfDamage" then
                            return nil
                        end
                        return _oldNC(self, ...)
                    end)
                    setreadonly(mt, true)
                    _hookInstalled = true
                end
                if not _jrConn then
                    _jrConn = UIS.JumpRequest:Connect(function()
                        if not _manualEnabled then return end
                        local c = lp.Character; if not c then return end
                        local h = c:FindFirstChild("HumanoidRootPart")
                        local hu = c:FindFirstChildOfClass("Humanoid")
                        if h and hu then
                            hu:ChangeState(Enum.HumanoidStateType.Jumping)
                            h.Velocity = Vector3.new(h.Velocity.X, _height, h.Velocity.Z)
                        end
                    end)
                end
                if not _rsConn then
                    _rsConn = RS.RenderStepped:Connect(function()
                        if not _manualEnabled then return end
                        local c = lp.Character; if not c then return end
                        local h = c:FindFirstChild("HumanoidRootPart")
                        local hu = c:FindFirstChildOfClass("Humanoid")
                        if h and hu then
                            local us = lp:FindFirstChild("UserStates")
                            if us then
                                for _, s in pairs({"BrokenLegs", "Grabbed", "Pin"}) do
                                    local v = us:FindFirstChild(s)
                                    if v then v.Value = false end
                                end
                            end
                            local ani = c:FindFirstChild("Animate")
                            if ani then ani.Parent = nil end
                            if h.Velocity.Y < -5 and not UIS:IsKeyDown(Enum.KeyCode.Space) then
                                hu:ChangeState(Enum.HumanoidStateType.Climbing)
                            end
                        end
                    end)
                end
            else
                -- 关闭手动：清除连接 + 恢复 metatable + 恢复动画
                if _hookInstalled then
                    local mt = getrawmetatable(game)
                    setreadonly(mt, false)
                    mt.__namecall = _oldNC
                    setreadonly(mt, true)
                    _hookInstalled = false
                end
                if _jrConn then _jrConn:Disconnect(); _jrConn = nil end
                if _rsConn then _rsConn:Disconnect(); _rsConn = nil end
                local c = lp.Character
                if c then
                    local ani = c:FindFirstChild("Animate")
                    if ani and not ani.Parent then ani.Parent = c end
                end
            end
        end

        function FEATURES.setAutoJumpHeight(v) _height = math.clamp(v, 0, 90) end
    end

    -- 工兵：攻击回收/肘击范围/肘击（移植 Skin HUB ）
    do
        local _recycleEnabled = false
        local _elbowRangeEnabled = false
        local _elbowActive = false
        local _animConn = nil
        local _elbowThread = nil

        -- 稿子专用动画 ID（三个）
        local PICKAXE_ANIMATIONS = {
            "rbxassetid://16663569329",
            "rbxassetid://16663563130",
            "rbxassetid://109975878922735"
        }

        -- 斧头/法棍专用动画 ID（三个）
        local AXE_BAGUETTE_ANIMATIONS = {
            "rbxassetid://12638406999",
            "rbxassetid://94131315859283",
            "rbxassetid://12638412059"
        }

        -- 肘击触发动画
        local ELBOW_TRIGGER_ANIMATIONS = {"rbxassetid://15345113937"}
        local STUN_RANGE = 50

        -- 检测当前武器类型
        local function getCurrentRecycleWeaponType()
            local char = lp.Character
            if not char then return nil end
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool then return nil end
            local name = tool.Name
            if name == "Pickaxe" then return "Pickaxe"
            elseif name == "Axe" then return "Axe"
            elseif name == "Baguette" then return "Baguette"
            end
            return nil
        end

        -- 通用武器回收（卸下再装备）
        local function recycleWeapon()
            if not _recycleEnabled then return end
            local weaponType = getCurrentRecycleWeaponType()
            if not weaponType then return end
            local char = lp.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool or (tool.Name ~= "Pickaxe" and tool.Name ~= "Axe" and tool.Name ~= "Baguette") then
                return
            end
            tool.Parent = lp:FindFirstChild("Backpack")
            task.wait(0.1)
            if _recycleEnabled and char.Parent and tool and tool.Parent == lp:FindFirstChild("Backpack") then
                tool.Parent = char
            end
        end

        -- 肘击范围
        local function stunAroundPlayer()
            if not _elbowRangeEnabled then return end
            local char = lp.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool or (tool.Name ~= "Pickaxe" and tool.Name ~= "Axe" and tool.Name ~= "Baguette") then
                return
            end
            local remote = tool:FindFirstChild("RemoteEvent")
            if not remote then return end
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            local playerPos = rootPart.Position
            local zombiesFolder = workspace:FindFirstChild("Zombies")
            if not zombiesFolder then return end
            for _, zombie in pairs(zombiesFolder:GetChildren()) do
                if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
                    if zombie:GetAttribute("Type") == "Barrel" then continue end
                    local state = zombie:FindFirstChild("State")
                    if state and state.Value == "Spawn" then continue end
                    local zombieRoot = zombie:FindFirstChild("HumanoidRootPart")
                    if not zombieRoot then continue end
                    if (zombieRoot.Position - playerPos).Magnitude <= STUN_RANGE then
                        if zombie:FindFirstChild("State") and zombie.State.Value ~= "Stunned" then
                            remote:FireServer("BraceBlock")
                            remote:FireServer("StopBraceBlock")
                            remote:FireServer("FeedbackStun", zombie, zombieRoot.Position)
                        end
                    end
                end
            end
        end

        -- 动画监听
        local function onEngineerAnimationPlayed(animationTrack)
            if not _recycleEnabled then
                if _elbowRangeEnabled then
                    local animId = animationTrack.Animation.AnimationId
                    for _, targetId in ipairs(ELBOW_TRIGGER_ANIMATIONS) do
                        if animId == targetId then
                            stunAroundPlayer()
                            break
                        end
                    end
                end
                return
            end
            local animId = animationTrack.Animation.AnimationId
            local weaponType = getCurrentRecycleWeaponType()
            if not weaponType then return end
            local delayTime = nil
            if weaponType == "Pickaxe" then
                for _, id in ipairs(PICKAXE_ANIMATIONS) do
                    if animId == id then
                        delayTime = 0.3
                        break
                    end
                end
            elseif weaponType == "Axe" or weaponType == "Baguette" then
                for _, id in ipairs(AXE_BAGUETTE_ANIMATIONS) do
                    if animId == id then
                        if animId == "rbxassetid://12638412059" then
                            delayTime = 0.40
                        else
                            delayTime = 0.30
                        end
                        break
                    end
                end
            end
            if delayTime then
                task.delay(delayTime, recycleWeapon)
            end
            if _elbowRangeEnabled then
                for _, targetId in ipairs(ELBOW_TRIGGER_ANIMATIONS) do
                    if animId == targetId then
                        stunAroundPlayer()
                        break
                    end
                end
            end
        end

        local function updateEngineerAnimConnection()
            if _recycleEnabled or _elbowRangeEnabled then
                if _animConn then return end
                local char = lp.Character
                if not char then
                    lp.CharacterAdded:Connect(function() task.wait(1); updateEngineerAnimConnection() end)
                    return
                end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    _animConn = humanoid.AnimationPlayed:Connect(onEngineerAnimationPlayed)
                end
            else
                if _animConn then
                    _animConn:Disconnect()
                    _animConn = nil
                end
            end
        end

        lp.CharacterAdded:Connect(updateEngineerAnimConnection)

        function FEATURES.toggleRecycle(s)
            _recycleEnabled = s
            updateEngineerAnimConnection()
        end

        function FEATURES.toggleElbowRange(s)
            _elbowRangeEnabled = s
            updateEngineerAnimConnection()
        end

        function FEATURES.toggleElbow(s)
            _elbowActive = s
            if s then
                if _elbowThread then task.cancel(_elbowThread) end
                _elbowThread = task.spawn(function()
                    while _elbowActive do
                        local char = lp.Character
                        if char then
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            local root = char:FindFirstChild("HumanoidRootPart")
                            if humanoid and humanoid.Health > 0 and root then
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then
                                    local toolName = tool.Name
                                    if toolName == "Axe" or toolName == "Baguette" or toolName == "Pickaxe" then
                                        local remote = tool:FindFirstChild("RemoteEvent")
                                        if remote then
                                            local playerPos = root.Position
                                            local zombiesFolder = workspace:FindFirstChild("Zombies")
                                            if zombiesFolder then
                                                local targets = {}
                                                for _, zombie in pairs(zombiesFolder:GetChildren()) do
                                                    if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
                                                        if zombie:GetAttribute("Type") == "Barrel" or zombie:FindFirstChild("Barrel") then
                                                            continue
                                                        end
                                                        local zombieRoot = zombie:FindFirstChild("HumanoidRootPart")
                                                        if zombieRoot then
                                                            local dist = (zombieRoot.Position - playerPos).Magnitude
                                                            if dist <= 45 then
                                                                table.insert(targets, {zombie = zombie, root = zombieRoot, dist = dist})
                                                            end
                                                        end
                                                    end
                                                end
                                                table.sort(targets, function(a,b) return a.dist < b.dist end)
                                                local maxTargets = math.min(30, #targets)
                                                for i = 1, maxTargets do
                                                    local t = targets[i]
                                                    pcall(function()
                                                        remote:FireServer("BraceBlock")
                                                        remote:FireServer("StopBraceBlock")
                                                        remote:FireServer("FeedbackStun", t.zombie, t.root.Position)
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.05)
                    end
                end)
            else
                if _elbowThread then
                    task.cancel(_elbowThread)
                    _elbowThread = nil
                end
            end
        end
    end

    -- 牧师功能（自动祝福感染玩家，移植）
    do
        local _active = false; local _threshold = 50
        local _cooldown = 2; local _range = 15
        local _lastRequest = {}; local _thread = nil

        local function _getInfection(player)
            local infection = 0
            pcall(function()
                local wsPlayers = workspace:FindFirstChild("Players")
                if wsPlayers then
                    local folder = wsPlayers:FindFirstChild(player.Name)
                    if folder and folder:FindFirstChild("UserStates") then
                        local val = folder.UserStates:FindFirstChild("Infected")
                        if val then infection = tonumber(val.Value) or 0 return end
                    end
                end
                if player:FindFirstChild("UserStates") then
                    local val = player.UserStates:FindFirstChild("Infected")
                    if val then infection = tonumber(val.Value) or 0 end
                end
            end)
            return infection
        end

        local function _getRemote()
            local char = lp.Character
            if not char then return nil end
            local tool = char:FindFirstChild("Blessing")
            if tool and tool:FindFirstChild("RemoteEvent") then return tool.RemoteEvent end
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("Tool") and child.Name:lower():find("bless") and child:FindFirstChild("RemoteEvent") then
                    return child.RemoteEvent
                end
            end
            return nil
        end

        local function _inRange(player)
            local localChar = lp.Character
            if not localChar then return false end
            local localRoot = localChar:FindFirstChild("HumanoidRootPart")
            if not localRoot then return false end
            if not player.Character then return false end
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
            if not targetRoot then return false end
            return (localRoot.Position - targetRoot.Position).Magnitude <= _range
        end

        local function _sendBless(player, humanoid)
            if not player or not humanoid then return end
            local infection = _getInfection(player)
            if infection < _threshold then return end
            local now = tick()
            if (_lastRequest[player] or 0) + _cooldown > now then return end
            if not _inRange(player) then return end
            local remote = _getRemote()
            if not remote then return end
            pcall(function()
                remote:FireServer("SendRequest", humanoid)
                _lastRequest[player] = now
            end)
        end

        local function _loop()
            while _active do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= lp and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            pcall(_sendBless, player, humanoid)
                        end
                    end
                end
                task.wait(0.5)
            end
        end

        function FEATURES.toggleChaplain(s)
            _active = s
            if s then
                if _thread then task.cancel(_thread) end
                _thread = task.spawn(_loop)
            else
                if _thread then task.cancel(_thread); _thread = nil end
                _lastRequest = {}
            end
        end

        function FEATURES.setChaplainThreshold(v)
            _threshold = v
        end
    end




    -- ===== 防护功能（移植自 Skin HUB v3.7） =====

    -- 1. 防红眼扑（完整移植3.7版，100线程+碰撞禁用+悬浮震动+清除Pin状态）
    do
        local _enabled = false
        local _floatHeight = 3
        local _floatAmplitude = 2.0
        local _floatFrequency = 1
        local _floatDuration = 1.0
        local _floatStartTime = 0
        local _suspendConn = nil
        local _isProcessing = false
        local _currentFloatPos = nil
        local _savedZombieCollisions = {}
        local _climbThreads = {}
        local _climbThreadsActive = false
        local _monitorThread = nil
        local CLIMB_THREAD_COUNT = 100
        local CLIMB_WAIT_TIME = 0.0000001

        local function _getHRP()
            local ch = lp.Character
            return ch and ch:FindFirstChild("HumanoidRootPart")
        end

        local function _disableZombieCollision()
            _savedZombieCollisions = {}
            local zombiesFolder = workspace:FindFirstChild("Zombies")
            if not zombiesFolder then return end
            for _, zombie in ipairs(zombiesFolder:GetDescendants()) do
                if zombie:IsA("BasePart") and zombie.Parent and zombie.Parent:IsA("Model") and zombie.Parent.Name == "m_Zombie" then
                    if not _savedZombieCollisions[zombie] then
                        _savedZombieCollisions[zombie] = {
                            CanCollide = zombie.CanCollide,
                            CanTouch = zombie.CanTouch,
                            CanQuery = zombie.CanQuery
                        }
                        zombie.CanCollide = false
                        zombie.CanTouch = false
                        zombie.CanQuery = false
                    end
                end
            end
        end

        local function _enableZombieCollision()
            for part, props in pairs(_savedZombieCollisions) do
                if part and part.Parent then
                    part.CanCollide = props.CanCollide
                    part.CanTouch = props.CanTouch
                    part.CanQuery = props.CanQuery
                end
            end
            _savedZombieCollisions = {}
        end

        local function _startFastClimb()
            if _climbThreadsActive then return end
            _climbThreadsActive = true
            for i = 1, CLIMB_THREAD_COUNT do
                local thread = task.spawn(function()
                    while _climbThreadsActive do
                        local ch = lp.Character
                        if ch then
                            local hum = ch:FindFirstChildOfClass("Humanoid")
                            if hum then
                                hum:ChangeState(Enum.HumanoidStateType.Climbing)
                            end
                        end
                        task.wait(CLIMB_WAIT_TIME)
                    end
                end)
                table.insert(_climbThreads, thread)
            end
        end

        local function _stopFastClimb()
            _climbThreadsActive = false
            for _, thread in ipairs(_climbThreads) do
                task.cancel(thread)
            end
            _climbThreads = {}
        end

        local function _isPinned()
            local ws = workspace:FindFirstChild("Players")
            local folder = ws and ws:FindFirstChild(lp.Name)
            local states = folder and folder:FindFirstChild("UserStates")
            local pinVal = states and states:FindFirstChild("Pin")
            return pinVal and tostring(pinVal.Value) ~= "None"
        end

        local function _stopSuspend()
            if _suspendConn then
                _suspendConn:Disconnect()
                _suspendConn = nil
            end
        end

        local function _startFloat(basePos)
            if _suspendConn then return end
            _floatStartTime = tick()
            _currentFloatPos = basePos
            _suspendConn = RunService.RenderStepped:Connect(function()
                if not _isProcessing then return end
                local hrp = _getHRP()
                if not hrp then return end
                local elapsed = tick() - _floatStartTime
                if elapsed >= _floatDuration then
                    _stopFastClimb()
                    _enableZombieCollision()
                    _isProcessing = false
                    _stopSuspend()
                    return
                end
                local t = elapsed * math.pi * 2
                local offsetY = math.sin(t) * _floatAmplitude
                local targetY = _currentFloatPos.Y + offsetY
                local targetPos = Vector3.new(_currentFloatPos.X, targetY, _currentFloatPos.Z)
                hrp.CFrame = CFrame.new(targetPos) * (hrp.CFrame - hrp.CFrame.Position)
                hrp.Velocity = Vector3.zero
                hrp.AssemblyLinearVelocity = Vector3.zero
            end)
        end

        local function _doFullTeleport()
            if _isProcessing then
                _stopSuspend()
                _stopFastClimb()
                _enableZombieCollision()
                _isProcessing = false
            end
            _isProcessing = true
            _startFastClimb()
            _disableZombieCollision()

            while _enabled and _isPinned() do
                local hrp = _getHRP()
                if not hrp then break end
                local origPos = hrp.Position
                pcall(function() hrp.CFrame = CFrame.new(origPos + Vector3.new(0, 5000000000, 0)) end)
                while _enabled and _isPinned() do
                    task.wait()
                end
                if not _enabled then break end
                local targetPos = origPos + Vector3.new(0, _floatHeight, 0)
                pcall(function() hrp.CFrame = CFrame.new(targetPos) end)

                local ws = workspace:FindFirstChild("Players")
                local folder = ws and ws:FindFirstChild(lp.Name)
                local states = folder and folder:FindFirstChild("UserStates")
                local pinVal = states and states:FindFirstChild("Pin")
                if pinVal then
                    pcall(function() pinVal.Value = "None" end)
                end

                if not _isPinned() then
                    break
                end
            end

            if not _enabled then
                _enableZombieCollision()
                _isProcessing = false
                _stopFastClimb()
                return
            end
            if _floatHeight <= 0 then
                _enableZombieCollision()
                _isProcessing = false
                _stopFastClimb()
                return
            end
            local hrp = _getHRP()
            if hrp then
                local basePos = hrp.Position
                _startFloat(basePos)
            else
                _enableZombieCollision()
                _isProcessing = false
                _stopFastClimb()
            end
        end

        local function _startMonitor()
            if _monitorThread then return end
            _monitorThread = task.spawn(function()
                local lastPinned = false
                while true do
                    task.wait(0.05)
                    if not _enabled then
                        lastPinned = false
                        continue
                    end
                    local isPinned = _isPinned()
                    if isPinned and not lastPinned then
                        task.spawn(_doFullTeleport)
                    end
                    lastPinned = isPinned
                end
            end)
        end

        local function _stopMonitor()
            if _monitorThread then
                task.cancel(_monitorThread)
                _monitorThread = nil
            end
        end

        function FEATURES.toggleAutoEscape(s)
            _enabled = s
            if s then
                _startMonitor()
            else
                _enabled = false
                _stopMonitor()
                _isProcessing = false
                _stopSuspend()
                _stopFastClimb()
                _enableZombieCollision()
            end
        end

        function FEATURES.setFloatHeight(v)
            _floatHeight = v
        end
    end

    -- 2. 防骨折
    do
        local _enabled = false
        local _active = false
        local _conn = nil
        local _UIS = game:GetService("UserInputService")

        function FEATURES.toggleFallProtect(s)
            _enabled = s
            if s then
                if not _conn then
                    _conn = RunService.Stepped:Connect(function()
                        if not _enabled then
                            if _active then _active = false end
                            return
                        end
                        local ch = lp.Character
                        if not ch then
                            if _active then _active = false end
                            return
                        end
                        local hu = ch:FindFirstChildOfClass("Humanoid")
                        local r = ch:FindFirstChild("HumanoidRootPart")
                        if not hu or not r then
                            if _active then _active = false end
                            return
                        end
                        local should = r.Velocity.Y < -5 and not _UIS:IsKeyDown(Enum.KeyCode.Space)
                        if should and not _active then
                            _active = true
                            task.spawn(function()
                                while _active and _enabled do
                                    local c2 = lp.Character
                                    if c2 then
                                        local h2 = c2:FindFirstChildOfClass("Humanoid")
                                        if h2 then h2:ChangeState(Enum.HumanoidStateType.Climbing) end
                                    end
                                    task.wait()
                                end
                            end)
                        elseif not should and _active then
                            _active = false
                        end
                    end)
                end
            else
                if _conn then _conn:Disconnect(); _conn = nil end
                _active = false
            end
        end
    end

    -- 3. 显示受伤伤害
    do
        local _enabled = false
        local _lh = nil
        local _hc = nil
        local _cc = nil
        local _bb = nil
        local _tl = nil

        local function _destroyBillboard()
            if _bb then _bb:Destroy() end
            _bb = nil; _tl = nil
        end

        local function _ensureBillboard()
            if _bb and _bb.Parent then return end
            local ch = lp.Character
            if not ch then return end
            local hd = ch:FindFirstChild("Head")
            if not hd then return end
            _bb = Instance.new("BillboardGui")
            _bb.Size = UDim2.new(0,100,0,50)
            _bb.StudsOffset = Vector3.new(0,2.5,0)
            _bb.AlwaysOnTop = true
            _bb.Adornee = hd
            _bb.Parent = ch
            _tl = Instance.new("TextLabel")
            _tl.Size = UDim2.new(1,0,1,0)
            _tl.BackgroundTransparency = 1
            _tl.Text = ""
            _tl.TextSize = 30
            _tl.Font = Enum.Font.GothamBold
            _tl.TextStrokeTransparency = 0.2
            _tl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            _tl.Parent = _bb
            _bb.Enabled = false
        end

        local function _showDamage(dmg)
            if not _enabled then return end
            _ensureBillboard()
            if not _bb then return end
            local col
            if dmg < 20 then
                col = Color3.fromRGB(0,255,0)
            elseif dmg < 50 then
                col = Color3.fromRGB(255,255,0)
            else
                col = Color3.fromRGB(255,0,0)
            end
            _tl.Text = tostring(math.floor(dmg))
            _tl.TextColor3 = col
            _bb.Enabled = true
            _tl.TextTransparency = 0
            task.delay(1, function()
                if _tl then _tl.TextTransparency = 1; task.wait(0.25) end
                if _bb then _bb.Enabled = false end
            end)
        end

        local function _onHealthChanged()
            local c2 = lp.Character
            if not c2 then return end
            local h2 = c2:FindFirstChildOfClass("Humanoid")
            if not h2 then return end
            local cur = h2.Health
            if _lh == nil then _lh = cur; return end
            local d = _lh - cur
            if d > 0 then _showDamage(d) end
            _lh = cur
        end

        function FEATURES.toggleDamageDisplay(s)
            _enabled = s
            if s then
                if _hc then _hc:Disconnect() end
                if _cc then _cc:Disconnect() end
                local ch = lp.Character
                if ch then
                    local hu = ch:FindFirstChildOfClass("Humanoid")
                    if hu then
                        _lh = hu.Health
                        _hc = hu:GetPropertyChangedSignal("Health"):Connect(_onHealthChanged)
                    end
                end
                _cc = lp.CharacterAdded:Connect(function(ch)
                    task.wait(0.2)
                    local hu = ch:FindFirstChildOfClass("Humanoid")
                    if hu then
                        if _hc then _hc:Disconnect() end
                        _lh = hu.Health
                        _hc = hu:GetPropertyChangedSignal("Health"):Connect(_onHealthChanged)
                    end
                    _destroyBillboard()
                    _ensureBillboard()
                end)
            else
                if _hc then _hc:Disconnect(); _hc = nil end
                if _cc then _cc:Disconnect(); _cc = nil end
                _destroyBillboard()
                _lh = nil
            end
        end
    end

    -- 4. 肘击自救
    do
        local _enabled = false
        local _th = nil
        local _wpns = {"Axe", "Baguette", "Pickaxe"}

        local function _getZombies()
            local ch = lp.Character
            if not ch then return {} end
            local r = ch:FindFirstChild("HumanoidRootPart")
            if not r then return {} end
            local zf = workspace:FindFirstChild("Zombies")
            if not zf then return {} end
            local list = {}
            for _, z in ipairs(zf:GetChildren()) do
                if z:IsA("Model") then
                    local zh = z:FindFirstChild("HumanoidRootPart") or z:FindFirstChild("Torso")
                    if zh and (zh.Position - r.Position).Magnitude <= 6 then
                        table.insert(list, z)
                    end
                end
            end
            return list
        end

        local function _doElbow(z)
            local zh = z:FindFirstChild("HumanoidRootPart") or z:FindFirstChild("Torso")
            if not zh then return end
            local w = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
            if not w then return end
            local re = w:FindFirstChild("RemoteEvent")
            if not re then return end
            pcall(function()
                re:FireServer("BraceBlock")
                re:FireServer("StopBraceBlock")
                re:FireServer("FeedbackStun", z, zh.Position)
            end)
        end

        local function _getBestWeapon()
            local bp = lp:FindFirstChild("Backpack")
            if not bp then return nil end
            for _, n in ipairs(_wpns) do
                local t = bp:FindFirstChild(n)
                if t and t:IsA("Tool") then return t end
            end
            return nil
        end

        function FEATURES.toggleElbowSave(s)
            _enabled = s
            if s then
                if _th then task.cancel(_th) end
                _th = task.spawn(function()
                    while _enabled do
                        local zombies = _getZombies()
                        if #zombies > 0 then
                            local w = _getBestWeapon()
                            if w and w.Parent ~= lp.Character then
                                w.Parent = lp.Character
                                task.wait(0.02)
                            end
                            for _, z in ipairs(zombies) do
                                _doElbow(z)
                            end
                        end
                        task.wait(0.3)
                    end
                end)
            else
                if _th then task.cancel(_th); _th = nil end
                local ch = lp.Character
                if ch then
                    for _, n in ipairs(_wpns) do
                        local t = ch:FindFirstChild(n)
                        if t then t.Parent = lp.Backpack end
                    end
                end
            end
        end
    end

    -- 6. 自爆拉扯
    do
        local _enabled = false
        local _size = 10
        local _th = nil

        local function _getRadiiHR()
            local f = _size / 10
            local h = math.clamp(16 * f, 5, 25)
            local v = math.clamp(5 * f, 2, 8)
            return h, v
        end

        local function _isBarrel(z)
            return z:GetAttribute("Type") == "Barrel" or z:FindFirstChild("Barrel")
        end

        local function _getBarrelPositions()
            local list = {}
            local zf = workspace:FindFirstChild("Zombies")
            if not zf then return list end
            for _, z in ipairs(zf:GetChildren()) do
                if z:IsA("Model") and _isBarrel(z) then
                    local zh = z:FindFirstChild("HumanoidRootPart") or z:FindFirstChild("Torso") or z:FindFirstChild("Head")
                    if zh then table.insert(list, zh.Position) end
                end
            end
            return list
        end

        function FEATURES.togglePushBarrel(s)
            _enabled = s
            if s then
                if _th then task.cancel(_th) end
                _th = task.spawn(function()
                    while _enabled do
                        local ch = lp.Character
                        if not ch then task.wait(0.05); continue end
                        local r = ch:FindFirstChild("HumanoidRootPart")
                        if not r then task.wait(0.05); continue end
                        local hR, vR = _getRadiiHR()
                        for _, center in ipairs(_getBarrelPositions()) do
                            local dx = r.Position.X - center.X
                            local dy = r.Position.Y - center.Y
                            local dz = r.Position.Z - center.Z
                            local inRange = (dx*dx+dz*dz)/(hR*hR) + (dy*dy)/(vR*vR) < 1
                            if inRange then
                                local delta = r.Position - center
                                if math.abs(delta.Y) > 3 then
                                    local hD = Vector3.new(delta.X, 0, delta.Z)
                                    if hD.Magnitude < 0.001 then
                                        hD = Vector3.new(1, 0, 0)
                                    else
                                        hD = hD.Unit
                                    end
                                    r.Velocity = Vector3.new(hD.X * 85, r.Velocity.Y, hD.Z * 85)
                                else
                                    local d = delta.Unit
                                    if d.Magnitude < 0.001 then d = Vector3.new(1, 0, 0) end
                                    r.Velocity = d * 45 + Vector3.new(0, 15, 0)
                                end
                                break
                            end
                        end
                        task.wait(0.05)
                    end
                end)
            else
                if _th then task.cancel(_th); _th = nil end
            end
        end

        function FEATURES.setPushBarrelSize(v)
            _size = v
        end
    end

    -- ===== 帧率提升功能 =====

    do
        local _enabled = false
        local _conn = nil

        function FEATURES.toggleFpsFire(s)
            _enabled = s
            if s then
                for _, o in ipairs(workspace:GetDescendants()) do
                    if o:IsA("ParticleEmitter") and o.Name:lower():find("fire") then
                        o.Enabled = false; o.Rate = 0
                    end
                end
                if not _conn then
                    _conn = workspace.DescendantAdded:Connect(function(d)
                        if d:IsA("ParticleEmitter") and d.Name:lower():find("fire") then
                            d.Enabled = false; d.Rate = 0
                        end
                    end)
                end
            else
                if _conn then _conn:Disconnect(); _conn = nil end
                for _, o in ipairs(workspace:GetDescendants()) do
                    if o:IsA("ParticleEmitter") and o.Name:lower():find("fire") then
                        o.Enabled = true; o.Rate = 20
                    end
                end
            end
        end
    end

    function FEATURES.fpsRemoveCarriage()
        local n = 0
        local targets = {"Carriage", "RearCarriage", "WagonPlatform", "FL_Wheel", "Horse", "Behind"}
        for _, nm in ipairs(targets) do
            for _, o in ipairs(workspace:GetDescendants()) do
                if o.Name == nm then
                    pcall(function() o:Destroy(); n = n + 1 end)
                end
            end
        end
        if type(WindUI) == "table" and type(WindUI.Notify) == "function" then
            WindUI:Notify({Title="帧率提升", Content="已移除马车 ("..n.."个模型)", Duration=3})
        end
    end

    function FEATURES.fpsExtremeSimplify()
        local l = game:GetService("Lighting")
        l.GlobalShadows = false
        l.Technology = Enum.Technology.Compatibility
        for _, o in ipairs(workspace:GetDescendants()) do
            if o:IsA("Decal") or o:IsA("Texture") then
                pcall(function() o:Destroy() end)
            elseif o:IsA("BasePart") then
                o.CastShadow = false
                o.Material = Enum.Material.SmoothPlastic
                if o:IsA("MeshPart") then o.TextureID = "" end
            end
        end
        if type(WindUI) == "table" and type(WindUI.Notify) == "function" then
            WindUI:Notify({Title="帧率提升", Content="已变成迷你世界画质", Duration=3})
        end
    end

    do
        function FEATURES.fpsSetBrightness(v)
            local m = math.clamp(v / 10, 0.05, 5)
            local l = game:GetService("Lighting")
            l.Brightness = l.Brightness * m
            l.Ambient = l.Ambient * m
            l.OutdoorAmbient = l.OutdoorAmbient * m
        end
    end

    function FEATURES.fpsRemoveHats()
        local n = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                for _, o in ipairs(p.Character:GetChildren()) do
                    if o:IsA("Accessory") then
                        pcall(function() o:Destroy(); n = n + 1 end)
                    end
                end
            end
        end
        if type(WindUI) == "table" and type(WindUI.Notify) == "function" then
            WindUI:Notify({Title="帧率提升", Content="已删除 "..n.." 个帽子", Duration=2})
        end
    end

    function FEATURES.fpsRemoveShirts()
        local n = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                for _, o in ipairs(p.Character:GetChildren()) do
                    if o:IsA("Shirt") or o:IsA("ShirtGraphic") then
                        pcall(function() o:Destroy(); n = n + 1 end)
                    end
                end
            end
        end
        if type(WindUI) == "table" and type(WindUI.Notify) == "function" then
            WindUI:Notify({Title="帧率提升", Content="已删除 "..n.." 件上衣", Duration=2})
        end
    end

    function FEATURES.fpsRemovePants()
        local n = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                for _, o in ipairs(p.Character:GetChildren()) do
                    if o:IsA("Pants") then
                        pcall(function() o:Destroy(); n = n + 1 end)
                    end
                end
            end
        end
        if type(WindUI) == "table" and type(WindUI.Notify) == "function" then
            WindUI:Notify({Title="帧率提升", Content="已删除 "..n.." 条裤子", Duration=2})
        end
    end

    -- ===== 娱乐新增功能 =====

    do
        local _enabled = false
        local _speed = 3
        local _conn = nil
        local _tilt = 0

        function FEATURES.toggleStutter(s)
            _enabled = s
            if s then
                if not _conn then
                    _conn = RunService.RenderStepped:Connect(function(dt)
                        if not _enabled then return end
                        _tilt = _tilt + dt * _speed * 10
                        local ch = lp.Character
                        if not ch then return end
                        local h = ch:FindFirstChild("HumanoidRootPart")
                        if not h then return end
                        h.CFrame = h.CFrame * CFrame.Angles(0, 0, math.sin(_tilt) * 0.15)
                    end)
                end
            else
                if _conn then _conn:Disconnect(); _conn = nil end
                _tilt = 0
            end
        end

        function FEATURES.setStutterSpeed(v)
            _speed = v
        end
    end

    do
        local _enabled = false
        local _conn = nil

        local function _lockJP()
            local hu = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
            if hu then
                hu.JumpPower = 30
                if _conn then _conn:Disconnect() end
                _conn = hu:GetPropertyChangedSignal("JumpPower"):Connect(function()
                    if hu.JumpPower ~= 30 then hu.JumpPower = 30 end
                end)
            end
        end

        local function _unlockJP()
            if _conn then _conn:Disconnect(); _conn = nil end
            local hu = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
            if hu then hu.JumpPower = 16 end
        end

        function FEATURES.toggleRemoveJumpLimit(s)
            _enabled = s
            if s then _lockJP() else _unlockJP() end
        end

        lp.CharacterAdded:Connect(function()
            if _enabled then task.wait(0.2); _lockJP() end
        end)
    end

    -- 击杀音效
    do
        local _enabled = false
        local _vol = 7
        local _th = nil
        local _lc = 0

        local function _getKills()
            local ls = lp:FindFirstChild("leaderstats")
            if ls then
                local k = ls:FindFirstChild("Kills")
                if k and (k:IsA("IntValue") or k:IsA("NumberValue")) then
                    return k.Value
                end
            end
            return 0
        end

        function FEATURES.toggleKillSound(s)
            _enabled = s
            if s then
                _lc = _getKills()
                if _th then task.cancel(_th) end
                _th = task.spawn(function()
                    while _enabled do
                        local cur = _getKills()
                        if cur > _lc then
                            for i = 1, cur - _lc do
                                local snd = Instance.new("Sound")
                                snd.SoundId = "rbxassetid://5700183626"
                                snd.Volume = _vol / 10
                                snd.Parent = workspace
                                snd:Play()
                                snd.Ended:Connect(function() snd:Destroy() end)
                                task.delay(0.5, function()
                                    if snd and snd.Parent then snd:Destroy() end
                                end)
                            end
                            _lc = cur
                        elseif cur < _lc then
                            _lc = cur
                        end
                        task.wait(0.1)
                    end
                end)
            else
                if _th then task.cancel(_th); _th = nil end
            end
        end

        function FEATURES.setKillSoundVol(v)
            _vol = v
        end

        lp.CharacterAdded:Connect(function()
            if _enabled then _lc = _getKills() end
        end)
    end

    -- ===== 地图自动新增功能 =====

    -- 自动水桶灭火
    do
        local _enabled = false
        local _conn = nil

        function FEATURES.toggleAutoBucket(s)
            _enabled = s
            if s then
                if not _conn then
                    _conn = RunService.Heartbeat:Connect(function()
                        if not _enabled then return end
                        local ch = lp.Character
                        if not ch then return end
                        local b = ch:FindFirstChild("Water Bucket") or lp.Backpack:FindFirstChild("Water Bucket")
                        if b then
                            if b.Parent ~= ch then b.Parent = ch; task.wait(0.1) end
                            local re = b:FindFirstChild("RemoteEvent")
                            if re then
                                pcall(function() re:FireServer("Throw") end)
                                task.spawn(function()
                                    task.wait(0.2)
                                    if b and b.Parent == ch then b.Parent = lp.Backpack end
                                end)
                            end
                        end
                    end)
                end
            else
                if _conn then _conn:Disconnect(); _conn = nil end
            end
        end
    end

    -- 自动打伦敦四块木板
    do
        local _enabled = false
        local _londonThread = nil
        local _REF = Vector3.new(-149.42, 31.08, -1354.90)

        local function _getRe()
            local ch = lp.Character
            if not ch then return nil end
            for _, t in ipairs(ch:GetChildren()) do
                if t:IsA("Tool") then
                    local r = t:FindFirstChild("RemoteEvent")
                    if r then return r end
                end
            end
            return nil
        end

        local function _doHit()
            local re = _getRe()
            if not re then return end
            local ok, lb, rb = pcall(function()
                return workspace.London.Modes.Objective.SniperSection.BarricadedDoors.Left.Boards,
                       workspace.London.Modes.Objective.SniperSection.BarricadedDoors.Right.Boards
            end)
            if not ok or not lb or not rb then return end
            pcall(function() re:FireServer("PrepareSwing"); re:FireServer("Swing","Over") end)
            -- Left boards
            for _, k in ipairs(lb:GetChildren()) do
                if k:IsA("BasePart") then
                    pcall(function()
                        re:FireServer("HitCon", k, Vector3.new(-149.4207611084,31.076683044434,-1354.8972167969), Vector3.new(-2.0772218704224e-05,1,7.62939453125e-05))
                        re:FireServer("HitCon", k, Vector3.new(-149.55505371094,29.676874160767,-1354.62890625), Vector3.new(-0.94289720058441,5.8412551879883e-06,-0.33308377861977))
                        re:FireServer("HitCon", k, Vector3.new(-150.27769470215,29.679218292236,-1351.9827880859), Vector3.new(0.94289720058441,-5.8412551879883e-06,0.33308377861977))
                    end)
                end
            end
            -- Right boards
            for _, k in ipairs(rb:GetChildren()) do
                if k:IsA("BasePart") then
                    pcall(function()
                        re:FireServer("HitCon", k, Vector3.new(-145.2381439209,33.006237030029,-1366.2482910156), Vector3.new(0.9428722858429,7.62939453125e-05,0.33315423130989))
                        re:FireServer("HitCon", k, Vector3.new(-146.18898010254,32.863513946533,-1363.5573730469), Vector3.new(0.9428722858429,7.62939453125e-05,0.33315423130989))
                    end)
                end
            end
        end

        function FEATURES.toggleLondonBoard(s)
            _enabled = s
            if s then
                if _th then task.cancel(_th) end
                _th = task.spawn(function()
                    while _enabled do
                        local ch = lp.Character
                        if ch then
                            local r = ch:FindFirstChild("HumanoidRootPart")
                            if r and (r.Position - _REF).Magnitude <= 7 then
                                _doHit()
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            else
                if _th then task.cancel(_th); _th = nil end
            end
        end
    end

    -- 火炮物资透视
    do
        local _enabled = false
        local _conn = nil
        local _marks = {}
        local _names = {"Cannonball", "CannonBall", "RoundShot", "Roundshot", "Swab", "PowderCharge", "Powder"}

        local function _clear()
            for _, m in ipairs(_marks) do
                pcall(function() m:Destroy() end)
            end
            _marks = {}
        end

        local function _update()
            _clear()
            if not _enabled then return end
            for _, nm in ipairs(_names) do
                for _, o in ipairs(workspace:GetDescendants()) do
                    if o.Name == nm and o:IsA("BasePart") and o.Transparency < 1 then
                        local h = Instance.new("Highlight")
                        h.Adornee = o
                        h.FillColor = Color3.fromRGB(255, 255, 0)
                        h.FillTransparency = 0.5
                        h.OutlineTransparency = 0
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = o
                        table.insert(_marks, h)
                    end
                end
            end
        end

        function FEATURES.toggleCannonSupplies(s)
            _enabled = s
            if s then
                _update()
                if not _conn then
                    _conn = workspace.DescendantAdded:Connect(function()
                        if _enabled then _update() end
                    end)
                end
            else
                _clear()
                if _conn then _conn:Disconnect(); _conn = nil end
            end
        end
    end

    -- ===== 莱比锡 =====
    do
        local _fs = 37
        function FEATURES.setLeipzigFlySpeed(v)
            _fs = v
        end
        function FEATURES.toggleAutoLeipzig(s)
            -- 完整飞行路径逻辑待从 Skin HUB v3.7 移植
        end
        function FEATURES.togglePathVisuals(s)
        end
    end


    -- ===== 军官功能（移植自 Skin HUB ） =====
    do
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        local StarterGui = game:GetService("StarterGui")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        -- ==================== Auto Reload Module ====================
        local _AR_ENABLED = false
        local _AR_NOTIFY_CD = 4
        local _AR_lastNotify = 0
        local _AR_monitored = {}
        local _AR_HOLSTER = false
        local _AR_holstering = false

        local function _ar_isGun(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local af = tool:FindFirstChild("Animations")
            if not af then return false end
            return af:FindFirstChild("Aim") ~= nil or af:FindFirstChild("Aiming") ~= nil
        end

        local function _ar_getShots(tool)
            if not tool then return 0 end
            local s = tool:FindFirstChild("ShotsLoaded")
            if s and (s:IsA("IntValue") or s:IsA("NumberValue")) then return s.Value end
            local ws = Workspace:FindFirstChild("Players")
            if ws then
                local pf = ws:FindFirstChild(LocalPlayer.Name)
                if pf then
                    local tf = pf:FindFirstChild(tool.Name)
                    if tf then
                        local sh = tf:FindFirstChild("ShotsLoaded")
                        if sh and (sh:IsA("IntValue") or sh:IsA("NumberValue")) then return sh.Value end
                    end
                end
            end
            return 0
        end

        local function _ar_getRemote(tool)
            if not tool then return nil end
            local r = tool:FindFirstChild("RemoteEvent")
            if r then return r end
            local ws = Workspace:FindFirstChild("Players")
            if ws then
                local pf = ws:FindFirstChild(LocalPlayer.Name)
                if pf then
                    local tf = pf:FindFirstChild(tool.Name)
                    if tf then return tf:FindFirstChild("RemoteEvent") end
                end
            end
            return nil
        end

        local function _ar_notify()
            local now = tick()
            if now - _AR_lastNotify < _AR_NOTIFY_CD then return end
            _AR_lastNotify = now
            pcall(function()
                if type(WindUI) == "table" and type(WindUI.Notify) == "function" then
                    WindUI:Notify({ Title = "自动装填", Content = "已装填一发子弹。", Duration = 3, Icon = "refresh-cw" })
                elseif type(Window) == "table" and type(Window.Notify) == "function" then
                    Window:Notify({ Title = "自动装填", Content = "已装填一发子弹。", Duration = 3, Icon = "refresh-cw" })
                else
                    pcall(function() StarterGui:SetCore("SendNotification", { Title = "自动装填", Text = "已装填一发子弹。", Duration = 3 }) end)
                end
            end)
            if _AR_HOLSTER and not _AR_holstering then
                _AR_holstering = true
                task.spawn(function()
                    local char = LocalPlayer.Character
                    if not char then _AR_holstering = false; return end
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and _ar_isGun(tool) then
                        tool.Parent = LocalPlayer.Backpack
                        task.wait(0.05)
                        if tool and tool.Parent == LocalPlayer.Backpack then
                            tool.Parent = char
                        end
                    end
                    task.wait(0.05)
                    _AR_holstering = false
                end)
            end
        end

        local function _ar_tryReload(tool)
            if not _AR_ENABLED then return end
            if not tool or not tool.Parent then return end
            if not _ar_isGun(tool) then return end
            if _ar_getShots(tool) == 0 then
                local r = _ar_getRemote(tool)
                if r then pcall(function() r:FireServer("Reload") end) end
            end
        end

        local function _ar_cleanup(tool)
            if _AR_monitored[tool] then
                local c = _AR_monitored[tool]
                if c.sc then c.sc:Disconnect() end
                if c.ac then c.ac:Disconnect() end
                _AR_monitored[tool] = nil
            end
        end

        local function _ar_cleanupAll()
            for t, _ in pairs(_AR_monitored) do _ar_cleanup(t) end
            _AR_monitored = {}
        end

        local function _ar_watch(tool)
            if not tool or not _ar_isGun(tool) then return end
            if _AR_monitored[tool] then return end
            local so = tool:FindFirstChild("ShotsLoaded")
            if not so or not (so:IsA("IntValue") or so:IsA("NumberValue")) then
                local ws = Workspace:FindFirstChild("Players")
                if ws then
                    local pf = ws:FindFirstChild(LocalPlayer.Name)
                    if pf then
                        local tf = pf:FindFirstChild(tool.Name)
                        if tf then so = tf:FindFirstChild("ShotsLoaded") end
                    end
                end
            end
            if not so then return end
            local remote = _ar_getRemote(tool)
            local prev = so.Value or 0
            if _AR_ENABLED and prev == 0 and remote then
                pcall(function() remote:FireServer("Reload") end)
            end
            local deb = false
            local sc = so.Changed:Connect(function()
                local v = so.Value
                if _AR_ENABLED and type(v) == "number" and type(prev) == "number" and v > prev then
                    for _ = prev + 1, v do task.spawn(_ar_notify) end
                end
                if _AR_ENABLED and v == 0 and remote and not deb then
                    deb = true; pcall(function() remote:FireServer("Reload") end)
                    task.delay(1.2, function() deb = false end)
                end
                prev = v
            end)
            local ac = tool.AncestryChanged:Connect(function()
                if tool.Parent == LocalPlayer.Character and _AR_ENABLED then _ar_tryReload(tool) end
            end)
            tool.AncestryChanged:Connect(function(_, parent)
                if not parent then _ar_cleanup(tool) end
            end)
            _AR_monitored[tool] = { sc = sc, ac = ac }
        end

        local function _ar_scanAll()
            _ar_cleanupAll()
            for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if t:IsA("Tool") and _ar_isGun(t) then _ar_watch(t) end
            end
            local char = LocalPlayer.Character
            if char then
                for _, t in ipairs(char:GetChildren()) do
                    if t:IsA("Tool") and _ar_isGun(t) then _ar_watch(t) end
                end
            end
        end

        local function _ar_doEnable()
            _ar_scanAll()
            local char = LocalPlayer.Character
            if char then
                for _, t in ipairs(char:GetChildren()) do
                    if t:IsA("Tool") and _ar_isGun(t) then _ar_tryReload(t) end
                end
            end
        end

        local function _ar_onRespawn()
            task.wait(1)
            if _AR_ENABLED then _ar_doEnable() end
        end

        LocalPlayer.Backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and _ar_isGun(child) then
                task.wait(0.1)
                if _AR_ENABLED then _ar_watch(child) end
            end
        end)

        if LocalPlayer.Character then
            LocalPlayer.Character.ChildAdded:Connect(function(child)
                if child:IsA("Tool") and _ar_isGun(child) then
                    task.wait(0.1)
                    if _AR_ENABLED then _ar_watch(child); _ar_tryReload(child) end
                end
            end)
        end

        LocalPlayer.CharacterAdded:Connect(_ar_onRespawn)
        _ar_scanAll()

        -- ==================== Auto Black Gun Core Utilities ====================
        local _bgEnabled = false
        local _bgSmooth = 0.28
        local _bgCooldown = 0.1
        local _bgEquipDelay = 0.2
        local _bgBarrelDist = 14
        local _bgThread = nil
        local _bgWallCheck = true
        local _bgMaxRange = 200

        local _ZombieMatchers = {
            Bomber = function(m) return m:FindFirstChild("Barrel") ~= nil end,
            Cuirassier = function(m) return m:FindFirstChild("Sword") ~= nil end,
            Runner = function(m) return m:FindFirstChild("Eye") and not m:FindFirstChild("Axe") and m:FindFirstChild("Head") end,
            Electrocutioner = function(m) return m:FindFirstChild("Axe") and m:FindFirstChild("Head") end,
        }

        local function _bg_isBlocked(origin, targetPos, targetModel)
            if not _bgWallCheck then return false end
            if not origin or not targetPos then return false end
            local dir = targetPos - origin; local dist = dir.Magnitude
            if dist <= 0 then return false end
            local function buildIgn()
                local ign = {}
                local cf = Workspace:FindFirstChild("Camera")
                if cf then for _, d in ipairs(cf:GetDescendants()) do if d and d:IsA("Model") and d.Name == "m_Zombie" then table.insert(ign, d) end end end
                local zf = Workspace:FindFirstChild("Zombies")
                if zf then table.insert(ign, zf) end
                for _, p in ipairs(Players:GetPlayers()) do if p and p.Character and p.Character:IsA("Model") then table.insert(ign, p.Character) end end
                if targetModel then table.insert(ign, targetModel) end
                return ign
            end
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Blacklist
            params.FilterDescendantsInstances = buildIgn()
            local dirU = dir.Unit; local remaining = dist; local originPos = origin
            for _ = 1, 12 do
                local ok, res = pcall(function() return Workspace:Raycast(originPos, dirU * remaining, params) end)
                if not ok or not res then return false end
                local h = res.Instance; if not h then return false end
                if targetModel and h:IsDescendantOf(targetModel) then return false end
                local bp = h:IsA("BasePart"); local cc = bp and h.CanCollide; local tr = bp and h.Transparency or 0
                if (not cc) or (bp and tr >= 0.95) then
                    local adv = res.Position + dirU * 0.2
                    if (adv - origin).Magnitude >= dist - 1e-4 then return false end
                    originPos = adv; remaining = (targetPos - originPos).Magnitude
                    local l = params.FilterDescendantsInstances; table.insert(l, h); params.FilterDescendantsInstances = l
                else return true end
            end
            return true
        end

        local function _bg_findTarget(range, matcher)
            local cf = Workspace:FindFirstChild("Camera"); local cam = workspace.CurrentCamera
            local origin = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and LocalPlayer.Character.Head.Position or (cam and cam.CFrame.Position)
            if not origin then return nil, nil end; if not cf then return nil, nil end
            local bestP, bestD, bestM = nil, range + 0.0001, nil
            for _, m in ipairs(cf:GetChildren()) do
                if m:IsA("Model") and m.Name == "m_Zombie" and matcher(m) then
                    local head = m:FindFirstChild("Head"); local barrel = m:FindFirstChild("Barrel")
                    local torso = m:FindFirstChild("Torso") or m:FindFirstChild("UpperTorso") or m:FindFirstChild("HumanoidRootPart")
                    local mp = barrel or head or torso
                    if mp and mp:IsA("BasePart") then
                        local d = (mp.Position - origin).Magnitude
                        if d <= range + 0.0001 and d < bestD then
                            local bV, hV, tV = false, false, false
                            if barrel and barrel:IsA("BasePart") then local ok,v=pcall(function() return not _bg_isBlocked(origin, barrel.Position, m) end); if ok and v then bV=true end end
                            if head and head:IsA("BasePart") then local ok,v=pcall(function() return not _bg_isBlocked(origin, head.Position, m) end); if ok and v then hV=true end end
                            if torso and torso:IsA("BasePart") then local ok,v=pcall(function() return not _bg_isBlocked(origin, torso.Position, m) end); if ok and v then tV=true end end
                            local cp = bV and barrel or hV and head or tV and torso
                            if cp and cp:IsA("BasePart") then bestP = cp; bestD = d; bestM = m end
                        end
                    end
                end
            end
            return bestP, bestM
        end

        local function _bg_hasOtherPlayerNear(zombie, range)
            if not zombie or not zombie:FindFirstChild("HumanoidRootPart") then return false end
            local zp = zombie.HumanoidRootPart.Position
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (p.Character.HumanoidRootPart.Position - zp).Magnitude <= range then return true end
                end
            end
            return false
        end

        -- ==================== Simple Auto Black Gun (with animation) ====================
        local function _bg_playAnim(id, animator)
            if not id or not animator then return nil end
            local ok, track = pcall(function() local a = Instance.new("Animation"); a.AnimationId = id; return animator:LoadAnimation(a) end)
            if not ok or not track then return nil end
            track.Priority = Enum.AnimationPriority.Action; track:Play(0.05, 1, 1); return track
        end

        local function _bg_smoothLookAt(root, getPos, duration)
            if not root then return end; local st = tick(); local sf = root.CFrame
            local ok, it = pcall(getPos); if not ok or not it then return end
            while tick() - st < duration do
                if not root.Parent then return end
                local cu = nil; pcall(function() cu = getPos() end); if not cu then cu = it end
                local d = CFrame.new(root.Position, Vector3.new(cu.X, root.Position.Y, cu.Z))
                local t = math.clamp((tick() - st) / duration, 0, 1); local sm = t * t * (3 - 2 * t)
                pcall(function() root.CFrame = sf:Lerp(d, sm) end); RunService.RenderStepped:Wait() end
            local fi = nil; pcall(function() fi = getPos() end)
            if fi then pcall(function() root.CFrame = CFrame.new(root.Position, root.Position + CFrame.new(root.Position, Vector3.new(fi.X, root.Position.Y, fi.Z)).LookVector) end) end
        end

        local function _bg_aimShoot(targetModel, initPart, tool)
            if not targetModel or not targetModel.Parent then return end
            if not initPart or not initPart.Parent or not initPart:IsA("BasePart") then return end
            if not tool or not tool.Parent or not tool:IsDescendantOf(LocalPlayer.Character) then return end
            local char = LocalPlayer.Character; if not char then return end
            local hu = char:FindFirstChildOfClass("Humanoid"); if not hu then return end
            local animator = hu:FindFirstChildOfClass("Animator") or Instance.new("Animator", hu)
            local af = tool:FindFirstChild("Animations")
            local aimId, aimingId, fireId = nil, nil, nil
            if af then
                local aim = af:FindFirstChild("Aim"); local aiming = af:FindFirstChild("Aiming"); local fire = af:FindFirstChild("Fire")
                if aim and aim:IsA("Animation") then aimId = aim.AnimationId end
                if aiming and aiming:IsA("Animation") then aimingId = aiming.AnimationId end
                if fire and fire:IsA("Animation") then fireId = fire.AnimationId end
            end
            aimId = aimId or "rbxassetid://83511222574103"
            aimingId = aimingId or "rbxassetid://136849639865723"
            local tA = _bg_playAnim(aimId, animator)
            if tA then task.wait(math.min(tA.Length or 0.6, 0.6)); pcall(function() tA:Stop(0.05) end) end
            local tB = _bg_playAnim(aimingId, animator)
            task.wait(0.02)
            local root = char:FindFirstChild("HumanoidRootPart")
            local curPart = initPart
            if root and targetModel and targetModel.Parent then
                local function getPos()
                    if not curPart or not curPart.Parent then
                        local barrel = targetModel:FindFirstChild("Barrel")
                        local head = targetModel:FindFirstChild("Head")
                        local torso = targetModel:FindFirstChild("Torso") or targetModel:FindFirstChild("UpperTorso") or targetModel:FindFirstChild("HumanoidRootPart")
                        local origin = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and LocalPlayer.Character.Head.Position or workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position
                        if barrel and barrel:IsA("BasePart") then local ok,v=pcall(function() return not _bg_isBlocked(origin, barrel.Position, targetModel) end); if ok and v then curPart=barrel; return barrel.Position end end
                        if head and head:IsA("BasePart") then local ok,v=pcall(function() return not _bg_isBlocked(origin, head.Position, targetModel) end); if ok and v then curPart=head; return head.Position end end
                        if torso and torso:IsA("BasePart") then local ok,v=pcall(function() return not _bg_isBlocked(origin, torso.Position, targetModel) end); if ok and v then curPart=torso; return torso.Position end end
                        return nil
                    end
                    if curPart and curPart.Parent then return curPart.Position end
                    return nil
                end
                pcall(function() _bg_smoothLookAt(root, getPos, _bgSmooth) end)
            else
                if tB then pcall(function() tB:Stop(0.1) end) end; return
            end
            local waited = 0; local TOUT = 3; local POLL = 0.05
            local shotsNow = _ar_getShots(tool)
            while (not shotsNow or shotsNow < 1) and waited < TOUT do
                if not tool or not tool.Parent or not tool:IsDescendantOf(LocalPlayer.Character) then if tB then pcall(function() tB:Stop(0.1) end) end; return end
                if not _bgEnabled then if tB then pcall(function() tB:Stop(0.1) end) end; return end
                task.wait(POLL); waited = waited + POLL; shotsNow = _ar_getShots(tool) end
            if not shotsNow or shotsNow < 1 then if tB then pcall(function() tB:Stop(0.1) end) end; return end
            task.wait(0.03)
            local fire = nil; if fireId then pcall(function() fire = _bg_playAnim(fireId, animator) end) end
            pcall(function()
                local mr = char:FindFirstChild("Model") or char
                local ts = workspace:GetServerTimeNow()
                local remote = _ar_getRemote(tool)
                if remote and curPart and curPart.Parent then remote:FireServer("Fire", mr, curPart.Position, ts) end end)
            if fire then task.delay(0.35, function() pcall(function() fire:Stop(0.07) end) end) end
            if tB then task.wait(0.05); pcall(function() tB:Stop(0.1) end) end
        end

        local function _bg_processBlackGun()
            if not _bgEnabled then return end
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if not tool then return end
            local shots = _ar_getShots(tool); if shots < 1 then return end
            local tp, tm = _bg_findTarget(_bgMaxRange, _ZombieMatchers.Bomber)
            if not tp or not tm then return end
            if not _bg_hasOtherPlayerNear(tm, _bgBarrelDist) then return end
            if _bgEquipDelay > 0 then task.wait(_bgEquipDelay) end
            if not tool.Parent or _ar_getShots(tool) < 1 then return end
            _bg_aimShoot(tm, tp, tool)
        end

        local function _bg_loop()
            while _bgEnabled do _bg_processBlackGun(); task.wait(_bgCooldown) end
        end

        -- ==================== Auto Jump Knife ====================
        local _jkEnabled = false; local _jkMonitoring = false
        local _jkHumanoid = nil; local _jkAnimator = nil; local _jkPlayed = {}
        local _JK_IDS = { ["rbxassetid://17406577733"] = true, ["rbxassetid://15669224658"] = true, ["rbxassetid://12591948314"] = true, ["rbxassetid://12333491302"] = true }

        local function _jk_norm(id)
            if not id then return nil end; local s = tostring(id)
            if s:match("^%d+$") then return "rbxassetid://" .. s end; return s end

        local function _jk_isTarget(track)
            if not track or not track.IsPlaying then return false end
            local a = track.Animation; if not a or not a.AnimationId then return false end
            return _JK_IDS[_jk_norm(a.AnimationId)]
        end

        local function _jk_doJump()
            if not _jkHumanoid or not _jkHumanoid.Parent then return end
            task.spawn(function() pcall(function()
                local st = os.clock()
                while os.clock() - st < 1 do
                    local s = _jkHumanoid:GetState()
                    if s == Enum.HumanoidStateType.Running or s == Enum.HumanoidStateType.Landed or s == Enum.HumanoidStateType.RunningNoPhysics or s == Enum.HumanoidStateType.Climbing then break end
                    task.wait(0.05) end
                local root = _jkHumanoid.RootPart or _jkHumanoid.Parent:FindFirstChild("HumanoidRootPart")
                if root then local g = workspace.Gravity; root.Velocity = Vector3.new(root.Velocity.X, math.sqrt(2 * g * 7.2), root.Velocity.Z) end
            end) end)
        end

        local function _jk_start()
            if _jkMonitoring then return end; _jkMonitoring = true
            task.spawn(function()
                while _jkMonitoring do
                    if _jkAnimator and _jkEnabled then
                        local ok, tracks = pcall(_jkAnimator.GetPlayingAnimationTracks, _jkAnimator)
                        if ok and tracks then
                            for _, track in ipairs(tracks) do
                                if _jk_isTarget(track) and not _jkPlayed[track] then
                                    _jkPlayed[track] = true; _jk_doJump()
                                    track.Stopped:Connect(function() _jkPlayed[track] = nil end)
                                end end end end
                    task.wait(0.08) end end)
        end

        local function _jk_stop() _jkMonitoring = false; _jkPlayed = {} end

        local function _jk_refresh(char)
            _jkHumanoid = char and char:FindFirstChildOfClass("Humanoid"); _jkAnimator = nil
            if _jkHumanoid then
                _jkAnimator = _jkHumanoid:FindFirstChildOfClass("Animator")
                if not _jkAnimator then _jkAnimator = Instance.new("Animator"); _jkAnimator.Name = "AutoJumpAnimator"; _jkAnimator.Parent = _jkHumanoid end end
            _jkPlayed = {} end

        _jk_refresh(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.2); _jk_refresh(char); if _jkEnabled then _jk_start() end end)

        -- ==================== Auto Charge ====================
        local _chEnabled = false; local _chThread = nil
        local function _chLoop()
            while _chEnabled do
                local char = LocalPlayer.Character
                if char then
                    for _, tool in pairs(char:GetChildren()) do
                        if tool:IsA("Tool") then local r = tool:FindFirstChild("RemoteEvent"); if r then pcall(function() r:FireServer("Charge") end) end end end end
                task.wait(0.125) end end
        local function _chStart() if _chThread then return end; _chEnabled = true; _chThread = task.spawn(_chLoop) end
        local function _chStop() _chEnabled = false; if _chThread then task.cancel(_chThread); _chThread = nil end end
        LocalPlayer.CharacterAdded:Connect(function() if _chEnabled then task.wait(0.5); _chStop(); task.wait(0.1); _chStart() end end)

        -- ==================== FEATURES Callbacks ====================
        function FEATURES.toggleAutoReload(state)
            if state then _AR_ENABLED = true; _ar_doEnable()
            else _AR_ENABLED = false; _ar_cleanupAll() end end

        function FEATURES.toggleAutoReequip(state) _AR_HOLSTER = state end

        function FEATURES.toggleBlackGun(state)
            _bgEnabled = state
            if state then if not _bgThread then _bgThread = task.spawn(_bg_loop) end
            else if _bgThread then task.cancel(_bgThread); _bgThread = nil end end end

        function FEATURES.toggleJumpKnife(state)
            _jkEnabled = state
            if state then if not _jkHumanoid then _jk_refresh(LocalPlayer.Character) end; _jk_start()
            else _jk_stop() end end
        function FEATURES.setJumpKnifeHeight(v) _jkHeight = math.clamp(v, 10, 100) end

        function FEATURES.toggleAutoCharge(state) if state then _chStart() else _chStop() end end

        -- ==================== Custom Auto Black Gun (with sliders) ====================
        local _cstEnabled = false; local _jkHeight = 30 local _cstSmooth = 0.28; local _cstCooldown = 0.3
        local _cstEquipDelay = 0.2; local _cstBarrelDist = 14; local _cstMaxRange = 200
        local _cstWallCheck = true; local _cstThread = nil
        local _cstLastScan = 0; local _cstCacheP = nil; local _cstCacheM = nil; local _cstCacheV = false

        local function _cst_inv() _cstCacheV = false; _cstCacheP = nil; _cstCacheM = nil end
        local function _cst_getTarget()
            local n = tick()
            if _cstCacheV and n - _cstLastScan < 0.2 then return _cstCacheP, _cstCacheM end
            _cstLastScan = n; local p, m = _bg_findTarget(_cstMaxRange, _ZombieMatchers.Bomber)
            _cstCacheP = p; _cstCacheM = m; _cstCacheV = true; return p, m end

        local function _cst_process()
            if not _cstEnabled then return end
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if not tool then return end
            local shots = _ar_getShots(tool); if shots < 1 then return end
            local tp, tm = _cst_getTarget()
            if not tp or not tm then return end
            if not _bg_hasOtherPlayerNear(tm, _cstBarrelDist) then return end
            if _cstEquipDelay > 0 then task.wait(_cstEquipDelay) end
            if not tool.Parent or _ar_getShots(tool) < 1 then return end
            local char = LocalPlayer.Character; if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and tp then
                if _cstSmooth <= 0.05 then
                    root.CFrame = CFrame.new(root.Position, Vector3.new(tp.Position.X, root.Position.Y, tp.Position.Z))
                else
                    local sf = root.CFrame; local ef = CFrame.new(root.Position, Vector3.new(tp.Position.X, root.Position.Y, tp.Position.Z))
                    local du = math.min(_cstSmooth, 0.1); local st = tick()
                    while tick() - st < du do local t = (tick() - st) / du; root.CFrame = sf:Lerp(ef, t); task.wait() end
                    root.CFrame = ef end end
            local remote = _ar_getRemote(tool)
            if remote then local mr = char:FindFirstChild("Model") or char; local ts = workspace:GetServerTimeNow(); pcall(function() remote:FireServer("Fire", mr, tp.Position, ts) end) end end

        local function _cst_loop()
            local mw = 0.2
            while _cstEnabled do
                local st = tick(); _cst_process()
                local el = tick() - st; local wt = math.max(mw, _cstCooldown - el)
                if wt > 0 then task.wait(wt) end; _cst_inv() end end

        function FEATURES.toggleCustomBlackGun(state)
            _cstEnabled = state
            if state then if not _cstThread then _cstThread = task.spawn(_cst_loop) end
            else _cstThread = nil; _cst_inv() end end

        function FEATURES.setAimTime(v) _cstSmooth = v end
        function FEATURES.setShootInterval(v) _cstCooldown = v end
        function FEATURES.setEquipSpeed(v) _cstEquipDelay = v end
        function FEATURES.setBarrelDetect(v) _cstBarrelDist = v end
        function FEATURES.setMaxAimRange(v) _cstMaxRange = v end
        function FEATURES.toggleCustomWallCheck(v) _cstWallCheck = v end

        -- ==================== PVP Auto Fire (独立射线+大范围) ====================
        local _pvpafEnabled = false
        local _pvpafSmooth = 0.28; local _pvpafCooldown = 0.3
        local _pvpafEquipDelay = 0.2; local _pvpafMaxRange = 400
        local _pvpafTeamCheck = false; local _pvpafRaycast = true
        local _pvpafAutoReload = false; local _pvpafThread = nil

        local function _pvpaf_findTarget()
            local chr = LocalPlayer.Character
            if not chr then return nil end
            local origin = chr:FindFirstChild("HumanoidRootPart")
            if not origin then return nil end
            origin = origin.Position
            local bestP, bestD = nil, _pvpafMaxRange + 1
            for _, p in pairs(Players:GetPlayers()) do
                if p == LocalPlayer then continue end
                local c = p.Character; if not c then continue end
                local hu = c:FindFirstChildOfClass("Humanoid")
                if not hu or hu.Health <= 0 then continue end
                if _pvpafTeamCheck then
                    local mt, pt = _getPlayerTeam(LocalPlayer), _getPlayerTeam(p)
                    if mt and pt and mt == pt then continue end
                end
                local tp = c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
                if not tp or not tp:IsA("BasePart") then continue end
                local d = (tp.Position - origin).Magnitude
                if d > _pvpafMaxRange or d >= bestD then continue end
                if _pvpafRaycast then
                    local rp = RaycastParams.new()
                    rp.FilterType = Enum.RaycastFilterType.Blacklist
                    rp.FilterDescendantsInstances = {chr, c}
                    if workspace:Raycast(origin, tp.Position - origin, rp) then continue end
                end
                bestD = d; bestP = tp
            end
            return bestP
        end

        local function _pvpaf_process()
            if not _pvpafEnabled then return end
            local chr = LocalPlayer.Character; if not chr then return end
            local tool = chr:FindFirstChildOfClass("Tool"); if not tool then return end
            local tp = _pvpaf_findTarget(); if not tp then return end
            local root = chr:FindFirstChild("HumanoidRootPart"); if not root then return end
            if _pvpafSmooth <= 0.05 then
                root.CFrame = CFrame.new(root.Position, Vector3.new(tp.Position.X, root.Position.Y, tp.Position.Z))
            else
                local sf, ef = root.CFrame, CFrame.new(root.Position, Vector3.new(tp.Position.X, root.Position.Y, tp.Position.Z))
                local du = math.min(_pvpafSmooth, 0.1); local st = tick()
                while tick() - st < du do
                    root.CFrame = sf:Lerp(ef, (tick() - st) / du)
                    task.wait()
                end
                root.CFrame = ef
            end
            local remote = _ar_getRemote(tool)
            if remote then
                pcall(function() remote:FireServer("Fire", chr:FindFirstChild("Model") or chr, tp.Position, workspace:GetServerTimeNow()) end)
            end
        end

        local function _pvpaf_loop()
            while _pvpafEnabled and not LocalPlayer.Character do task.wait(0.5) end
            while _pvpafEnabled do
                local st = tick()
                local ok, err = pcall(_pvpaf_process)
                if not ok then warn("[PVPAF]", err) end
                task.wait(math.max(0.15, _pvpafCooldown - (tick() - st)))
            end
        end

        function PVP.toggleAutoFire(state)
            _pvpafEnabled = state
            if state then
                if not _pvpafThread then _pvpafThread = task.spawn(_pvpaf_loop) end
            else _pvpafThread = nil end
        end
        function PVP.toggleAutoFireTeamCheck(v) _pvpafTeamCheck = v end
        function PVP.toggleAutoFireRaycast(v) _pvpafRaycast = v end
        function PVP.toggleAutoFireReload(v)
            _pvpafAutoReload = v; _AR_ENABLED = v
            if v then _ar_doEnable() else _ar_cleanupAll() end
        end
        function PVP.setAutoFireAimTime(v) _pvpafSmooth = v end
        function PVP.setAutoFireShootInterval(v) _pvpafCooldown = v end
        function PVP.setAutoFireEquipSpeed(v) _pvpafEquipDelay = v end
        function PVP.setAutoFireMaxRange(v) _pvpafMaxRange = v end
    end

    -- 获取物品（原版）
    local function _getPE() local e = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        if e then local c = e:FindFirstChild("Customize"); if c then return c:FindFirstChild("PurchaseEvent") end end end
    local function _getEW() local e = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        if e then local c = e:FindFirstChild("Customize"); if c then return c:FindFirstChild("EquipWeapon") end end end
    function FEATURES.getAchievement()
        local a = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if a then a = a:FindFirstChild("AchievementUnlock"); if a then a:FireServer("Legion") end end
    end
    function FEATURES.getBaguette() local p = _getPE(); if p then p:FireServer("Baguette") end end
    function FEATURES.getVoivode() local p = _getPE(); if p then p:FireServer("Voivode") end end
    function FEATURES.getStake() local p = _getPE(); if p then p:FireServer("Iron Stake") end end
    function FEATURES.getAllWeapons()
        local p = _getPE(); local e = _getEW(); if not p or not e then return end
        p:FireServer("Baguette"); p:FireServer("Voivode"); p:FireServer("Iron Stake"); task.wait(0.2)
        for _, c in ipairs({"LineInfantry","Officer","Seaman","Musician","Sapper","Surgeon","Chaplain"}) do
            if c == "Sapper" then e:FireServer(c, "Baguette", false)
            elseif c == "Chaplain" then e:FireServer(c, "Iron Stake", false)
            else e:FireServer(c, "Voivode", false) end end
    end

    -- 医生（移植）
    do
        local _active = false; local _threshold = 25; local _range = 10; local _cooldown = 2
        local _th = nil; local _lastRequest = {}
        local function _requestHeal(player, humanoid)
            if not player or not humanoid then return end
            local hp = (humanoid.Health / humanoid.MaxHealth) * 100
            if hp > _threshold then return end
            local now = tick()
            if (_lastRequest[player] or 0) + _cooldown > now then return end
            _lastRequest[player] = now
            local char = lp.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local tr = humanoid.Parent:FindFirstChild("HumanoidRootPart") or humanoid.Parent:FindFirstChild("Torso")
            if not tr then return end
            if (root.Position - tr.Position).Magnitude > _range then return end
            local med = char:FindFirstChild("Medical Supplies")
            if not med then return end
            local re = med:FindFirstChild("RemoteEvent")
            if not re then return end
            pcall(function() re:FireServer("SendRequest", humanoid) end)
        end
        local function _loop()
            while _active do
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= lp and plr.Character then
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            pcall(_requestHeal, plr, hum)
                        end
                    end
                end
                task.wait(0.5)
            end
        end
        function FEATURES.toggleDoctor(s)
            _active = s
            if s then
                if _londonThread then task.cancel(_londonThread) end
                _londonThread = task.spawn(_loop)
            else
                if _th then task.cancel(_th); _th = nil end
                _lastRequest = {}
            end
        end
        function FEATURES.setDoctorThreshold(v)
            _threshold = v
        end
    end
-- ===== AnimationPack (AP) system — ported from v3.7 =====
_G.AP = _G.AP or {}
local AP = _G.AP
AP.activeAnims = {}

function AP.getAnimator()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil, nil end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    return hum, animator
end

function AP.playLoop(idleId, walkId, priority, onState)
    local hum, anim = AP.getAnimator()
    if not hum or not anim then return nil end
    local tracks = { idle = nil, walk = nil }
    local conns = {}
    if idleId then
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://" .. idleId
        tracks.idle = anim:LoadAnimation(a)
        tracks.idle.Priority = priority or Enum.AnimationPriority.Action
    end
    if walkId then
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://" .. walkId
        tracks.walk = anim:LoadAnimation(a)
        tracks.walk.Priority = priority or Enum.AnimationPriority.Action
    end
    local function update()
        if hum.MoveDirection.Magnitude > 0 then
            if tracks.walk and not tracks.walk.IsPlaying then
                if tracks.idle and tracks.idle.IsPlaying then tracks.idle:Stop() end
                tracks.walk:Play()
            end
        else
            if tracks.idle and not tracks.idle.IsPlaying then
                if tracks.walk and tracks.walk.IsPlaying then tracks.walk:Stop() end
                tracks.idle:Play()
            end
        end
    end
    table.insert(conns, hum:GetPropertyChangedSignal("MoveDirection"):Connect(update))
    update()
    if onState then onState(true) end
    return {
        stop = function()
            if onState then onState(false) end
            if tracks.idle and tracks.idle.IsPlaying then tracks.idle:Stop() end
            if tracks.walk and tracks.walk.IsPlaying then tracks.walk:Stop() end
            for _, c in ipairs(conns) do c:Disconnect() end
        end
    }
end

function AP.playOnce(animId, priority, onFinish)
    local hum, anim = AP.getAnimator()
    if not hum or not anim then return false end
    local a = Instance.new("Animation")
    a.AnimationId = "rbxassetid://" .. animId
    local track = anim:LoadAnimation(a)
    track.Priority = priority or Enum.AnimationPriority.Action4
    track:Play()
    if onFinish then track.Stopped:Connect(onFinish) end
    return true
end

function AP.playCrawl(idleId, walkId, sitId, priority)
    local hum, anim = AP.getAnimator()
    if not hum or not anim then return nil end
    local tracks = { idle = nil, walk = nil, sit = nil }
    local conns = {}
    if idleId then
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://" .. idleId
        tracks.idle = anim:LoadAnimation(a)
        tracks.idle.Priority = priority or Enum.AnimationPriority.Action
    end
    if walkId then
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://" .. walkId
        tracks.walk = anim:LoadAnimation(a)
        tracks.walk.Priority = priority or Enum.AnimationPriority.Action
    end
    if sitId then
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://" .. sitId
        tracks.sit = anim:LoadAnimation(a)
        tracks.sit.Priority = Enum.AnimationPriority.Action2
        tracks.sit.Looped = true
        tracks.sit:Play()
    end
    local function update()
        if hum.MoveDirection.Magnitude > 0 then
            if tracks.walk and not tracks.walk.IsPlaying then
                if tracks.idle and tracks.idle.IsPlaying then tracks.idle:Stop() end
                tracks.walk:Play()
            end
        else
            if tracks.idle and not tracks.idle.IsPlaying then
                if tracks.walk and tracks.walk.IsPlaying then tracks.walk:Stop() end
                tracks.idle:Play()
            end
        end
    end
    table.insert(conns, hum:GetPropertyChangedSignal("MoveDirection"):Connect(update))
    update()
    return {
        stop = function()
            if tracks.idle and tracks.idle.IsPlaying then tracks.idle:Stop() end
            if tracks.walk and tracks.walk.IsPlaying then tracks.walk:Stop() end
            if tracks.sit and tracks.sit.IsPlaying then tracks.sit:Stop() end
            for _, c in ipairs(conns) do c:Disconnect() end
        end
    }
end

-- ==================== Beauty feature: 天使光环 ====================
do
    local AURA_ASSET_ID = "rbxassetid://97658130917593"
    local TOGGLE_KEY = Enum.KeyCode.Insert
    local AUTO_ENABLE = false

    local Aura = { Particles = {}, AuraModel = nil, IsEnabled = false, CurrentConnection = nil, Character = nil, HumanoidRootPart = nil }
    local lp = game:GetService("Players").LocalPlayer

    local function ClearParticles()
        for _, p in ipairs(Aura.Particles) do pcall(function() p:Destroy() end) end
        Aura.Particles = {}
    end

    local function ApplyAura()
        ClearParticles()
        if not Aura.AuraModel or not Aura.Character then return end
        local cloned = Aura.AuraModel:Clone()
        for _, child in ipairs(cloned:GetChildren()) do
            local target = Aura.Character:FindFirstChild(child.Name)
            if target then
                for _, sub in ipairs(child:GetChildren()) do
                    sub.Parent = target
                    table.insert(Aura.Particles, sub)
                end
            end
            child:Destroy()
        end
        cloned:Destroy()
    end

    local function LoadAura()
        if Aura.AuraModel then pcall(function() Aura.AuraModel:Destroy() end) end
        local ok, res = pcall(function() return game:GetObjects(AURA_ASSET_ID)[1] end)
        if ok and res then
            Aura.AuraModel = res
            if Aura.IsEnabled then ApplyAura() end
        end
    end

    local function OnRenderStep()
        if not Aura.IsEnabled then return end
        local ch = lp.Character
        if ch ~= Aura.Character then
            Aura.Character = ch
            if Aura.Character then
                Aura.HumanoidRootPart = Aura.Character:WaitForChild("HumanoidRootPart", 5)
                ApplyAura()
            end
        end
    end

    local function EnableAura()
        if Aura.IsEnabled then return end
        Aura.IsEnabled = true
        if not Aura.AuraModel then LoadAura() else ApplyAura() end
        if not Aura.CurrentConnection then
            Aura.CurrentConnection = game:GetService("RunService").RenderStepped:Connect(OnRenderStep)
        end
    end

    local function DisableAura()
        if not Aura.IsEnabled then return end
        Aura.IsEnabled = false
        ClearParticles()
        if Aura.CurrentConnection then
            Aura.CurrentConnection:Disconnect()
            Aura.CurrentConnection = nil
        end
    end

    game:GetService("UserInputService").InputBegan:Connect(function(inp, gameProcessed)
        if gameProcessed then return end
        if inp.KeyCode == TOGGLE_KEY then
            if Aura.IsEnabled then DisableAura() else EnableAura() end
        end
    end)

    lp.CharacterAdded:Connect(function(ch)
        Aura.Character = ch
        Aura.HumanoidRootPart = ch:WaitForChild("HumanoidRootPart", 5)
        if Aura.IsEnabled then task.wait(0.5); ApplyAura() end
    end)

    Aura.Character = lp.Character
    if Aura.Character then Aura.HumanoidRootPart = Aura.Character:WaitForChild("HumanoidRootPart", 5) end
    LoadAura()
    if AUTO_ENABLE then EnableAura() end

    function FEATURES.toggleAngel(state)
        if state then EnableAura() else DisableAura() end
    end
end

-- ==================== Beauty feature: 你好臭呀 (zombie) ====================
do
    local zombieEnabled = false
    local savedProps = {}
    local particleList = {}
    local fogObj = nil
    local lp = game:GetService("Players").LocalPlayer

    local function getParts(ch)
        local list = {}
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum then
            local ok, rig = pcall(function() return hum:GetRigParts() end)
            if ok then
                for _, p in ipairs(rig) do if p:IsA("BasePart") then list[#list+1] = p end end
            end
        end
        if #list == 0 then
            for _, n in ipairs({"Head","Torso","UpperTorso","HumanoidRootPart","Left Arm","Right Arm"}) do
                local p = ch:FindFirstChild(n)
                if p and p:IsA("BasePart") then list[#list+1] = p end
            end
        end
        return list
    end

    local function isTarget(p)
        local n = p.Name:lower()
        return n == "head" or n == "left arm" or n == "right arm"
    end

    local function saveOrig(ch)
        for _, p in ipairs(getParts(ch)) do
            if isTarget(p) and not savedProps[p] then
                savedProps[p] = {Material = p.Material, Color = p.Color, Transparency = p.Transparency}
            end
        end
    end

    local function restoreOrig(ch)
        for _, p in ipairs(getParts(ch)) do
            if isTarget(p) then
                local o = savedProps[p]
                if o then
                    p.Material = o.Material
                    p.Color = o.Color
                    p.Transparency = o.Transparency
                else
                    p.Material = Enum.Material.Plastic
                    p.Color = Color3.new(1,1,1)
                    p.Transparency = 0
                end
            end
        end
    end

    local function rottenParts(ch)
        for _, p in ipairs(getParts(ch)) do
            if isTarget(p) then
                p.Material = Enum.Material.Slate
                p.Color = Color3.fromRGB(80,100,50)
                p.Transparency = 0.1
            end
        end
    end

    local function clearParticles()
        for _, e in ipairs(particleList) do pcall(function() e:Destroy() end) end
        particleList = {}
    end

    local function addParticles(ch)
        clearParticles()
        local attach = {}
        for _, name in ipairs({"Head","Torso","UpperTorso","Left Arm","Right Arm","Left Leg","Right Leg"}) do
            local p = ch:FindFirstChild(name)
            if p and p:IsA("BasePart") then attach[#attach+1] = p end
        end
        if #attach == 0 then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then attach[#attach+1] = hrp end
        end
        for _, p in ipairs(attach) do
            local e = Instance.new("ParticleEmitter")
            e.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            e.Color = ColorSequence.new(Color3.fromRGB(70,120,40))
            e.Size = NumberSequence.new(0.2,0.5)
            e.Transparency = NumberSequence.new(0.6,1)
            e.SpreadAngle = Vector2.new(360,360)
            e.Lifetime = NumberRange.new(0.8,1.5)
            e.Rate = 15
            e.Speed = NumberRange.new(0.2,1)
            e.Acceleration = Vector3.new(0,1,0)
            e.Parent = p
            particleList[#particleList+1] = e
        end
    end

    local function createFog(ch)
        local root = ch:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local att = Instance.new("Attachment")
        att.CFrame = CFrame.new(0, -1.2, 0)
        att.Parent = root
        local e = Instance.new("ParticleEmitter")
        e.Texture = "rbxasset://textures/particles/smoke_main.dds"
        e.Color = ColorSequence.new(Color3.fromRGB(90,150,70), Color3.fromRGB(160,210,80))
        e.Size = NumberSequence.new(2.5,4.5)
        e.Transparency = NumberSequence.new(0.4,1)
        e.Lifetime = NumberRange.new(1.8,2.5)
        e.Rate = 30
        e.SpreadAngle = Vector2.new(360,360)
        e.Speed = NumberRange.new(0.6,1.4)
        e.RotSpeed = NumberRange.new(-20,20)
        e.LightEmission = 0.2
        e.Parent = att
        return {emitter = e, attachment = att}
    end

    local function destroyFog()
        if fogObj then
            if fogObj.emitter then fogObj.emitter:Destroy() end
            if fogObj.attachment then fogObj.attachment:Destroy() end
            fogObj = nil
        end
    end

    local function applyZombie(ch)
        if not ch then return end
        saveOrig(ch)
        rottenParts(ch)
        addParticles(ch)
        destroyFog()
        fogObj = createFog(ch)
    end

    local function removeZombie(ch)
        if not ch then return end
        restoreOrig(ch)
        clearParticles()
        destroyFog()
    end

    local function onChar(ch)
        ch:WaitForChild("Humanoid")
        task.wait(0.2)
        if zombieEnabled then applyZombie(ch) end
    end

    lp.CharacterAdded:Connect(onChar)
    if lp.Character then task.wait(0.5); if zombieEnabled then applyZombie(lp.Character) end end

    function FEATURES.toggleStinky(state)
        zombieEnabled = state
        if state then
            if lp.Character then applyZombie(lp.Character) end
        else
            if lp.Character then removeZombie(lp.Character) end
        end
    end
end

-- ==================== Beauty feature: 残疾人 (cripple) ====================
do
    local brokenEnabled = false
    local savedMeshes = {}
    local lp = game:GetService("Players").LocalPlayer

    local function getLegs(ch)
        local legs = {}
        local r = ch:FindFirstChild("RightLeg") or ch:FindFirstChild("Right Leg")
        local l = ch:FindFirstChild("LeftLeg") or ch:FindFirstChild("Left Leg")
        if r then legs[#legs+1] = r end
        if l then legs[#legs+1] = l end
        return legs
    end

    local function clearLeg(leg)
        for _, c in ipairs(leg:GetChildren()) do
            if c:IsA("SpecialMesh") then c:Destroy() end
        end
    end

    local function saveLeg(leg)
        if not savedMeshes[leg] then
            local clones = {}
            for _, c in ipairs(leg:GetChildren()) do
                if c:IsA("SpecialMesh") then clones[#clones+1] = c:Clone() end
            end
            savedMeshes[leg] = clones
        end
    end

    local function restoreLeg(leg)
        local clones = savedMeshes[leg]
        if clones then
            clearLeg(leg)
            for _, m in ipairs(clones) do m:Clone().Parent = leg end
        end
    end

    local function applyBroken(ch)
        if not ch then return end
        for _, leg in ipairs(getLegs(ch)) do
            saveLeg(leg)
            clearLeg(leg)
            local m = Instance.new("SpecialMesh")
            m.MeshId = "rbxassetid://101851696"
            m.TextureId = "rbxassetid://115727863"
            m.Scale = Vector3.new(1,1,1)
            m.Parent = leg
        end
    end

    local function removeBroken(ch)
        if not ch then return end
        for _, leg in ipairs(getLegs(ch)) do restoreLeg(leg) end
    end

    local function onChar(ch)
        ch:WaitForChild("Humanoid")
        task.wait(0.1)
        if brokenEnabled then applyBroken(ch) end
    end

    lp.CharacterAdded:Connect(onChar)
    if lp.Character then task.wait(0.5); if brokenEnabled then applyBroken(lp.Character) end end

    function FEATURES.toggleCripple(state)
        brokenEnabled = state
        if state then
            if lp.Character then applyBroken(lp.Character) end
        else
            if lp.Character then removeBroken(lp.Character) end
        end
    end
end

-- ==================== Animation toggles via FEATURES ====================
do
    local ctrls = {}

    local function animCtrls()
        local hum = AP.getAnimator()
        return hum
    end

    local function setCtrl(name, s, idleId, walkId, priority, extra)
        if ctrls[name] then
            ctrls[name].stop()
            ctrls[name] = nil
        end
        if s then
            local ctrl
            if extra and extra.special == "crawl" then
                ctrl = AP.playCrawl(idleId, walkId, extra.sitId, priority)
            else
                ctrl = AP.playLoop(idleId, walkId, priority)
            end
            ctrls[name] = ctrl
        end
    end

    -- local helper for speed toggles
    local function speedToggle(name, s, idleId, walkId, priority)
        if ctrls[name] then
            ctrls[name].stop()
            ctrls[name] = nil
        end
        local hum = AP.getAnimator()
        if s then
            if hum then hum.WalkSpeed = 24 end
            ctrls[name] = AP.playLoop(idleId, walkId, priority)
        else
            if hum then hum.WalkSpeed = 16 end
        end
    end

    -- 1. 山伯乐 (normal)
    function FEATURES.toggleAnimNormal(s)  setCtrl("normal", s, "12333488814", "14463730540", Enum.AnimationPriority.Action3) end

    -- 2. 红眼 (runner)
    function FEATURES.toggleAnimRunner(s)  setCtrl("runner", s, "12581784105", "12581785298", Enum.AnimationPriority.Action3) end

    -- 3. 胸甲骑兵 (cuirassier)
    function FEATURES.toggleAnimCuirassier(s)  setCtrl("cuirassier", s, "87579228279296", "102081698785465", Enum.AnimationPriority.Action3) end

    -- 4. 提灯人 (lantern)
    function FEATURES.toggleAnimLantern(s)  setCtrl("lantern", s, "14678879479", "14678880308", Enum.AnimationPriority.Action3) end

    -- 5. 斧头僵尸 (axe zapper animation)
    function FEATURES.toggleAnimAxe(s)  setCtrl("axe", s, "14498563473", "14498289874", Enum.AnimationPriority.Action3) end

    -- 6. 自爆 (barrel)
    function FEATURES.toggleAnimBarrel(s)  setCtrl("barrel", s, "13211198049", "13211207597", Enum.AnimationPriority.Action3) end

    -- 7. 爬尸 (crawler) -- special crawl mode
    function FEATURES.toggleAnimCrawler(s)  setCtrl("crawler", s, "13726632691", "13726634549", Enum.AnimationPriority.Action3, { special = "crawl", sitId = "130515356351734" }) end

    -- 8. 重剑冲锋 (heavy charge) -- speed toggle
    function FEATURES.toggleAnimHeavyCharge(s)  speedToggle("heavy_charge", s, "14284611111", "17406602570", Enum.AnimationPriority.Action3) end

    -- 9. 滑膛枪冲锋 (musket charge) -- speed toggle
    function FEATURES.toggleAnimMusketCharge(s)  speedToggle("musket_charge", s, "14292935158", "14292937831", Enum.AnimationPriority.Action3) end

    -- 10. 冲锋 (charge) -- speed toggle, Idle priority
    function FEATURES.toggleAnimCharge(s)  speedToggle("charge", s, "14284611111", "14284623849", Enum.AnimationPriority.Idle) end
end

-- ==================== 胸甲骑兵冲锋 (cavalry charge UI) ====================
do
    AP.cavalryUI = nil
    AP.cavalryBtn = nil
    AP.cavalryPlaying = false
    local lp = game:GetService("Players").LocalPlayer

    function AP.cavalryCharge()
        if AP.cavalryPlaying then return end
        AP.cavalryPlaying = true
        if AP.cavalryBtn then AP.cavalryBtn.Text = "冲锋中" end

        local hum, anim = AP.getAnimator()
        if not hum or not anim then
            AP.cavalryPlaying = false
            if AP.cavalryBtn then AP.cavalryBtn.Text = "冲" end
            return
        end
        for _, t in pairs(hum:GetPlayingAnimationTracks()) do t:Stop() end
        local function load(id)
            local a = Instance.new("Animation")
            a.AnimationId = "rbxassetid://" .. id
            local t = anim:LoadAnimation(a)
            t.Priority = Enum.AnimationPriority.Action4
            return t
        end
        local t1 = load("105118183189738")
        local t2 = load("17406602570")
        local finalId = "102984581737936"
        local noEnemyId = "139159672489901"
        local origSpeed = hum.WalkSpeed
        hum.WalkSpeed = 1
        t1:Play()
        t1.Stopped:Wait()
        if not AP.cavalryPlaying then return end
        hum.WalkSpeed = 28
        t2:Play()
        local stopAt = os.clock() + 5
        while os.clock() < stopAt and t2.IsPlaying do task.wait() if not AP.cavalryPlaying then break end end
        t2:Stop()
        hum.WalkSpeed = origSpeed
        if not AP.cavalryPlaying then return end
        local hasEnemy = false
        for _, pl in ipairs(game:GetService("Players"):GetPlayers()) do
            if pl ~= lp and pl.Character then
                local dist = (pl.Character:GetPivot().Position - hum.RootPart.Position).Magnitude
                if dist < 10 then hasEnemy = true; break end
            end
        end
        local finalT = load(hasEnemy and finalId or noEnemyId)
        if not hasEnemy then hum.WalkSpeed = 4 end
        finalT:Play()
        finalT.Stopped:Wait()
        hum.WalkSpeed = 16
        AP.cavalryPlaying = false
        if AP.cavalryBtn then AP.cavalryBtn.Text = "冲" end
    end

    function AP.createCavalryUI()
        if AP.cavalryUI then AP.cavalryUI:Destroy() end
        local pgui = lp:WaitForChild("PlayerGui")
        AP.cavalryUI = Instance.new("ScreenGui")
        AP.cavalryUI.Name = "CavalryChargeUI"
        AP.cavalryUI.ResetOnSpawn = false
        AP.cavalryUI.Parent = pgui

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 60)
        btn.Position = UDim2.new(0.5, -30, 0.3, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = "冲"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 20
        btn.Font = Enum.Font.GothamBold
        btn.Parent = AP.cavalryUI
        btn.Active = true
        btn.Draggable = true
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = btn
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 200, 100)
        stroke.Thickness = 2.5
        stroke.Parent = btn
        AP.cavalryBtn = btn
        btn.MouseButton1Click:Connect(function()
            AP.cavalryCharge()
        end)
    end

    function AP.destroyCavalryUI()
        if AP.cavalryUI then AP.cavalryUI:Destroy(); AP.cavalryUI = nil end
        AP.cavalryPlaying = false
        AP.cavalryBtn = nil
    end

    function FEATURES.toggleAnimCuirassierCharge(s)
        if s then AP.createCavalryUI() else AP.destroyCavalryUI() end
    end
end

-- ==================== 斧头僵尸劈砍快捷栏 (zapper slash UI) ====================
do
    AP.zapperUI = nil
    AP.zapperBtn = nil
    AP.zapperBusy = false
    local lp = game:GetService("Players").LocalPlayer

    function AP.createZapperUI()
        if AP.zapperUI then AP.zapperUI:Destroy() end
        local pgui = lp:WaitForChild("PlayerGui")
        AP.zapperUI = Instance.new("ScreenGui")
        AP.zapperUI.Name = "ZapperEffectUI"
        AP.zapperUI.ResetOnSpawn = false
        AP.zapperUI.Parent = pgui

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 60)
        btn.Position = UDim2.new(0.5, -30, 0.4, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = "劈砍"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 18
        btn.Font = Enum.Font.GothamBold
        btn.Parent = AP.zapperUI
        btn.Active = true
        btn.Draggable = true
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = btn
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(100, 200, 255)
        stroke.Thickness = 2.5
        stroke.Transparency = 0.3
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn
        AP.zapperBtn = btn

        btn.MouseButton1Click:Connect(function()
            if AP.zapperBusy then return end
            AP.zapperBusy = true
            if AP.zapperBtn then AP.zapperBtn.Text = "劈砍中" end
            AP.playOnce("14499470197", Enum.AnimationPriority.Action4, function()
                AP.zapperBusy = false
                if AP.zapperBtn then AP.zapperBtn.Text = "劈砍" end
            end)
        end)
    end

    function AP.destroyZapperUI()
        if AP.zapperUI then AP.zapperUI:Destroy(); AP.zapperUI = nil end
        AP.zapperBusy = false
        AP.zapperBtn = nil
    end

    function FEATURES.toggleAnimAxeSlash(s)
        if s then AP.createZapperUI() else AP.destroyZapperUI() end
    end
end


end