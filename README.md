# File Dialog 
Pay attention this project has been merged into the [](https://pharo-spec/newtools)



[![Build Status](https://travis-ci.org/pharo-contributions/file-dialog.svg?branch=master)](https://travis-ci.org/pharo-contributions/file-dialog) [![Coverage Status](https://coveralls.io/repos/github/pharo-contributions/file-dialog/badge.svg)](https://coveralls.io/github/pharo-contributions/file-dialog)

A simple replacement for Pharo's native file/folder selection dialog.
![](figures/file-dialog-3.png)






## Features

* contextMenu to add/remove bookmark
* toggle hidden files (right-click on file listing)
* preset file name
* filtering files by subclass FDAbstractSelect
* TextInputField like window path text input
* preview system
* you can change the column of the tablePresente

## Installation

(catalog soon)

```st
Metacello new
	baseline: 'FileDialog';
	repository: 'github://pharo-contributions/file-dialog/repository';
	load.
```

### Replacing native dialogs

If you feel brave, you can replace the native dialogs everywhere in the system by running

```st
FDMorphicUIManager new beDefault
```

Of course you can switch back anytime you want.

```st
MorphicUIManager new beDefault
```

## Howto

If you chose using the extended UIManager, then you can use that

```st
UIManager default chooseFileMatching: #('*.ston')
```

You can also use the classes directly — there are just minor differences in the behavior, such as `DirectoryDialog` will not show files, etc.

### Classes

* `FDSaveFileDialog` - saving a file
* `FDOpenFileDialog` - selecting a file
* `FDOpenDirectoryDialog` - selecting a directory

### API

The user-facing API is in the `api-customization` protocol of `FDFileDialogPresenter`

* `defaultFolder: aPath` — where should the dialog open, the default is the imageDirectory
* `filtersCustomization: aCollectionOfFDAbstractPredicate` — a collection of FDAbstractPredicate
* `bookmarks: aCollectionOfBookmark` _ see bookmark example class side of FileDialog
* `okActionBlock: aBlock` — a one arg block executed when a file was selected
* `previewer: aPreviewer` _ a son of FDAbstractPreviewer that returning a Spec widget 
* `columns: aCollectionOfColumns` _ you have to give a collection of subclass of FDAbstractFileReferenceColumn

## Custom Icons



## Example



