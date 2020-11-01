if [[ $1 != "-t" ]]; then
  RECORD_TYPE="A"
  DOMEIN=$1
  IP=$2
  ZONE=$3
else
  while getopts ":t:" opt; do
    case $opt in
      t) RECORD_TYPE="$OPTARG"
      ;;
      \?) echo "Invalid option -$OPTARG" >&2
          exit 1
      ;;
    esac
  done

  case $RECORD_TYPE in
    MX) echo "$RECORD_TYPE"
        NAME=$3
        IP=$4
        DOMEIN=$5
    ;;
    A) echo "$RECORD_TYPE"                                                                                                                                                                                                                          DOMEIN=$3
       IP=$4
       ZONE=$5
    ;;
    CNAME) echo "$RECORD_TYPE"
           ALIAS=$3
           DOMEIN=$4
    ;;
    *) echo "Invalid record type given" >&2
       exit 1
    ;;
  esac
fi
