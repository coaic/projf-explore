## Project F: FPGA Graphics - Verilator Sim Makefile
## (C)2023 Will Green, open source hardware released under the MIT License
## Learn more at https://projectf.io/posts/fpga-graphics/

VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`

rect_variable: rect_variable.exe
square: square.exe
flag_ethiopia: flag_ethiopia.exe
flag_sweden: flag_sweden.exe
colour: colour.exe

%.exe: %.mk
	make -C ./obj_dir -f Vtop_$<

%.mk: top_%.sv
	verilator ${VFLAGS} -I.. \
		-cc $< --exe main_$(basename $@).cpp -o $(basename $@) \
		-CFLAGS "${SDL_CFLAGS}" -LDFLAGS "${SDL_LDFLAGS}"

all: rect_variable square flag_ethiopia flag_sweden colour

clean:
	rm -rf ./obj_dir

.PHONY: all clean
