#!/bin/bash

# convert swiftlint's output into GitHub Actions Logging commands
# https://help.github.com/en/github/automating-your-workflow-with-github-actions/development-tools-for-github-actions#logging-commands

function stripPWD() {
    sed -E "s/$(pwd|sed 's/\//\\\//g')\///"
}

function convertToGitHubActionsLoggingCommands() {
    sed -E 's/^(.*):([0-9]+):([0-9]+): (warning|error|[^:]+): (.*)/::error file=\1,line=\2,col=\3::\5/'
}

function setExitStatusCode() {
    grep 'not'
    if [ $? == 0 ]; then
       exit 1
    fi
}

set -o pipefail && swiftlint "$@" | stripPWD | convertToGitHubActionsLoggingCommands | setExitStatusCode
