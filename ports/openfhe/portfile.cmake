vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

find_program(GIT git)

set(GIT_URL "https://github.com/openfheorg/openfhe-development")

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${PORT})

if(NOT EXISTS ${SOURCE_PATH})
	file(MAKE_DIRECTORY ${SOURCE_PATH})
endif()

if(NOT EXISTS "${SOURCE_PATH}/.git")
    message(STATUS "Cloning and fetching submodules")
    vcpkg_execute_required_process(
        COMMAND ${GIT} clone ${GIT_URL} ${SOURCE_PATH} 
	WORKING_DIRECTORY ${SOURCE_PATH} 
	LOGNAME clone)
endif()

file(REMOVE "${SOURCE_PATH}/.git/config.lock")

message(STATUS "Checkout v${VERSION}")
vcpkg_execute_required_process(
    COMMAND ${GIT} checkout tags/v${VERSION} 
    WORKING_DIRECTORY ${SOURCE_PATH}
    LOGNAME checkout)

vcpkg_execute_required_process(
    COMMAND ${GIT} submodule update --recursive --init 
    WORKING_DIRECTORY ${SOURCE_PATH} 
    LOGNAME submodules)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS 
        -DBUILD_UNITTESTS=OFF
        -DBUILD_EXAMPLES=OFF
        -DBUILD_BENCHMARKS=OFF
        -DBUILD_STATIC=ON
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${SOURCE_PATH}/thirdparty/*")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)


