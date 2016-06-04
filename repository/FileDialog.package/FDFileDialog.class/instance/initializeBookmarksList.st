initialization
initializeBookmarksList
	| places initialItems |
	places := self defaultBookmarks keys.
	initialItems := self bookmarks keys.
	bookmarksList items: initialItems.
	bookmarksList autoDeselect: false.
	bookmarksList displayBlock: [ :folder | (self bookmarks at: folder) first ].
	bookmarksList icons: [ :folder | (self bookmarks at: folder) second ].
	bookmarksList setSelectedIndex: (initialItems indexOf: self currentDirectory).
	bookmarksList whenSelectedItemChanged: [ :folder | folder ifNotNil: [ self openFolder: folder ] ].
	bookmarksList
		menu: [ :aMenu :shifterd | 
			bookmarksList selectedItem
				ifNotNil: [ :folder | 
					(places includes: folder)
						ifFalse: [ aMenu
								add: 'Remove bookmark'
								target: self
								selector: #removeBookmark:
								argument: folder ].
					aMenu ] ]