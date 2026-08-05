return {
	-- Mason's Ubuntu build requires libodbc.so.2; use Arch's Qt-matched server instead.
	cmd = { "/usr/lib/qt6/bin/qmlls" },
}
