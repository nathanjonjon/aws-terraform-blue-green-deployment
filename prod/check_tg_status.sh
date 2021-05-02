tg_status(){
	TG_ARN=$1
	aws elbv2 describe-target-health --target-group-arn $TG_ARN > health.json
	len=$(jq -r '.TargetHealthDescriptions | length' health.json)
	counter=0
	if [[ $len == 0 ]]; then
		echo "no targets in this target group yet"
		return 2
	fi
	for i in $(seq 0 $(($len - 1)))
	do
		target=$(jq --argjson index $i -r '.TargetHealthDescriptions[$index].Target.Id' health.json)
		status=$(jq --argjson index $i -r '.TargetHealthDescriptions[$index].TargetHealth.State' health.json)
		if [[ $status == "initial" ]]; then
			continue
		fi
		if [[ $status == "healthy" || $status == "unused" ]]; then
			counter=$((counter+1))
			if [[ $counter == $len ]]; then
				echo "all healthy"
				return 0
			fi
		else
			reason=$(jq --argjson index $i -r '.TargetHealthDescriptions[$index].TargetHealth.Reason' health.json)
			echo "$target is $status because $reason"
			return 1
		fi
		
	done
	echo "not all targets are ready"
	return 2
}

SECONDS=0
for i in $(seq 1 40)
do
    # output=$(tg_status $1)
	tg_status $1
	output=$?
    if [[ $output == "2" ]]; then
        msg="wait for $SECONDS sec"
        echo -n $msg
		if [[ $i == "40" ]]; then
            echo "timeout"
			exit 1
		else
			for j in $(seq 1 ${#msg})
        	do
                echo -en "\b"
        	done
        fi
        sleep 10
	fi
    if [[ $output == "0" ]]; then
        exit 0
    fi
	if [[ $output == "1" ]]; then
        exit 1
    fi
done


