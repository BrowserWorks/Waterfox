# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

import datetime
import logging
import moznetwork
import select
import socket
import time
import os
import re
import posixpath
import subprocess
import StringIO
from devicemanager import DeviceManager, DMError, _pop_last_line
import errno
from distutils.version import StrictVersion


class DeviceManagerSUT(DeviceManager):
    """
    Implementation of DeviceManager interface that speaks to a device over
    TCP/IP using the "system under test" protocol. A software agent such as
    Negatus (http://github.com/mozilla/Negatus) or the Mozilla Android SUTAgent
    app must be present and listening for connections for this to work.
    """

    _base_prompt = '$>'
    _base_prompt_re = '\$\>'
    _prompt_sep = '\x00'
    _prompt_regex = '.*(' + _base_prompt_re + _prompt_sep + ')'
    _agentErrorRE = re.compile('^##AGENT-WARNING##\ ?(.*)')

    reboot_timeout = 600
    reboot_settling_time = 60

    def __init__(self, host, port=20701, retryLimit=5, deviceRoot=None,
                 logLevel=logging.ERROR, **kwargs):
        DeviceManager.__init__(self, logLevel=logLevel,
                               deviceRoot=deviceRoot)
        self.host = host
        self.port = port
        self.retryLimit = retryLimit
        self._sock = None
        self._everConnected = False

        # Get version
        verstring = self._runCmds([{'cmd': 'ver'}])
        ver_re = re.match('(\S+) Version (\S+)', verstring)
        self.agentProductName = ver_re.group(1)
        self.agentVersion = ver_re.group(2)

    def _cmdNeedsResponse(self, cmd):
        """ Not all commands need a response from the agent:
            * rebt obviously doesn't get a response
            * uninstall performs a reboot to ensure starting in a clean state and
              so also doesn't look for a response
        """
        noResponseCmds = [re.compile('^rebt'),
                          re.compile('^uninst .*$'),
                          re.compile('^pull .*$')]

        for c in noResponseCmds:
            if (c.match(cmd)):
                return False

        # If the command is not in our list, then it gets a response
        return True

    def _stripPrompt(self, data):
        """
        take a data blob and strip instances of the prompt '$>\x00'
        """
        promptre = re.compile(self._prompt_regex + '.*')
        retVal = []
        lines = data.split('\n')
        for line in lines:
            foundPrompt = False
            try:
                while (promptre.match(line)):
                    foundPrompt = True
                    pieces = line.split(self._prompt_sep)
                    index = pieces.index('$>')
                    pieces.pop(index)
                    line = self._prompt_sep.join(pieces)
            except(ValueError):
                pass

            # we don't want to append lines that are blank after stripping the
            # prompt (those are basically "prompts")
            if not foundPrompt or line:
                retVal.append(line)

        return '\n'.join(retVal)

    def _shouldCmdCloseSocket(self, cmd):
        """
        Some commands need to close the socket after they are sent:
          * rebt
          * uninst
          * quit
        """
        socketClosingCmds = [re.compile('^quit.*'),
                             re.compile('^rebt.*'),
                             re.compile('^uninst .*$')]

        for c in socketClosingCmds:
            if (c.match(cmd)):
                return True
        return False

    def _sendCmds(self, cmdlist, outputfile, timeout=None, retryLimit=None):
        """
        Wrapper for _doCmds that loops up to retryLimit iterations
        """
        # this allows us to move the retry logic outside of the _doCmds() to make it
        # easier for debugging in the future.
        # note that since cmdlist is a list of commands, they will all be retried if
        # one fails.  this is necessary in particular for pushFile(), where we don't want
        # to accidentally send extra data if a failure occurs during data transmission.

        retryLimit = retryLimit or self.retryLimit
        retries = 0
        while retries < retryLimit:
            try:
                self._doCmds(cmdlist, outputfile, timeout)
                return
            except DMError as err:
                # re-raise error if it's fatal (i.e. the device got the command but
                # couldn't execute it). retry otherwise
                if err.fatal:
                    raise err
                self._logger.debug(err)
                retries += 1
                # if we lost the connection or failed to establish one, wait a bit
                if retries < retryLimit and not self._sock:
                    sleep_time = 5 * retries
                    self._logger.info('Could not connect; sleeping for %d seconds.' % sleep_time)
                    time.sleep(sleep_time)

        raise DMError("Remote Device Error: unable to connect to %s after %s attempts" %
                      (self.host, retryLimit))

    def _runCmds(self, cmdlist, timeout=None, retryLimit=None):
        """
        Similar to _sendCmds, but just returns any output as a string instead of
        writing to a file
        """
        retryLimit = retryLimit or self.retryLimit
        outputfile = StringIO.StringIO()
        self._sendCmds(cmdlist, outputfile, timeout, retryLimit=retryLimit)
        outputfile.seek(0)
        return outputfile.read()

    def _doCmds(self, cmdlist, outputfile, timeout):
        promptre = re.compile(self._prompt_regex + '$')
        shouldCloseSocket = False

        if not timeout:
            # We are asserting that all commands will complete in this time unless
            # otherwise specified
            timeout = self.default_timeout

        if not self._sock:
            try:
                if self._everConnected:
                    self._logger.info("reconnecting socket")
                self._sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            except socket.error as msg:
                self._sock = None
                raise DMError("Automation Error: unable to create socket: " + str(msg))

            try:
                self._sock.settimeout(float(timeout))
                self._sock.connect((self.host, int(self.port)))
                self._everConnected = True
            except socket.error as msg:
                self._sock = None
                raise DMError("Remote Device Error: Unable to connect socket: " + str(msg))

            # consume prompt
            try:
                self._sock.recv(1024)
            except socket.error as msg:
                self._sock.close()
                self._sock = None
                raise DMError(
                    "Remote Device Error: Did not get prompt after connecting: " + str(msg),
                    fatal=True)

            # future recv() timeouts are handled by select() calls
            self._sock.settimeout(None)

        for cmd in cmdlist:
            cmdline = '%s\r\n' % cmd['cmd']

            try:
                sent = self._sock.send(cmdline)
                if sent != len(cmdline):
                    raise DMError("Remote Device Error: our cmd was %s bytes and we "
                                  "only sent %s" % (len(cmdline), sent))
                if cmd.get('data'):
                    totalsent = 0
                    while totalsent < len(cmd['data']):
                        sent = self._sock.send(cmd['data'][totalsent:])
                        self._logger.debug("sent %s bytes of data payload" % sent)
                        if sent == 0:
                            raise DMError("Socket connection broken when sending data")
                        totalsent += sent

                self._logger.debug("sent cmd: %s" % cmd['cmd'])
            except socket.error as msg:
                self._sock.close()
                self._sock = None
                self._logger.error("Remote Device Error: Error sending data"
                                   " to socket. cmd=%s; err=%s" % (cmd['cmd'], msg))
                return False

            # Check if the command should close the socket
            shouldCloseSocket = self._shouldCmdCloseSocket(cmd['cmd'])

            # Handle responses from commands
            if self._cmdNeedsResponse(cmd['cmd']):
                foundPrompt = False
                data = ""
                timer = 0
                select_timeout = 1
                commandFailed = False

                while not foundPrompt:
                    socketClosed = False
                    errStr = ''
                    temp = ''
                    self._logger.debug("recv'ing...")

                    # Get our response
                    try:
                        # Wait up to a second for socket to become ready for reading...
                        if select.select([self._sock], [], [], select_timeout)[0]:
                            temp = self._sock.recv(1024)
                            self._logger.debug(u"response: %s" % temp.decode('utf8', 'replace'))
                            timer = 0
                            if not temp:
                                socketClosed = True
                                errStr = 'connection closed'
                        timer += select_timeout
                        if timer > timeout:
                            self._sock.close()
                            self._sock = None
                            raise DMError("Automation Error: Timeout in command %s" %
                                          cmd['cmd'], fatal=True)
                    except socket.error as err:
                        socketClosed = True
                        errStr = str(err)
                        # This error shows up with we have our tegra rebooted.
                        if err[0] == errno.ECONNRESET:
                            errStr += ' - possible reboot'

                    if socketClosed:
                        self._sock.close()
                        self._sock = None
                        raise DMError(
                            "Automation Error: Error receiving data from socket. "
                            "cmd=%s; err=%s" % (cmd, errStr))

                    data += temp

                    # If something goes wrong in the agent it will send back a string that
                    # starts with '##AGENT-WARNING##'
                    if not commandFailed:
                        errorMatch = self._agentErrorRE.match(data)
                        if errorMatch:
                            # We still need to consume the prompt, so raise an error after
                            # draining the rest of the buffer.
                            commandFailed = True

                    for line in data.splitlines():
                        if promptre.match(line):
                            foundPrompt = True
                            data = self._stripPrompt(data)
                            break

                    # periodically flush data to output file to make sure it doesn't get
                    # too big/unwieldly
                    if len(data) > 1024:
                        outputfile.write(data[0:1024])
                        data = data[1024:]

                if commandFailed:
                    raise DMError("Automation Error: Error processing command '%s'; err='%s'" %
                                  (cmd['cmd'], errorMatch.group(1)), fatal=True)

                # Write any remaining data to outputfile
                outputfile.write(data)

        if shouldCloseSocket:
            try:
                self._sock.close()
                self._sock = None
            except:
                self._sock = None
                raise DMError("Automation Error: Error closing socket")

    def _setupDeviceRoot(self, deviceRoot):
        if not deviceRoot:
            deviceRoot = "%s/tests" % self._runCmds(
                [{'cmd': 'testroot'}]).strip()
        self.mkDir(deviceRoot)

        return deviceRoot

    def shell(self, cmd, outputfile, env=None, cwd=None, timeout=None, root=False):
        cmdline = self._escapedCommandLine(cmd)
        if env:
            cmdline = '%s %s' % (self._formatEnvString(env), cmdline)

        # execcwd/execcwdsu currently unsupported in Negatus; see bug 824127.
        if cwd and self.agentProductName == 'SUTAgentNegatus':
            raise DMError("Negatus does not support execcwd/execcwdsu")

        haveExecSu = (self.agentProductName == 'SUTAgentNegatus' or
                      StrictVersion(self.agentVersion) >= StrictVersion('1.13'))

        # Depending on agent version we send one of the following commands here:
        # * exec (run as normal user)
        # * execsu (run as privileged user)
        # * execcwd (run as normal user from specified directory)
        # * execcwdsu (run as privileged user from specified directory)

        cmd = "exec"
        if cwd:
            cmd += "cwd"
        if root and haveExecSu:
            cmd += "su"

        if cwd:
            self._sendCmds([{'cmd': '%s %s %s' % (cmd, cwd, cmdline)}], outputfile, timeout)
        else:
            if (not root) or haveExecSu:
                self._sendCmds([{'cmd': '%s %s' % (cmd, cmdline)}], outputfile, timeout)
            else:
                # need to manually inject su -c for backwards compatibility (this may
                # not work on ICS or above!!)
                # (FIXME: this backwards compatibility code is really ugly and should
                # be deprecated at some point in the future)
                self._sendCmds([{'cmd': '%s su -c "%s"' % (cmd, cmdline)}], outputfile,
                               timeout)

        # dig through the output to get the return code
        lastline = _pop_last_line(outputfile)
        if lastline:
            m = re.search('return code \[([0-9]+)\]', lastline)
            if m:
                return int(m.group(1))

        # woops, we couldn't find an end of line/return value
        raise DMError(
            "Automation Error: Error finding end of line/return value when running '%s'" % cmdline)

    def pushFile(self, localname, destname, retryLimit=None, createDir=True):
        retryLimit = retryLimit or self.retryLimit
        if createDir:
            self.mkDirs(destname)

        try:
            filesize = os.path.getsize(localname)
            with open(localname, 'rb') as f:
                remoteHash = self._runCmds([{'cmd': 'push ' + destname + ' ' + str(filesize),
                                             'data': f.read()}], retryLimit=retryLimit).strip()
        except OSError:
            raise DMError("DeviceManager: Error reading file to push")

        self._logger.debug("push returned: %s" % remoteHash)

        localHash = self._getLocalHash(localname)

        if localHash != remoteHash:
            raise DMError("Automation Error: Push File failed to Validate! (localhash: %s, "
                          "remotehash: %s)" % (localHash, remoteHash))

    def mkDir(self, name):
        if not self.dirExists(name):
            self._runCmds([{'cmd': 'mkdr ' + name}])

    def pushDir(self, localDir, remoteDir, retryLimit=None, timeout=None):
        retryLimit = retryLimit or self.retryLimit
        self._logger.info("pushing directory: %s to %s" % (localDir, remoteDir))

        existentDirectories = []
        for root, dirs, files in os.walk(localDir, followlinks=True):
            _, subpath = root.split(localDir)
            subpath = subpath.lstrip('/')
            remoteRoot = posixpath.join(remoteDir, subpath)
            for f in files:
                remoteName = posixpath.join(remoteRoot, f)

                if subpath == "":
                    remoteRoot = remoteDir

                parent = os.path.dirname(remoteName)
                if parent not in existentDirectories:
                    self.mkDirs(remoteName)
                    existentDirectories.append(parent)

                self.pushFile(os.path.join(root, f), remoteName,
                              retryLimit=retryLimit, createDir=False)

    def dirExists(self, remotePath):
        ret = self._runCmds([{'cmd': 'isdir ' + remotePath}]).strip()
        if not ret:
            raise DMError('Automation Error: DeviceManager isdir returned null')

        return ret == 'TRUE'

    def fileExists(self, filepath):
        # Because we always have / style paths we make this a lot easier with some
        # assumptions
        filepath = posixpath.normpath(filepath)
        # / should always exist but we can use this to check for things like
        # having access to the filesystem
        if filepath == '/':
            return self.dirExists(filepath)
        (containingpath, filename) = posixpath.split(filepath)
        return filename in self.listFiles(containingpath)

    def listFiles(self, rootdir):
        rootdir = posixpath.normpath(rootdir)
        if not self.dirExists(rootdir):
            return []
        data = self._runCmds([{'cmd': 'cd ' + rootdir}, {'cmd': 'ls'}])

        files = filter(lambda x: x, data.splitlines())
        if len(files) == 1 and files[0] == '<empty>':
            # special case on the agent: empty directories return just the
            # string "<empty>"
            return []
        return files

    def removeFile(self, filename):
        self._logger.info("removing file: " + filename)
        if self.fileExists(filename):
            self._runCmds([{'cmd': 'rm ' + filename}])

    def removeDir(self, remoteDir):
        if self.dirExists(remoteDir):
            self._runCmds([{'cmd': 'rmdr ' + remoteDir}])

    def moveTree(self, source, destination):
        self._runCmds([{'cmd': 'mv %s %s' % (source, destination)}])

    def copyTree(self, source, destination):
        self._runCmds([{'cmd': 'dd if=%s of=%s' % (source, destination)}])

    def getProcessList(self):
        data = self._runCmds([{'cmd': 'ps'}])

        processTuples = []
        for line in data.splitlines():
            if line:
                pidproc = line.strip().split()
                try:
                    if (len(pidproc) == 2):
                        processTuples += [[pidproc[0], pidproc[1]]]
                    elif (len(pidproc) == 3):
                        # android returns <userID> <procID> <procName>
                        processTuples += [[int(pidproc[1]), pidproc[2], int(pidproc[0])]]
                    else:
                        # unexpected format
                        raise ValueError
                except ValueError:
                    self._logger.error("Unable to parse process list (bug 805969)")
                    self._logger.error("Line: %s\nFull output of process list:\n%s" % (line, data))
                    raise DMError("Invalid process line: %s" % line)

        return processTuples

    def fireProcess(self, appname, failIfRunning=False, maxWaitTime=30):
        """
        Starts a process

        returns: pid

        DEPRECATED: Use shell() or launchApplication() for new code
        """
        if not appname:
            raise DMError("Automation Error: fireProcess called with no command to run")

        self._logger.info("FIRE PROC: '%s'" % appname)

        if (self.processExist(appname) is None):
            self._logger.warning("process %s appears to be running already\n" % appname)
            if (failIfRunning):
                raise DMError("Automation Error: Process is already running")

        self._runCmds([{'cmd': 'exec ' + appname}])

        # The 'exec' command may wait for the process to start and end, so checking
        # for the process here may result in process = None.
        # The normal case is to launch the process and return right away
        # There is one case with robotium (am instrument) where exec returns at the end
        pid = None
        waited = 0
        while pid is None and waited < maxWaitTime:
            pid = self.processExist(appname)
            if pid:
                break
            time.sleep(1)
            waited += 1

        self._logger.debug("got pid: %s for process: %s" % (pid, appname))
        return pid

    def launchProcess(self, cmd, outputFile="process.txt", cwd='', env='', failIfRunning=False):
        """
        Launches a process, redirecting output to standard out

        Returns output filename

        WARNING: Does not work how you expect on Android! The application's
        own output will be flushed elsewhere.

        DEPRECATED: Use shell() or launchApplication() for new code
        """
        if not cmd:
            self._logger.warning("launchProcess called without command to run")
            return None

        if cmd[0] == 'am' and hasattr(self, '_getExtraAmStartArgs'):
            cmd = cmd[:2] + self._getExtraAmStartArgs() + cmd[2:]

        cmdline = subprocess.list2cmdline(cmd)
        if outputFile == "process.txt" or outputFile is None:
            outputFile += "%s/process.txt" % self.deviceRoot
            cmdline += " > " + outputFile

        # Prepend our env to the command
        cmdline = '%s %s' % (self._formatEnvString(env), cmdline)

        # fireProcess may trigger an exception, but we won't handle it
        if cmd[0] == "am":
            # Robocop tests spawn "am instrument". sutAgent's exec ensures that
            # am has started before returning, so there is no point in having
            # fireProcess wait for it to start. Also, since "am" does not show
            # up in the process list while the test is running, waiting for it
            # in fireProcess is difficult.
            self.fireProcess(cmdline, failIfRunning, 0)
        else:
            self.fireProcess(cmdline, failIfRunning)
        return outputFile

    def killProcess(self, appname, sig=None):
        if sig:
            pid = self.processExist(appname)
            if pid and pid > 0:
                try:
                    self.shellCheckOutput(['kill', '-%d' % sig, str(pid)],
                                          root=True)
                except DMError as err:
                    self._logger.warning("unable to kill -%d %s (pid %s)" %
                                         (sig, appname, str(pid)))
                    self._logger.debug(err)
                    raise err
            else:
                self._logger.warning("unable to kill -%d %s -- not running?" %
                                     (sig, appname))
        else:
            retries = 0
            while retries < self.retryLimit:
                try:
                    if self.processExist(appname):
                        self._runCmds([{'cmd': 'kill ' + appname}])
                    return
                except DMError as err:
                    retries += 1
                    self._logger.warning("try %d of %d failed to kill %s" %
                                         (retries, self.retryLimit, appname))
                    self._logger.debug(err)
                    if retries >= self.retryLimit:
                        raise err

    def getTempDir(self):
        return self._runCmds([{'cmd': 'tmpd'}]).strip()

    def pullFile(self, remoteFile, offset=None, length=None):
        # The "pull" command is different from other commands in that DeviceManager
        # has to read a certain number of bytes instead of just reading to the
        # next prompt.  This is more robust than the "cat" command, which will be
        # confused if the prompt string exists within the file being catted.
        # However it means we can't use the response-handling logic in sendCMD().

        def err(error_msg):
            err_str = 'DeviceManager: pull unsuccessful: %s' % error_msg
            self._logger.error(err_str)
            self._sock = None
            raise DMError(err_str)

        # FIXME: We could possibly move these socket-reading functions up to
        # the class level if we wanted to refactor sendCMD().  For now they are
        # only used to pull files.

        def uread(to_recv, error_msg):
            """ unbuffered read """
            try:
                data = ""
                if select.select([self._sock], [], [], self.default_timeout)[0]:
                    data = self._sock.recv(to_recv)
                if not data:
                    # timed out waiting for response or error response
                    err(error_msg)

                return data
            except:
                err(error_msg)

        def read_until_char(c, buf, error_msg):
            """ read until 'c' is found; buffer rest """
            while c not in buf:
                data = uread(1024, error_msg)
                buf += data
            return buf.partition(c)

        def read_exact(total_to_recv, buf, error_msg):
            """ read exact number of 'total_to_recv' bytes """
            while len(buf) < total_to_recv:
                to_recv = min(total_to_recv - len(buf), 1024)
                data = uread(to_recv, error_msg)
                buf += data
            return buf

        prompt = self._base_prompt + self._prompt_sep
        buf = ''

        # expected return value:
        # <filename>,<filesize>\n<filedata>
        # or, if error,
        # <filename>,-1\n<error message>

        # just send the command first, we read the response inline below
        if offset is not None and length is not None:
            cmd = 'pull %s %d %d' % (remoteFile, offset, length)
        elif offset is not None:
            cmd = 'pull %s %d' % (remoteFile, offset)
        else:
            cmd = 'pull %s' % remoteFile

        self._runCmds([{'cmd': cmd}])

        # read metadata; buffer the rest
        metadata, sep, buf = read_until_char('\n', buf, 'could not find metadata')
        if not metadata:
            return None
        self._logger.debug('metadata: %s' % metadata)

        filename, sep, filesizestr = metadata.partition(',')
        if sep == '':
            err('could not find file size in returned metadata')
        try:
            filesize = int(filesizestr)
        except ValueError:
            err('invalid file size in returned metadata')

        if filesize == -1:
            # read error message
            error_str, sep, buf = read_until_char('\n', buf, 'could not find error message')
            if not error_str:
                err("blank error message")
            # prompt should follow
            read_exact(len(prompt), buf, 'could not find prompt')
            # failures are expected, so don't use "Remote Device Error" or we'll RETRY
            raise DMError("DeviceManager: pulling file '%s' unsuccessful: %s" %
                          (remoteFile, error_str))

        # read file data
        total_to_recv = filesize + len(prompt)
        buf = read_exact(total_to_recv, buf, 'could not get all file data')
        if buf[-len(prompt):] != prompt:
            err('no prompt found after file data--DeviceManager may be out of sync with agent')
            return buf
        return buf[:-len(prompt)]

    def getFile(self, remoteFile, localFile):
        data = self.pullFile(remoteFile)

        fhandle = open(localFile, 'wb')
        fhandle.write(data)
        fhandle.close()
        if not self.validateFile(remoteFile, localFile):
            raise DMError("Automation Error: Failed to validate file when downloading %s" %
                          remoteFile)

    def getDirectory(self, remoteDir, localDir, checkDir=True):
        self._logger.info("getting files in '%s'" % remoteDir)
        if checkDir and not self.dirExists(remoteDir):
            raise DMError("Automation Error: Error getting directory: %s not a directory" %
                          remoteDir)

        filelist = self.listFiles(remoteDir)
        self._logger.debug(filelist)
        if not os.path.exists(localDir):
            os.makedirs(localDir)

        for f in filelist:
            if f == '.' or f == '..':
                continue
            remotePath = remoteDir + '/' + f
            localPath = os.path.join(localDir, f)
            if self.dirExists(remotePath):
                self.getDirectory(remotePath, localPath, False)
            else:
                self.getFile(remotePath, localPath)

    def validateFile(self, remoteFile, localFile):
        remoteHash = self._getRemoteHash(remoteFile)
        localHash = self._getLocalHash(localFile)

        if (remoteHash is None):
            return False

        if (remoteHash == localHash):
            return True

        return False

    def _getRemoteHash(self, filename):
        data = self._runCmds([{'cmd': 'hash ' + filename}]).strip()
        self._logger.debug("remote hash returned: '%s'" % data)
        return data

    def unpackFile(self, filePath, destDir=None):
        """
        Unzips a bundle to a location on the device

        If destDir is not specified, the bundle is extracted in the same directory
        """
        # if no destDir is passed in just set it to filePath's folder
        if not destDir:
            destDir = posixpath.dirname(filePath)

        if destDir[-1] != '/':
            destDir += '/'

        self._runCmds([{'cmd': 'unzp %s %s' % (filePath, destDir)}])

    def _getRebootServerSocket(self, ipAddr):
        serverSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        serverSocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        serverSocket.settimeout(60.0)
        serverSocket.bind((ipAddr, 0))
        serverSocket.listen(1)
        self._logger.debug('Created reboot callback server at %s:%d' %
                           serverSocket.getsockname())
        return serverSocket

    def _waitForRebootPing(self, serverSocket):
        conn = None
        data = None
        startTime = datetime.datetime.now()
        waitTime = datetime.timedelta(seconds=self.reboot_timeout)
        while not data and datetime.datetime.now() - startTime < waitTime:
            self._logger.info("Waiting for reboot callback ping from device...")
            try:
                if not conn:
                    conn, _ = serverSocket.accept()
                # Receiving any data is good enough.
                data = conn.recv(1024)
                if data:
                    self._logger.info("Received reboot callback ping from device!")
                    conn.sendall('OK')
                conn.close()
            except socket.timeout:
                pass
            except socket.error as e:
                if e.errno != errno.EAGAIN and e.errno != errno.EWOULDBLOCK:
                    raise

        if not data:
            raise DMError('Timed out waiting for reboot callback.')

        self._logger.info("Sleeping for %s seconds to wait for device "
                          "to 'settle'" % self.reboot_settling_time)
        time.sleep(self.reboot_settling_time)

    def reboot(self, ipAddr=None, port=30000, wait=False):
        # port ^^^ is here for backwards compatibility only, we now
        # determine a port automatically and safely
        wait = (wait or ipAddr)

        cmd = 'rebt'

        self._logger.info("Rebooting device")

        # if we're waiting, create a listening server and pass information on
        # it to the device before rebooting (we do this instead of just polling
        # to make sure the device actually rebooted -- yes, there are probably
        # simpler ways of doing this like polling uptime, but this is what we're
        # doing for now)
        if wait:
            if not ipAddr:
                ipAddr = moznetwork.get_ip()
            serverSocket = self._getRebootServerSocket(ipAddr)
            # The update.info command tells the SUTAgent to send a TCP message
            # after restarting.
            destname = '/data/data/com.mozilla.SUTAgentAndroid/files/update.info'
            data = "%s,%s\rrebooting\r" % serverSocket.getsockname()
            self._runCmds([{'cmd': 'push %s %s' % (destname, len(data)),
                            'data': data}])
            cmd += " %s %s" % serverSocket.getsockname()

        # actually reboot device
        self._runCmds([{'cmd': cmd}])
        # if we're waiting, wait for a callback ping from the agent before
        # continuing (and throw an exception if we don't receive said ping)
        if wait:
            self._waitForRebootPing(serverSocket)

    def getInfo(self, directive=None):
        data = None
        result = {}
        collapseSpaces = re.compile('  +')

        directives = ['os', 'id', 'uptime', 'uptimemillis', 'systime', 'screen',
                      'rotation', 'memory', 'process', 'disk', 'power', 'sutuserinfo',
                      'temperature']
        if (directive in directives):
            directives = [directive]

        for d in directives:
            data = self._runCmds([{'cmd': 'info ' + d}])

            data = collapseSpaces.sub(' ', data)
            result[d] = data.split('\n')

        # Get rid of any 0 length members of the arrays
        for k, v in result.iteritems():
            result[k] = filter(lambda x: x != '', result[k])

        # Format the process output
        if 'process' in result:
            proclist = []
            for l in result['process']:
                if l:
                    proclist.append(l.split('\t'))
            result['process'] = proclist

        self._logger.debug("results: %s" % result)
        return result

    def installApp(self, appBundlePath, destPath=None):
        cmd = 'inst ' + appBundlePath
        if destPath:
            cmd += ' ' + destPath

        data = self._runCmds([{'cmd': cmd}])

        if 'installation complete [0]' not in data:
            raise DMError("Remove Device Error: Error installing app. Error message: %s" % data)

    def uninstallApp(self, appName, installPath=None):
        cmd = 'uninstall ' + appName
        if installPath:
            cmd += ' ' + installPath
        data = self._runCmds([{'cmd': cmd}])

        status = data.split('\n')[0].strip()
        self._logger.debug("uninstallApp: '%s'" % status)
        if status == 'Success':
            return
        raise DMError("Remote Device Error: uninstall failed for %s" % appName)

    def uninstallAppAndReboot(self, appName, installPath=None):
        cmd = 'uninst ' + appName
        if installPath:
            cmd += ' ' + installPath
        data = self._runCmds([{'cmd': cmd}])

        self._logger.debug("uninstallAppAndReboot: %s" % data)
        return

    def updateApp(self, appBundlePath, processName=None, destPath=None,
                  ipAddr=None, port=30000, wait=False):
        # port ^^^ is here for backwards compatibility only, we now
        # determine a port automatically and safely
        wait = (wait or ipAddr)

        cmd = 'updt '
        if processName is None:
            # Then we pass '' for processName
            cmd += "'' " + appBundlePath
        else:
            cmd += processName + ' ' + appBundlePath

        if destPath:
            cmd += " " + destPath

        if wait:
            if not ipAddr:
                ipAddr = moznetwork.get_ip()
            serverSocket = self._getRebootServerSocket(ipAddr)
            cmd += " %s %s" % serverSocket.getsockname()

        self._logger.debug("updateApp using command: " % cmd)

        self._runCmds([{'cmd': cmd}])

        if wait:
            self._waitForRebootPing(serverSocket)

    def getCurrentTime(self):
        return int(self._runCmds([{'cmd': 'clok'}]).strip())

    def _formatEnvString(self, env):
        """
        Returns a properly formatted env string for the agent.

        Input - env, which is either None, '', or a dict
        Output - a quoted string of the form: '"envvar1=val1,envvar2=val2..."'
        If env is None or '' return '' (empty quoted string)
        """
        if (env is None or env == ''):
            return ''

        retVal = '"%s"' % ','.join(map(lambda x: '%s=%s' % (x[0], x[1]), env.iteritems()))
        if (retVal == '""'):
            return ''

        return retVal

    def adjustResolution(self, width=1680, height=1050, type='hdmi'):
        """
        Adjust the screen resolution on the device, REBOOT REQUIRED

        NOTE: this only works on a tegra ATM

        supported resolutions: 640x480, 800x600, 1024x768, 1152x864, 1200x1024, 1440x900,
        1680x1050, 1920x1080
        """
        if self.getInfo('os')['os'][0].split()[0] != 'harmony-eng':
            self._logger.warning("unable to adjust screen resolution on non Tegra device")
            return False

        results = self.getInfo('screen')
        parts = results['screen'][0].split(':')
        self._logger.debug("we have a current resolution of %s, %s" %
                           (parts[1].split()[0], parts[2].split()[0]))

        # verify screen type is valid, and set it to the proper value
        # (https://bugzilla.mozilla.org/show_bug.cgi?id=632895#c4)
        screentype = -1
        if (type == 'hdmi'):
            screentype = 5
        elif (type == 'vga' or type == 'crt'):
            screentype = 3
        else:
            return False

        # verify we have numbers
        if not (isinstance(width, int) and isinstance(height, int)):
            return False

        if (width < 100 or width > 9999):
            return False

        if (height < 100 or height > 9999):
            return False

        self._logger.debug("adjusting screen resolution to %s, %s and rebooting" % (width, height))

        self._runCmds(
            [{'cmd': "exec setprop persist.tegra.dpy%s.mode.width %s" % (screentype, width)}])
        self._runCmds(
            [{'cmd': "exec setprop persist.tegra.dpy%s.mode.height %s" % (screentype, height)}])

    def chmodDir(self, remoteDir, **kwargs):
        self._runCmds([{'cmd': "chmod " + remoteDir}])
