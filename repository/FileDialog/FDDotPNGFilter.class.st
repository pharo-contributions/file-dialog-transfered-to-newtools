Class {
	#name : #FDDotPNGFilter,
	#superclass : #FDAbstractCompositeFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDotPNGFilter >> filter: aFileReference [
	^ aFileReference isDirectory
		or: [ aFileReference isFile
				and: [ aFileReference basename
						regex: '.*\.png'
						matchesDo: [ :item | ^ true ].
					^ false ] ]
]

{ #category : #accessing }
FDDotPNGFilter >> name [
	^ 'png filter'
]
