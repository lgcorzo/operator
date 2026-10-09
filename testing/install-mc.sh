#!/usr/bin/env bash
# This script will run inside ubuntu-pod that is located at default namespace in the cluster
# This script will not and should not be executed in the self hosted runner

echo "install-mc.sh: Installing mc command"
apt-get update -y
apt-get upgrade -y
apt-get clean -y
apt-get install wget -y
apt-get install jq -y

echo "install-mc.sh: Install mc"
echo "MC_HOT_FIX_REL=$MC_HOT_FIX_REL, MC_VER=$MC_VER"

if [ ! -x /usr/local/bin/mc ]; then
	if command -v docker >/dev/null 2>&1; then
		docker run --rm --entrypoint cat ghcr.io/lgcorzo/mc:latest /usr/bin/mc > mc || \
		docker run --rm --entrypoint cat quay.io/minio/aistor/mc:latest /usr/bin/mc > mc || true
	fi
	if [ ! -s mc ]; then
		wget -qO mc https://github.com/lgcorzo/mc/releases/latest/download/mc || true
	fi
	if [ -s mc ]; then
		chmod +x mc
		mv mc /usr/local/bin/mc
	fi
fi

echo "install-mc.sh: we should see mc output if mc got installed:"
mc --version
RESULT=$(mc | grep -c GNU)
if [ "$RESULT" == "1" ]; then
	echo "script passed" >install-mc.log
else
	echo "mc not installed, install-mc.sh failed"
fi
