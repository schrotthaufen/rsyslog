#!/bin/bash
# Test for disk-only queue mode
# This test checks if queue files can be correctly written
# and read back, but it does not test the transition from
# memory to disk mode for DA queues.
# added 2009-04-17 by Rgerhards
# This file is part of the rsyslog project, released  under GPLv3
# uncomment for debugging support:
echo ===============================================================================
echo \[diskqueue.sh\]: testing queue disk-only mode
# uncomment for debugging support:
#export RSYSLOG_DEBUG="debug nostdout noprintmutexaction"
#export RSYSLOG_DEBUGLOG="log"
. $srcdir/diag.sh init
startup diskqueue.conf
# 20000 messages should be enough - the disk test is slow enough ;)
sleep 4
. $srcdir/diag.sh tcpflood -m20000
shutdown_when_empty # shut down rsyslogd when done processing messages
wait_shutdown
seq_check 0 19999
exit_test
