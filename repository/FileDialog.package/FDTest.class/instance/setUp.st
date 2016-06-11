running
setUp
	filter := FDFileFilter new.
	(root := FileLocator imageDirectory / 'fd-test') ensureCreateDirectory.
"	(root := FileSystem memory / 'root') ensureCreateDirectory."
	(root / 'dir') ensureCreateDirectory.
	(root / 'dir.ext') ensureCreateDirectory.
	(root / '.hidden-dir') ensureCreateDirectory.
	(root / '.hidden') ensureCreateFile.
	(root / 'sth.ext') ensureCreateFile.
	(root / 'sth.aaa') ensureCreateFile