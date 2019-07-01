Class {
	#name : #FDOpenFileDialogTest,
	#superclass : #FDFileDialogTest,
	#category : #'FileDialog-Tests'
}

{ #category : #accessing }
FDOpenFileDialogTest >> dialogClass [
	^ FDOpenFileDialog
]

{ #category : #tests }
FDOpenFileDialogTest >> testSelectFile [
	| selectedFile |
	dialog whenSelected: [ :file | selectedFile := file ].
	window := dialog openDialogWithSpec.
	self assert: dialog currentDirectory equals: root.
	dialog selectFile: root / 'sth.ext'.
	self assert: dialog selectedEntry equals: root / 'sth.ext'.
	dialog confirm.
	self assert: selectedFile equals: root / 'sth.ext'
]
