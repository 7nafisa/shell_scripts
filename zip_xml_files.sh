echo "Going to zip xml files for dir: "
echo $1 
cd $1
rm -r _zipped
mkdir _zipped
cd _zipped
count=0
zip_number=0
for file_name in ../*.xml
do
	echo "$file_name"
	count=$(($count+1))
	if [[ $count = 1 ]]
	then
		echo "creating temp dir"
		mkdir ./temp
	fi   
	cp "$file_name" ./temp
	if [[ $count = 10 ]]
	then
		zip_file="$1""_""$zip_number"".zip"
		echo "Zipping file" $zip_file
		cd ./temp/
		zip -r $zip_file .
		mv $zip_file ../
		cd ..
		rm -r ./temp
		zip_number=$(($zip_number+1))
		count=0
	fi

done
zip_file="$1""_""$zip_number"".zip"
cd ./temp/
zip -r ./$zip_file .
mv $zip_file ../
cd ..
rm -r ./temp

echo "Done with zipping all files"



