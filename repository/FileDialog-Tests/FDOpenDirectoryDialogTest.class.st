Class {
	#name : #FDOpenDirectoryDialogTest,
	#superclass : #FDFileDialogTest,
	#category : #'FileDialog-Tests'
}

{ #category : #accessing }
FDOpenDirectoryDialogTest >> dialogClass [
	^ FDOpenDirectoryDialog
]

{ #category : #tests }
FDOpenDirectoryDialogTest >> testSelectDirectory [
	| selectedDirectory |
	dialog whenSelected: [ :dir | selectedDirectory := dir ].
	window := dialog open.
	self assert: dialog currentDirectory equals: root.
	dialog selectFile: root / 'dir'.
	self
		assert: dialog selectedEntry
		equals: root / dialog filesList selection selectedItem basename.
	window triggerOkAction.
	self assert: selectedDirectory equals: root / 'dir'
]
