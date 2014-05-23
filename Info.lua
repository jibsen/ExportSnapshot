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

return {
	LrSdkVersion = 5.0,
	LrSdkMinimumVersion = 3.0,

	LrPluginName = LOC '$$$/ExportSnapshot/General/PluginName=Export Snapshot',
	LrToolkitIdentifier = 'com.ibsensoftware.lightroom.exportsnapshot',
	
	LrExportFilterProvider = {
		title = LOC '$$$/ExportSnapshot/General/PluginName=Export Snapshot',
		file = 'ExportSnapshotFilterProvider.lua',
		id = 'exportsnapshot',
	},

	VERSION = { major=0, minor=1, revision=3, build=0, },
}
