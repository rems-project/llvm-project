"""
Check that lldb-server allows to obtain siginfo data for the last signal
received by a thread.
"""

from __future__ import print_function

import re
import struct
import sys

import gdbremote_testcase
from lldbsuite.test.decorators import llgs_test, no_match, skipIf
from lldbsuite.test import lldbtest
from lldbsuite.test import lldbutil


class TestGdbRemoteSigInfo(gdbremote_testcase.GdbRemoteTestCaseBase):

    mydir = lldbtest.TestBase.compute_mydir(__file__)

    SIGINFO_SUPPORT_FEATURE_NAME = "qXfer:siginfo:read"

    def check_signal(self, signal, endian, use_thread_suffix):
        """
        Continue the program and expect it to be stopped because it received a
        specified signal. Then query the siginfo data using the
        qXfer:siginfo:read request and check that the obtained information is
        sensible.

        If use_thread_suffix is True then the variant of qXfer:siginfo:read
        that includes the thread ID is used to read the data.
        """

        # Continue until the process stops at the signal.
        context = self.run_process_then_stop()
        self.assertIsNotNone(context)
        signo = lldbutil.get_signal_number(signal)
        self.assertEqual(int(context['stop_result'], 16), signo)

        # Grab the siginfo data.
        self.reset_test_sequence()
        self.test_sequence.add_log_lines(
            ['read packet: $qXfer:siginfo:read::0,80{}#00'.format(
                ';1' if use_thread_suffix else ''),
             {'direction': 'send',
              'regex': re.compile(
                  r'^\$([^E])(.*)#[0-9a-fA-F]{2}$',
                  re.MULTILINE | re.DOTALL),
              'capture': {1: 'response_type', 2: 'content_raw'}}],
            True)
        context = self.expect_gdbremote_sequence()
        self.assertIsNotNone(context)

        # Ensure all siginfo data are read in one packet.
        self.assertEqual(context['response_type'], 'l')

        # Decode the binary data.
        content_raw = context.get('content_raw')
        self.assertIsNotNone(content_raw)
        siginfo = self.decode_gdbremote_binary(content_raw)

        # Check the signal information.
        self.assertEqual(len(siginfo), 128)

        # Temporary python 2 code - should be removed when our CI has moved away
        # from python 2.
        if sys.version_info.major == 2:
            int_format = '<i' if endian == 'little' else '>i'
            si_signo = struct.unpack(int_format, siginfo[:4])[0]   # int si_signo
            si_errno = struct.unpack(int_format, siginfo[4:8])[0]  # int si_errno
            si_code = struct.unpack(int_format, siginfo[8:12])[0]  # int si_code
        else:
            def raw_bytes(str_input):
                # The byteorder doesn't matter here, since we only have 1 byte.
                return b''.join(
                        ord(c).to_bytes(1, byteorder=endian) for c in str_input)

            def parse_int(str_input):
                return int.from_bytes(raw_bytes(str_input), endian, signed=True)

            si_signo = parse_int(siginfo[:4])
            si_errno = parse_int(siginfo[4:8])
            si_code = parse_int(siginfo[8:12])

        self.assertEqual(si_signo, signo)
        self.assertEqual(si_errno, 0)
        self.assertEqual(si_code, -6)  # SI_TKILL (glibc >= 2.3.3)

    @llgs_test
    @skipIf(oslist=no_match(['linux']))
    @skipIf(archs=no_match(['arm', 'aarch64', 'i386', 'x86_64']))
    def test_siginfo(self):
        """
        Check that lldb-server reports correctly support for qXfer:siginfo:read
        in the qSupported reply and that querying the siginfo data returns
        correct information.
        """

        self.init_llgs_test()
        self.build()
        self.set_inferior_startup_launch()
        self.prep_debug_monitor_and_inferior()

        # Obtain endianness of the target.
        self.add_process_info_collection_packets()
        context = self.expect_gdbremote_sequence()
        self.assertIsNotNone(context)
        proc_info = self.parse_process_info_response(context)
        self.assertIsNotNone(proc_info)
        self.assertIn('endian', proc_info)
        endian = proc_info['endian']
        self.assertIn(endian, ['little', 'big'])

        # Check that qSupported reports that reading siginfo is supported.
        self.add_qSupported_packets()
        context = self.expect_gdbremote_sequence()
        self.assertIsNotNone(context)
        features = self.parse_qSupported_response(context)
        self.assertIn(self.SIGINFO_SUPPORT_FEATURE_NAME, features)
        self.assertEqual(features[self.SIGINFO_SUPPORT_FEATURE_NAME], '+')

        # Continue the program to the point where it raises SIGUSR1 and then
        # check the signal information.
        self.check_signal('SIGUSR1', endian, False)
        # Do the same with SIGUSR2 but this time use the variant of the
        # qXfer:siginfo:read query that includes the thread ID.
        self.check_signal('SIGUSR2', endian, True)
