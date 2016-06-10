instance creation
openModal
	| result |
	self whenSelected: [ :file | result := file ].
	self openWithSpec modalRelativeTo: self currentWorld.
	^ result