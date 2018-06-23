spot(0..7).
%male(mrAstor). male(mrBlake). ...
male(mrAstor;mrBlake;mrCrane;mrDavis).
person(mrAstor;mrsAstor;mrBlake;mrsBlake;
mrCrane;mrsCrane;mrDavis;mrsDavis).
married(mrAstor,mrsAstor).
married(mrBlake,mrsBlake).
married(mrCrane,mrsCrane).
married(mrDavis,mrsDavis).
%married is symmetric
married(P,P1) :- married(P1,P), person(P;P1).

%% GENERATE
%% Mr and Mrs Astor, Mr and Mrs Blake, Mr and Mrs Crane,
%% Mr and Mrs Davis were seated around a circular table.
%every person is assigned a spot
1{place(P,S): spot(S)}1:-person(P).
%% DEFINE
% two places at a table are opposite
opposite(S,S+4) :- spot(S;S+4).
% opposite is symmetric
opposite(S1,S2) :- opposite(S2,S1), spot(S1;S2).


