"
i'm creating 

a SpImagePresenter of PNG file
"
Class {
	#name : #FDPNGPreviewer,
	#superclass : #FDAbstractPreviewer,
	#category : #'FileDialog-previewerStrategie'
}

{ #category : #testing }
FDPNGPreviewer >> canBeUsedOn: aFileReference [
	aFileReference ifNil: [ ^ false ].
	aFileReference mimeTypes
		ifNil: [ ^ false ]
		ifNotNil:
			[ :item | ^ item anySatisfy: [ :each | each matches: ZnMimeType imagePng ] ]
]

{ #category : #'as yet unclassified' }
FDPNGPreviewer >> previewOn: aFileReference [
	^ SpImagePresenter new
		image:
			(aFileReference
				binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ]);
		yourself
]
