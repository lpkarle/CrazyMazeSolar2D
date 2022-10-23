local aspectRatio = display.pixelHeight / display.pixelWidth
local width = 360
local height = width * aspectRatio

print('Display: ', display.pixelHeight .. 'x' .. display.pixelWidth)
print('Aspect Ratio: ', aspectRatio .. ' Divice: ' .. width .. 'x' .. height)

application =
{
	content =
	{
		width = width,
		height = height, 
		scale = 'zoomEven',
		fps = 60,
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
			    ["@4x"] = 4,
		},
		--]]
	},
}
