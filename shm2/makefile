# Makefile  

# 变量定义  
CXX = g++  
CXXFLAGS = -Wall -g -std=c++11  
TARGET1 = app1  
SRCS1 = app1.C  
OBJS1 = $(SRCS1:.C=.o)  
TARGET2 = app2  
SRCS2 = app2.C  
OBJS2 = $(SRCS2:.C=.o) 
# 默认目标  
all: $(TARGET1) $(TARGET2)
# 帮助信息  
help:  
	@echo "Usage: make [target]"  
	@echo "Targets:"  
	@echo " appr  - Build appr"  
	@echo " appw  - Build appw"  
	@echo " all   - Build appr appw"  
	@echo " clean - Remove generated files"  
# 链接目标  
$(TARGET1): $(OBJS1)  
	$(CXX) -o $@ $^  
$(TARGET2): $(OBJS2)  
	$(CXX) -o $@ $^
# 编译源文件  
%.o: %.C 
	$(CXX) $(CXXFLAGS) -c $^ -o $@  

# 清理生成的文件  
clean:  
	rm -f $(OBJS1) $(TARGET1) $(OBJS2) $(TARGET2)

# 伪目标  
.PHONY: all clean
