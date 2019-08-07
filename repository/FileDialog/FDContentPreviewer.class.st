Class {
	#name : #FDContentPreviewer,
	#superclass : #FDAbstractPreviewer,
	#category : #'FileDialog-previewerStrategie'
}

{ #category : #testing }
FDContentPreviewer >> matchingMimeType: aZnMimeType [
	"return a Boolean to indicate if element matches"
	1halt.
	 
]

{ #category : #templateMethod }
FDContentPreviewer >> previewActionOn: aFileReference [
	1halt.
	^ SpTextPresenter new text: aFileReference 
]
