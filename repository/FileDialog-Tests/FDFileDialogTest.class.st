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
FDFileDialogTest >> testAddABookmarkShouldBeInBookmarkTreeTable [
	self
		deny:
			(dialog customBookmarks collection
				includes: (dialog creatAnFDBookMark: (root / 'dir') asFileReference)).
	dialog addBookmark: (root / 'dir') asFileReference.
	self
		assert:
			(dialog customBookmarks collection
				includes: (dialog creatAnFDBookMark: (root / 'dir') asFileReference))
]

{ #category : #tests }
FDFileDialogTest >> testAddTwiceSameDirectoryToCustomBookmarkShouldCystomBookContainsOnlyOnce [
	self
		deny:
			(dialog customBookmarks collection
				includes: (dialog creatAnFDBookMark: (root / 'dir') asFileReference)).
	dialog addBookmark: (root / 'dir') asFileReference.
	dialog addBookmark: (root / 'dir') asFileReference.
	self
		assert:
			((dialog customBookmarks collection collect: #name)
				count: [ :item | item = 'dir' ])
		equals: 1
]

{ #category : #tests }
FDFileDialogTest >> testCanonicalize [
	| location |
	location := FileLocator imageDirectory asFileReference.
	self assert: (dialog canonicalize: location / '..') fullName equals: location parent fullName
]

{ #category : #tests }
FDFileDialogTest >> testCustomizationWhenChangeCollectionOfPreviewerShouldBeSet [
	| previewerUtil |
	previewerUtil := FDJPGPreviewer new.
	dialog previewer: previewerUtil.
	self assert: dialog previewer equals: previewerUtil
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
	window := dialog openDialogWithSpec.
]

{ #category : #tests }
FDFileDialogTest >> testOpenFolder [
	window := dialog openDialogWithSpec.
	self assert: dialog currentDirectory equals: root.
	dialog openFolder: root / 'dir'.
	self assert: dialog currentDirectory equals: root / 'dir'
]

{ #category : #tests }
FDFileDialogTest >> testRemoveABookmarkShouldNotBeInBookmarkTreeTable [
	| bookmark |
	bookmark := dialog creatAnFDBookMark: (root / 'dir') asFileReference.
	dialog addBookmark: (root / 'dir') asFileReference.
	self assert: (dialog customBookmarks collection includes: bookmark).
	dialog removeBookmark: bookmark.
	self deny: (dialog customBookmarks collection includes: bookmark).
	self
		deny: ((dialog bookmarksTreeTable roots collect: #name) includes: bookmark)
]

{ #category : #'as yet unclassified' }
FDFileDialogTest >> testWhenAddACollectionOfBookmarkToCustomBookmarkShouldBeAddedToBookmarkTreeTable [
	| aCollectionOfBookmark |
	aCollectionOfBookmark := {((root / 'dir') asFileReference).
	((root / 'dir.ext') asFileReference)}
		collect:
			[ :eachItem | FDBookmark name: eachItem basename location: eachItem path icon: nil ].
	dialog fillCustomBookmarksWith: aCollectionOfBookmark.
	self
		assert: (dialog customBookmarks collection includesAll: aCollectionOfBookmark).
	self
		assert:
			((dialog bookmarksTreeTable roots
				at:
					((dialog bookmarksTreeTable roots collect: #name)
						indexOf: 'customBookMark')) collection
				includesAll: aCollectionOfBookmark)
]

{ #category : #tests }
FDFileDialogTest >> testWhenAddBookmarkShouldBeInCustomBookmarks [
	| contextActionMenu |
	contextActionMenu := FDAddBookMarkCommand new
		context: dialog;
		yourself.
	dialog filesList
		selectIndex: ((dialog filesList items collect: #basename) indexOf: 'dir').
	contextActionMenu execute.
	self
		assert:
			(((dialog bookmarksTreeTable roots
				at:
					((dialog bookmarksTreeTable roots collect: #name)
						indexOf: 'customBookMark')) collection collect: #name)
				includes: 'dir')
]

{ #category : #tests }
FDFileDialogTest >> testWhenChangeDirectoryShouldFilesListContainsHisChildren [
	| newDirectory |
	newDirectory := (root / 'dir') asFileReference.
	dialog defaultFolder: newDirectory.
	self
		assert: (dialog filesList items includesAll: newDirectory children)
]

{ #category : #tests }
FDFileDialogTest >> testWhenCustomizeFilterShouldFilterDropListPresenterIncludeIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {FDDefaultFilter new.
	FDDotJPGFilter new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self
		assert: dialog filtersDropList selectedItem name
		equals: FDDefaultFilter new name.
	self
		assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : #tests }
FDFileDialogTest >> testWhenCustomizeFilterWithoutDefaultFilterShouldFilterDropListPresenterIncludeDefaultFilterAndSelectIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {FDDotJPGFilter new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self
		assert: dialog filtersDropList selectedItem name
		equals: FDDefaultFilter new name.
	self
		assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : #tests }
FDFileDialogTest >> testWhenFilesListSelectionChangedAndIsAJPGShouldpreviewContentPresenterIsNotNil [
	| previewerUtil |
	previewerUtil := FDJPGPreviewer new.
	dialog previewer: previewerUtil.
	window := dialog openWithSpec.
	self
		should:
			(dialog filesList
				selectIndex: ((dialog filesList items collect: #basename) indexOf: 'banana.jpg'))
		raise: Error new.
	self
		assert: dialog filesList selection selectedItem basename
		equals: 'banana.jpg'.
	self deny: dialog previewContentPresenter isNil
]

{ #category : #tests }
FDFileDialogTest >> testWhenFilesListSelectionChangedAndIsNotAJPGShouldpreviewContentPresenterNil [
	| previewerUtil |
	previewerUtil := FDJPGPreviewer new.
	dialog previewer: previewerUtil.
	window := dialog openWithSpec.
	dialog filesList
		selectIndex: ((dialog filesList items collect: #basename) indexOf: 'patate.png').
	self
		assert: dialog filesList selection selectedItem basename
		equals: 'patate.png'.
	self assert: dialog previewContentPresenter isNil
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
		dialog filesList clickOnSelectedItem.
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
