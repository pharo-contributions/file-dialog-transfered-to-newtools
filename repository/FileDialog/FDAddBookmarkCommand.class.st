"
I'm a command use to add bookamark from selectedFile 
"
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

{ #category : #'class initialization' }
FDAddBookmarkCommand >> initialize [
	super initialize.
	self
		basicName: 'add bookmark';
		basicDescription: 'add the selected directory to the bookmarkPresenter '
]
