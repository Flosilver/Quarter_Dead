main: main.o
	g++ -g -Wall -o main main.o -lRosace

main.o: main.cpp 
	g++ -g -Wall -c main.cpp

clean:
	rm -f *.o

mrproper: clean
	rm -f main

remake: mrproper main

rerun: remake
	./main