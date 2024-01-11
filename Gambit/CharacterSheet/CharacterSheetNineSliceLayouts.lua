do
    NineSliceUtil.AddLayout("GambitCorruptedBorder", {
        TopLeftCorner =	{
            atlas = "Tooltip-Corrupted-NineSlice-CornerTopLeft",
        },
        TopRightCorner = {
            atlas = "Tooltip-Corrupted-NineSlice-CornerTopRight",
        },
        BottomLeftCorner = {
            atlas = "Tooltip-Corrupted-NineSlice-CornerBottomLeft",
        },
        BottomRightCorner =	{
            atlas = "Tooltip-Corrupted-NineSlice-CornerBottomRight",
        },
        TopEdge = {
            atlas = "_Tooltip-Corrupted-NineSlice-EdgeTop",
        },
        BottomEdge = {
            atlas = "_Tooltip-Corrupted-NineSlice-EdgeBottom",
        },
        LeftEdge = {
            atlas = "!Tooltip-Corrupted-NineSlice-EdgeLeft",
        },
        RightEdge = {
            atlas = "!Tooltip-Corrupted-NineSlice-EdgeRight",
        },
    });
end

do
    local bCornerOffset = 4;
    local bCenterOffset = 8;
    NineSliceUtil.AddLayout("GambitBlueHighlight", {
        mirrorLayout = true,
        TopLeftCorner =	{
            atlas = "editmode-actionbar-highlight-nineslice-corner",
            x = -bCornerOffset,
            y = bCornerOffset,
        },
        TopRightCorner = {
            atlas = "editmode-actionbar-highlight-nineslice-corner",
            x = bCornerOffset,
            y = bCornerOffset,
        },
        BottomLeftCorner = {
            atlas = "editmode-actionbar-highlight-nineslice-corner",
            x = -bCornerOffset,
            y = -bCornerOffset,
        },
        BottomRightCorner = {
            atlas = "editmode-actionbar-highlight-nineslice-corner",
            x = bCornerOffset,
            y = -bCornerOffset,
        },
        TopEdge = {
            atlas = "_editmode-actionbar-highlight-nineslice-edgetop",
        },
        BottomEdge = {
            atlas = "_editmode-actionbar-highlight-nineslice-edgebottom",
            mirrorLayout = false,
        },
        LeftEdge = {
            atlas = "!editmode-actionbar-highlight-nineslice-edgeleft",
            mirrorLayout = false,
        },
        RightEdge = {
            atlas = "!editmode-actionbar-highlight-nineslice-edgeright",
            mirrorLayout = false,
        },
        Center = {
            atlas = "editmode-actionbar-highlight-nineslice-center",
            x = -bCenterOffset,
            y = bCenterOffset,
            x1 = bCenterOffset,
            y1 = -bCenterOffset
        },
    });
end

do
    local bCornerOffset = 15;
    NineSliceUtil.AddLayout("GambitGoldBorder", {
        mirrorLayout = true,
        TopLeftCorner =	{
            atlas = "GarrMission_RewardsBorder-Corner",
            x = -bCornerOffset,
            y = bCornerOffset,
        },
        TopRightCorner = {
            atlas = "GarrMission_RewardsBorder-Corner",
            x = bCornerOffset,
            y = bCornerOffset,
        },
        BottomLeftCorner = {
            atlas = "GarrMission_RewardsBorder-Corner",
            x = -bCornerOffset,
            y = -bCornerOffset,
        },
        BottomRightCorner = {
            atlas = "GarrMission_RewardsBorder-Corner",
            x = bCornerOffset,
            y = -bCornerOffset,
        },
        TopEdge = {
            atlas = "_GarrMission_RewardsBorder-Top",
        },
        BottomEdge = {
            atlas = "_GarrMission_RewardsBorder-Top",
        },
        LeftEdge = {
            atlas = "!GarrMission_RewardsBorder-Left",
        },
        RightEdge = {
            atlas = "!GarrMission_RewardsBorder-Left",
        },
    });
end

do
    NineSliceUtil.AddLayout("GambitKyrianBorder", {
        TopLeftCorner =	{
            atlas = "Kyrian-NineSlice-CornerTopLeft",
        },
        TopRightCorner = {
            atlas = "Kyrian-NineSlice-CornerTopRight",
        },
        BottomLeftCorner = {
            atlas = "Kyrian-NineSlice-CornerBottomLeft",
        },
        BottomRightCorner = {
            atlas = "Kyrian-NineSlice-CornerBottomRight",
        },
        TopEdge = {
            atlas = "_Kyrian-NineSlice-EdgeTop",
        },
        BottomEdge = {
            atlas = "_Kyrian-NineSlice-EdgeBottom",
        },
        LeftEdge = {
            atlas = "!Kyrian-NineSlice-EdgeLeft",
        },
        RightEdge = {
            atlas = "!Kyrian-NineSlice-EdgeRight",
        },
    });
end

do
    local bCornerOffset = 15
    NineSliceUtil.AddLayout("GambitThinGrayBorder", {
        TopLeftCorner =	{
            atlas = "OptionsFrame-NineSlice-CornerTopLeft",
            x = -bCornerOffset,
            y = bCornerOffset,
        },
        TopRightCorner = {
            atlas = "OptionsFrame-NineSlice-CornerTopRight",
            x = bCornerOffset,
            y = bCornerOffset,
        },
        BottomLeftCorner = {
            atlas = "OptionsFrame-NineSlice-CornerBottomLeft",
            x = -bCornerOffset,
            y = -bCornerOffset,
        },
        BottomRightCorner = {
            atlas = "OptionsFrame-NineSlice-CornerBottomRight",
            x = bCornerOffset,
            y = -bCornerOffset,
        },
        TopEdge = {
            atlas = "_OptionsFrame-NineSlice-EdgeTop",
        },
        BottomEdge = {
            atlas = "_OptionsFrame-NineSlice-EdgeBottom",
        },
        LeftEdge = {
            atlas = "!OptionsFrame-NineSlice-EdgeLeft",
        },
        RightEdge = {
            atlas = "!OptionsFrame-NineSlice-EdgeRight",
        },
    });
end

do
    local bCornerOffset = 0
    NineSliceUtil.AddLayout("GambitMawBorder", {
        TopLeftCorner =	{
            atlas = "Tooltip-Maw-NineSlice-CornerTopLeft",
            x = -bCornerOffset,
            y = bCornerOffset,
        },
        TopRightCorner = {
            atlas = "Tooltip-Maw-NineSlice-CornerTopRight",
            x = bCornerOffset,
            y = bCornerOffset,
        },
        BottomLeftCorner = {
            atlas = "Tooltip-Maw-NineSlice-CornerBottomLeft",
            x = -bCornerOffset,
            y = -bCornerOffset,
        },
        BottomRightCorner = {
            atlas = "Tooltip-Maw-NineSlice-CornerBottomRight",
            x = bCornerOffset,
            y = -bCornerOffset,
        },
        TopEdge = {
            atlas = "_Tooltip-Maw-NineSlice-EdgeTop",
        },
        BottomEdge = {
            atlas = "_Tooltip-Maw-NineSlice-EdgeBottom",
        },
        LeftEdge = {
            atlas = "!Tooltip-Maw-NineSlice-EdgeLeft",
        },
        RightEdge = {
            atlas = "!Tooltip-Maw-NineSlice-EdgeRight",
        },
    });
end