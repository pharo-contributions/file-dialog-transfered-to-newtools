"
My responsibility is to provide dialog for selecting Directories.

So no files will be shown in the file/folder listings.
"
Class {
	#name : #FDOpenDirectoryDialog,
	#superclass : #FDFileDialog,
	#category : #FileDialog
}

{ #category : #specs }
FDOpenDirectoryDialog class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :r | 
			r
				newColumn: [ :c | c add: #bookmarksList ] width: 150;
				newColumn: [ :c | 
					c add: #currentFolderLabel height: self toolbarHeight.
					c add: #filesList ] ];
		newRow: [ :r | 
			r newColumn: [ :c |  ].
			self dialogButtonsLayout: r ]
			height: self toolbarHeight;
		yourself
]

{ #category : #accessing }
FDOpenDirectoryDialog >> filesFilteringBlock [
	^ [ :entries | 
	| e |
	e := filter directoriesOnly: entries.
	showHiddenFiles
		ifFalse: [ e := filter noHiddenFiles: e ].
	e ]
]

{ #category : #api }
FDOpenDirectoryDialog >> initialTitle [
	^ 'Select Directory To Open'
]

{ #category : #initialization }
FDOpenDirectoryDialog >> initializeWidgets [
	super initializeWidgets.
	nameText disable.
	confirmButton
		label: 'Open';
		enable
]

{ #category : #actions }
FDOpenDirectoryDialog >> nameChanged [
	"we don't need to do anything for folder"

	
]

{ #category : #actions }
FDOpenDirectoryDialog >> selectedEntry [
	^ self currentDirectory
]
