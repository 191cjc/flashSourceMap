# Native Package Launcher

This small Windows GUI executable starts the packaged Node mock server and CEF
Flash host without showing a console window.

It is intentionally separate from `flash-native-host.exe`: the host renders CEF,
while this launcher prepares package-local environment variables and starts the
Node runtime in the background.
