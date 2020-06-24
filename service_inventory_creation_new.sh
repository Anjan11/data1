#!/bin/bash


function reading_lines {

vms=()
while read -r line && [ -n "$line" ] 
do
  vms+=("$line")
done

}

function prd_group_vms_reading {

#flusing the variable
vms=""

reading_lines

group_a_prd_aus_vm=$(printf "%s\n" "${vms[@]}" | egrep "^prd|^ecprd" | grep aus | awk 'NR==1 {print}')

ganglia_collector_aus=$(echo "$group_a_prd_aus_vm" | perl -lne 's/(.*)(\[)(..?.?)(:..?.?\])(.*)/$1$3$5/; print')

group_b_prd_aus_vm=$(printf "%s\n" "${vms[@]}" | egrep "^prd|^ecprd" | grep aus | awk 'NR==2 {print}')

group_a_prd_phl_vm=$(printf "%s\n" "${vms[@]}" | egrep "^prd|^ecprd" | grep phl | awk 'NR==1 {print}')

ganglia_collector_phl=$(echo "$group_a_prd_phl_vm" | perl -lne 's/(.*)(\[)(..?.?)(:..?.?\])(.*)/$1$3$5/; print')

group_b_prd_phl_vm=$(printf "%s\n" "${vms[@]}" | egrep "^prd|^ecprd" | grep phl | awk 'NR==2 {print}')

groupprd_aus="${tnt}_${prdenv}_${service}_${dcaus}"

groupprd_phl="${tnt}_${prdenv}_${service}_${dcphl}"

}

function pre_prd_vms_reading {

#flusing the variable

vms=""

reading_lines

group_pre_prd_aus=$(printf "%s\n" "${vms[@]}" | egrep "\-prd" | grep aus | awk 'NR==1 {print}')	

group_pre_prd_phl=$(printf "%s\n" "${vms[@]}" | egrep "\-prd" | grep phl | awk 'NR==1 {print}')

}	

function pre_qa_stg_vms_reading {

#flusing the variable

vms=""

reading_lines

pre_qa_aus=$(printf "%s\n" "${vms[@]}" | egrep "\-qa" | grep aus | awk 'NR==1 {print}')

pre_qa_phl=$(printf "%s\n" "${vms[@]}" | egrep "\-qa" | grep phl | awk 'NR==1 {print}')

pre_pre_stg_aus=$(printf "%s\n" "${vms[@]}" | egrep "\-stg" | grep aus | awk 'NR==1 {print}')

pre_stg_phl=$(printf "%s\n" "${vms[@]}" | egrep "\-stg" | grep phl | awk 'NR==1 {print}')

}


function qa_stg_vms {

cat <<EOF 
[${tnt}_${env1}_${service}_${dcaus}]
$qa_aus

[${tnt}_${env1}_${service}_${dcphl}]
$qa_phl

[${tnt}_${stgenv}_${service}_${dcaus}]
$stg_aus

[${tnt}_${stgenv}_${service}_${dcphl}]
$stg_phl

EOF
}

function qa_vms {

cat <<EOF
[${tnt}_${qaenv}_${service}_${dcaus}]
$qa_aus

[${tnt}_${qaenv}_${service}_${dcphl}]
$qa_phl

EOF
	
}	

function stg_vms {

cat <<EOF
[${tnt}_${stgenv}_${service}_${dcaus}]
$stg_aus

[${tnt}_${stgenv}_${service}_${dcphl}]
$stg_phl

EOF
}

function beta_vms {

cat <<EOF
[${tnt}_${betaenv}_${service}_${dcaus}]
$beta_aus

[${tnt}_${betaenv}_${service}_${dcphl}]
$beta_phl

[${tnt}_${betaenv}_${service}:children]
${tnt}_${betaenv}_${service}_${dcaus}
${tnt}_${betaenv}_${service}_${dcphl}

#Add values to below vars or remove if beta vars not required
[${tnt}_${betaenv}_${service}:vars]
zabbix_cluster_group="skip"
tag=
min_vm_count=
max_vm_count=

EOF
}


