CHOST="i686-pc-linux-gnu"
CFLAGS = ['-pipe', '-march=core2', '-msse', '-msse2', '-msse3', '-maccumulate-outgoing-args', '-funroll-all-loops', '-momit-leaf-frame-pointer', '-ffast-math' , '-mmmx', '-mfpmath=sse,387', '-funsigned-char', '-fno-strict-aliasing', '-O3','-fomit-frame-pointer','-funroll-loops']
CXXFLAGS="${CFLAGS}"

BF_OPENAL_LIB = 'openal alut'
WITH_BF_INTERNATIONAL = 'false'
WITH_BF_VERSE = 'true'
BF_TWEAK_MODE = 'true'
WITH_BF_JPEG = 'true'
WITH_BF_PNG = 'true'
WITH_BF_OPENEXR = 'true'
WITH_BF_QUICKTIME = 'false'
WITH_BF_FFMPEG = 'true'
WITH_BF_OPENAL = 'false'
WITH_BF_SDL = 'true'
WITH_BF_GAMEENGINE = 'false'
WITH_BF_PLAYER = 'false'
WITH_BF_BULLET = 'false'
WITH_BF_ZLIB = 'true'
WITH_BF_FMOD = 'true'
WITH_BF_FTGL = 'true'
WITH_BF_ICONV = 'false'
WITH_BF_STATICOPENGL = 'false'
BF_PYTHON_VERSION = '2.5'
BF_DEBUG = 'false' 
