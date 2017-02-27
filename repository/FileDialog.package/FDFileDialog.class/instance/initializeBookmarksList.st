initialization
initializeBookmarksList
	| nonRemovableBookmarks |
	nonRemovableBookmarks := self defaultBookmarks.
	bookmarksList items: self bookmarks.
	bookmarksList autoDeselect: false.
	bookmarksList displayBlock: [ :each | each name ].
	bookmarksList icons: [ :each | each icon ].
	self selectBookmarkFor: self currentDirectory.
	bookmarksList
		whenSelectedItemChanged: [ :bookmark | bookmark ifNotNil: [ self openFolder: bookmark location ] ].
	bookmarksList
		menu: [ :aMenu :shifterd | 
			bookmarksList selectedItem
				ifNotNil: [ :bookmark | 
					(nonRemovableBookmarks includes: bookmark)
						ifFalse: [ aMenu
								add: 'Remove bookmark'
								target: self
								selector: #removeBookmark:
								argument: bookmark ].
					aMenu ] ]