function pre_qa_stg_vms {

cat <<EOF	
[${tnt}_pre_${qaenv}_${service}_${dcaus}]
$pre_qa_aus

[${tnt}_pre_${qaenv}_${service}_${dcphl}]
$pre_qa_phl

[${tnt}_pre_${stgenv}_${service}_${dcaus}]
$pre_stg_aus

[${tnt}_pre_${stgenv}_${service}_${dcphl}]
$pre_stg_phl

EOF


}

function pre_prd_vms {

cat <<EOF
[${tnt}_pre_${prdenv}_${service}_${dcaus}]
$pre_prd_aus

[${tnt}_pre_${prdenv}_${service}_${dcphl}]
$pre_prd_phl
EOF
	
}	

function pre_prd_children {

cat <<EOF

[${tnt}_pre_${service}:children]
${tnt}_pre_${env1}_${service}_${dcaus}
${tnt}_pre_${env1}_${service}_${dcphl}
${tnt}_pre_${stgenv}_${service}_${dcaus}
${tnt}_pre_${stgenv}_${service}_${dcphl}
${tnt}_pre_${prdenv}_${service}_${dcaus}
${tnt}_pre_${prdenv}_${service}_${dcphl}

[${tnt}_pre_${env1}_${service}:children]
${tnt}_pre_${env1}_${service}_${dcaus}
${tnt}_pre_${env1}_${service}_${dcphl}

[${tnt}_pre_${stgenv}_${service}:children]
${tnt}_pre_${stgenv}_${service}_${dcaus}
${tnt}_pre_${stgenv}_${service}_${dcphl}

[${tnt}_pre_${prdenv}_${service}:children]
${tnt}_pre_${prdenv}_${service}_${dcaus}
${tnt}_pre_${prdenv}_${service}_${dcphl}

[${tnt}_pre_${service}:children]
${tnt}_pre_${env1}_${service}
${tnt}_pre_${stgenv}_${service}
${tnt}_pre_${prdenv}_${service}
EOF
}	

# non group wise prd vms
function non_group_wise_vms {
cat <<EOF	
[${tnt}_${prdenv}_${service}_${dcaus}]
$prd_aus

[${tnt}_${prdenv}_${service}_${dcphl}]
$prd_phl
EOF
}

function prd_group_wise {

cat <<EOF

[${tnt}_${prdenv}_${service}_${dcaus}:children]
${groupprd_aus}_group_a
${groupprd_aus}_group_b

[${groupprd_aus}_group_a]
$group_a_prd_aus_vm

[${groupprd_aus}_group_b]
$group_b_prd_aus_vm

[${tnt}_${prdenv}_${service}_${dcphl}:children]
${groupprd_phl}_group_a
${groupprd_phl}_group_b

[${groupprd_phl}_group_a]
$group_a_prd_phl_vm

[${groupprd_phl}_group_b]
$group_b_prd_phl_vm

[${tnt}_${prdenv}_${service}:children]
${tnt}_${prdenv}_${service}_${dcaus}
${tnt}_${prdenv}_${service}_${dcphl}

#Please remove below if group specific vars not required
[${groupprd_aus}_group_a:vars]
tag=

[${groupprd_phl}_group_a:vars]
tag=

[${groupprd_aus}_group_b:vars]
tag=

[${groupprd_phl}_group_b:vars]
tag=
EOF
}


function all_env_group_children {

cat <<EOF	

## Add beta groups if beta vms specified to below groups ##

#Please add below micro "${tnt}_${service}:children" groups in the respective main service groups children like "tnt4_prd_asset_phl:children" or "tnt2_prd_commerce_aus:children" for all environments respectively. This is for to get global vars ##
[${tnt}_${service}:children]
${tnt}_${env1}_${service}_${dcaus}
${tnt}_${env1}_${service}_${dcphl}
${tnt}_${stgenv}_${service}_${dcaus}
${tnt}_${stgenv}_${service}_${dcphl}
${tnt}_${prdenv}_${service}_${dcaus}
${tnt}_${prdenv}_${service}_${dcphl}

[${tnt}_${env1}_${service}:children]
${tnt}_${env1}_${service}_${dcaus}
${tnt}_${env1}_${service}_${dcphl}

[${tnt}_${stgenv}_${service}:children]
${tnt}_${stgenv}_${service}_${dcaus}
${tnt}_${stgenv}_${service}_${dcphl}

[${tnt}_${prdenv}_${service}:children]
${tnt}_${prdenv}_${service}_${dcaus}
${tnt}_${prdenv}_${service}_${dcphl}

[${tnt}_${service}:children]
${tnt}_${env1}_${service}
${tnt}_${stgenv}_${service}
${tnt}_${prdenv}_${service}

#Add values to below vars
[${tnt}_${env1}_${service}:vars]
zabbix_cluster_group="skip"
tag=
min_vm_count=
max_vm_count=

[${tnt}_${stgenv}_${service}:vars]
zabbix_cluster_group="skip"
tag=
min_vm_count=
max_vm_count=
EOF

}

