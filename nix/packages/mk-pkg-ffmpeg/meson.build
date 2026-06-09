# https://mesonbuild.com/External-Project-module.html

project('ffmpeg', 'c', 'cpp', 'objc')

mod = import('unstable-external_project')

# build binaries
c = meson.get_compiler('c')
cpp = meson.get_compiler('cpp')
objc = meson.get_compiler('objc')
nm = find_program('nm')
ar = find_program('ar')
strip = find_program('strip')
pkg_config = find_program('pkg-config')

# build options
c_args = get_option('c_args')
cpp_args = get_option('cpp_args')
objc_args = get_option('objc_args')
c_link_args = get_option('c_link_args')

# parameters
variant = get_option('variant')
flavor = get_option('flavor')

# options
disable_all_options = [
    '--disable-autodetect',
    '--disable-all',
    '--disable-x86asm',
    '--disable-runtime-cpudetect',
    '--disable-debug',
    '--disable-stripping',
    '--disable-optimizations',
    '--disable-static',
    '--disable-shared',
    '--disable-pthreads',
    '--disable-safe-bitstream-reader',
]

common_options = [
    '--prefix=@PREFIX@',
    '--enable-small', # reduce libs size
    '--enable-optimizations',
    '--enable-shared',
    '--enable-network',
    '--enable-pthreads',
    '--enable-pic',
    '--enable-mbedtls', # tls support (mbedtls)
    '--enable-version3',
    '--enable-safe-bitstream-reader',
    '--enable-stripping',
    '--enable-avcodec',
    '--enable-avformat',
    '--enable-swresample',
    '--enable-swscale',
    '--enable-avfilter',

    # '--enable-gpl', # uncomment it to include GPL code
    # '--enable-nonfree', # uncomment it to include unredistributable code
]

audio_common_options = [
    '--enable-zlib', # rasc support
    '--enable-audiotoolbox',
]

# IT-minimal (FLTR-20042): dropped --enable-libxml2 (DASH only; IT is
# HLS-only) and --enable-libdav1d (AV1 decoder; IT serves h264/HEVC only).
# These two together save ~2.6 MB on iOS. Kept --enable-neon (ARM HEVC
# improvement) and --enable-videotoolbox (HW decode).
video_common_options = [
    '--enable-neon',
    '--enable-videotoolbox',
]

# IT-minimal audio set (FLTR-20042). Only AAC + AC-3 / E-AC-3 + PCM —
# everything else stripped. AAC for the universal HLS audio codec,
# AC-3 / E-AC-3 for Dolby Digital streams, PCM as the tiny safety net.
audio_default_options = [
    '--enable-decoder=aac*',
    '--enable-decoder=ac3',
    '--enable-decoder=eac3',
    '--enable-decoder=pcm*',

    '--enable-parser=aac*',
    '--enable-parser=ac3',

    # Demuxers shared by audio + video. `mov` covers mp4/m4a/fMP4
    # segments. `hls` is the master HLS demuxer. `mpegts` covers
    # MPEG-TS HLS segments (BipBop classic, classic IT live). `aac`
    # covers raw-AAC HLS audio renditions.
    '--enable-demuxer=mov',
    '--enable-demuxer=hls',
    '--enable-demuxer=mpegts',
    '--enable-demuxer=aac',

    # Protocols: HTTPS over TCP/TLS, HLS, file. No RTMP/RTSP/etc.
    '--enable-protocol=file',
    '--enable-protocol=http',
    '--enable-protocol=https',
    '--enable-protocol=tcp',
    '--enable-protocol=tls',
    '--enable-protocol=hls',
]

