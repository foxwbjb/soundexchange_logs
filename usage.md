# WBJB Soundexchange Log Formatter



### Usage

Run the sxlogs script on the Icecast logs dir

```
bash /home/fox/sxlog.sh /mnt/storage/logs/icecast/access.log.202209*
```

That will parse the log and generate separate log files for each stream and each day.

Then run the sxcat script with an input date to concatenate the logs for input date +7

```
bash sxcat.sh /mnt/storage/logs/icecast/sxlogs/905_2022-Sep-20.txt

```
