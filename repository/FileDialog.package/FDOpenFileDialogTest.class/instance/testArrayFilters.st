tests
testArrayFilters
	dialog fileFilters: #('*.ston' '*.image').
	self assert: dialog fileFilters equals: {'*.ston, *.image' -> #('*.ston' '*.image')}