# IT-minimal video set (FLTR-20042). h264 + HEVC only. mjpeg dropped
# (was needed by media_kit's snapshot path; we don't use it). All
# legacy codecs (flv, h263, mpeg1/2/4, vp6/8/9, theora, msmpeg, wmv)
# stripped. Subtitle decoders stripped (we set sid=no at the player
# level anyway). VideoToolbox hwaccels limited to h264 + hevc.
video_default_options = [
    '--enable-decoder=h264',
    '--enable-decoder=hevc',

    '--enable-parser=h264',
    '--enable-parser=hevc',

    # h264/hevc-in-mp4 → annex-B bitstream filters. Needed when the
    # decoder is VideoToolbox and the source is fMP4 HLS.
    '--enable-bsf=aac_adtstoasc',
    '--enable-bsf=h264_mp4toannexb',
    '--enable-bsf=hevc_mp4toannexb',

    # HW decode
    '--enable-hwaccel=h264_videotoolbox',
    '--enable-hwaccel=hevc_videotoolbox',
]

audio_full_options = [
    '--enable-decoders',
    '--enable-hwaccels',
    '--enable-parsers',
    '--enable-demuxers',
    '--enable-protocols',
    '--enable-bsfs',

    # filters
    '--enable-filter=overlay',
    '--enable-filter=equalizer',

    # TODO: `media_kit` checks the presence of the h264 decoder to determine if
    # `ffmpeg` is an audio or video variant, so we disable it for the audio
    # variant.
    # Ideally, we should only enable the audio decoders…
    '--disable-decoder=h264',
]

video_full_options = [
    '--enable-decoder=h264',
]

audio_encodersgpl_options = [
    '--enable-encoders',
    '--enable-muxers',
    '--enable-filters',
    '--enable-libvorbis',
    # TODO: If audio_encoders is going to exist as its own package, be smarter about what encoders to include
]

video_encodersgpl_options = [
    '--enable-libvpx',
    '--enable-libx264',
    '--enable-gpl'
]

# disable all option
options = disable_all_options

# common
options += common_options
options += audio_common_options
if variant == 'video'
    options += video_common_options
endif

# components
if flavor == 'default'
    options += audio_default_options
    if variant == 'video'
        options += video_default_options
    endif
elif flavor == 'full'
    options += audio_full_options
    if variant == 'video'
        options += video_full_options
    endif
elif flavor == 'encodersgpl'
    options += audio_full_options
    options += audio_encodersgpl_options
    if variant == 'video'
        options += video_full_options
        options += video_encodersgpl_options
    endif
endif

p = mod.add_project('configure',
    configure_options : options,
    cross_configure_options: [
        '--enable-cross-compile',
        '--target-os=@0@'.format(host_machine.system()),
        '--arch=@0@'.format(host_machine.cpu_family()),

        '--nm=@0@'.format(nm.path()),
        '--ar=@0@'.format(ar.path()),
        '--as=@0@'.format(''.join(c.cmd_array())),
        '--strip=@0@'.format(strip.path()),
        '--cc=@0@'.format(''.join(c.cmd_array())),
        '--cxx=@0@'.format(''.join(cpp.cmd_array())),
        '--objcc=@0@'.format(''.join(objc.cmd_array())),
        '--ld=@0@'.format(''.join(c.cmd_array())),
        '--pkg-config=@0@'.format(pkg_config.path()),

        '--host-cc=@0@'.format(''.join(c.cmd_array())),
        '--host-ld=@0@'.format(''.join(c.cmd_array())),

        '--extra-cflags=@0@'.format(' '.join(c_args)),
        '--extra-cxxflags=@0@'.format(' '.join(cpp_args)),
        '--extra-objcflags=@0@'.format(' '.join(objc_args)),
        '--extra-ldflags=@0@'.format(' '.join(c_link_args)),
    ],
    verbose: true,
)

libavfilter_dep = p.dependency('avfilter')
libswscale_dep = p.dependency('swscale')
libavcodec_dep = p.dependency('avcodec')
libavformat_dep = p.dependency('avformat')
libavutil_dep = p.dependency('avutil')
libswresample_dep = p.dependency('swresample')

meson.override_dependency('libavfilter', libavfilter_dep)
meson.override_dependency('libswscale', libswscale_dep)
meson.override_dependency('libavcodec', libavcodec_dep)
meson.override_dependency('libavformat', libavformat_dep)
meson.override_dependency('libavutil', libavutil_dep)
meson.override_dependency('libswresample', libswresample_dep)
