function fileshare
  
  if not set -q argv[1]
    echo "Please provide a file to share"
    return 1
  end

  set -l config_file ~/.config/fileshare/config.json

  if not test -f $config_file
    mkdir -p (dirname $config_file)

    echo "Config file not found. Initialize config file at $config_file Please set values."
    printf "\
{
	\"bucket\": \"Your bucket to upload a file\",
	\"region\": \"Region of your bucket\",
	\"service_account\": \"Service account email that can read and write an object in your bucket\",
	\"key_file\": \"Key file (json) of the service account\"
}
" > $config_file
    return 0
  end

  # Read config
  set -l bucket (cat $config_file | jq -r '.bucket')
  set -l service_account (cat $config_file | jq -r '.service_account')
  set -l key_file (cat $config_file | jq -r '.key_file')
  set -l region (cat $config_file | jq -r '.region')

  set -l file_to_share $argv[1]
  set -l filename (basename $file_to_share)
  set -l identifier (date "+%Y-%m-%d-%H:%M:%S")(random 100000 999999)
  set -l identifier (echo $identifier | shasum | tr -d "\n *-")

  gcloud storage cp $file_to_share gs://$bucket/$identifier/$filename --account $service_account

  set -l output (CLOUDSDK_PYTHON_SITEPACKAGES=1 gcloud storage sign-url gs://$bucket/$identifier/$filename --region=$region --duration=5m --account=$service_account --private-key-file=$key_file)

  # echo $output

  set -l signed_url (echo $output | grep -oE 'https://\S+')
  echo $signed_url | fish_clipboard_copy
  echo
  echo "Copied to clipboard!"

end
