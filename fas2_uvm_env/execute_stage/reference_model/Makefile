PYTHON ?= python3

# Where the DPI .so should live
DPI_DIR = ../dpi

# Python build info
PYTHON_INCLUDE = $(shell $(PYTHON) -c "import sysconfig; print(sysconfig.get_paths()['include'])")
PYTHON_LIB     = $(shell $(PYTHON) -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR'))")
PYTHON_LDLIB   = $(shell $(PYTHON) -c "import sysconfig; print(sysconfig.get_config_var('LDLIBRARY'))")

CXX = g++
CXXFLAGS = -fPIC -shared -O2 -I$(PYTHON_INCLUDE)
LDFLAGS  = -L$(PYTHON_LIB) -l:$(PYTHON_LDLIB) -Wl,-rpath,$(PYTHON_LIB)

# IMPORTANT: lib prefix + output dir
TARGET = $(DPI_DIR)/libexecute_stage_ref.so
SRC = execute_stage_ref.cpp

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	@mkdir -p $(DPI_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	rm -f $(TARGET)

