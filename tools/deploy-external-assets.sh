#!/usr/bin/env bash

# Fail on errors.
set -eux -o pipefail

if [[ $# -ne 1 || ! -d $1 ]]; then
    echo "Usage: deploy-external-assets.sh SITE_DIR"
    exit 1
fi

OUTPUT_DIR=$1

echo "Deploying the /badge/ directory..."
BADGE_DIR=${OUTPUT_DIR}/badge
curl https://gitlab.com/fdroid/artwork/repository/archive.tar.gz?ref=master | gunzip -c | tar --wildcards -xf - 'artwork-master*/badge'
rm -rf ${BADGE_DIR}
mv artwork-master-*/badge ${BADGE_DIR}
rm -r artwork-master-*

echo "Deploying the /forums/ directory..."
FORUMS_DIR=${OUTPUT_DIR}/forums
curl https://gitlab.com/fdroid/fdroid-website-legacy-forum/repository/archive.tar.gz?ref=master | gunzip -c | tar --wildcards -xf - 'fdroid-website-legacy-forum-master*/forums'
rm -rf ${FORUMS_DIR}
mv fdroid-website-legacy-forum-master-*/forums ${FORUMS_DIR}
rm -r fdroid-website-legacy-forum-master*