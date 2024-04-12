//SuperCollider 3.13.0
//to avoid conflict with output sample rate which must be 44,100 Hz
Server.default.options.numInputBusChannels=0;
Server.default = Server.internal;
s.boot;
//Longplayer SynthDef
(
SynthDef("longplayer",{
arg buffer = 0,length = 1,realLength,
    pitch1 = 1,pitch2 = 0.75,pitch3 = 1.5,pitch4 = 0.5,pitch5 = 0.66,pitch6 = 1.33,
    startPos1 = 0,startPos2 = 0,startPos3 = 0,startPos4 = 0,startPos5 = 0,startPos6 = 0,
    offset1 = 0.2045898210232640,offset2 = 46.44188937228090,offset3 = 329.185022026432,
    offset4 = 2593.175981469840,offset5 = 11146.05344934740,offset6 = 19751.3059114067,
    yteration;
var e,osc;
e = Env.new([0,1,1,0],[0.05,0.95,0.05]);
osc =
PlayBuf.ar(1,buffer,BufRateScale.kr(buffer)* pitch1,startPos: (startPos1 + (offset1 * yteration))%realLength)
+
PlayBuf.ar(1,buffer,BufRateScale.kr(buffer)* pitch2,startPos: (startPos2 + (offset2 * yteration))%realLength)
+
PlayBuf.ar(1,buffer,BufRateScale.kr(buffer)* pitch3,startPos: (startPos3 + (offset3 * yteration))%realLength)
+
PlayBuf.ar(1,buffer,BufRateScale.kr(buffer)* pitch4,startPos: (startPos4 + (offset4 * yteration))%realLength)
+
PlayBuf.ar(1,buffer,BufRateScale.kr(buffer)* pitch5,startPos: (startPos5 + (offset5 * yteration))%realLength)
+
PlayBuf.ar(1,buffer,BufRateScale.kr(buffer)* pitch6,startPos: (startPos6 + (offset6 * yteration))%realLength);

Out.ar([0,1],osc * EnvGen.kr(e,timeScale:length, doneAction: 2));
}).writeDefFile;
s.sendSynthDef("longplayer");
)
//run
(
var date;
var yr,mnth,dy,hr,min,sec;
var leap,fullYearsRun,leapYears,notLeapYears,daysInFullYears,totalDays;
var daysInMonths,monthDays,leapMonthDays;
var now_seconds, millennium_seconds, num_seconds_since_millennium;
var listNo,extraIterations;
var onAt,extraIt,totalIterations,incList,realLength,lpCallList;
var timeZoneOffset;
var minz,hrz,daze;
//calculating time run
var minsrun,hrsrun,daysrun;
//for countdown
var onIn;
//time zone offset: Loongplayer takes its time from the International Date Line
//London: 12 hours behind - offset added to local time
timeZoneOffset = 12;
/*
the soundfile has an extra section, the first two minutes, added to its end
this is to allow the 2 minute section playing to slide seamlessly across the join of
end and start points, as if the soundfile was glued together into a continuous circle
*/
//expects a soundfile called 20-20.aif inside the same directory as this code
s.sendMsg("/b_allocRead", 0, thisProcess.nowExecutingPath.dirname +/+ "20-20.aif");
lpCallList = List.fill(6,0);
//realLength is 20 mins 20 seconds * sample rate - here 44100
//actual soundfile is longer to emulate smooth transition across joined up start and end point
realLength = 53802000;
monthDays =#[0,31,59,90,120,151,181,212,243,273,304,334];
leapMonthDays =#[0,31,60,91,121,152,182,213,244,274,305,335];
//increments
incList = #[0.2045898210232640,46.44188937228090,329.185022026432, 2593.175981469840, 11146.05344934740, 19751.3059114067];
//find current time and date
date = Date.gmtime;
yr = date.year;
mnth = date.month;
dy = date.day;
hr = date.hour;
min = date.minute;
sec = date.second;
//calculate time to start playing, onAt. This has to be the start of the next increment,the next even number of minutes
if(min.even,{onAt = (min + 2)%60},{onAt = (min + 1)%60});
if(onAt == 0,{onAt = 60});
["onAt "++onAt].postln;
//calculate number of increments since Longplayer started playing:
//total seconds since January 1st 1970
now_seconds = Date.getDate.rawSeconds;
//total seconds between January 1st 1970 and 31st December 1999
millennium_seconds = 946641600;
//total seconds Longplayer has been playing
num_seconds_since_millennium = now_seconds - millennium_seconds;
//total number of iterations at next two minute period
totalIterations = (num_seconds_since_millennium / 120).ceil;
totalIterations.postln;
["time zone offset is local time plus "++timeZoneOffset++" hours"].postln;
["date and time at 180 degrees longitude is "++(if(hr + timeZoneOffset > 23,{dy+1},{dy}))++" : "++mnth++" : "++yr++"   "++((hr + timeZoneOffset)%24)++" hours : "++min++" minutes"].postln;
["total iterations are "++totalIterations].postln;
//startup:
//calculate start points, in samples, for each of the six transpositions of soundfile
6.do({arg i;var temp;temp = (totalIterations*(incList@i))%realLength;lpCallList.put(i,temp)});
["start point list is "++lpCallList].postln;
//countdown to Longplayer starting to play
onIn = ((onAt * 60) - ((Date.localtime.minute * 60) + (Date.localtime.second))).post;
t = Routine({
onIn.do
	({arg j;
		{("Longplayer starting up in "++(onIn - j)++ " seconds").postln}.defer;
     1.wait;
     });
});
SystemClock.play(t);
//play routine
r = Routine({
onIn.wait;
inf.do({arg j;
{Synth("longplayer",['buffer',0,'length',120,'realLength',realLength,'startPos1',lpCallList@0,'startPos2',lpCallList@1,'startPos3',lpCallList@2,'startPos4',lpCallList@3,'startPos5',lpCallList@4,'startPos6',lpCallList@5,'yteration',j]);
//update increments
totalIterations = totalIterations +1;
//post how long Longplayer has been playing
minsrun = totalIterations * 2;
minsrun = minsrun - 2;
minz = minsrun%60;
if(minz == -0,{minz = 0});
hrsrun = ((minsrun/60).floor);
hrz = hrsrun%24;
if(hrz == -0,{hrz = 0});
daze = (hrsrun/24).floor;
("Longplayer has been playing for "++daze++" days "++hrz++" hours and "++minz++" minutes").postln;
}.defer;
120.wait;
     });
});
SystemClock.play(r);
)