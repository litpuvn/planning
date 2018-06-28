%% crossing.lp -- translation of system description from Section 9.2.3
%% (Code from Appendix D.2)
%% Last Modified: 2/3/14
%% Three missionaries and three cannibals come to a river
%% and find a boat that holds at most two people. If the
%% cannibals ever outnumber the missionaries on either bank,
%% the missionaries will be eaten.
%% How can they all cross?

%% crossing.lp

%% ----------
%% Signature:
%% ----------

%% Steps:
#const n = 11.
step(0..n).

location(bank1).
location(bank2).

%% Number of cannibals/missionaries:
num(0..3).

%% Number of Boats:
num_boats(0..1).

%% --------
%% Statics:
%% --------

%% opposite bank:
opposite(bank1,bank2).
opposite(bank2,bank1).

%% --------
%% Fluents:
%% --------

%% number of missionaries at location Loc is N:
fluent(inertial, m(Loc, N)) :- location(Loc), num(N).

%% number of cannibals at location Loc is N:
fluent(inertial, c(Loc, N)) :- location(Loc), num(N).

%% number of boats at location Loc is NB:
fluent(inertial, b(Loc, NB)) :- location(Loc), num(NB).

%% true if cannibals outnumber missionaries on the same bank:
fluent(inertial, casualties).

%% --------
%% Actions:
%% --------

%% move NC (a given number of cannibals) and NM (a given number
%% of missionaries) to Dest (a destination):
action(move(NC, NM, Dest)) :- num(NC), num(NM), location(Dest).

%%-----------------------------------
%% Encoding of AL System Description:
%%-----------------------------------

%% Moving objects increases the number of objects at the
%% destination by the amount moved.

holds(m(Dest, N+NM), I+1) :- holds(m(Dest,N),I),
                             occurs(move(NC, NM, Dest), I),
                             I < n.

holds(c(Dest, N+NC), I+1) :- holds(c(Dest,N),I),
                             occurs(move(NC, NM, Dest), I),
                             I < n.

holds(b(Dest, 1), I+1) :- occurs(move(NC, NM, Dest), I),
                          I < n.

%% The number of missionaries/cannibals at the opposite bank
%% is 3 - number_on_this_bank. The number of boats at the
%% opposite bank is 1-number_of_boats_on_this_bank.

holds(m(Source, 3-N),I) :- holds(m(Dest, N),I),
                           opposite(Source,Dest).

holds(c(Source, 3-N),I) :- holds(c(Dest, N),I),
                           opposite(Source,Dest).

holds(b(Source, 1-NB), I) :- holds(b(Dest,NB),I),
                             opposite(Source,Dest).

%% There cannot be different numbers of the same type of person
%% at the same location.
-holds(m(Loc, N1), I) :- num(N1),
                         holds(m(Loc, N2),I),
                         N1 != N2.

-holds(c(Loc, N1), I) :- num(N1),
                         holds(c(Loc, N2),I),
                         N1 != N2.

%% A boat can't be in and not in a location
-holds(b(Loc, NB1), I) :- num(NB1),
                          holds(b(Loc, NB2), I),
                          NB1 != NB2.

%% A boat can't be in two places at once.
-holds(b(Loc1, N), I) :- location(Loc1),
                         holds(b(Loc2, N),I),
                         Loc1 != Loc2.

%% There will be casualties if cannibals outnumber missionaries:
holds(casualties,I) :- holds(m(Loc, NM),I),
                       holds(c(Loc, NC),I),
                       NM > 0, NM < NC.

%% It is impossible to move more than two people at the same time;
%% it is also impossible to move less than 1 person.
-occurs(move(NC,NM,Dest),I) :- num(NC), num(NM),
                               location(Dest), step(I),
                               (NC+NM) > 2.
-occurs(move(NC,NM,Dest),I) :- num(NC), num(NM),
                               location(Dest), step(I),
                               (NM+NC) < 1.

%% It is impossible to move objects without a boat at the source.
-occurs(move(NC,NM,Dest), I) :- num(NC), num(NM),
                                opposite(Source,Dest),
                                holds(b(Source,0),I).

%% It is impossible to move N objects from a source if there
%% aren't at least N objects at the source in the first place.
-occurs(move(NC,NM,Dest), I) :- num(NC), num(NM),
                                opposite(Source,Dest),
                                holds(m(Source,NMSource), I),
                                NMSource < NM.
-occurs(move(NC,NM,Dest), I) :- num(NC), num(NM),
                                opposite(Source,Dest),
                                holds(c(Source,NCSource),I),
                                NCSource < NC.

%%---------------
%% Inertia Axiom:
%%---------------

holds(F, I+1) :- fluent(inertial, F),
                 holds(F,I),
                 not -holds(F, I+1),
                 I < n.

-holds(F, I+1) :- fluent(inertial, F),
                  -holds(F,I),
                  not holds(F, I+1),
                  I < n.

%%-----------------
%% CWA for Actions:
%%-----------------

-occurs(A,I) :- action(A), step(I),
                not occurs(A,I).

%% ------------------
%% Initial Situation:
%% ------------------

holds(m(bank1,3), 0).
holds(c(bank1,3), 0).
holds(b(bank1,1), 0).
-holds(casualties,0).

%% -----
%% Goal:
%% -----

goal(I) :-
   -holds(casualties,I),
    holds(m(bank2,3),I),
    holds(c(bank2,3),I).

%% ----------------
%% Planning Module:
%% ----------------

success :- goal(I),
           I <= n.
:- not success.

1{occurs(Action,I): action(Action)}1 :- step(I),
                                        not goal(I),
                                        I < n.

#show occurs/2.