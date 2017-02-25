#!/bin/bash
rm -rf ./pb/*.pb

protofiles=`ls ./proto  | grep .proto`


for f in ${protofiles[*]} 
do
	# gen pb binary file
	./protoc ./proto/$f -o ./pb/${f/".proto"/".pb"}

	# gen c++ file
	./protoc ./proto/$f --cpp_out=src

	# gen golang file
	./protoc ./proto/$f --go_out=gosrc
done
