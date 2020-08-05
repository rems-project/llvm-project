"""
Test that it is possible to obtain the siginfo data for the last signal
received by a thread.
"""

from __future__ import print_function

import os

import lldb
from lldbsuite.test.decorators import no_match, skipIf
from lldbsuite.test import lldbtest
from lldbsuite.test import lldbutil


class SigInfoTestCase(lldbtest.TestBase):

    mydir = lldbtest.TestBase.compute_mydir(__file__)

    @skipIf(oslist=no_match(['linux']))
    @skipIf(archs=no_match(['arm', 'aarch64', 'i386', 'x86_64']))
    def test_siginfo(self):
        """
        Test that the siginfo data can be queried through the SB API and the
        command line interface.
        """

        self.build()
        exe = self.getBuildArtifact('a.out')

        # Create a target from the debugger.
        target = self.dbg.CreateTarget(exe)
        self.assertTrue(target, lldbtest.VALID_TARGET)

        # Create a breakpoint at main().
        lldbutil.run_break_set_by_symbol(self, 'main')

        # Now launch the process, and do not stop at the entry point.
        process = target.LaunchSimple(
            None, None, self.get_process_working_directory())
        self.assertTrue(process, lldbtest.PROCESS_IS_VALID)
        self.assertEqual(process.GetState(), lldb.eStateStopped,
                         lldbtest.STOPPED_DUE_TO_BREAKPOINT)
        thread = lldbutil.get_stopped_thread(process,
                                             lldb.eStopReasonBreakpoint)
        self.assertTrue(thread.IsValid(),
                        "Thread is stopped due to a breakpoint")

        # Make sure to stop at SIGUSR1.
        signal = 'SIGUSR1'
        signo = process.GetUnixSignals().GetSignalNumberFromName(signal)
        return_obj = lldb.SBCommandReturnObject()
        self.dbg.GetCommandInterpreter().HandleCommand(
            'process handle --notify true --pass false --stop true {}'.format(
                signal),
            return_obj)
        self.assertTrue(return_obj.Succeeded(), "Setting signal handling")

        # Continue until the process stops at the signal.
        process.Continue()
        self.assertEqual(process.GetState(), lldb.eStateStopped)
        thread = lldbutil.get_stopped_thread(process, lldb.eStopReasonSignal)
        self.assertTrue(thread.IsValid(), "Thread is stopped due to a signal")
        self.assertGreaterEqual(thread.GetStopReasonDataCount(), 1,
                                "There is data in the event")
        self.assertEqual(thread.GetStopReasonDataAtIndex(0), signo,
                         "The stop signal is {}".format(signal))

        # Check the signal information.
        error = lldb.SBError()
        siginfo = thread.GetSigInfo(error)
        self.assertTrue(siginfo.IsValid())
        self.assertTrue(error.Success())

        si_signo = siginfo.GetChildMemberWithName('si_signo')
        self.assertTrue(si_signo.IsValid())
        self.assertEqual(si_signo.GetValueAsSigned(-1), signo)

        si_errno = siginfo.GetChildMemberWithName('si_errno')
        self.assertTrue(si_errno.IsValid())
        self.assertEqual(si_errno.GetValueAsSigned(-1), 0)

        si_code = siginfo.GetChildMemberWithName('si_code')
        self.assertTrue(si_code.IsValid())
        self.assertEqual(si_code.GetValueAsSigned(0), -6)  # SI_TKILL

        # Check the kill fields.
        si_kill_pid = siginfo.GetValueForExpressionPath('.si_fields.kill.pid')
        self.assertTrue(si_kill_pid.IsValid())
        self.assertEqual(si_kill_pid.GetValueAsSigned(-1),
                         process.GetProcessID())
        si_kill_uid = siginfo.GetValueForExpressionPath('.si_fields.kill.uid')
        self.assertTrue(si_kill_uid.IsValid())

        # Check the timer fields.
        si_timer_tid = siginfo.GetValueForExpressionPath(
            '.si_fields.timer.tid')
        self.assertTrue(si_timer_tid.IsValid())
        si_timer_overrun = siginfo.GetValueForExpressionPath(
            '.si_fields.timer.overrun')
        self.assertTrue(si_timer_overrun.IsValid())
        si_timer_sigval_int = siginfo.GetValueForExpressionPath(
            '.si_fields.timer.sigval.sival_int')
        self.assertTrue(si_timer_sigval_int.IsValid())
        si_timer_sigval_ptr = siginfo.GetValueForExpressionPath(
            '.si_fields.timer.sigval.sival_ptr')
        self.assertTrue(si_timer_sigval_ptr.IsValid())

        # Check the rt fields.
        si_rt_pid = siginfo.GetValueForExpressionPath('.si_fields.rt.pid')
        self.assertTrue(si_rt_pid.IsValid())
        si_rt_uid = siginfo.GetValueForExpressionPath('.si_fields.rt.uid')
        self.assertTrue(si_rt_uid.IsValid())
        si_rt_sigval_int = siginfo.GetValueForExpressionPath(
            '.si_fields.rt.sigval.sival_int')
        self.assertTrue(si_rt_sigval_int.IsValid())
        si_rt_sigval_ptr = siginfo.GetValueForExpressionPath(
            '.si_fields.rt.sigval.sival_ptr')
        self.assertTrue(si_rt_sigval_ptr.IsValid())

        # Check the sigchld fields.
        si_sigchld_pid = siginfo.GetValueForExpressionPath(
            '.si_fields.sigchld.pid')
        self.assertTrue(si_sigchld_pid.IsValid())
        si_sigchld_uid = siginfo.GetValueForExpressionPath(
            '.si_fields.sigchld.uid')
        self.assertTrue(si_sigchld_uid.IsValid())
        si_sigchld_status = siginfo.GetValueForExpressionPath(
            '.si_fields.sigchld.status')
        self.assertTrue(si_sigchld_status.IsValid())
        si_sigchld_utime = siginfo.GetValueForExpressionPath(
            '.si_fields.sigchld.utime')
        self.assertTrue(si_sigchld_utime.IsValid())
        si_sigchld_stime = siginfo.GetValueForExpressionPath(
            '.si_fields.sigchld.stime')
        self.assertTrue(si_sigchld_stime.IsValid())

        # Check the sigfault fields.
        si_sigfault_addr = siginfo.GetValueForExpressionPath(
            '.si_fields.sigfault.addr')
        self.assertTrue(si_sigfault_addr.IsValid())
        si_sigfault_addr_lsb = siginfo.GetValueForExpressionPath(
            '.si_fields.sigfault.addr_lsb')
        self.assertTrue(si_sigfault_addr_lsb.IsValid())
        si_sigfault_addr_bnd = siginfo.GetValueForExpressionPath(
            '.si_fields.sigfault.extra.addr_bnd')
        self.assertTrue(si_sigfault_addr_bnd.IsValid())
        si_sigfault_pkey = siginfo.GetValueForExpressionPath(
            '.si_fields.sigfault.extra.pkey')
        self.assertTrue(si_sigfault_pkey.IsValid())

        # Check the sigpoll fields.
        si_sigpoll_band = siginfo.GetValueForExpressionPath(
            '.si_fields.sigpoll.band')
        self.assertTrue(si_sigpoll_band.IsValid())
        si_sigpoll_fd = siginfo.GetValueForExpressionPath(
            '.si_fields.sigpoll.fd')
        self.assertTrue(si_sigpoll_fd.IsValid())

        # Check the sigsys fields.
        si_sigsys_call_addr = siginfo.GetValueForExpressionPath(
            '.si_fields.sigsys.call_addr')
        self.assertTrue(si_sigsys_call_addr.IsValid())
        si_sigsys_syscall = siginfo.GetValueForExpressionPath(
            '.si_fields.sigsys.syscall')
        self.assertTrue(si_sigsys_syscall.IsValid())
        si_sigsys_arch = siginfo.GetValueForExpressionPath(
            '.si_fields.sigsys.arch')
        self.assertTrue(si_sigsys_arch.IsValid())

        # Check the information using the command line interface.
        self.expect(
            'thread info --sig-info',
            substrs=["si_signo = {}".format(signo),
                     "si_errno = 0",
                     "si_code = -6"])

        # Continue until the exit.
        process.Continue()
        self.assertEqual(process.GetState(), lldb.eStateExited)
        self.assertEqual(process.GetExitStatus(), 0)
