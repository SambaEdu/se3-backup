#!/bin/bash

#
## $Id: diskdetect.sh 4428 2009-09-19 15:32:26Z gnumdk $ ##
#
cd /dev/disk/by-id/
ls usb-*| grep -v part
cd - >/dev/null
