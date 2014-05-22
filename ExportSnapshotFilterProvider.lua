--[[-------------------------------------------------------------------------
-- ExportSnapshot Lightroom plug-in
--
-- Copyright 2014 Joergen Ibsen
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-------------------------------------------------------------------------]]--

local LrView = import 'LrView'
local bind = LrView.bind
local LrDialogs = import 'LrDialogs'

local LrLogger = import 'LrLogger'
local myLogger = LrLogger('ExportSnapshotLogger')
myLogger:enable('logfile')

myLogger:trace('loading file')

local function startDialog(propertyTable)
	myLogger:trace('in startDialog')
end

local function sectionForFilterInDialog(f, propertyTable)
	myLogger:trace('in sectionForFilterInDialog')
	
	return {
		title = LOC "$$$/ExportSnapshot/General/PluginName=Export Snapshot",
		f:row {
			spacing = f:control_spacing(),
			f:static_text {
				title = "Export snapshot name",
				fill_horizontal = 1,
			},

			f:edit_field {
				value = bind 'snappostfix',
			},
		}
	}
end

local exportPresetFields = {
	{ key = 'snappostfix', default = "Export" },
}

local function postProcessRenderedPhotos(functionContext, filterContext)
	myLogger:trace('in postProcessRenderedPhotos')

	local catalog = filterContext.sourceExportSession.catalog

	for sourceRendition, renditionToSatisfy in filterContext:renditions() do
		local success, pathOrMessage = sourceRendition:waitForRender()

		if success then
			myLogger:trace('rendered ' .. (pathOrMessage or '?'))

			catalog:withWriteAccessDo('Create export snapshot', function(context) 
				local photo = sourceRendition.photo
				photo:createDevelopSnapshot('test snapshot')
			end) 
		end
	end
end

return {
	startDialog = startDialog,
	exportPresetFields = exportPresetFields,
	sectionForFilterInDialog = sectionForFilterInDialog,
	postProcessRenderedPhotos = postProcessRenderedPhotos,
}
