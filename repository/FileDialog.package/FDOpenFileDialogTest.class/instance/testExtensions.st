tests
testExtensions
	opener extensionFilters: {'Ext files' -> #(ext)}.
	self assert: opener fileFilters equals: {'Ext files (*.ext)' -> #('*.ext')}