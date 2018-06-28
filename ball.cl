% Path search in a grid, from one point to goal
% blank positions are where defenders are located. The ball cannot be driven there.

% missing positions are blocking positions such as goal keeper or defender.
position(1,1).  position(1,2).   position(1,3). position(1,4). position(1,5).
                position(2,2).   position(2,3). position(2,4). position(2,5).
position(3,1).  position(3,2).                  position(3,4). position(3,5).
position(4,1).  position(4,2).   position(4,3).                position(4,5).
position(5,1).                                                 position(5,5).

% steps
#const n = 10 .
step(0..n) .

% FLUENT ball_at changes with time
fluent(ball_at(X,Y)) :- position(X,Y).

% ACTION "move" in our domain
action(move((X,Y),(I,J))) :- holds(ball_at(X, Y)), position(I, J), I-X=0..1, |Y-J|=0..1, |X-I|+|Y-J|=1..2.

% DYNAMIC CAUSAL law: action move causes ball_at
holds(ball_at(X,Y), T+1) :- occurs(move((I,J),(X,Y)), T), holds(ball_at(I, J), T), position(X, Y), step(T), step(T+1) .

% initial position
holds(ball_at(1,1), 0) .

% Setting goals
goal(T) :- holds(ball_at(5, 1), T) .

occurs(move((1,1),(2,2)), 1) .
occurs(move((2,2),(3,2)), 2) .
occurs(move((3,2),(4,1)), 3) .




