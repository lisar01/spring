# This file is part of the Spring engine (GPL v2 or later), see LICENSE.html

IF    (NOT PREFER_STATIC_LIBS)
	SET(PREFER_STATIC_LIBS FALSE)
	SET(WARN_STATIC_LINK_SWITCH TRUE CACHE BOOL "")
	MARK_AS_ADVANCED(WARN_STATIC_LINK_SWITCH)
ENDIF (NOT PREFER_STATIC_LIBS)

SET(PREFER_STATIC_LIBS ${PREFER_STATIC_LIBS} CACHE BOOL "Try to link as much as possible libraries statically")
IF    (PREFER_STATIC_LIBS)
	IF    (WARN_STATIC_LINK_SWITCH)
		Message(FATAL_ERROR "You cannot toggle `static linked` once you run cmake! You have to use a cmake `toolchain` file to enable this flag!")
	ENDIF (WARN_STATIC_LINK_SWITCH)

	SET(Boost_USE_STATIC_LIBS TRUE)
	MARK_AS_ADVANCED(Boost_USE_STATIC_LIBS)

	SET(ORIG_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
	MARK_AS_ADVANCED(ORIG_FIND_LIBRARY_SUFFIXES)

	MACRO    (PREFER_STATIC_LIBS)
		if    (WIN32 OR MINGW)
			SET(CMAKE_FIND_LIBRARY_SUFFIXES .a .lib ${CMAKE_FIND_LIBRARY_SUFFIXES})
		else  (WIN32 OR MINGW)
			SET(CMAKE_FIND_LIBRARY_SUFFIXES .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
		endif (WIN32 OR MINGW)
	ENDMACRO (PREFER_STATIC_LIBS)

	MACRO    (UNPREFER_STATIC_LIBS)
		SET(CMAKE_FIND_LIBRARY_SUFFIXES ${ORIG_FIND_LIBRARY_SUFFIXES})
	ENDMACRO (UNPREFER_STATIC_LIBS)

	MACRO    (FIND_PACKAGE_STATIC)
		PREFER_STATIC_LIBS()
		Find_Package(${ARGV0} ${ARGV1})
		UNPREFER_STATIC_LIBS()
	ENDMACRO (FIND_PACKAGE_STATIC)
ELSE (PREFER_STATIC_LIBS)
	MACRO    (PREFER_STATIC_LIBS)
	ENDMACRO (PREFER_STATIC_LIBS)

	MACRO    (UNPREFER_STATIC_LIBS)
	ENDMACRO (UNPREFER_STATIC_LIBS)

	MACRO    (FIND_PACKAGE_STATIC)
		Find_Package(${ARGV0} ${ARGV1})
	ENDMACRO (FIND_PACKAGE_STATIC)
ENDIF (PREFER_STATIC_LIBS)
