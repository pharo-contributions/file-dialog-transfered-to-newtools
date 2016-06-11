public
defaultFolder: aPath
	aPath
		ifNil: [ self openFolder: self defaultFolder ]
		ifNotNil: [ self openFolder: aPath asFileReference ]