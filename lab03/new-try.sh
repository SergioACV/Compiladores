  GNU nano 2.2.2                                                                  File: new-try.sh                                                                                                                                           

rm cool-tree.handcode.h
rm cool-tree.h
rm semant.cc
rm semant.h

cp /media/sf_actividades/Compiladores/lab03/semant.cc .
cp /media/sf_actividades/Compiladores/lab03/semant.h .
cp /media/sf_actividades/Compiladores/lab03/cool-tree.h .
cp /media/sf_actividades/Compiladores/lab03/cool-tree.handcode.h .


rm mysemant
make semant

./pa3-grading.pl