function qa_prd_children {

cat <<EOF
[${tnt}_${service}:children]
${tnt}_${qaenv}_${service}_${dcaus}
${tnt}_${qaenv}_${service}_${dcphl}
${tnt}_${prdenv}_${service}_${dcaus}
${tnt}_${prdenv}_${service}_${dcphl}

[${tnt}_${qaenv}_${service}:children]
${tnt}_${qaenv}_${service}_${dcaus}
${tnt}_${qaenv}_${service}_${dcphl}

[${tnt}_${prdenv}_${service}:children]
${tnt}_${prdenv}_${service}_${dcaus}
${tnt}_${prdenv}_${service}_${dcphl}

[${tnt}_${service}:children]
${tnt}_${qaenv}_${service}
${tnt}_${prdenv}_${service}

#Add values to below vars
[${tnt}_${qaenv}_${service}:vars]
zabbix_cluster_group="skip"
tag=
min_vm_count=
max_vm_count=

[${tnt}_${prdenv}_${service}:vars]
zabbix_cluster_group="skip"
tag=
min_vm_count=
max_vm_count=

EOF

}

function stg_prd_children {

cat <<EOF
[${tnt}_${service}:children]
${tnt}_${stgenv}_${service}_${dcaus}
${tnt}_${stgenv}_${service}_${dcphl}
${tnt}_${prdenv}_${service}_${dcaus}
${tnt}_${prdenv}_${service}_${dcphl}

[${tnt}_${stgenv}_${service}:children]
${tnt}_${stgenv}_${service}_${dcaus}
${tnt}_${stgenv}_${service}_${dcphl}

[${tnt}_${prdenv}_${service}:children]
${tnt}_${prdenv}_${service}_${dcaus}
${tnt}_${prdenv}_${service}_${dcphl}

[${tnt}_${service}:children]
${tnt}_${stgenv}_${service}
${tnt}_${prdenv}_${service}

#Add values to below vars
[${tnt}_${stgenv}_${service}:vars]
zabbix_cluster_group="skip"
tag=
min_vm_count=
max_vm_count=

[${tnt}_${prdenv}_${service}:vars]
zabbix_cluster_group="skip"
tag=
min_vm_count=
max_vm_count=
EOF

}

function common_vars {

cat <<EOF

#Please add below if "tag and zabbix cluster" are common for both aus and phl
[${tnt}_${prdenv}_${service}:vars]
zabbix_cluster_group=""
tag=

[${tnt}_${prdenv}_${service}_${dcphl}:vars]
ganglia_collector="$ganglia_collector_phl"
flavor_id=""
min_vm_count=
max_vm_count=
tag=

[${tnt}_${prdenv}_${service}_${dcaus}:vars]
ganglia_collector="$ganglia_collector_aus"
flavor_id=""
min_vm_count=
max_vm_count=
tag=

#Add the values to below vars and remove java or descale vars if not required
[${tnt}_${service}:vars]
flavor=""
chef_vm_role=['']
chef_run_role=['']
app_folder_name=['']
stopapp_cmd=['']
startapp_cmd=['']
app_ports=['']
bigip_pool_port=['']
zabbix_template=['']
${tnt}_${service}_keys_folder=""
ganglia_cluster=""
zabbix_group="skip"
descale=""
java=""
EOF
}

file=verify.ini

if [ -f "$file" ];

then

rm verify.ini

fi

echo -e "Enter the Service details for inventory"

echo "Enter the tenant name example tnt2"

read tnt

echo "Enter the environment names with space between them, qa stg beta(if beta not required, please do not add) prd"

read -r env1 env2 env3 env4

