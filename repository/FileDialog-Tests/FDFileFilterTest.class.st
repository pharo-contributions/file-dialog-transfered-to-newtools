Class {
	#name : #FDFileFilterTest,
	#superclass : #FDTest,
	#category : #'FileDialog-Tests'
}

{ #category : #tests }
FDFileFilterTest >> testDefaultFilterShouldReturnEveryTimeTrue [
	| beforeFilter defaultFilter |
	beforeFilter := root children.
	defaultFilter := FDDefaultPredicate new.
	self
		assert:
			(root children
				select: [ :fileReference | defaultFilter predicate: fileReference ])
		equals: beforeFilter
]

{ #category : #tests }
FDFileFilterTest >> testHiddenFilter [
	| hiddenFilter |
	hiddenFilter := FDHidenFilePredicate new.
	self
		assert:
			((root children select: [ :item | hiddenFilter predicate: item ])
				collect: #basename) asSet
		equals: {'.hidden-dir' . '.hidden'} asSet
]

{ #category : #tests }
FDFileFilterTest >> testJPGFilterShouldFilterOnlyJPGFile [
	| filterBis |
	filterBis := FDDotJPGPredicate new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis predicate: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.jpg') or: [ item isDirectory ] ])
]

{ #category : #tests }
FDFileFilterTest >> testPNGFilterShouldFilterOnlyPNGFile [
	| filterBis |
	filterBis := FDDotPNGPredicate new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis predicate: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.png' )or:[ item isDirectory]  ])
]
