EXE := game


SRC_DIR := src
OBJ_DIR := obj
INCLUDE_DIR := include

SRC := $(wildcard $(SRC_DIR)/*.cpp)
OBJ := $(addprefix $(OBJ_DIR)/, $(notdir $(patsubst %.cpp, %.o, $(SRC))))

CC := g++
INCLUDE := -Iinclude
CFLAGS := -g -Wall -std=c++11
LDFLAGS := 
ENET_PATH := -L/usr/local/lib
LIB_ROSACE := -lRosace
LIB_ENET := -lenet -I/usr/local/include
LIB_THREAD := -lpthread
LIBFLAG := $(LIB_ROSACE) $(LIB_ENET) $(ENET_PATH) $(LIB_THREAD)

.PHONY: all clean mrproper remake rerun


all: $(EXE)
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

$(EXE): $(OBJ)
	$(CC) $^ -o $@ $(INCLUDE) $(LIBFLAG)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CC) -c $< -o $@ $(CFLAGS) $(INCLUDE) $(LIBFLAG)
	
$(OBJ_DIR):
	mkdir $@

clean:
	rm -rf $(OBJ)

mrproper: clean
	rm -rf $(EXE)

remake: mrproper $(EXE)

rerun: remake
	./$(EXE)