#!/bin/bash

#constants
ELB=your-elb-name

ELB_NODE_ONE=i-000000c0
ELB_NODE_TWO=i-000000c1

#remove from elb and wait for instance to be actually removed
remove_from_lb_and_wait() {

    #Check for active node:

    ELB_NODE_ONE_CHANGE=`aws elb describe-instance-health --load-balancer-name danny-test-lb |  grep InstanceId | awk '{ print $2 }'| tr -d '"'| tr -d ','`
    
    

    
    echo "active node: " $ELB_NODE_ONE_CHANGE

    echo "Taking " $ELB_NODE_ONE " Down. "
    aws elb deregister-instances-from-load-balancer --load-balancer-name $ELB --instances $ELB_NODE_ONE
    echo "Node " $ELB_NODE_ONE "Is down. "
    echo '_Adam Delarosa' | bash sshInstance.sh $ELB_NODE_ONE "cat > /home/test/index.html"
        #aws elb describe-instance-health --load-balancer-name $ELB
        #remove instance
        #wait till actually removed
}

#insert into elb and wait for instance to be in service
insert_into_lb_and_wait() {
        aws elb register-instances-with-load-balancer --load-balancer-name $ELB --instances $ELB_NODE_ONE

        #add instance
        #wait till inservice
}

#main
main() {
    remove_from_lb_and_wait
    insert_into_lb_and_wait
}

main
