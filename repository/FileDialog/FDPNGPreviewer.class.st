Class {
	#name : #FDPNGPreviewer,
	#superclass : #FDAbstractPreviewer,
	#category : #'FileDialog-previewerStrategie'
}

{ #category : #testing }
FDPNGPreviewer >> canBeUsedOn: aFileReference [
	^ aFileReference isNotNil
		and: [ aFileReference isFile
				and: [ aFileReference basename endsWith: '.png' ] ]
]

{ #category : #'as yet unclassified' }
FDPNGPreviewer >> previewOn: aFileReference [
	^ SpImagePresenter new
		image:
			(aFileReference
				binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ]);
		yourself
]
