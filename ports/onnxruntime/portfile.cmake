vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

find_program(GIT git)

set(GIT_URL "https://github.com/microsoft/onnxruntime")

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
    LOGNAME checkout
)

vcpkg_execute_required_process(
    COMMAND bash build.sh --config Release --skip_tests
    WORKING_DIRECTORY ${SOURCE_PATH}
    LOGNAME build-script
    ENV CMAKE_ARGS=-DDEP_SHA1_eigen=51982be81bbe52572b54180454df11a3ece9a934
)

file(COPY
        ${SOURCE_PATH}/include/onnxruntime/core/session/experimental_onnxruntime_cxx_api.h 
        ${SOURCE_PATH}/include/onnxruntime/core/session/experimental_onnxruntime_cxx_inline.h
        DESTINATION ${CURRENT_PACKAGES_DIR}/include
    )

file(MAKE_DIRECTORY
        ${CURRENT_PACKAGES_DIR}/include
        ${CURRENT_PACKAGES_DIR}/lib
        ${CURRENT_PACKAGES_DIR}/bin
        ${CURRENT_PACKAGES_DIR}/debug/lib
        ${CURRENT_PACKAGES_DIR}/debug/bin
    )

file(COPY
        ${SOURCE_PATH}/onnxruntime/include
        DESTINATION ${CURRENT_PACKAGES_DIR}
    )

file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_common.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_graph.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_optimizer.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_test_utils.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnx_test_runner_common.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_flatbuffers.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_lora.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_providers.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_util.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_framework.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_mlas.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_session.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnx_test_data_proto.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${SOURCE_PATH}/build/Linux/Release/lib/libonnxruntime_providers_shared.so DESTINATION ${CURRENT_PACKAGES_DIR}/lib)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)


