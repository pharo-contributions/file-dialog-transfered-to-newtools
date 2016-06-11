filters
files: aCollection withExtensions: extensions
	^ aCollection reject: [ :each | each isFile & (extensions includes: each extension) not ]