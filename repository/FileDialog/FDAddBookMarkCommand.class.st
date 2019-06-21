Class {
	#name : #FDAddBookMarkCommand,
	#superclass : #CmCommand,
	#category : #'FileDialog-Menu'
}

{ #category : #hooks }
FDAddBookMarkCommand >> canBeRun [
	| selectedItem |
	selectedItem := self context filesList selection selectedItem.
	^ selectedItem isNotNil and: [ selectedItem isDirectory ]
]

{ #category : #hooks }
FDAddBookMarkCommand >> execute [
	| selectedItem |
	selectedItem := self context filesList selection selectedItem.
	self context customBookmarks
		collection:
			(self context customBookmarks collection
				add:
					(FDBookmark
						name: selectedItem basename
						location: selectedItem
						icon: nil);
				yourself).
	self context bookmarksTreeTable
		roots: self context upadateBookmarksTreeTable.
	self context bookmarksTreeTable update
]

{ #category : #hooks }
FDAddBookMarkCommand >> initialize [
	super initialize.
	self
		basicName: 'add directory to bookMark';
		basicDescription: 'add a directory for the bookmark'
]
