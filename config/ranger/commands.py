# -*- coding: utf-8 -*-
# This file is part of ranger, the console file manager.
#
# ===================================================================
# This file contains ranger's commands.
# It's all in python; lines beginning with # are comments.
#
# Note that additional commands are automatically generated from the methods
# of the class ranger.core.actions.Actions.
#
# You can customize commands in the files /etc/ranger/commands.py (system-wide)
# and ~/.config/ranger/commands.py (per user).
# They have the same syntax as this file.  In fact, you can just copy this
# file to ~/.config/ranger/commands_full.py with
# `ranger --copy-config=commands_full' and make your modifications, don't
# forget to rename it to commands.py.  You can also use
# `ranger --copy-config=commands' to copy a short sample commands.py that
# has everything you need to get started.
# But make sure you update your configs when you update ranger.
#
# ===================================================================
# Every class defined here which is a subclass of `Command' will be used as a
# command in ranger.  Several methods are defined to interface with ranger:
#   execute():   called when the command is executed.
#   cancel():    called when closing the console.
#   tab(tabnum): called when <TAB> is pressed.
#   quick():     called after each keypress.
#
# tab() argument tabnum is 1 for <TAB> and -1 for <S-TAB> by default
#
# The return values for tab() can be either:
#   None: There is no tab completion
#   A string: Change the console to this string
#   A list/tuple/generator: cycle through every item in it
#
# The return value for quick() can be:
#   False: Nothing happens
#   True: Execute the command afterwards
#
# The return value for execute() and cancel() doesn't matter.
#
# ===================================================================
# Commands have certain attributes and methods that facilitate parsing of
# the arguments:
#
# self.line: The whole line that was written in the console.
# self.args: A list of all (space-separated) arguments to the command.
# self.quantifier: If this command was mapped to the key "X" and
#      the user pressed 6X, self.quantifier will be 6.
# self.arg(n): The n-th argument, or an empty string if it doesn't exist.
# self.rest(n): The n-th argument plus everything that followed.  For example,
#      if the command was "search foo bar a b c", rest(2) will be "bar a b c"
# self.start(n): Anything before the n-th argument.  For example, if the
#      command was "search foo bar a b c", start(2) will be "search foo"
#
# ===================================================================
# And this is a little reference for common ranger functions and objects:
#
# self.fm: A reference to the "fm" object which contains most information
#      about ranger.
# self.fm.notify(string): Print the given string on the screen.
# self.fm.notify(string, bad=True): Print the given string in RED.
# self.fm.reload_cwd(): Reload the current working directory.
# self.fm.thisdir: The current working directory. (A File object.)
# self.fm.thisfile: The current file. (A File object too.)
# self.fm.thistab.get_selection(): A list of all selected files.
# self.fm.execute_console(string): Execute the string as a ranger command.
# self.fm.open_console(string): Open the console with the given string
#      already typed in for you.
# self.fm.move(direction): Moves the cursor in the given direction, which
#      can be something like down=3, up=5, right=1, left=1, to=6, ...
#
# File objects (for example self.fm.thisfile) have these useful attributes and
# methods:
#
# tfile.path: The path to the file.
# tfile.basename: The base name only.
# tfile.load_content(): Force a loading of the directories content (which
#      obviously works with directories only)
# tfile.is_directory: True/False depending on whether it's a directory.
#
# For advanced commands it is unavoidable to dive a bit into the source code
# of ranger.
# ===================================================================

from __future__ import absolute_import, division, print_function

from collections import deque

from ranger.api.commands import Command


class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import os
        import subprocess

        command = (
            "find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) "
            "-prune -o {}"
        )
        if self.quantifier:
            # match only directories
            command = command.format(
                "-type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
            )
        else:
            # match files and directories
            command = command.format(
                "-print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
            )
        fzf = self.fm.execute_command(
            command, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


FD_DEQ = deque()


class fd_search(Command):
    """
    :fd_search [-d<depth>] <query>

    Executes "fd -d<depth> <query>" in the current directory and focuses the
    first match. <depth> defaults to 1, i.e. only the contents of the current
    directory.
    """

    def execute(self):
        import os
        import subprocess

        from ranger.ext.get_executables import get_executables

        if 'fd' not in get_executables():
            self.fm.notify("Couldn't find fd on the PATH.", bad=True)
            return
        if self.arg(1):
            if self.arg(1)[:2] == '-d':
                depth = self.arg(1)
                target = self.rest(2)
            else:
                depth = '-d1'
                target = self.rest(1)
        else:
            self.fm.notify(":fd_search needs a query.", bad=True)
            return

        # For convenience, change which dict is used as result_sep to change
        # fd's behavior from splitting results by \0, which allows for newlines
        # in your filenames to splitting results by \n, which allows for \0 in
        # filenames.
        # nl_sep = {'arg': '', 'split': '\n'}
        null_sep = {'arg': '-0', 'split': '\0'}
        result_sep = null_sep

        process = subprocess.Popen(
            ['fd', result_sep['arg'], depth, target],
            universal_newlines=True,
            stdout=subprocess.PIPE,
        )
        (search_results, _err) = process.communicate()
        global FD_DEQ
        FD_DEQ = deque(
            (
                self.fm.thisdir.path + os.sep + rel
                for rel in sorted(
                    search_results.split(result_sep['split']), key=str.lower
                )
                if rel != ''
            )
        )
        if FD_DEQ:
            self.fm.select_file(FD_DEQ[0])


class fd_next(Command):
    """
    :fd_next

    Selects the next match from the last :fd_search.
    """

    def execute(self):
        if len(FD_DEQ) > 1:
            FD_DEQ.rotate(-1)  # rotate left
            self.fm.select_file(FD_DEQ[0])
        elif len(FD_DEQ) == 1:
            self.fm.select_file(FD_DEQ[0])


class fd_prev(Command):
    """
    :fd_prev

    Selects the next match from the last :fd_search.
    """

    def execute(self):
        if len(FD_DEQ) > 1:
            FD_DEQ.rotate(1)  # rotate right
            self.fm.select_file(FD_DEQ[0])
        elif len(FD_DEQ) == 1:
            self.fm.select_file(FD_DEQ[0])
