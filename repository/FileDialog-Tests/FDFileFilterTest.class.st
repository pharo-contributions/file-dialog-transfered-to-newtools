Class {
	#name : #FDFileFilterTest,
	#superclass : #FDTest,
	#category : #'FileDialog-Tests'
}

{ #category : #tests }
FDFileFilterTest >> testDefaultFilterShouldReturnEveryTimeTrue [
	| beforeFilter |
	beforeFilter := root children.
	FDDefaultFilter new filter: root.
	self
		assert:
			(root children
				select: [ :fileReference | FDDefaultFilter new filter: fileReference ])
		equals: beforeFilter
]

{ #category : #tests }
FDFileFilterTest >> testHiddenFilter [
	self
		assert:
			((root children select: [ :item | FDHidenFileFilter new filter: item ])
				collect: #basename) asSet
		equals: {  '.hidden-dir' . '.hidden'} asSet 
]

{ #category : #tests }
FDFileFilterTest >> testJPGFilterShouldFilterOnlyJPGFile [
	| filterBis |
	filterBis := FDDotJPGFilter new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis filter: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.jpg') or: [ item isDirectory ] ])
]

{ #category : #tests }
FDFileFilterTest >> testPNGFilterShouldFilterOnlyPNGFile [
	| filterBis |
	filterBis := FDDotPNGFilter new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis filter: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.png' )or:[ item isDirectory]  ])
]
