% Path search in a grid, from one point to goal
% blank positions are where defenders are located. The ball cannot be driven there.

% missing positions are blocking positions such as goal keeper or defender.
position(1,1).  position(1,2).   position(1,3). position(1,4). position(1,5).
position(2,1).  position(2,2).   position(2,3). position(2,4). position(2,5).
position(3,1).                                                 position(3,5).
position(4,1).  position(4,2).   position(4,3). position(4,4). position(4,5).
position(5,1).                                                 position(5,5).

% STEPS
#const n = 5 .
step(0..n) .

% FLUENT ------ ball_at changes with time
fluent(inertial, ball_at(X,Y)) :- position(X,Y).
fluent(defined, visited(X,Y)) :- position(X,Y).
fluent(inertial, directionLeft).


%% ---- CWA for Defined FLUENT ----
-holds(F,T) :- fluent(defined,F), step(T), not holds(F,T).

% INERTIA AXIOM ------- normally things stay as they are
%holds(F, T+1) :- holds(F, T), not -holds(F, T+1), step(T), T< n.
%-holds(F, T+1) :- -holds(F, T), not holds(F, T+1), step(T), T< n.

%% INERTIA AXIOM for inertial FLUENT
holds(F,T+1) :- fluent(inertial,F), holds(F,T), not -holds(F,T+1), T < n.
-holds(F,T+1) :- fluent(inertial,F), -holds(F,T), not holds(F,T+1), T < n.

%% CWA for Actions
-occurs(A,T) :- action(A), step(T), not occurs(A,T), step(T).

% ACTION ------ "move" in our domain
action(move((X,Y),(I,J))) :- position(X, Y), position(I, J), I-X=0..1, |Y-J|=0..1, |X-I|+|Y-J|=1..2.

% DYNAMIC CAUSAL law ------- action move causes ball_at
holds(ball_at(X,Y), T+1) :- occurs(move((I,J),(X,Y)), T), holds(ball_at(I, J), T), position(X, Y), step(T), step(T+1) .

% clear previous position after the move
-holds(ball_at(I,J), T+1) :- occurs(move((I,J),(X,Y)), T), holds(ball_at(I, J), T), position(X, Y), step(T), step(T+1) .

% ---- CONSTRAINTS and HEURISTICS --------------

% ball cannot be at two places
%-holds(ball_at(X,Y), T) :- holds(ball_at(I,J), T), position(X,Y), position(I,J), {I!=X; J!=Y}, step(T).
-holds(ball_at(X,Y), T) :- holds(ball_at(I,J), T), position(X,Y), position(I,J), X != I, step(T).
-holds(ball_at(X,Y), T) :- holds(ball_at(I,J), T), position(X,Y), position(I,J), Y != J, step(T).

% not moving back
%-occurs(move((I,J), (X,Y)), T+1) :- holds(move((X,Y),(I, J)), T), step(T), step(T+1) .
-holds(ball_at(X,Y), T+2) :- holds(ball_at(X,Y), T), step(T), step(T+2) .

% indirect effect, ball_at(X,Y) cause visited(X,Y)
holds(visited(X,Y), T) :- holds(ball_at(X,Y), T), position(X, Y), step(T).

% impossible to move to the position which is visited
-occurs(move((I,J), (X,Y)), T) :- holds(ball_at(I,J), T), holds(visited(X,Y), T), step(T).

% impossible to move((I,J), (X,Y)) if the ball is not at that position ball_at(I,J)
-occurs(move((I,J), (X,Y)), T) :- -holds(ball_at(I,J), T), position(I,J), position(X,Y), step(T).

% should not move((I,J), (X,Y)) if the ball_at(X,Y) already
-occurs(move((I,J), (X,Y)), T) :- holds(ball_at(X,Y), T), position(I, J) .

% impossible to move to the reverse direction
% impossible to move to the reverse direction
-occurs(move((I,J), (X,Y)), T) :- holds(directionLeft, T), holds(ball_at(I, J), T), position(X, Y), Y-J>0 .
-occurs(move((I,J), (X,Y)), T) :- -holds(directionLeft, T), holds(ball_at(I, J), T), position(X, Y), Y-J < 0  .


% ------- CHOICE RULES ---------------
success :- goal(T), T <= n.
:- not success.
%1{occurs(Action, T): action(Action)}1 :- step(T), not goal(T), T < n.

% ---------- GOAL ----------------
goal(T) :- holds(ball_at(5, 1), T), step(T).

% -------- INITIAL position --------------
holds(ball_at(1,3), 0) .
-holds(directionLeft, 0) .

occurs(move((1,3),(2,2)), 0) .
occurs(move((2,2),(3,1)), 1) .
occurs(move((3,1),(4,1)), 2) .
occurs(move((4,1),(5,1)), 3) .


#show occurs/2 .
%#show holds/2 .
%#show action/1 .
%#show ball_at/2 .


