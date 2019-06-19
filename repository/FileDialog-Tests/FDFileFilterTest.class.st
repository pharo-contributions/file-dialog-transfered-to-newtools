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
FDFileFilterTest >> testFilterExtensions [
	self
		assert: ((filter files: root children withExtensions: #(aaa)) collect: #basename) asSet
		equals:
			(Set
				with: 'dir'
				with: 'dir.ext'
				with: '.hidden-dir'
				with: 'sth.aaa')
]

{ #category : #tests }
FDFileFilterTest >> testFilterMatching [
	self
		assert: ((filter files: root children matching: #('*th.e*' '*dd*')) collect: #basename) asSet
		equals:
			(Set
				with: 'dir'
				with: 'dir.ext'
				with: '.hidden-dir'
				with: '.hidden'
				with: 'sth.ext')
]

{ #category : #tests }
FDFileFilterTest >> testFoldersOnly [
	self
		assert: ((filter directoriesOnly: root children) collect: #basename) asSet
		equals: (Set with: 'dir' with: 'dir.ext' with: '.hidden-dir')
]

{ #category : #tests }
FDFileFilterTest >> testHiddenFiles [
	self
		assert: ((filter noHiddenFiles: root children) collect: #basename) asSet
		equals:
			(Set
				with: 'dir'
				with: 'dir.ext'
				with: 'sth.ext'
				with: 'sth.aaa')
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
