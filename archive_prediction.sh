echo there are $# number of team codes have been passed.
pi_suffix="_PI_prediction_archive.json"
mi_suffix="_MI_prediction_archive.json"

for code in $*
do 
	pi_file="$code""$pi_suffix"
	echo Calling PI for team "$code"
	pi_url="https://nba-phys-temp.sa.demo-gotapaas.com/rest/nba/physIntensityTeam?team="$code""
	pi_response=$(curl "$pi_url")
	echo "$pi_response" >> "$pi_file"
	echo Done saving PI predictions in "$pi_file"
	mi_file="$code""$mi_suffix"
	echo Calling MI for team "$code"
        mi_url="https://nba-mech-temp.sa.demo-gotapaas.com/rest/nba/mechIntensityTeam?team="$code""
	mi_response=$(curl "$mi_url")
	echo "$mi_response" >> "$mi_file"
        echo Done saving MI predictions onto "$mi_file"
done
