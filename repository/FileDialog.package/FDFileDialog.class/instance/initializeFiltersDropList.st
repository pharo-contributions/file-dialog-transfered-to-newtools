initialization
initializeFiltersDropList
	filtersDropList
		items: self fileFilters;
		displayBlock: [ :item | item key ];
		whenSelectedItemChanged: [ :item | filesList refreshListItems ];
		setSelectedIndex: 1