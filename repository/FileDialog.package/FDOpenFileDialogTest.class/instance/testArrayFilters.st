tests
testArrayFilters
	opener fileFilters: #('*.ston' '*.image').
	self assert: opener fileFilters equals: {'*.ston, *.image' -> #('*.ston' '*.image')}