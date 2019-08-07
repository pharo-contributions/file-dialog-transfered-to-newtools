Class {
	#name : #FDFileFilterTest,
	#superclass : #FDTest,
	#category : #'FileDialog-Tests'
}

{ #category : #tests }
FDFileFilterTest >> testDefaultFilterShouldReturnEveryTimeTrue [
	| beforeFilter defaultFilter |
	beforeFilter := root children.
	defaultFilter := FDDefaultSelect new.
	self
		assert:
			(root children
				select: [ :fileReference | defaultFilter predicate: fileReference ])
		equals: beforeFilter
]

{ #category : #tests }
FDFileFilterTest >> testHiddenFilter [
	| hiddenFilter |
	hiddenFilter := FDHidenSelect new.
	self
		assert:
			((root children select: [ :item | hiddenFilter predicate: item ])
				collect: #basename) asSet
		equals:
			{'sth.ext' . 'banana.jpg' . 'sth.aaa' . 'patate.png' . 'dir.ext'.
			'dir'} asSet
]

{ #category : #tests }
FDFileFilterTest >> testJPGFilterShouldFilterOnlyJPGFile [
	| filterBis |
	filterBis := FDDotJPGSelect new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis predicate: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.jpg') or: [ item isDirectory ] ])
]

{ #category : #tests }
FDFileFilterTest >> testPNGFilterShouldFilterOnlyPNGFile [
	| filterBis |
	filterBis := FDDotPNGSelect new.
	self
		assert:
			((root children
				select: [ :fileReference | filterBis predicate: fileReference ])
				allSatisfy: [ :item | (item basename endsWith: '.png' )or:[ item isDirectory]  ])
]
