set -x
set -e

npx oc publish hello-world --registries $OC_REGISTRY --username $OC_USERNAME --password $OC_PASSWORD

while true; do
    sleep 10
done
