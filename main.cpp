#include <Rosace.hpp>
#include <iostream>
#include <memory>

using namespace std;

int main (){
    srand(time(0));
    cout << "North: " << rsc::North << "\tEast: " << rsc::East << "\tSouth: " << rsc::South << "\tWest: " << rsc::West << endl;

    rsc::Card c1;
    rsc::Card c2(10);
    rsc::Card c3(20);
    cout << "c1: " << c1.getValue() << "\tc2: " << c2.getValue() << "\tc3: " << c3.getValue() << endl;

    rsc::Deck d;
    d.add(make_shared<rsc::Card>(c1), rsc::TOP);
    d.add(make_shared<rsc::Card>(c2), rsc::TOP);
    d.add(make_shared<rsc::Card>(c3), rsc::TOP);
    cout << "d[0]: " << d[0]->getValue() << "\td[1]: " << d[1]->getValue() << "\td[2]: " << d[2]->getValue() << endl;

    d.shuffle();
    cout << "d[0]: " << d[0]->getValue() << "\td[1]: " << d[1]->getValue() << "\td[2]: " << d[2]->getValue() << endl;

    rsc::Vect2f v1(0,1.25);
    rsc::Vect2f v2(1,1);
    rsc::Vect2f v3 = v1 + v2;

    cout<<"v1 x y :"<<v1.x<<" "<<v1.y<<endl;
    cout<<"v2 x y :"<<v2.x<<" "<<v2.y<<endl;
    cout<<"v3 x y :"<<v3.x<<" "<<v3.y<<endl;

    rsc::Vect3i v4;

    cout << "v1: " << v1 << "\tv2: " << v2 << "\tv3: " << v3 << endl;
    cout << "v4: " << v4 << endl;

}