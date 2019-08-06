"
I'm selecting only PNG file
"
Class {
	#name : #FDDotPNGSelect,
	#superclass : #FDAbstractCompositeSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDotPNGSelect >> name [
	^ 'png filter'
]

{ #category : #accessing }
FDDotPNGSelect >> predicate: aFileReference [
	^ aFileReference isDirectory
		or: [ aFileReference isFile
				and: [ aFileReference basename
						regex: '.*\.png'
						matchesDo: [ :item | ^ true ].
					^ false ] ]
]
