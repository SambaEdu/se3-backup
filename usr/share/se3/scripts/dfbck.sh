#!/bin/bash

#
# $Id$
#

df -Ph |grep backuppc | awk '{print $4}'
