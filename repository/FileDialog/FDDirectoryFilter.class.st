Class {
	#name : #FDDirectoryFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDirectoryFilter >> filter: aFileReference [
	^ aFileReference isDirectory
]

{ #category : #accessing }
FDDirectoryFilter >> name [
	^ 'directory filter'
]
