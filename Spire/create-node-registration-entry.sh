#/bin/bash
set -x

set -e

bb=$(tput bold)
nn=$(tput sgr0)



register() {
    oc exec -n spire spire-server-0 -c spire-server -- /opt/spire/bin/spire-server entry create $@
}

echo "${bb}Creating registration entry for the node...${nn}"
register  /opt/spire/bin/spire-server entry create \
    -node  \
    -spiffeID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s_sat:cluster:ocp \
    -selector k8s_sat:agent_ns:spire \
    -selector k8s_sat:agent_sa:spire-agent

echo "${bb}Creating registration entry for the registry - auth-server...${nn}"
register  -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -spiffeID spiffe://example.org/ns/gx-lab/sa/default/gx-registry-server-main \
    -selector k8s:ns:default \
    -selector k8s:sa:default \
    -selector k8s:pod-label:app:backend \
    -selector k8s:container-name:envoy

echo "${bb}Creating registration entry for the compliance - auth-server...${nn}"
register  -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -spiffeID spiffe://example.org/ns/gx-lab/sa/default/gx-compliance-server-main \
    -selector k8s:ns:gx-lab \
    -selector k8s:sa:default \
    -selector k8s:pod-label:app:gx-compliance-main \
    -selector k8s:container-name:envoy

 echo "${bb}Creating registration entry for the workload - auth-server...${nn}"
register  -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -spiffeID spiffe://example.org/ns/gx-lab/sa/default/gx-workload \
    -selector k8s:ns:gx-lab \
    -selector k8s:sa:default \
    -selector k8s:pod-label:app:gx-workload \
    -selector k8s:container-name:envoy
