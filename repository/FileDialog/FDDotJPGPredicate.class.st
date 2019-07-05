Class {
	#name : #FDDotJPGPredicate,
	#superclass : #FDAbstractCompositePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDotJPGPredicate >> name [
	^ 'end with jpg'
]

{ #category : #accessing }
FDDotJPGPredicate >> predicate: aFileReference [
	^ aFileReference isDirectory
		or: [ aFileReference isFile
				and: [ 
					aFileReference basename
						regex: '.*\.jpg'
						matchesDo: [ :item | ^ true ].
					^ false ] ]
]
