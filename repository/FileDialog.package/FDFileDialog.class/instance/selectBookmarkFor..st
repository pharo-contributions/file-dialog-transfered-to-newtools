utility
selectBookmarkFor: aDirectory
	"bookmarksList' ListModel uses identity based comparison, so I need to select index instead"
	
	"is there withIndexDetect: ?"
	bookmarksList setSelectedIndex: ((self bookmarks collect: #location) indexOf: aDirectory)