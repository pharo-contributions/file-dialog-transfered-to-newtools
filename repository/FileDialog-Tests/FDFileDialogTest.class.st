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

{ #category : #tests }
FDFileDialogTest >> fileListAllMustBeFilterByPNGFIlter [
	self
		assert:
			(dialog filesList items
				allSatisfy: [ :fileReference | 
					fileReference isDirectory
						or: [ fileReference basename endsWith: '.png' ] ])
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
FDFileDialogTest >> testInitializeFilterDropListSelectedItemShouldBeDefaultFilter [
	self assert: dialog filtersDropList selectedItem name equals: FDDefaultFilter new name
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

{ #category : #tests }
FDFileDialogTest >> testWhenOpenADirectoryShouldDisplayHisChildrenFilterByCurrentFilter [
	dialog filtersDropList
		selectedIndex:
			((dialog filtersDropList listItems collect: #name)
				indexOf: FDDotPNGFilter new name).
	self fileListAllMustBeFilterByPNGFIlter.
	dialog filesList
		selectIndex: ((dialog filesList items collect: #basename) indexOf: 'dir').
	self fileListAllMustBeFilterByPNGFIlter
]

{ #category : #'as yet unclassified' }
FDFileDialogTest >> testWhenToggleShowHiddenFileShouldHiddenFileAppear [
	self deny: dialog showHiddenFiles.
	dialog toggleHiddenFiles.
	self
		assert: (dialog filesList items collect: #basename) asSet
		equals:
			{'dir'  . 'dir.ext' . '.hidden-dir' . '.hidden'.
			'sth.ext' . 'sth.aaa' . 'banana.jpg' . 'patate.png' . '..'} asSet
]
