#!/bin/bash

function print_usage() {
    echo "Usage: $0 -i interface [-p ports] [-a address] [-r] [-c] [-f file]"
    echo "  -i  Network interface to listen on"
    echo "  -p  Ports to listen on, separated by commas (optional)"
    echo "  -a  IP address to filter by (optional)"
    echo "  -r  Show raw packet data (optional)"
    echo "  -c  Disable colorized output (optional, default is colored)"
    echo "  -f  File to save output to (optional, .pcap for binary or .txt for text)"
    exit 1
}
while getopts i:p:a:rcf: opt; do
     case ${opt} in
         i) INTERFACE=${OPTARG} ;;
         p) PORTS=${OPTARG} ;;
         a) ADDRESS=${OPTARG} ;;
         r) RAW=true ;;
         c) COLORIZE=false ;;
         f) OUTPUT_FILE=${OPTARG} ;;
         *) print_usage ;;
     esac
done

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

function colorize() {
    perl -pe '
        s/(IP)/\033[34m$1\033[39m/g;
        s/(length)/\033[31m$1\033[39m/g;
        s/(tcp)/\033[32m$1\033[39m/g;
    '
}






COLORIZE=true
    if [[ ${COLORIZE} = true ]]; then
        bash -c "$cmd" | colorize
    else
        bash -c "$cmd"
    fi
echo -e "${GREEN}\
┏━┓╋┏┳┓╋╋┏┳━┓┏━┓╋╋╋╋╋╋╋┏━┓┏━┓
┃┃┗┓┃┃┗┓┏┛┃┃┗┛┃┃╋╋╋╋╋╋╋┃┏┛┃┏┛
┃┏┓┗┛┣┓┗┛┏┫┏┓┏┓┣━━┳━┓┏┳┛┗┳┛┗┳━━┳━┓
┃┃┗┓┃┃┗┓┏┛┃┃┃┃┃┃━━┫┏┓╋╋┓┏┻┓┏┫┃━┫┏┛
┃┃╋┃┃┃╋┃┃╋┃┃┃┃┃┣━━┃┃┃┃┃┃┃╋┃┃┃┃━┫┃
┗┛╋┗━┛╋┗┛╋┗┛┗┛┗┻━━┻┛┗┻┛┗┛╋┗┛┗━━┻┛${NC}"

function sniff() {
    local interface=$1
    local filter=$2
    local raw=$3
    local colorize=$4
    local output_file=$5

    local cmd="tcpdump -i ${interface} -nn -s0 ${filter}"


    if [[ ${raw} = true ]]; then
        cmd="${cmd} -x"
    fi

    if [[ -n ${output_file} ]]; then
        if [[ ${output_file: -5} == ".pcap" ]]; then
            cmd="tcpdump -i ${interface} -nn -s0 -w ${output_file} ${filter}"
        else
            cmd="${cmd} | tee ${output_file}"
        fi
    fi

    if [[ ${colorize} = true ]]; then
        eval $cmd | colorize
    else
        eval $cmd
    fi
}

FILTER='tcp'

if [[ -z ${INTERFACE} ]]; then
    echo "You must specify a network interface with -i"
    print_usage
fi


### TODO WHEN USING PORT< NO COLOR OUTPUT IS AVAILABLE. NOT SURE HWY LOL
if [[ -n ${PORTS} ]]; then
   ## IFS=',' read -ra PORTS_ARRAY <<< "${PORTS}"
   set -x
   ## PORTxS_LIST=${PORTS_LIST}
   ##FILTER="${FILTER} and port ${PORTS}"
   FILTER="${FILTER} and port ${PORTS}"
   sniff "${INTERFACE}" "${FILTER}" && exit 0
fi








if [[ -n ${ADDRESS} ]]; then
    FILTER="${FILTER} and host ${ADDRESS}"
fi

sniff "${INTERFACE}" "${FILTER}" "${RAW}" "${COLORIZE}" "${OUTPUT_FILE}"
