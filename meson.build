project('breakout', 'c',
  version: '0.0.1',
  license: 'BSD 2-Clause',
  meson_version: '>=0.50.0',
  default_options: [
    'c_std=c11',
    'cpp_eh=none',
    'cpp_rtti=false',
    'default_library=static',
    'warning_level=3',
    'buildtype=release'
  ])

if target_machine.system() == 'darwin'
  appkit_dep = dependency('appkit')
else
  appkit_dep = []
endif
sdl_dep = dependency('sdl2')

subdir('src')
