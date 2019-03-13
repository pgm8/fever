#!/usr/bin/env bash

# get the absolute path of this file
# (** This does not expand symlink)
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pushd . > /dev/null
# clone takuma-ynd/jack.git
cd ${THIS_FILE_PATH}/../
cd /content/
git clone https://github.com/takuma-ynd/jack.git
# cd jack
# This part can fail depending on the python environment. -> better to manually run this.
# # if "python3" command is available, use that.
# if command -v python3 &>/dev/null; then
#     python3 -m pip install -e .[tf]
# else
#     python -m pip install -e .[tf]
# fi
# bash ./data/GloVe/download.sh
popd > /dev/null

pushd . > /dev/null
cd ${THIS_FILE_PATH}/../
cd /content/
git clone https://github.com/takuma-ynd/fever-baselines.git
popd > /dev/null

cd /content/fever

mkdir data
mkdir results

download_if_not_exists() {
    if [ ! -f $2 ]; then
        wget $1 -O $2
    else
        echo "$2 already exists. skipping download..."
    fi
}
download_if_not_exists "https://s3-eu-west-1.amazonaws.com/fever.public/train.jsonl" "data/train.jsonl"
download_if_not_exists "https://s3-eu-west-1.amazonaws.com/fever.public/shared_task_dev.jsonl" "data/dev.jsonl"
download_if_not_exists "https://s3-eu-west-1.amazonaws.com/fever.public/shared_task_test.jsonl" "data/test.jsonl"
download_if_not_exists "https://s3-eu-west-1.amazonaws.com/fever.public/wiki-pages.zip" "/tmp/wiki-pages.zip"
# download trained model
download_if_not_exists "http://tti-coin.jp/data/yoneda/fever/base+sampling2+evscores+rerank+train+dev+test-shared_test.ver0727_newaggr_submission.zip" "/tmp/base+sampling2+evscores+rerank+train+dev+test-shared_test.ver0727_newaggr_submission.zip"

download_if_not_exists "http://tti-coin.jp/data/yoneda/fever/data.zip" "/tmp/data.zip"
unzip /tmp/data.zip

if [ ! -d fever/data/wiki-pages/wiki-pages ]; then
    mkdir fever/data/wiki-pages
    unzip /tmp/wiki-pages.zip -d fever/data/wiki-pages
    rm /tmp/wiki-pages.zip
fi

if [ ! -d fever/results/base+sampling2+evscores+rerank+train+dev+test-shared_test.ver0727_newaggr_submission ]; then
    unzip /tmp/base+sampling2+evscores+rerank+train+dev+test-shared_test.ver0727_newaggr_submission.zip -d fever/results
fi


setup.sh  #Done manually in colab
