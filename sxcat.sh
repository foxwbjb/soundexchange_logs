#!/bin/bash

if [ ! -r "$1" ]
then
	echo
	echo "Input file does not exist!"
	echo
	echo "Usage: $0 filename"
	echo "		where filename is [STREAM]_YEAR-Mon-DD.txt"
	echo "		e.g. 905_2021-Sep-04.txt"
	echo
else
	DIRNAME=$(dirname $1)
	STREAM=$(basename $1 | /usr/bin/sed 's/\(...\)_\(....\)-\(.*\)-\(..\).txt/\1/')
	YEAR=$(basename $1 | /usr/bin/sed 's/\(...\)_\(....\)-\(.*\)-\(..\).txt/\2/')
	MONTH=$(basename $1 | /usr/bin/sed 's/\(...\)_\(....\)-\(.*\)-\(..\).txt/\3/')
	STARTDAY=$(basename $1 | /usr/bin/sed 's/\(...\)_\(....\)-\(.*\)-\(..\).txt/\4/')

	
	DATE1=$(/usr/bin/date --date="${MONTH} ${STARTDAY} ${YEAR} +0 days" +%Y-%b-%d)
	DATE2=$(/usr/bin/date --date="${MONTH} ${STARTDAY} ${YEAR} +1 days" +%Y-%b-%d)
	DATE3=$(/usr/bin/date --date="${MONTH} ${STARTDAY} ${YEAR} +2 days" +%Y-%b-%d)
	DATE4=$(/usr/bin/date --date="${MONTH} ${STARTDAY} ${YEAR} +3 days" +%Y-%b-%d)
	DATE5=$(/usr/bin/date --date="${MONTH} ${STARTDAY} ${YEAR} +4 days" +%Y-%b-%d)
	DATE6=$(/usr/bin/date --date="${MONTH} ${STARTDAY} ${YEAR} +5 days" +%Y-%b-%d)
	DATE7=$(/usr/bin/date --date="${MONTH} ${STARTDAY} ${YEAR} +6 days" +%Y-%b-%d)
	
	OUTFILE=/mnt/storage/logs/sxlogs/${STREAM}_${YEAR}-${MONTH}-${STARTDAY}_SX.txt

	/usr/bin/cat ${DIRNAME}/${STREAM}_${DATE1}.txt \
			${DIRNAME}/${STREAM}_${DATE2}.txt \
			${DIRNAME}/${STREAM}_${DATE3}.txt \
			${DIRNAME}/${STREAM}_${DATE4}.txt \
			${DIRNAME}/${STREAM}_${DATE5}.txt \
			${DIRNAME}/${STREAM}_${DATE6}.txt \
			${DIRNAME}/${STREAM}_${DATE7}.txt > ${OUTFILE} 2>/dev/null
	echo Outfile is ${OUTFILE}
		
fi
