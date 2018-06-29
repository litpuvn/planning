% Path search in a grid, from one point to goal
% blank positions are where defenders are located. The ball cannot be driven there.

% missing positions are blocking positions such as goal keeper or defender.
position(1,1).  position(1,2).   position(1,3). position(1,4). position(1,5).
                position(2,2).   position(2,3). position(2,4). position(2,5).
position(3,1).  position(3,2).                  position(3,4). position(3,5).
position(4,1).  position(4,2).   position(4,3).                position(4,5).
position(5,1).                                                 position(5,5).

% STEPS
#const n = 3 .
step(0..n) .

% FLUENT ------ ball_at changes with time
fluent(inertial, ball_at(X,Y)) :- position(X,Y).
fluent(defined, visited(X,Y)) :- position(X,Y).

%holds(visited(X,Y), T) :- holds(ball_at(X,Y), T) .

%% ---- CWA for Defined FLUENT ----
-holds(F,T) :- fluent(defined,F), step(T), not holds(F,T).

%% INERTIA AXIOM ------- normally things stay as they are
%% INERTIA AXIOM for inertial FLUENT
holds(F,T+1) :- fluent(inertial,F), holds(F,T), not -holds(F,T+1), T < n.
-holds(F,T+1) :- fluent(inertial,F), -holds(F,T), not holds(F,T+1), T < n.

%% CWA for Actions
-occurs(A,T) :- action(A), step(T), not occurs(A,T), step(T).

% --------- ACTION ------ "move" in our domain
action(move((X,Y),(I,J))) :- position(X, Y), position(I, J), I-X=0..1, |Y-J|=0..1, |X-I|+|Y-J|=1..2.

%------ DYNAMIC CAUSAL law ------- action move causes ball_at
holds(ball_at(X,Y), T+1) :- occurs(move((I,J),(X,Y)), T), step(T), step(T+1) .

% clear previous position after the move
-holds(ball_at(I,J), T+1) :- occurs(move((I,J),(X,Y)), T), step(T), step(T+1) .

% ---- CONSTRAINTS and HEURISTICS --------------

% ball cannot be at two places at once
-holds(ball_at(X,Y), T) :- holds(ball_at(I,J), T), position(X,Y), position(I,J), X != I, step(T).
-holds(ball_at(X,Y), T) :- holds(ball_at(I,J), T), position(X,Y), position(I,J), Y != J, step(T).


% -------- INITIAL position --------------
holds(ball_at(1,1), 0) .

occurs(move((1,1),(2,2)), 0) .
occurs(move((2,2),(3,2)), 1) .
%occurs(move((3,2),(4,1)), 2) .


%#show occurs/2 .
#show holds/2 .
%#show action/1 .


