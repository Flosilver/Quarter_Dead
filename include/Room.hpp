#ifndef ROOM_HPP
#define ROOM_HPP


class Room
{
    protected:
        int type;
        bool visited = false;

    public:
        Room();
        Room(int t);
        Room(const Room& r);
        ~Room();

        /* Opérators */
        Room& operator=(const Room& r);

        /* Accesseurs */
        const int& getType() const;
        const bool& isVisited() const;
        virtual void visite() = 0;
};


#endif