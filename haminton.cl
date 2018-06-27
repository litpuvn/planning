vertex(1..8) .

edge(1, 2) . edge(2, 3) . edge(3, 4) .
edge(4, 5) . edge(5, 6) . edge(6, 7) .
edge(7, 8) . edge(8, 1) .

% undirected graph
edge(X, Y) : edge(Y, X) .
pos(X) :- vertex(X) .

% each vertex V, has one position P that V is in
1{ in_pos(V, P) : pos(P)}1:- vertex(V) .

% each position, there is a vertex in
1{ in_pos(V, P) : vertex(V)}1 :- pos(P) .

% not an answer if no edge connecting two vertices
:- in_pos(V1, P), in_pos(V2, P+1), not edge(V1, V2), pos(P), pos(P+1) .