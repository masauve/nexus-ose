#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

${DIR}/addrepo.sh jboss http://maven.repository.redhat.com/techpreview/all/
${DIR}/addrepo.sh jboss-ce https://repository.jboss.org/nexus/content/groups/public/
${DIR}/addrepo.sh fusesource-public https://repo.fusesource.com/nexus/content/groups/public
${DIR}/addrepo.sh fusesource-ea https://repo.fusesource.com/nexus/content/groups/ea
${DIR}/addrepo.sh redhat-ga https://maven.repository.redhat.com/ga
${DIR}/addrepo.sh apache-public https://repo.maven.apache.org/maven2
