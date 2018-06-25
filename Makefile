#
# COPYRIGHT INFORMATION - DO NOT REMOVE
# 
# i HavE nO iDeA WhAt i'M DoInG WoooOOOoo \(@^@)/
# Copyright (c) LinuxMagic Inc. 2018 All Rights Reserved
#
# This file contains Original Code as created by LinuxMagic Inc.
#
# The Original Code is distributed on an 'AS IS' basis,
# WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, AND LINUXMAGIC
# HEREBY DISCLAIMS ALL SUCH WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET
# ENJOYMENT OR NON-INFRINGEMENT.
#
# Do NOT download, distribute, use or alter this software or file in any
# way without express written permission from LinuxMagic Inc. or its parent
# company Wizard Tower TechnoServices signed by an authorized company officer.
#
# Author(s): Daniel Fraser <danielf@linuxmagic.com>
#
# $Id:
# 

# clear out all default make targets
.SUFFIXES:

# List all make targets which are not filenames
.PHONY: all tests clean

# compiler tool definitions
CC=cc
MAKE=make
RM=rm -rf
AR=ar cru
RANLIB=ranlib

CFLAGS=-g -Wall -O2 -fPIC

# compiler defines
DEFINES=\

# compiler include paths
INCLUDES=\

# only set them if they're not empty to prevent unnecessary whitespace
ifneq ($(DEFINES),)
    CFLAGS+=$(DEFINES)
endif
ifneq ($(INCLUDES),)
    CFLAGS+=$(INCLUDES)
endif

# local NONSTANDARD libraries to link with
# these MUST be exact filenames, cannot be -l syntax
# for example:
#   ../lmrepo/clibs/libclibs.a
# NOT THIS:
#   -L../lmrepo/clibs -lclibs
# You should NOT need to add a make target to build 
# this library if you have added it correctly.
LLIBS=\

# STANDARD libraries to link with (-l is fine here)
# MUST have LLIBS BEFORE the standard libraries
LIBS=\
	$(LLIBS) \

# source files
# local source files first, other sources after
SRC=\
    ./test.c \

# object files are source files with .c replaced with .o
OBJS=\
	$(SRC:.c=.o) \

# dependency files are source files with .c replaced with .d
DFILES=\
	$(SRC:.c=.d) \

# target dependencies
# this includes any script generated c/h files,
# the $(OBJS) list, and the $(LLIBS) list
DEPS=\
	$(OBJS) \
	$(LLIBS) \

# unit tests
TESTS=\

# target files
TARGETS=\
    test \

# Default target for 'make' command
all: $(TARGETS)

# unit test target
tests: $(TESTS)

# target for test
test: $(DEPS)
	$(CC) $(CFLAGS) $^ -o $@ $(LIBS)

# catch-all make target to generate .o and .d files
%.o: %.c
	$(CC) $(CFLAGS) -MMD -c $< -o $@

# catch-all for static libraries in the form of:
# <directory>/<library.a>
# this expects that the makefile in <directory> has a
# make target named <library>
%.a:
	$(MAKE) -C $(dir $@) $(notdir $@)

# generic clean target
clean:
	@$(RM) $(DFILES) $(OBJS) $(TARGETS) $(TESTS)

# Now include our target dependency files
# the hyphen means ignore non-existent files
-include $(DFILES)
