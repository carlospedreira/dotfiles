# ALIASES
alias ls="ls -ghs --group-directories-first --color"

# ENVIRONMENT
DOTNET_CLI_TELEMETRY_OPTOUT=1

# PROMPT
source .git-prompt.sh
PROMPT_COMMAND='__posh_git_ps1 "\[\033[01;34m\]\w\[\033[00m\] " "\\\$ ";'$PROMPT_COMMAND
PROMPT_DIRTRIM=3
