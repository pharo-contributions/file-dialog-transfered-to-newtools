Class {
	#name : #FDFileFilterTest,
	#superclass : #FDTest,
	#category : #'FileDialog-Tests'
}

{ #category : #tests }
FDFileFilterTest >> testDefaultFilterShouldReturnEveryTimeTrue [
	| beforeFilter |
	beforeFilter := root children.
	FDDefaultPredicate new filter: root.
	self
		assert:
			(root children
				select: [ :fileReference | FDDefaultPredicate new filter: fileReference ])
		equals: beforeFilter
]

{ #category : #tests }
FDFileFilterTest >> testHiddenFilter [
	self
		assert:
			((root children select: [ :item | FDHidenFilePredicate new filter: item ])
				collect: #basename) asSet
		equals: {  '.hidden-dir' . '.hidden'} asSet 
]

{ #category : #tests }
FDFileFilterTest >> testJPGFilterShouldFilterOnlyJPGFile [
	| filterBis |
	filterBis := FDDotJPGPredicate new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis filter: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.jpg') or: [ item isDirectory ] ])
]

{ #category : #tests }
FDFileFilterTest >> testPNGFilterShouldFilterOnlyPNGFile [
	| filterBis |
	filterBis := FDDotPNGPredicate new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis filter: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.png' )or:[ item isDirectory]  ])
]
