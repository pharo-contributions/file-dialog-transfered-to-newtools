"
I'm selecting only jpg file
"
Class {
	#name : #FDDotJPGSelect,
	#superclass : #FDAbstractCompositeSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDotJPGSelect >> name [
	^ 'end with jpg'
]

{ #category : #accessing }
FDDotJPGSelect >> predicate: aFileReference [
	^ aFileReference isDirectory
		or: [ aFileReference isFile
				and: [ 
					aFileReference basename
						regex: '.*\.jpg'
						matchesDo: [ :item | ^ true ].
					^ false ] ]
]
