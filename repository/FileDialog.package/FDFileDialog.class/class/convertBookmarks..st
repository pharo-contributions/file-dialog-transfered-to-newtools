adding
convertBookmarks: aDictionary
	"convert bookmarks from old OrderedDictionary of location->#(name icon) to FDBookmark instances"

	^ aDictionary associations asOrderedCollection
		collect: [ :pair | FDBookmark name: pair value first location: pair key icon: pair value second ]