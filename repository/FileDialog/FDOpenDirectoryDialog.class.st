"
My responsibility is to provide dialog for selecting Directories.

So no files will be shown in the file/folder listings.
"
Class {
	#name : #FDOpenDirectoryDialog,
	#superclass : #FDFileDialogPresenter,
	#category : #FileDialog
}

{ #category : #specs }
FDOpenDirectoryDialog class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add:
			(SpecBoxLayout newHorizontal
				add: #bookmarksList
					withConstraints: [ :contraint | contraint width: 150 ];
				add:
					(SpecBoxLayout newVertical
						add: #currentFolderLabel
							withConstraints: [ :contraint | contraint height: self toolbarHeight ];
						add: #filesList;
						yourself);
				yourself);
		yourself
]

{ #category : #examples }
FDOpenDirectoryDialog class >> main [
	<example>
		^ self new openDialogWithSpec 
]

{ #category : #api }
FDOpenDirectoryDialog >> initialTitle [
	^ 'Select Directory To Open'
]

{ #category : #initialization }
FDOpenDirectoryDialog >> initializeWidgets [
	super initializeWidgets.
	nameText disable.
]

{ #category : #actions }
FDOpenDirectoryDialog >> nameChanged [
	"we don't need to do anything for folder"

	
]

{ #category : #actions }
FDOpenDirectoryDialog >> selectedEntry [
	^ self currentDirectory
]
