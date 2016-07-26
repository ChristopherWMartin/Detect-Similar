# Detect Similar

When run, detectSimilar.sh iterates through a directory of images and allows the user to act on those that contain greater than a defined percentage of similar pixels (set using the 'definedThreshhold' variable (the default being 0.2 -- 20%)).

detectSimilar.sh can be run periodically as a cron job by editing your users crontab file

```
crontab -e
```

and adding a new job for the script

```
* * * * * /path/to/detectSimilar.sh
```

The above will, for example, run the script once every minute.

This script depends on 'ImageMagick' and 'bc'. Both of which are installed by default on most Linux distributions.
