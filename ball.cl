% Path search in a grid, from one point to goal
% blank positions are where defenders are located. The ball cannot be driven there.

% missing positions are blocking positions such as goal keeper or defender.
position(1,1).  position(1,2).   position(1,3). position(1,4). position(1,5).
                position(2,2).   position(2,3). position(2,4). position(2,5).
position(3,1).  position(3,2).                  position(3,4). position(3,5).
position(4,1).  position(4,2).   position(4,3).                position(4,5).
position(5,1).                                                 position(5,5).


% action move
holds(position(X,Y), T+1) :- occurs(move((I,J),(X,Y)), T), position(I,J), position(X,Y),  step(T), step(T+1) .

% constraint not moving backward; just 1 step either forward or horizontally.
move((X,Y),(I,J)):- position(X,Y) , position(I,J) , I-X=0..1 , |Y-J|=0..1 , |X-I|+|Y-J|=1..2 .

fluent(at(X, Y)) :- position(X,Y) .

holds(at(1,1), 0) .

% Setting goal
%goal(T) :- holds(position(5, 1), T) .
goal(T) :- holds(position(5, 5), T) .

% constraint not moving backward; just 1 step either forward or horizontally.
move((X,Y),(I,J)):- position(X,Y) , position(I,J) , I-X=0..1 , |Y-J|=0..1 , |X-I|+|Y-J|=1..2 .
% action move
holds(position(X,Y), T+1) :- occurs(move((I,J),(X,Y)), T), position(I,J), position(X,Y),  step(T), step(T+1) .

% not moving back
:- occurs(move((I,J), (X,Y)), T+1),  occurs(move((X,Y), (I,J)), T), position(X, Y), position(I, J), step(T), step(T+1) .

#const m=100 .
1{occurs(move((I,J), (X,Y)), T): move((I,J), (X,Y))}m :- step(T), not goal(T) .


% Outputs.
#show occurs/2 .