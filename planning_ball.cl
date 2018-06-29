% Path search in a grid, from one point to goal
% blank positions are where defenders are located. The ball cannot be driven there.

% missing positions are blocking positions such as goal keeper or defender.
position(1,1).  position(1,2).   position(1,3). position(1,4). position(1,5).
                position(2,2).   position(2,3). position(2,4). position(2,5).
position(3,1).  position(3,2).                  position(3,4). position(3,5).
position(4,1).  position(4,2).   position(4,3).                position(4,5).
position(5,1).                                                 position(5,5).

% STEPS
#const n = 10 .
step(0..n) .

% FLUENT ------ ball_at changes with time
fluent(inertial, ball_at(X,Y)) :- position(X,Y).
fluent(defined, visited(X,Y)) :- position(X,Y).

%% ---- CWA for Defined FLUENT ----
-holds(F,T) :- fluent(defined,F), step(T), not holds(F,T).

% INERTIA AXIOM ------- normally things stay as they are
%holds(F, T+1) :- holds(F, T), not -holds(F, T+1), step(T), T< n.
%-holds(F, T+1) :- -holds(F, T), not holds(F, T+1), step(T), T< n.

%% INERTIA AXIOM for inertial FLUENT
holds(F,T+1) :- fluent(inertial,F), holds(F,T), not -holds(F,T+1), T < n.
-holds(F,I+1) :- fluent(inertial,F), -holds(F,I), not holds(F,I+1), I < n.

%% CWA for Actions
-occurs(A,T) :- action(A), step(T), not occurs(A,T), step(T).

% ACTION ------ "move" in our domain
action(move((X,Y),(I,J))) :- position(X, Y), position(I, J), I-X=0..1, |Y-J|=0..1, |X-I|+|Y-J|=1..2.

% DYNAMIC CAUSAL law ------- action move causes ball_at
holds(ball_at(X,Y), T+1) :- occurs(move((I,J),(X,Y)), T), holds(ball_at(I, J), T), position(X, Y), step(T), step(T+1) .

% ---- CONSTRAINTS and HEURISTICS --------------
% not moving back
-holds(ball_at(X,Y), T+2) :- holds(ball_at(X,Y), T), step(T), step(T+2) .
%-occurs(move((I,J), (X,Y)), T+1) :- holds(move((X,Y),(I, J)), T), step(T), step(T+1) .

% indirect effect, when the ball moves causes visited
holds(visited(X,Y), T) :- holds(ball_at(X,Y), T), position(X, Y).

% impossible to move to the position which is visited
-occurs(move((I,J), (X,Y)), T) :- holds(ball_at(I,J), T), holds(visited(X,Y), T).

% ------- CHOICE RULES ---------------
success :- goal(T), T <= n.
:- not success.
1{occurs(Action, T): action(Action)}1 :- step(T), not goal(T), T < n.

% ---------- GOAL ----------------
goal(T) :- holds(ball_at(5, 1), T), step(T).

% -------- INITIAL position --------------
holds(ball_at(1,1), 0) .

#show occurs/2 .
%#show holds/2 .
%#show visited/2 .


