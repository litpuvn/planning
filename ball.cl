% Path search in a grid, from one point to goal
% blank positions are where defenders are located. The ball cannot be driven there.

% missing positions are blocking positions such as goal keeper or defender.
position(1,1).  position(1,2).   position(1,3). position(1,4). position(1,5).
                position(2,2).   position(2,3). position(2,4). position(2,5).
position(3,1).  position(3,2).                  position(3,4). position(3,5).
position(4,1).  position(4,2).   position(4,3).                position(4,5).
position(5,1).                                                 position(5,5).

start(1,1).
goals((5,1);(5,5)).  % will stop at one of them.


% PROGRAM set max-length
#const path_maxlen=100.

% action move
holds(position(X,Y), T+1) :- occurs(move((I,J),(X,Y)), T), position(I,J), position(X,Y),  step(T), step(T+1) .

% constraint not moving backward; just 1 step either forward or horizontally.
move((X,Y),(I,J)):- position(X,Y) , position(I,J) , I-X=0..1 , |Y-J|=0..1 , |X-I|+|Y-J|=1..2 .

% not moving back
%:- occurs( move((I,J), (X,Y)), T+2);  holds(position(I, J), T+1); holds(position(X, Y), T);
%              position(I, J); position(X, Y); step(T); step(T+1); step(T+2) .

%:- occurs(move((I,J), (X,Y)), T+1);  holds(move((X,Y),(I, J)), T); position(X, Y); position(I, J); step(T); step(T+1) .




% All user-defined goals are linked to the endgoal, a virtual node that is the real end.
move(G,endgoal):- goals(G).

% Path from start pos to the goal.
path(1,(X,Y)):- start(X,Y).
0{path(N+1,E): path(N,S), move(S,E), S!=endgoal}1:- path(N,_) , N<path_maxlen.

% Shortcut to last move step.
pathlen(N):- path(N,_) , not path(N+1,_).

% A path that do not join the end is illegal.
:- path(N,E) , pathlen(N) , not E=endgoal.

% Minimize the number of steps.
%#minimize{N: pathlen(N)}.

% Outputs.
#show path/2.
