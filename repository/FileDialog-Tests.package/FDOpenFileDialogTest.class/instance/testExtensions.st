tests
testExtensions
	dialog extensionFilters: {'Ext files' -> #(ext)}.
	self assert: dialog fileFilters equals: {'Ext files (*.ext)' -> #('*.ext')}