###############################################################################
# Flags & Folders
###############################################################################
FOLDER_BIN=bin
FOLDER_BUILD=build

UNAME=$(shell uname)

CC=gcc
CPP=g++

LD_FLAGS=-lm
CC_FLAGS=-Wall -g -fPIC
ifeq ($(UNAME), Linux)
  LD_FLAGS+=-lrt 
endif

AR=ar
AR_FLAGS=-rsc

###############################################################################
# Compile rules
###############################################################################
SUBDIRS=benchmark \
        edit \
        gap_affine \
        gap_lineal \
        system \
        utils
       
LIB_WFA=$(FOLDER_BUILD)/libwfa.a


all: CC_FLAGS+=-O3 -fPIC
all: MODE=all
all: setup
all: $(SUBDIRS) lib_wfa tools

debug: MODE=all
debug: setup
debug: $(SUBDIRS) lib_wfa tools

setup:
	@mkdir -p $(FOLDER_BIN) $(FOLDER_BUILD)
	
lib_wfa: $(SUBDIRS)
	$(AR) $(AR_FLAGS) $(LIB_WFA) $(FOLDER_BUILD)/*.o 2> /dev/null

clean:
	rm -rf $(FOLDER_BIN) $(FOLDER_BUILD)
	
###############################################################################
# Subdir rule
###############################################################################
export
$(SUBDIRS):
	$(MAKE) --directory=$@ all
	
tools: $(SUBDIRS)
	$(MAKE) --directory=$@ $(MODE)

.PHONY: $(SUBDIRS) tools

