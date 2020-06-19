main: main.o
	g++ -g -Wall -o main main.o -lRosace

main.o: main.cpp 
	g++ -g -Wall -c main.cpp

clean:
	rm -f *.o

vclean: clean
	rm -f main

remake: vclean main