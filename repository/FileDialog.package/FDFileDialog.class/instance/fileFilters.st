accessing
fileFilters
	^ fileFilters ifNil: [ fileFilters := self class filterAllFiles ]