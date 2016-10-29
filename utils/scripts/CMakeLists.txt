cmake_minimum_required(VERSION 2.8)

SET(COMPILE_DEFINITIONS -Werror)

include_directories(opt/vc/include)
include_directories(opt/vc/include/interface/vcos/pthreads)
include_directories(opt/vc/include/interface/vmcs_host)
include_directories(opt/vc/include/interface/vmcs_host/linux)

find_library(BMC_LIB bcm_host HINTS opt/vc/lib) 
find_library(VCHOST_LIB vchostif HINTS opt/vc/lib) 

add_executable(fbcp main.c)

target_link_libraries(fbcp PUBLIC ${BMC_LIB} ${VCHOST_LIB})
