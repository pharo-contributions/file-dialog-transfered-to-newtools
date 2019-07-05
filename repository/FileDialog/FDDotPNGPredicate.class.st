Class {
	#name : #FDDotPNGPredicate,
	#superclass : #FDAbstractCompositePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDotPNGPredicate >> name [
	^ 'png filter'
]

{ #category : #accessing }
FDDotPNGPredicate >> predicate: aFileReference [
	^ aFileReference isDirectory
		or: [ aFileReference isFile
				and: [ aFileReference basename
						regex: '.*\.png'
						matchesDo: [ :item | ^ true ].
					^ false ] ]
]
