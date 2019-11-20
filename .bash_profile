#run bashrc
[ -r ~/.bashrc ] && . ~/.bashrc

#re-run inputrc file to get lates updates
[ -r ~/.inputrc ] && . ~/.inputrc

# add git plugin?
plugins=(git)
#
#Colors
BLACK='30m\]'
RED='31m\]'
GREEN='32m\]'
YELLOW='33m\]'
BLUE='34m\]'
MAGENTA='35m\]'
CYAN='36m\]'
GRAY='90m\]'
LIGHT_GRAY='37m\]'
LIGHT_RED='91m\]'
LIGHT_GREEN='92m\]'
LIGHT_YELLOW='93m\]'
LIGHT_BLUE='94m\]'
LIGHT_MAGENTA='95m\]'
LIGHT_CYAN='96m\]'

#Formats
BOLD='\[\033[2;'
BLINK='\[\033[5;'
REVERSE='\[\033[7;'
NORM='\[\033[0;'
DEFAULT="\[\033[0m\]"
#!/usr/bin/expect
set timeout 60

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# get current branch in git repo
function parse_git_branch() {
        BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [ "${BRANCH}" != "" ]
        then
                STAT=$(parse_git_dirty)
                echo "λ:$MAGENTA${BRANCH}[${STAT}]"
        else
                echo ""
        fi
}

# get current status of git repo
function parse_git_dirty {
        status=`git status 2>&1 | tee`
        dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
        untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
        ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
        newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
        renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
        deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
        bits=''
        format=''
	if [ "${renamed}" == "0" ]; then
                format="$NORM$LIGHT_BLUE"
		bits=">${bits}"
        fi
        if [ "${ahead}" == "0" ]; then
		format="$NORM$LIGHT_MAGENTA"
                bits="*${bits}"
        fi
        if [ "${newfile}" == "0" ]; then
                format="$NORM$LIGHT_GREEN"
		bits="+${bits}"
        fi
        if [ "${untracked}" == "0" ]; then
                bits="${bits}"
		format="$NORM$YELLOW?${bits}"
        fi
        if [ "${deleted}" == "0" ]; then
                format="$NORM$RED"
		bits="x${bits}"
        fi
        if [ "${dirty}" == "0" ]; then
                format="$NORM$LIGHT_RED"
		bits="$!${bits}"
        fi
        if [ ! "${bits}" == "" ]; then
                echo "$format${bits}"
        else
                echo ""
        fi
}

#PS1
TIME="$NORM$BLUE\@"
USER="$NORM$LIGHT_YELLOW\u"
SHELL="$NORM$LIGHT_BLUE\s"
CURR_DIRECT="\W"
POINTER="$NORM$LIGHT_GREEN ➜ $DEFAULT"

export PS1="$TIME:$SHELL $USER:$CURR_DIRECT \[$(parse_git_branch)\]$POINTER "

#PS2
export PS2="$NORM$CYAN ➜ $DEFAULT"

# caen authentication
#stty -echo
#send_user -- "Password for <aisaav>>@login.engin.umich.edu: "
#expect_user -re "(.*)\n"
#send_user "\n"
#stty echo
#set pass $expect_out(1,string)
#spawn ssh <aisaav>@login.engin.umich.edu

#expect "*?assword" { send -- "$pass\r" }

#expect "Passcode or option (1-3): " { send "1\r" }

#interact
