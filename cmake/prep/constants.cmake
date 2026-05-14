# source assets will be installed from this directory
set(SUNSHINE_SOURCE_ASSETS_DIR "${CMAKE_SOURCE_DIR}/src_assets")

# enable system tray based on option, platform-specific cmake may override to 0 if deps are missing
if(SUNSHINE_ENABLE_TRAY)
  set(SUNSHINE_TRAY 1)
else()
  set(SUNSHINE_TRAY 0)
endif()
