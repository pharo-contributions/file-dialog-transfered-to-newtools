accessing
currentDirectory
	^ currentDirectory ifNil: [ currentDirectory := self defaultFolder ]