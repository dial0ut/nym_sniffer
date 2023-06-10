#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function print_usage() {
    echo -e "${RED}Usage: $0 -i interface [-p ports] [-a address] [-r]"
    echo -e "  -i  Network interface to listen on"
    echo -e "  -p  Ports to listen on, separated by commas (optional)"
    echo -e "  -a  IP address to filter by (optional)"
    echo -e "  -r  Show raw packet data (optional)${NC}"
    exit 1
}

echo -e "${GREEN}\
┏━┓╋┏┳┓╋╋┏┳━┓┏━┓╋╋╋╋╋╋╋┏━┓┏━┓
┃┃┗┓┃┃┗┓┏┛┃┃┗┛┃┃╋╋╋╋╋╋╋┃┏┛┃┏┛
┃┏┓┗┛┣┓┗┛┏┫┏┓┏┓┣━━┳━┓┏┳┛┗┳┛┗┳━━┳━┓
┃┃┗┓┃┃┗┓┏┛┃┃┃┃┃┃━━┫┏┓╋╋┓┏┻┓┏┫┃━┫┏┛
┃┃╋┃┃┃╋┃┃╋┃┃┃┃┃┣━━┃┃┃┃┃┃┃╋┃┃┃┃━┫┃
┗┛╋┗━┛╋┗┛╋┗┛┗┛┗┻━━┻┛┗┻┛┗┛╋┗┛┗━━┻┛${NC}"

while getopts "i:p:a:r" opt; do
    case ${opt} in
        i)
            INTERFACE=${OPTARG}
            ;;
        p)
            PORTS=${OPTARG//,/ or port }
            ;;
        a)
            ADDRESS=${OPTARG}
            ;;
        r)
            RAW=true
            ;;
        \?)
            print_usage
            ;;
    esac
done

if [[ -z ${INTERFACE} ]]; then
    print_usage
fi

FILTER="tcp"
if [[ -n ${PORTS} ]]; then
    FILTER="${FILTER} and (port ${PORTS})"
fi
if [[ -n ${ADDRESS} ]]; then
    FILTER="${FILTER} and host ${ADDRESS}"
fi

echo -e "${BLUE}Listening on interface ${INTERFACE} with filter '${FILTER}'${NC}"

if [[ ${RAW} = true ]]; then
    tcpdump -i ${INTERFACE} -nn -s0 -v ${FILTER}
else
    tcpdump -i ${INTERFACE} -nn -s0 ${FILTER}
fi

