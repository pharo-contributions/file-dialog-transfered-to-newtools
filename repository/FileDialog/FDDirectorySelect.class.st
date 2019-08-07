"
I'm selecting only directory
"
Class {
	#name : #FDDirectorySelect,
	#superclass : #FDAbstractSimpleSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDirectorySelect >> name [
	^ 'directory filter'
]

{ #category : #accessing }
FDDirectorySelect >> predicate: aFileReference [
	^ aFileReference isDirectory
]
