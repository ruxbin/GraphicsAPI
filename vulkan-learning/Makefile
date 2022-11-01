TestVulkan : main.cpp vert.spv frag.spv libSupport.so edward.vert.spv edward.frag.spv
	g++ -g -O0 $< -L. -lxcb -lvulkan -lSupport -o $@


CXXFLAGS=-fPIC -g -O0
CFLAGS=-g -O0

libsrcs=$(wildcard ../UsingMetalToDrawAViewContentsents/Libs/*.cpp)
libos=$(patsubst %.cpp,%.o,$(libsrcs))
$(libos): $(libsrcs)


Shaders=shaders/vert.spv shaders/frag.spv shaders/edward.vert.spv shaders/edward.frag.spv

clean:
	rm $(Shaders)
	rm $(libos) libSupport.so

libSupport.so : $(libos)
	g++ -shared $^ -o $@

vert.spv : shaders/shader.vert
	glslc $< -o $@
	mv $@ shaders/
frag.spv : shaders/shader.frag
	glslc $< -o $@
	mv $@ shaders/
edward.vert.spv : shaders/edward.vert
	glslc $< -o $@
	mv $@ shaders/
edward.frag.spv : shaders/edward.frag
	glslc $< -o $@
	mv $@ shaders/