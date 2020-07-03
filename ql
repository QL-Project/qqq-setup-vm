#!/usr/bin/env bash

# Easy alias for escape codes
function echo() {
    command echo -e "${@}"
}

function help_menu() {
echo
echo "${BOLD}QLauncher menu${RST}"
echo
echo "${BOLD}USAGE:${RST} ${0} <options>"
echo
echo "${BOLD}EXAMPLE:${RST} ${0} -s"
echo
echo "${BOLD}EXAMPLE:${RST} ${0} --status"
echo
echo " -b | --bind:      Bind account to QQQ App"
echo " -c | --check:     Verify Installation"
echo " -f | --freeze:    Stop miner"
echo " -h | --help:      Help menu"
echo " -k | --kickoff:   Start miner"
echo " -r | --restart:   Restart miner"
echo " -s | --status:    Status miner"
echo " -u | --update:    Update QLauncher"
echo
}

function setup_variables() {
    DIRQL="$HOME/qlauncher"
    ZIP="app.tar.gz"
    BOLD="\033[1m"
    RST="\033[0m"
    QLS="$DIRQL/qlauncher.sh"
}

function bind() {
    $QLS bind
}

function check() {
    $QLS check
}

function freeze() {
    $QLS stop
}

function kickoff() {
    $QLS start
}

function restart() {
    $QLS restart
}

function status() {
    $QLS status
}

function zipdl() {
    wget https://github.com/poseidon-network/qlauncher-linux/releases/latest/download/ql-linux.tar.gz -O "${ZIP}"
    tar -vxzf "${ZIP}" -C "${DIRQL}"
    echo "start QLauncher"
    kickoff
}

function update() {
    if [[ -d ${DIRQL} ]]; then
       echo "folder exist, deleting current qlauncher folder"
       freeze
       rm -rf ${DIRQL}
       mkdir ${DIRQL}
       if [[ -e ${ZIP} ]]; then
          echo
          # remove package if exist then start updating
          rm -rf "${ZIP}"
          zipdl
       else
          echo
          # seems file doesn't exist, lets start updating
          zipdl
          rm -rf "${ZIP}"
       fi
    else
       echo
       echo "QLauncher doesn't exist, read the README for how to install it"
       echo
    fi
}

function parse_parameters() {
    case "${1}" in
        "-b"|"--bind") bind  ;;
        "-c"|"--check") check ;;
        "-f"|"--freeze") freeze ;;
        "-k"|"--kickoff") kickoff ;;
        "-r"|"--restart") restart ;;
        "-s"|"--status") status ;;
        "-u"|"--update") update ;;

        # HELP!
        "-h"|"--help"|*) help_menu ;;
    esac
}

setup_variables
parse_parameters "${@}"
