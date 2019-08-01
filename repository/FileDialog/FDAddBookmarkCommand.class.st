Class {
	#name : #FDAddBookmarkCommand,
	#superclass : #CmCommand,
	#category : #'FileDialog-Menu'
}

{ #category : #hooks }
FDAddBookmarkCommand >> canBeRun [
	^ self context filesList selection selectedItem isDirectory
]

{ #category : #hooks }
FDAddBookmarkCommand >> execute [
	| fileReference |
	fileReference := self context filesList selection selectedItem.
	self context bookmarks
		add:
			(FDBookmark
				name: fileReference basename
				location: fileReference
				icon: nil).
	self context bookmarksTreeTable roots: self context bookmarks
]
