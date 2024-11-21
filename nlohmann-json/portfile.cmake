vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO nlohmann/json
	REF v${VERSION}
	SHA512 7df19b621de34f08d5d5c0a25e8225975980841ef2e48536abcf22526ed7fb99f88ad954a2cb823115db59ccc88d1dbe74fe6c281b5644b976b33fb78db9d717
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${SOURCE_PATH}/thirdparty/*")

file(INSTALL "${SOURCE_PATH}/LICENSE.MIT" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)


