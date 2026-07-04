# FlashSourceMap Native CEF Host

This is a minimal CEF host for the native Flash runtime. It replaces the
official `cefclient.exe` sample so Flash receives game keyboard input directly.

The official sample client contains demo keyboard handling that consumes Space
before the renderer and Pepper Flash see it. This host deliberately does not
consume keyboard events in `OnPreKeyEvent`.

Build requirements:

- Windows x64
- Visual Studio 2019/2022 Build Tools with C++ workload
- CMake 3.19+
- CEF standard binary distribution, not the `client` runtime-only package

Build from the repository root:

```powershell
npm run native-flash:build-host
```

The build script downloads CEF 87 standard into `workspace/native-cef-host` when
it is missing, then writes the runnable output to `workspace/native-host/Release`.
