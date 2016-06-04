# File Dialog

A simple replacement for Pharo's native file/folder selection dialog.

## Features

* list of most common places (home, root, image directory, temp)
* adding custom bookmarks by dragging folders from file-pane to bookmark-pane
* toggle hidden files (right-click on file listing)
* preset file name
* filtering files by extension and toggling between filters

## Installation

```st
Metacello new
	baseline: 'FileDialog';
	repository: 'github://peteruhnak/file-dialog/repository';
	load.

## Classes

* `FDSaveFileDialog` - saving a file
* `FDOpenFileDialog` - selecting a file
* `FDOpenDirectoryDialog` - selecting a directory

## Example

FDSaveFileDialog new
	whenSelected: [ :file | file inspect ];
	filteredExtensions: {
		'All images' -> #(jpg png gif svg).
		'All files' -> #()
	};
	defaultFolder: FileLocator imageDirectory asFileReference;
	defaultName: 'hello.png';
	open


![](figures/file-dialog-1.png)
![](figures/file-dialog-2.png)
