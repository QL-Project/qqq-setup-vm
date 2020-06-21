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
}

function update() {
    if [[ -d $DIRQL ]]; then
       if [[ -e ${ZIP} ]]; then
          rm -rf "${ZIP}"
       else
          wget https://github.com/poseidon-network/qlauncher-linux/releases/latest/download/ql-linux.tar.gz -O "${ZIP}"
          tar -vxzf "${ZIP}" -C "${DIRQL}"
          echo "restart QLauncher"
          restart
          rm -rf "${ZIP}"
       fi
    fi
}

function parse_parameters() {
    while [[ ${#} ]]; do
        case "${1}" in
            "-b"|"--bind") bind  ;;
            "-c"|"--check") check ;;
            "-f"|"--freeze") freeze ;;
            "-k"|"--kickoff") kickoff ;;
            "-r"|"--restart") restart ;;
            "-s"|"--status") status ;;
            "-u"|"--update") update ;;

            # HELP!
            "-h"|"--help") help_menu; exit ;;
        esac

        [[ -z ${@} ]] && { help_menu; } 
        exit
    done
}

setup_variables
parse_parameters "${@}"
