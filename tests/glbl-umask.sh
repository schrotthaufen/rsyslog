#!/bin/bash
# addd 2017-03-06 by RGerhards, released under ASL 2.0

# Note: we need to inject a somewhat larger nubmer of messages in order
# to ensure that we receive some messages in the actual output file,
# as batching can (validly) cause a larger loss in the non-writable
# file

. $srcdir/diag.sh init
generate_conf
add_conf '
global(umask="0077")

template(name="outfmt" type="string" string="%msg:F,58:2%\n")
:msg, contains, "msgnum:" {
	action(type="omfile" template="outfmt" file="rsyslog.out.log")
}
'
startup
$srcdir/diag.sh injectmsg 0 1
shutdown_when_empty
wait_shutdown

if [ `ls -l rsyslog.out.log|$RS_HEADCMD -c 10 ` != "-rw-------" ]; then
  echo "invalid file permission (umask), rsyslog.out.log has:"
  ls -l rsyslog.out.log
  error_exit 1
fi;
exit_test
