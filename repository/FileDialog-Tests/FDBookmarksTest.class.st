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
	existingBookmarks := FDFileDialog customBookmarks copy.
	FDFileDialog customBookmarks: OrderedCollection new
]

{ #category : #tests }
FDBookmarksTest >> tearDown [
	super tearDown.
	FDFileDialog customBookmarks: existingBookmarks
]

{ #category : #tests }
FDBookmarksTest >> testAdd [
	self assert: FDFileDialog customBookmarks isEmpty.
	FDFileDialog addBookmark: FileLocator D asFileReference / 'prog'.
	self assert: FDFileDialog customBookmarks size equals: 1
]

{ #category : #tests }
FDBookmarksTest >> testAddTwiceSame [
	self assert: FDFileDialog customBookmarks isEmpty.
	FDFileDialog addBookmark: FileLocator D asFileReference / 'prog'.
	FDFileDialog addBookmark: FileLocator D asFileReference / 'prog'.
	self assert: FDFileDialog customBookmarks size equals: 1
]
