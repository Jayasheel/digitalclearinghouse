mongopod=`sudo kubectl get pods -l io.kompose.service=mongo -n gx-lab -o json | jq .items[0].metadata.name | sed 's/"//g'`
sudo kubectl exec -it ${mongopod} -n gx-lab -- mongosh << _EOT_
use trust-registry
db.createUser({user:"trustuser",pwd:"password",roles:["dbOwner"]})
db.getName()
_EOT_

