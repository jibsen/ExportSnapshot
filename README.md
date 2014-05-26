
ExportSnapshot
==============

Copyright 2014 Joergen Ibsen

<http://www.ibsensoftware.com/>


About
-----

ExportSnapshot is a [Lightroom][] plug-in that creates a snapshot in the
Develop module when you export a photo.

I export photos from Lightroom for upload to different services, and I found
it useful to have a snapshot of the state the photo was in, so I can go back
to it later.

For more information on Lightroom plug-ins, check the [Lightroom SDK][SDK].

[Lightroom]: http://www.adobe.com/products/photoshop-lightroom.html
[SDK]: http://www.adobe.com/devnet/photoshoplightroom.html


Usage
-----

Lightroom requires plug-ins to be in folders with special extensions. For
ExportSnapshot, this means you need to place the Lua files in a folder called
`ExportSnapshot.lrplugin`

If you create this folder in one of the default locations Lightroom looks for
plug-ins, it should be picked up automatically. Otherwise you will have to
open the Plug-in Manager, click Add, and point Lightroom to where the folder
is (and remember, if the folder containing the Lua files does not have the
`.lrplugin` extension, Lightroom will not recognize it).

After ExportSnapshot is added to Lightroom, you should see it in the
Post-Process Actions window of the Export dialog. When you insert it, it will
show up as a section in the export settings, where you have options for
disabling snapshots, and changing the name used for snapshots. These options
are saved along with any presets you create.

This plug-in has not been tested with publish services.
