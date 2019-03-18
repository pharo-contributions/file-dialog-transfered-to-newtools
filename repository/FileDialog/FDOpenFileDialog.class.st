"
My responsibility is to provide dialog for selecting Files.
"
Class {
	#name : #FDOpenFileDialog,
	#superclass : #FDFileDialog,
	#category : 'FileDialog'
}

{ #category : #api }
FDOpenFileDialog >> initialTitle [
	^ 'Select File To Open'
]

{ #category : #initialization }
FDOpenFileDialog >> initializeWidgets [
	super initializeWidgets.
	nameText disable.
	confirmButton label: 'Open'
]

{ #category : #accessing }
FDOpenFileDialog >> selectedEntry [
	^ filesList selectedItem
]
