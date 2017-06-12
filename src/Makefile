CXX = g++
CXXFLAGS = -Wall -std=c++11 $(shell pkg-config --cflags lua5.3)
LDLIBS = $(shell pkg-config --libs lua5.3)

main: main.o receiver.o sender.o
	$(CXX) $(CXXFLAGS) main.o receiver.o sender.o -o main $(LDLIBS)

main.o: main.cpp receiver.h

receiver.o: receiver.cpp receiver.h

sender.o: sender.cpp sender.h

clean:
	$(RM) *.o main
