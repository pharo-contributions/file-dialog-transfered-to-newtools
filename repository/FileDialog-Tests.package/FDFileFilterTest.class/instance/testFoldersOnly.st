tests
testFoldersOnly
	self
		assert: ((filter directoriesOnly: root children) collect: #basename) asSet
		equals: (Set with: 'dir' with: 'dir.ext' with: '.hidden-dir')