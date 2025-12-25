bash vrun_runAll.sh

FILE_NAME="report.txt"
grep -E 'ERROR::|UVM_ERROR' transcript > $FILE_NAME
echo "Done and save as $FILE_NAME :)"
