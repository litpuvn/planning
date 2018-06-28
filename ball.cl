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
action(move((X,Y),(I,J))) :- ball_at(X, Y), position(I, J) .

% possible move
possible(move((X,Y), (I,J)),T) :- holds(ball_at(X,Y), T), position(I,J), position(X,Y), I-X=0..1 , |Y-J|=0..1 , |X-I|+|Y-J|=1..2 .

% causal law: action move causes ball_at
holds(ball_at(X,Y), T+1) :- occurs(move((I,J),(X,Y)), T), ball_at(I, J), position(X, Y), step(T), step(T+1) .

% action must be possible
%:- action(move((X,Y),(I,J))), occurs(move((X,Y),(I,J)), T), not possible(move((X,Y),(I,J)),T), step(T).

% action generator
1{occurs(Action, T): action(Action)}1 :- step(T), not goal(T), T < n .

% initial position
holds(ball_at(1,1), 0) .

% Setting goals
goal(T) :- holds(ball_at(5, 5), T) .

%success :- goal(T), T< n .
%:- not success .

%#show occurs/2.