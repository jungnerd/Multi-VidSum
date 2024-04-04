set -eu
source ./tools/shell_utils.sh
load_project_config

cp "${DOCKER_SETTING_DIR}/base_entrypoint.sh" "${DOCKER_SETTING_DIR}/entrypoint.sh"
exec_shell="bash"
echo $exec_shell  >> "${DOCKER_SETTING_DIR}/entrypoint.sh"



export DOCKER_HOST=unix:///var/run/docker.sock
IP_ADDRESS=`hostname -I | cut -d ' ' -f1`
ZSH_CONFIG_PATH=`readlink -f ${HOME}/.bashrc`

mkdir -p "${WORK_DIR}"

docker run \
       -it \
       --gpus all \
       --rm  \
       --hostname=`hostname` \
       --env ENTER_DIR=`pwd -P` \
       --shm-size=100gb \
       --mount type=bind,source="${WORK_DIR}",target="/work" \
       --mount type=bind,source="${BASE_DIR}",target="${BASE_DIR}" \
       --mount type=bind,source="${DOCKER_SETTING_DIR}/.zshrc",target="${ZSH_CONFIG_PATH}" \
       $PROJECT_NAME
