# Description: Generating a disk name according to linux disk naming policy
# Input parameter: disk index number
# Output: disk name
#
get_disk_name(){
  local disk_idx=$1 disk_type="$2"
  array_disk=( {a..z} )
  if [ $disk_idx -lt 26 ];then
    disk_name1=""
    disk_name2=""
    disk_name3="${array_disk[$disk_idx]}"
  elif [ $disk_idx -ge 26 -a $disk_idx -lt 702 ];then
  # disk id 27 -> sdaa
    disk_name1=""
    disk_id2=$(( i / 26 ))
    disk_id2=$(( disk_id2 -1 ))
    disk_name2="${array_disk[$disk_id2]}"
    disk_id3=$(( i % 26 ))
    disk_name3="${array_disk[$disk_id3]}"
  elif [ $disk_idx -ge 702 -a $disk_idx -lt $MAX_DISK_NUM ];then
  # disk id 703 -> sdaaa, max id 18278 -> sdzzz
    disk_id=$(( i - 702 ))
    disk_id1=$(( disk_id / 676 ))
    disk_name1="${array_disk[$disk_id1]}"
    disk_id=$(( disk_id % 676 ))
    disk_id2=$(( disk_id / 26 ))
    disk_name2="${array_disk[$disk_id2]}"
    disk_id3=$(( disk_id % 26 ))
    disk_name3="${array_disk[$disk_id3]}"
  else
    echo "Invalid disk index:$disk_idx, must less than $MAX_DISK_NUM!"
  fi
  if [ "X$disk_type" == "Xvirtio" ];then
    disk_prefix="vd"
  else
    disk_prefix="sd"
  fi
  disk_name="${disk_prefix}${disk_name1}${disk_name2}${disk_name3}"
  #echo "disk_id:$disk_idx id1:$disk_id1 id2:$disk_id2 id3:$disk_id3 name:$disk_name"
  echo "$disk_name"
}

# Maximum limit, see http://lxr.linux.no/#linux+v2.6.37/drivers/scsi/sd.c#L2262
MAX_DISK_NUM=18278
total=18
for (( i=0; i<=$(( $total -1 )); i++ ));do
  disk_name=$(get_disk_name $i "virtio")
  echo "name:$disk_name"
done
