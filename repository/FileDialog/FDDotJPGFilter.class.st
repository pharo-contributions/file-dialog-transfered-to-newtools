Class {
	#name : #FDDotJPGFilter,
	#superclass : #FDAbstractCompositeFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDotJPGFilter >> filter: aFileReference [
	^ aFileReference isDirectory
		or: [ aFileReference isFile
				and: [ 
					aFileReference basename
						regex: '.*\.jpg'
						matchesDo: [ :item | ^ true ].
					^ false ] ]
]

{ #category : #accessing }
FDDotJPGFilter >> name [
	^ 'end with jpg'
]
