"
My responsibility is to provide dialog for selecting Files.


Example of modal use

[[[  
FDOpenFileDialog new openModal
]]]

Example of modal use

[[[ 
FDOpenFileDialog new
	whenSelected: [ :file | file inspect ];
	extensionFilters: {
		'All images' -> #(jpg png gif svg).
		'All files' -> #()
	};
	defaultFolder: FileLocator imageDirectory asFileReference;
	open
]]]
"
Class {
	#name : #FDOpenFileDialog,
	#superclass : #FDFileDialogPresenter,
	#category : #'FileDialog-UI'
}

{ #category : #api }
FDOpenFileDialog >> initialTitle [
	^ 'Select File To Open'
]

{ #category : #initialization }
FDOpenFileDialog >> initializeWidgets [
	super initializeWidgets.
	nameText disable.
	"confirmButton label: 'Open'"
]

{ #category : #accessing }
FDOpenFileDialog >> selectedEntry [
	^ filesList selection selectedItem
]
