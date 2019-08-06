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

{ #category : #running }
FDFileDialogTest >> tearDown [
	super tearDown.
	dialog class initialize.
	window ifNotNil: #delete
	
]

{ #category : #tests }
FDFileDialogTest >> testCustomizationWhenChangeCollectionOfPreviewerShouldBeSet [
	| previewerUtil |
	previewerUtil := FDPNGPreviewer new.
	dialog previewer: previewerUtil.
	self assert: dialog previewer equals: previewerUtil
]

{ #category : #tests }
FDFileDialogTest >> testInitializeFilterDropListSelectedItemShouldBeDefaultFilter [
	self assert: dialog filtersDropList selectedItem name equals: FDDefaultPredicate new name
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
FDFileDialogTest >> testWhenAddACollectionOfBookmarkToCustomBookmarkShouldBeAddedToBookmarkTreeTable [
	| aCollectionOfBookmark |
	aCollectionOfBookmark := {(root / 'dir') asFileReference.
	(root / 'dir.ext') asFileReference}
		collect:
			[ :eachItem | FDBookmark name: eachItem basename location: eachItem path icon: nil ].
	dialog
		bookmarks:
			{(FDGroupBookMark
				CreatWithname: 'aTestBookmark'
				WithContent: aCollectionOfBookmark
				withIconName: '')}.
	self
		assertCollection: (dialog bookmarksTreeTable roots at: 1) collection
		hasSameElements: aCollectionOfBookmark.
	self assert: dialog bookmarksTreeTable roots size equals: 1
]

{ #category : #tests }
FDFileDialogTest >> testWhenAddingBookmarkOnDefaultBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand |
	anOtherInstance := FDOpenDirectoryDialog new.
	self
		assertCollection: anOtherInstance bookmarks
		hasSameElements: dialog bookmarks.
	addCommand := FDAddBookmarkCommand new.
	addCommand context: dialog.
	dialog filesList
		selectIndex: ((dialog filesList items collect: #basename) indexOf: 'dir'). 
	addCommand execute.
	self
		assertCollection: dialog bookmarksTreeTable roots
		hasSameElements: anOtherInstance bookmarks .
	self
		assertCollection: dialog bookmarksTreeTable roots
		hasSameElements: anOtherInstance bookmarksTreeTable roots
]

{ #category : #tests }
FDFileDialogTest >> testWhenAddingBookmarkOnIsolateBookmarksShouldBeAddToAllInstance [
	| anOtherInstance addCommand beforeAdding |
	dialog isolate.
	addCommand := FDAddBookmarkCommand new.
	addCommand context: dialog.
	dialog filesList
		selectIndex: ((dialog filesList items collect: #basename) indexOf: 'dir'). 
	addCommand execute.
	anOtherInstance := FDOpenDirectoryDialog new.
	self flag: #issue4162.
	self deny: anOtherInstance bookmarks equals: dialog bookmarks.
	self
		deny: dialog bookmarksTreeTable roots
		equals: anOtherInstance bookmarksTreeTable roots
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
FDFileDialogTest >> testWhenClickAnAfterHistoryButtonIfThereAreHistoryShouldComeBackTheGoodDirectory [
	| itemsBefore |
	itemsBefore := dialog filesList items.
	dialog filesList
		selectIndex: ((dialog filesList items collect: #basename) indexOf: 'dir').
	dialog filesList
		doActivateAtIndex: ((dialog filesList items collect: #basename) indexOf: 'dir').
	self
		assertCollection: (dialog filesList items collect: #basename)
		hasSameElements: {'klm.jpg' . 'klm.png' . '..'}.
	dialog previousButton click.
	self
		assertCollection: dialog filesList items
		hasSameElements: itemsBefore.
	dialog nextButton click.
	self
		assertCollection: (dialog filesList items collect: #basename)
		hasSameElements: {'klm.jpg' . 'klm.png' . '..'}
]

{ #category : #tests }
FDFileDialogTest >> testWhenClickAnBeforeHistoryButtonIfThereAreHistoryShouldComeBackToTheLastDirectoryVisited [
	| itemsBefore |
	itemsBefore := dialog filesList items.
	dialog filesList
		selectIndex: ((dialog filesList items collect: #basename) indexOf: 'dir').
	dialog filesList
		doActivateAtIndex: ((dialog filesList items collect: #basename) indexOf: 'dir').
	self
		assertCollection: (dialog filesList items collect: #basename)
		hasSameElements: {'klm.jpg' . 'klm.png' . '..'}.
	dialog previousButton click.
	self
		assertCollection: dialog filesList items
		hasSameElements: itemsBefore
]

{ #category : #tests }
FDFileDialogTest >> testWhenCustomizeFilterShouldFilterDropListPresenterIncludeIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {FDDefaultPredicate new.
	FDDotJPGPredicate new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self
		assert: dialog filtersDropList selectedItem name
		equals: FDDefaultPredicate new name.
	self
		assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : #tests }
FDFileDialogTest >> testWhenCustomizeFilterWithoutDefaultFilterShouldFilterDropListPresenterIncludeDefaultFilterAndSelectIt [
	| aCollectionOfFilter |
	aCollectionOfFilter := {FDDotJPGPredicate new}.
	dialog filtersCustomization: aCollectionOfFilter.
	self
		assert: dialog filtersDropList selectedItem name
		equals: FDDefaultPredicate new name.
	self
		assert: (dialog filtersDropList listItems includesAll: aCollectionOfFilter)
]

{ #category : #tests }
FDFileDialogTest >> testWhenFilesListSelectionChangedAndIsAPNGShouldpreviewContentPresenterIsNotNil [
	| previewerUtil |
	previewerUtil := FDPNGPreviewer new.
	dialog previewer: previewerUtil.
	window := dialog openWithSpec.
	self
		should: [ dialog filesList
				selectIndex: ((dialog filesList items collect: #basename) indexOf: 'patate.png') ]
			"raise an error because banane.jpg don't respect the jpg format"
		raise: Error.
	self
		assert: dialog filesList selection selectedItem basename
		equals: 'patate.png'.
]

{ #category : #tests }
FDFileDialogTest >> testWhenFilesListSelectionChangedAndIsNotAPNGShouldpreviewContentPresenterNil [
	| previewerUtil |
	previewerUtil := FDPNGPreviewer new.
	dialog previewer: previewerUtil.
	window := dialog openWithSpec.
	dialog filesList
		selectIndex: ((dialog filesList items collect: #basename) indexOf: 'banana.jpg').
	self
		assert: dialog filesList selection selectedItem basename
		equals: 'banana.jpg'.
	self assert: dialog previewContentPresenter isNil
]

{ #category : #tests }
FDFileDialogTest >> testWhenOpenADirectoryShouldDisplayHisChildrenFilterByCurrentFilter [
	dialog filtersDropList
		selectedIndex:
			((dialog filtersDropList listItems collect: #name)
				indexOf: FDDotPNGPredicate new name).
	self fileListAllMustBeFilterByPNGFIlter.
	dialog filesList
		selectIndex: ((dialog filesList items collect: #basename) indexOf: 'dir').
		dialog filesList clickOnSelectedItem.
	self fileListAllMustBeFilterByPNGFIlter
]

{ #category : #tests }
FDFileDialogTest >> testWhenPathTextInputPresenterAcceptShouldChangeFileListWithTheGoodContent [
	dialog currentPathTextInputPresenter 
		text: dialog currentPathTextInputPresenter text , '/dir/'.
	dialog currentPathTextInputPresenter accept.
	self
		assertCollection: (dialog filesList items collect: #basename)
		hasSameElements: {'klm.png' . 'klm.jpg' . '..'}
]

{ #category : #tests }
FDFileDialogTest >> testWhenToggleShowHiddenFileShouldHiddenFileAppear [
	self deny: dialog showHiddenFiles.
	dialog toggleHiddenFiles.
	self
		assert: (dialog filesList items collect: #basename) asSet
		equals:
			{'dir'  . 'dir.ext' . '.hidden-dir' . '.hidden'.
			'sth.ext' . 'sth.aaa' . 'banana.jpg' . 'patate.png' . '..'} asSet
]
