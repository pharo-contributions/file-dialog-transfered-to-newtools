tests
testHiddenFiles
	self
		assert: ((filter noHiddenFiles: root children) collect: #basename) asSet
		equals:
			(Set
				with: 'dir'
				with: 'dir.ext'
				with: 'sth.ext'
				with: 'sth.aaa')