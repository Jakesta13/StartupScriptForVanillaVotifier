#!/bin/bash
#Settings
#Name of Screen session.
name=VOTE

#CPU to limit the jar.
#E.g 400% means allow the program to use 100% of all 4 cores of a cpu.
#Low persentages causes the program to behave slowly for the first vote,
# which is why we send an initial testvote command.
CPU=5

#Memory limits for VanillaVotifier.
#Lower is prefered, 32MB works best.
#Less memory causes the program to behave slowly for the first vote,
# but since we send an initial testvote command, this doesn't matter.
#Refrence: -Xmx is max memory. -Xms is iniital memory.
initial=32MB
max=32MB

#Program process niceness.
#Higher the number, less process priority.
#Max of 20 and -20
niceness=10

#Username to send testvote as.
#Doesn't have to be a real account.
testname=jakesta13

#DIR where the JAR is located.
#Please, please, please use quotations.
#Note: You don't need to have a final forward slash
# as the script adds one as a suffix.
basedir="/home/pi/Votifyer"
#### #### ####

echo starting new screen session in the background named ${name}
screen -dmS ${name} java -jar ${basedir}/VanillaVotifier.jar -Xmx${max} -Xms${initial}
#We need to sleep for a minimum of 10 seconds,
# this is to allow the program to start before limits as pre-limits causes errors.
sleep 10
cpulimit -b -l ${CPU} -p `pgrep java`
renice -n ${niceness} `pgrep java`
echo sending testvote command for setup.
screen -S ${name} -p 0 -X stuff "testvote ${testname}^M"
exit
