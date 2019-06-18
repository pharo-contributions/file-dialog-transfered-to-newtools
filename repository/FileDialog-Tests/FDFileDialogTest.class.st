Class {
	#name : #FDFileDialogTest,
	#superclass : #FDTest,
	#instVars : [
		'dialog',
		'window'
	],
	#category : #'FileDialog-Tests'
}

{ #category : #testing }
FDFileDialogTest class >> isAbstract [
	^ self = FDFileDialogTest
]

{ #category : #accessing }
FDFileDialogTest >> dialogClass [
	^ self subclassResponsibility
]

{ #category : #running }
FDFileDialogTest >> setUp [
	super setUp.
	(dialog := self dialogClass new) defaultFolder: root
]

{ #category : #tests }
FDFileDialogTest >> tearDown [
	super tearDown.
	window ifNotNil: #delete
]

{ #category : #tests }
FDFileDialogTest >> testCanonicalize [
	| location |
	location := FileLocator imageDirectory asFileReference.
	self assert: (dialog canonicalize: location / '..') fullName equals: location parent fullName
]

{ #category : #tests }
FDFileDialogTest >> testIsRootDirectory [
	self assert: (dialog isRootDirectory: FileLocator root)
]

{ #category : #tests }
FDFileDialogTest >> testIsRootDirectoryWindowsDrive [
	OSPlatform current isWindows
		ifFalse: [ ^ self ].
	self assert: (dialog isRootDirectory: FileLocator C)
]

{ #category : #tests }
FDFileDialogTest >> testOpen [
	"will it even open?"
	window := dialog open.
]

{ #category : #tests }
FDFileDialogTest >> testOpenFolder [
	window := dialog open.
	self assert: dialog currentDirectory equals: root.
	dialog openFolder: root / 'dir'.
	self assert: dialog currentDirectory equals: root / 'dir'
]
