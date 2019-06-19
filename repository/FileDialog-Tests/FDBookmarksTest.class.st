Class {
	#name : #FDBookmarksTest,
	#superclass : #FDTest,
	#instVars : [
		'existingBookmarks'
	],
	#category : #'FileDialog-Tests'
}

{ #category : #tests }
FDBookmarksTest >> setUp [
	super setUp.
	existingBookmarks := FDFileDialogPresenter customBookmarks copy.
	FDFileDialogPresenter customBookmarks: OrderedCollection new
]

{ #category : #tests }
FDBookmarksTest >> tearDown [
	super tearDown.
	FDFileDialogPresenter customBookmarks: existingBookmarks
]

{ #category : #tests }
FDBookmarksTest >> testAdd [
	self assert: FDFileDialogPresenter customBookmarks isEmpty.
	FDFileDialogPresenter addBookmark: FileLocator D asFileReference / 'prog'.
	self assert: FDFileDialogPresenter customBookmarks size equals: 1
]

{ #category : #tests }
FDBookmarksTest >> testAddTwiceSame [
	self assert: FDFileDialogPresenter customBookmarks isEmpty.
	FDFileDialogPresenter addBookmark: FileLocator D asFileReference / 'prog'.
	FDFileDialogPresenter addBookmark: FileLocator D asFileReference / 'prog'.
	self assert: FDFileDialogPresenter customBookmarks size equals: 1
]
