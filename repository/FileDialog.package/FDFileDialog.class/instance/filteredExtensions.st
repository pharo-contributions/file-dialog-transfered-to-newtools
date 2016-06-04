accessing
filteredExtensions
	^ filteredExtensions ifNil: [ filteredExtensions := self class filterAllFiles ]