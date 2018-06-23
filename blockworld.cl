block ( b0 ) .
block ( b4 ) .
block ( b1 ) .
block ( b5 ) .
block ( b2 ) .
block ( b6 ) .
block ( b3 ) .
block ( b7 ) .

location(X) :- block(X) .
location(t) .

#const n = 2 .
step(0..n) .

fluent ( on( B , L ) ) :- block ( B ), location( L ) .

action(put ( B , L ) ) :- block( B ) , location( L ) , B != L .

holds ( on ( b0 , t ) , 0 ) .
holds ( on ( b3 , b0 ) , 0 ) .
holds ( on ( b2 , b3 ) , 0 ) .
holds ( on ( b1 , t ) , 0 ) .
holds ( on ( b4 , b1 ) , 0 ) .
holds ( on ( b5 , t ) , 0 ) .
holds ( on ( b6 , b5 ) , 0 ) .
holds ( on ( b7 , b6 ) , 0 ) .

-holds ( on( B , L ) , 0 ) :- block( B ), location( L ) , not holds ( on ( B , L ) , 0 ) .

holds ( on( B , L ) , I +1) :- occurs( put ( B , L ) , I ) , I < n.
