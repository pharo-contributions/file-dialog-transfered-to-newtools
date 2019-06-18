Class {
	#name : #FDRemoveBookMarkCommand,
	#superclass : #CmCommand,
	#category : #'FileDialog-Menu'
}

{ #category : #hooks }
FDRemoveBookMarkCommand >> canBeRun [
	| selectedItem |
	 ^ ((selectedItem := self context selectedBookMark) isNotNil)
		and: [ (self context noRemovableBookmarks includes: selectedItem) not ]
]

{ #category : #hooks }
FDRemoveBookMarkCommand >> execute [
	"Execute the actions that should be done by the command.
	 This method expect that the context has been put in #context inst. var. if any context is relevant."

	self context removeBookmark: self context selectedBookMark
]

{ #category : #initialization }
FDRemoveBookMarkCommand >> initialize [
	super initialize.
	self
		basicName: 'remove bookmark';
		basicDescription: 'only remove removeable bookmark'
]
