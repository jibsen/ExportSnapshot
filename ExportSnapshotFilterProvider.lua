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
--[[
local LrLogger = import 'LrLogger'
local myLogger = LrLogger('ExportSnapshotLogger')
myLogger:enable('logfile')

local function logPrint(...)
	myLogger:trace(...)
end

local function logPrintf(format, ...)
	myLogger:tracef(format, ...)
end
--]]
---[[
local function logPrint(...)
end

local function logPrintf(format, ...)
end
--]]

logPrint('loading file')

-- Initialization function
local function startDialog(propertyTable)
	logPrint('in startDialog')
end

-- Define section for filter in Export dialog
local function sectionForFilterInDialog(f, propertyTable)
	logPrint('in sectionForFilterInDialog')
	
	return {
		title = LOC '$$$/ExportSnapshot/FilterDialog/Title=Export Snapshot',
		f:row {
			spacing = f:control_spacing(),
			f:checkbox {
				title =  LOC '$$$/ExportSnapshot/FilterDialog/EnableWithName=Enable with name:',
				value = bind 'snapshot_enable',
			},

			f:edit_field {
				value = bind 'snapshot_name',
			},
		}
	}
end

-- Table of settings and default values we wish to store
local exportPresetFields = {
	{ key = 'snapshot_enable', default = true },
	{ key = 'snapshot_name', default = 'Export' },
}

-- Post-processing function
local function postProcessRenderedPhotos(functionContext, filterContext)
	logPrint('in postProcessRenderedPhotos')

	local propertyTable = filterContext.propertyTable
	local exportSession = filterContext.sourceExportSession
	local catalog = exportSession.catalog

	for sourceRendition, renditionToSatisfy in filterContext:renditions() do
		-- Wait for upstream task to finish work on photo
		local success, pathOrMessage = sourceRendition:waitForRender()

		if success and propertyTable.snapshot_enable then
			logPrint('rendered ' .. (pathOrMessage or '?'))

			-- Create snapshot name from user string and timestamp
			local time = LrDate.currentTime()
			local snapshotName = string.format(
				'%s (%s %s)',
				propertyTable.snapshot_name or 'Export',
				LrDate.formatShortDate(time),
				LrDate.formatMediumTime(time)
			)

			-- Get write access to the catalog
			catalog:withWriteAccessDo(
				LOC '$$$/ExportSnapshot/General/UndoMessage=Create export snapshot',
				function(context) 
					local photo = sourceRendition.photo
					-- Create snapshot
					photo:createDevelopSnapshot(snapshotName)
				end
			) 
		end
	end
end

return {
	startDialog = startDialog,
	exportPresetFields = exportPresetFields,
	sectionForFilterInDialog = sectionForFilterInDialog,
	postProcessRenderedPhotos = postProcessRenderedPhotos,
}
