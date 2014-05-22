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
local LrDate = import 'LrDate'

-- Support for debug logging
local LrLogger = import 'LrLogger'
local myLogger = LrLogger('ExportSnapshotLogger')
myLogger:enable('logfile')

myLogger:trace('loading file')

-- Initialization function
local function startDialog(propertyTable)
	myLogger:trace('in startDialog')
end

-- Define section for filter in Export dialog
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

-- Table of settings and default values we wish to store
local exportPresetFields = {
	{ key = 'snappostfix', default = "Export" },
}

-- Post-processing function
local function postProcessRenderedPhotos(functionContext, filterContext)
	myLogger:trace('in postProcessRenderedPhotos')

	local propertyTable = filterContext.propertyTable
	local exportSession = filterContext.sourceExportSession
	local catalog = exportSession.catalog

	for sourceRendition, renditionToSatisfy in filterContext:renditions() do
		-- Wait for upstream task to finish work on photo
		local success, pathOrMessage = sourceRendition:waitForRender()

		if success then
			myLogger:trace('rendered ' .. (pathOrMessage or '?'))

			-- Create snapshot name from user string and timestamp
			local time = LrDate.currentTime()
			local snapshotName = string.format(
				'%s (%s %s)',
				propertyTable.snappostfix or 'Export',
				LrDate.formatShortDate(time),
				LrDate.formatShortTime(time)
			)

			-- Get write access to the catalog
			catalog:withWriteAccessDo('Create export snapshot', function(context) 
				local photo = sourceRendition.photo
				-- Create snapshot
				photo:createDevelopSnapshot(snapshotName)
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
