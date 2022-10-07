#!/usr/bin/bash 
#
# sxlog.sh
# version 0.2
#
# CHANGELOG
# 
# v0.2 - supporting batch mode with multiple input files, sorting to output folder, filename by date
# v0.1 - Initial release
#
# for reference, the following nasty sed line does the trick:
# sed -n 's/\(^[0-9]*.[0-9]*.[0-9]*.[0-9]*\).*\[\([0-9]\{2\}\/[A-Za-z]*\/....\):\(.*\)......\] \"GET \/\([0-9a-zA-Z]\{3\}\)-[^"]*" \([0-9]*\) [0-9]* "\(.*\)" ".*[^0-9]* \([0-9]*\)$/\1'"\t"'\2'"\t"'\3'"\t"'\4'"\t"'\7'"\t"'\5'"\t"'\6/p'
#

# the following variable contains the name of the streams we want to dig out from the logs
ALLSTREAMS="905 ALT BSR FMF"

if [ -z "$*" ]
then
	echo
	echo Usage:
	echo $0 'streamer*log'
	echo
	exit 1
fi

# change these if the path is different in your distro, we assume GNU tools here
AWK=/usr/bin/awk
SED=/usr/bin/sed
DATE=/usr/bin/date
GREP=/usr/bin/grep
CAT=/usr/bin/cat
MKDIR=/usr/bin/mkdir
MKTEMP=/usr/bin/mktemp
RM=/usr/bin/rm
SORT=/usr/bin/sort

# we create a new output dir from scratch so we do not overwrite anything
OUTPUTDIR=/mnt/storage/logs/sxlogs/


# we store the "aggregate" in a temp file then sort out by stream and date later on
TEMPFILE=$(${MKTEMP} -p ${OUTPUTDIR})

# here we fill up the temp file with all the data
${CAT} $* | ${SED} -n 's/\(^[0-9]*.[0-9]*.[0-9]*.[0-9]*\).*\[\([0-9]\{2\}\/[A-Za-z]*\/....\):\(.*\)......\] \"GET \/\([0-9a-zA-Z]\{3\}\)-[^"]*" \([0-9]*\) [0-9]* "\(.*\)" ".*[^0-9]* \([0-9]*\)$/\1'"\t"'\2'"\t"'\3'"\t"'\4'"\t"'\7'"\t"'\5'"\t"'\6/p' > ${TEMPFILE}

# we pick each unique date
ALLDATES=$(${AWK} '{print $2}' ${TEMPFILE} | ${SORT} -u)

# and here we organize data into separate files, grouped by stream and date
for myDate in ${ALLDATES}
do
	
	for myStream in ${ALLSTREAMS}
	do
	
		OUTFILE=${OUTPUTDIR}/${myStream}_$(echo ${myDate} | ${SED} 's/\([^\/]*\)\/\([^\/]*\)\/\([^\/]*\)/\3-\2-\1/').txt
		${DATE} "+%Y-%m-%dT%H:%M:%S.%N  Creating ${OUTFILE}"
		${AWK} '$2 == "'${myDate}'" && $4 == "'${myStream}'"' ${TEMPFILE} > ${OUTFILE}

	done
done

# cleanup
${RM} ${TEMPFILE}
