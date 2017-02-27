instance creation
createRoot
	(root := (FileLocator imageDirectory / 'fd-test') asFileReference) ensureCreateDirectory.
	(root / 'dir') ensureCreateDirectory.
	(root / 'dir.ext') ensureCreateDirectory.
	(root / '.hidden-dir') ensureCreateDirectory.
	(root / '.hidden') ensureCreateFile.
	(root / 'sth.ext') ensureCreateFile.
	(root / 'sth.aaa') ensureCreateFile.
	^ root