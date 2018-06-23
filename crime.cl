innocent(Suspect) :- motive(Suspect), not guilty(Suspect).

motive(harry).
motive(sally).
guilty(harry).

#show innocent/1.