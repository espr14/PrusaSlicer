
set(_srcdir ${CMAKE_CURRENT_LIST_DIR}/gmp)
set(_dstdir ${DESTDIR}/usr/local)

if (MSVC)
    set(_output  ${_dstdir}/include/gmp.h 
                 ${_dstdir}/lib/libgmp-10.lib 
                 ${_dstdir}/bin/libgmp-10.dll)

    add_custom_command(
        OUTPUT  ${_output}
        COMMAND ${CMAKE_COMMAND} -E copy ${_srcdir}/include/gmp.h ${_dstdir}/include/
        COMMAND ${CMAKE_COMMAND} -E copy ${_srcdir}/lib/win${DEPS_BITS}/libgmp-10.lib ${_dstdir}/lib/
        COMMAND ${CMAKE_COMMAND} -E copy ${_srcdir}/lib/win${DEPS_BITS}/libgmp-10.dll ${_dstdir}/bin/
    )
    
    add_custom_target(dep_GMP SOURCES ${_output})

else ()
    set(_gmp_build_tgt "")
    if (APPLE)
        set(_gmp_build_tgt "--build=${CMAKE_SYSTEM_PROCESSOR}-apple-darwin")
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
        set(_gmp_build_tgt "--build=${CMAKE_SYSTEM_PROCESSOR}-pc-linux-gnu")
    endif ()

    ExternalProject_Add(dep_GMP
        # URL  https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
        URL https://gmplib.org/download/gmp/gmp-6.2.0.tar.lz
        BUILD_IN_SOURCE ON 
        CONFIGURE_COMMAND ./configure --enable-shared=no --enable-cxx=yes --enable-static=yes "--prefix=${DESTDIR}/usr/local" ${_gmp_build_tgt}
        BUILD_COMMAND     make -j
        INSTALL_COMMAND   make install
    )
endif ()