echo "Enter the service name like commerce or rendering etc"

read service

echo "Enter the DC names with space between them, aus phl"

read -r dcaus dcphl

echo "Enter the service vms and Press Enter key twice (after completion of adding vms) to come out of it"

reading_lines

qa_aus=$(printf "%s\n" "${vms[@]}" | egrep "^qa|int" | grep aus)

qa_phl=$(printf "%s\n" "${vms[@]}" | egrep "^qa|int" | grep phl)

stg_aus=$(printf "%s\n" "${vms[@]}" | egrep "^stg|reg" | grep aus)

stg_phl=$(printf "%s\n" "${vms[@]}" | egrep "^stg|reg" | grep phl)

beta_aus=$(printf "%s\n" "${vms[@]}" | egrep "beta" | grep aus)

beta_phl=$(printf "%s\n" "${vms[@]}" | egrep "beta" | grep phl)

### pre value capturing from all environment ###
pre_qa_aus=$(printf "%s\n" "${vms[@]}" | egrep "\-qa" | grep aus)

pre_qa_phl=$(printf "%s\n" "${vms[@]}" | egrep "\-qa" | grep phl)

pre_stg_aus=$(printf "%s\n" "${vms[@]}" | egrep "\-stg" | grep aus)

pre_stg_phl=$(printf "%s\n" "${vms[@]}" | egrep "\-stg" | grep phl)

pre_prd_aus=$(printf "%s\n" "${vms[@]}" | egrep "\-prd" | grep aus)

pre_prd_phl=$(printf "%s\n" "${vms[@]}" | egrep "\-prd" | grep aus)
###

prd_aus=$(printf "%s\n" "${vms[@]}" | egrep "^prd|^ecprd" | grep aus2)

ganglia_collector_aus=""

ganglia_collector_aus=$(echo "$prd_aus" | perl -lne 's/(.*)(\[)(..?.?)(:..?.?\])(.*)/$1$3$5/; print')

prd_phl=$(printf "%s\n" "${vms[@]}" | egrep "^prd|^ecprd" | grep phl1)

ganglia_collector_phl=""

ganglia_collector_phl=$(echo "$prd_phl" | perl -lne 's/(.*)(\[)(..?.?)(:..?.?\])(.*)/$1$3$5/; print')

echo -e

qaenv=qa
stgenv=stg
betaenv=beta
prdenv=prd

read -n 1 -p "Press y or n, if group is required for prd or not:" yn

echo -e

#read -r -p "Please specify if groups required for qa stg prd:" groupqa groupstg groupprd

echo "Enter the prod vms per groupwise for both DC's, if groups are required. Press Enter key twice (after completion of adding vms)"

if [[ $yn == "y" ]]

then

if [[ "$env1" == "qa" ]] && [[ "$env2" == "stg" ]] || [[ "$env3" == "beta" ]] || [[ "$env3" == "prd" ]] || [[ "$env4" == "prd" ]]

then

prd_group_vms_reading 

qa_stg_vms

echo "$env3" | grep -q "beta"

if [[ $? -eq 0 ]]

then	

beta_vms

fi

if [[ ! -z "$pre_prd_aus" ]] || [[ ! -z "$pre_prd_phl" ]]

then

pre_prd_vms_reading
pre_qa_stg_vms
pre_prd_vms
pre_prd_children

fi	

prd_group_wise 

all_env_group_children 

common_vars

elif [[ "$env1" == "qa" ]] || [[ "$env1" == "stg" ]] && [[ "$env2" == "prd" ]]

then

prd_group_vms_reading

#Verifying if qa or stg in first passed input

echo "$env1" | grep -q "qa"

if [[ $? -eq 0 ]]

then

qa_vms

qa_prd_children

else

stg_vms

stg_prd_children    
    
fi

prd_group_wise

common_vars 

fi >>$file


else

qa_stg_vms $stgenv

echo "$env3" | grep -q "beta"

if [[ $? -eq 0 ]]

then

beta_vms

fi

non_group_wise_vms

all_env_group_children

common_vars

#group_children

fi >>$file

echo "Below are ansible debug to know vms belong to which groups"
ansible -i $file -m debug -a "var=group_names" all

echo "Inventory details which was given as input has copied to verify.ini file"


