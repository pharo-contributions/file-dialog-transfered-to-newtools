tests
testCanonicalize
	| location |
	location := FileLocator imageDirectory asFileReference.
	self assert: (dialog canonicalize: location / '..') fullName equals: location parent fullName