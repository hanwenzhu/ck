from cmind import utils
import cmind as cm
import os
import subprocess
from os.path import exists

def preprocess(i):

    os_info = i['os_info']
    env = i['env']
    if 'CM_DOCKER_RUN_SCRIPT_TAGS' not in env:
        env['CM_DOCKER_RUN_SCRIPT_TAGS'] = "run,docker,container"
        CM_RUN_CMD="cm version"
    else:
        CM_RUN_CMD="cm run script --quiet --tags=" + env['CM_DOCKER_RUN_SCRIPT_TAGS']
    if 'CM_DOCKER_IMAGE_BASE' not in env:
        env['CM_DOCKER_IMAGE_BASE'] = "ubuntu:20.04"
    if 'CM_DOCKER_IMAGE_REPO' not in env:
        env['CM_DOCKER_IMAGE_REPO'] = "local/" + env['CM_DOCKER_RUN_SCRIPT_TAGS'].replace(',', '-').replace('_','')
    if 'CM_DOCKER_IMAGE_TAG' not in env:
        env['CM_DOCKER_IMAGE_TAG'] = env['CM_DOCKER_IMAGE_BASE'].replace(':','-').replace('_','') + "-latest"

    r = cm.access({'action':'search', 'automation':'script', 'tags': env['CM_DOCKER_RUN_SCRIPT_TAGS']})
    if len(r['list']) < 1:
        raise Exception('CM script with tags '+ env['CM_DOCKER_RUN_SCRIPT_TAGS'] + ' not found!')
    PATH = r['list'][0].path
    os.chdir(PATH)
    env['CM_DOCKER_IMAGE_RUN_CMD'] = CM_RUN_CMD
    DOCKER_CONTAINER = env['CM_DOCKER_IMAGE_REPO'] +  ":" + env['CM_DOCKER_IMAGE_TAG'] 

    CMD = "docker images -q " +  DOCKER_CONTAINER + " 2> /dev/null"
    docker_image = subprocess.check_output(CMD, shell=True).decode("utf-8")
    recreate_image = env.get('CM_DOCKER_IMAGE_RECREATE', '')

    if docker_image and recreate_image != "yes":
        print("Docker image exists with ID: " + docker_image)
        env['CM_DOCKER_IMAGE_EXISTS'] = "yes"
    elif recreate_image == "yes":
        env['CM_DOCKER_IMAGE_RECREATE'] = "no"

    return {'return':0}

def postprocess(i):
    env = i['env']
    run_cmds = []
    if 'CM_DOCKER_PRE_RUN_COMMANDS' in env:
        for pre_run_cmd in env['CM_DOCKER_PRE_RUN_COMMANDS']:
            run_cmds.append(pre_run_cmd)
    run_cmd = env['CM_DOCKER_IMAGE_RUN_CMD'] + " " +env.get('CM_DOCKER_RUN_CMD_EXTRA', '').replace(":","=")
    run_cmds.append(run_cmd)
    if 'CM_DOCKER_POST_RUN_COMMANDS' in env:
        for post_run_cmd in env['CM_DOCKER_POST_RUN_COMMANDS']:
            run_cmds.append(post_run_cmd)

    run_cmd = " && ".join(run_cmds)
    print("Running "+run_cmd+" inside docker container")
    CONTAINER="docker run -dt --rm " + env['CM_DOCKER_IMAGE_REPO'] + ":" + env['CM_DOCKER_IMAGE_TAG'] + " bash"
    CMD = "ID=`" + CONTAINER + "` && docker exec $ID bash -c '" + run_cmd + "' && docker kill $ID >/dev/null"
    docker_out = subprocess.check_output(CMD, shell=True).decode("utf-8")
    print(docker_out)

    return {'return':0}
