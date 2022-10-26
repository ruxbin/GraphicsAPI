TestVulkan : main.cpp vert.spv frag.spv
	g++ -g -O0 $< -lglfw -lvulkan -o $@


CXXFLAGS=-fPIC

libsrcs=$(wildcard ../UsingMetalToDrawAViewContentsents/Libs/*.cpp)
libos=$(patsubst %.cpp,%.o,$(libsrcs))
$(libos): $(libsrcs)

clean:
	rm $(libos) libSupport.so

libSupport.so : $(libos)
	g++ -shared $^ -o $@

vert.spv : shaders/shader.vert
	glslc $< -o $@
	mv $@ shaders/
frag.spv : shaders/shader.frag
	glslc $< -o $@
	mv $@ shaders/